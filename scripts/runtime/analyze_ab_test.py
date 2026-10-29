#!/usr/bin/env python3
"""
analyze_ab_test.py - Statistical A/B Test Analyzer CLI
Part of solo-project-lifecycle (Module 13: Product Operations & Iteration).

Calculates:
- Conversion rates, absolute & relative lift
- Standard error, Z-score, two-tailed p-value
- 95% Confidence Interval for conversion difference
- Sample Ratio Mismatch (SRM) chi-square test
- Minimum sample size & statistical power validation
- Guardrail metric degradation checks
- Structured product decision: Ship it / Investigate / Extend the test / Stop the test / Don't ship

Zero third-party dependencies required (pure standard library math).
"""

import argparse
import csv
import json
import math
import os
import sys

def normal_cdf(x: float) -> float:
    """Cumulative distribution function for standard normal distribution N(0,1)."""
    return 0.5 * (1.0 + math.erf(x / math.sqrt(2.0)))

def chi2_sf_1df(chi2: float) -> float:
    """Survival function (1 - CDF) of chi-square distribution with 1 degree of freedom."""
    if chi2 <= 0:
        return 1.0
    return 1.0 - math.erf(math.sqrt(chi2 / 2.0))

def parse_args():
    parser = argparse.ArgumentParser(
        description="A/B Test Statistical Analyzer CLI for Solo Product Managers and Developers."
    )
    # Summary inputs
    parser.add_argument("-cu", "--control-users", type=int, help="Total users in Control group")
    parser.add_argument("-cc", "--control-conversions", type=int, help="Total conversions in Control group")
    parser.add_argument("-vu", "--variant-users", type=int, help="Total users in Variant group")
    parser.add_argument("-vc", "--variant-conversions", type=int, help="Total conversions in Variant group")

    # Raw CSV input
    parser.add_argument("--csv", type=str, help="Path to raw event CSV (user_id, variant, converted)")

    # Test parameters
    parser.add_argument("--test-name", type=str, default="A/B Experiment", help="Experiment name")
    parser.add_argument("--hypothesis", type=str, default="Proposed change will improve target metric", help="Hypothesis statement")
    parser.add_argument("--duration-days", type=int, default=14, help="Test duration in days (minimum 7-14 for business cycles)")
    parser.add_argument("--split", type=float, default=0.5, help="Expected traffic fraction to Control (default 0.5 for 50/50)")
    parser.add_argument("--alpha", type=float, default=0.05, help="Significance level alpha (default 0.05 for 95% confidence)")
    parser.add_argument("--mde", type=float, default=10.0, help="Minimum Detectable Effect (relative percentage, e.g. 10.0 for 10%%)")
    parser.add_argument("--metric-name", type=str, default="Conversion Rate", help="Primary metric name")

    # Guardrail metrics
    # Format: "Name:ControlVal:VariantVal:Status" where Status is PASS/FAIL/OK/DEGRADED
    parser.add_argument("--guardrail", action="append", default=[], help="Guardrail metric spec (e.g. 'P95 Latency:240ms:248ms:OK' or 'Churn:1.2%%:2.8%%:FAIL')")

    # Output options
    parser.add_argument("--json", action="store_true", help="Output results in JSON format")

    return parser.parse_args()

def load_csv(csv_path: str):
    """Load raw data CSV and aggregate counts."""
    if not os.path.exists(csv_path):
        raise FileNotFoundError(f"CSV file not found: {csv_path}")

    control_users = 0
    control_conv = 0
    variant_users = 0
    variant_conv = 0

    with open(csv_path, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            variant_val = str(row.get("variant", row.get("group", ""))).strip().lower()
            conv_val = int(row.get("converted", row.get("conversion", 0)))

            if variant_val in ["control", "a", "c", "0"]:
                control_users += 1
                if conv_val == 1:
                    control_conv += 1
            elif variant_val in ["variant", "treatment", "b", "v", "1"]:
                variant_users += 1
                if conv_val == 1:
                    variant_conv += 1

    return control_users, control_conv, variant_users, variant_conv

def analyze_test(
    control_users: int,
    control_conv: int,
    variant_users: int,
    variant_conv: int,
    expected_split: float = 0.5,
    alpha: float = 0.05,
    mde_pct: float = 10.0,
    duration_days: int = 14,
    guardrails: list = None
):
    if control_users <= 0 or variant_users <= 0:
        raise ValueError("User counts for Control and Variant must be greater than zero.")

    total_users = control_users + variant_users
    total_conv = control_conv + variant_conv

    # 1. Conversion rates
    cr_control = control_conv / control_users
    cr_variant = variant_conv / variant_users

    abs_lift = cr_variant - cr_control
    rel_lift_pct = (abs_lift / cr_control * 100.0) if cr_control > 0 else 0.0

    # 2. Standard Error & Z-Score
    se_control = math.sqrt(cr_control * (1.0 - cr_control) / control_users)
    se_variant = math.sqrt(cr_variant * (1.0 - cr_variant) / variant_users)
    se_diff = math.sqrt(se_control**2 + se_variant**2)

    z_score = abs_lift / se_diff if se_diff > 0 else 0.0

    # Two-tailed p-value
    p_value = 2.0 * (1.0 - normal_cdf(abs(z_score)))

    # 3. Confidence Interval (95% CI standard Z = 1.95996 for alpha=0.05)
    # Z-critical approximation for general alpha
    z_crit = 1.959964 if math.isclose(alpha, 0.05) else 1.644853 if math.isclose(alpha, 0.10) else 2.575829
    ci_lower_abs = abs_lift - (z_crit * se_diff)
    ci_upper_abs = abs_lift + (z_crit * se_diff)

    ci_lower_rel = (ci_lower_abs / cr_control * 100.0) if cr_control > 0 else 0.0
    ci_upper_rel = (ci_upper_abs / cr_control * 100.0) if cr_control > 0 else 0.0

    # 4. Sample Ratio Mismatch (SRM)
    exp_control = total_users * expected_split
    exp_variant = total_users * (1.0 - expected_split)
    chi2_srm = ((control_users - exp_control)**2 / exp_control) + ((variant_users - exp_variant)**2 / exp_variant)
    p_srm = chi2_sf_1df(chi2_srm)
    has_srm = p_srm < 0.001

    # 5. Statistical Power & Sample Size Check
    # Formula: n_per_variant = 2 * (Z_alpha/2 + Z_beta)^2 * p * (1 - p) / (MDE_abs)^2
    # Z_alpha/2 = 1.96, Z_beta (for 80% power) = 0.8416 -> sum = 2.8016 -> sum^2 = 7.849
    p_avg = total_conv / total_users if total_users > 0 else 0.01
    mde_abs = (mde_pct / 100.0) * cr_control
    if mde_abs > 0 and p_avg > 0 and p_avg < 1:
        n_req_per_variant = int(math.ceil((7.849 * 2.0 * p_avg * (1.0 - p_avg)) / (mde_abs**2)))
    else:
        n_req_per_variant = 1000

    min_users = min(control_users, variant_users)
    min_convs = min(control_conv, variant_conv)
    is_underpowered = min_users < n_req_per_variant or min_convs < 100

    # 6. Guardrail Status
    guardrail_degraded = False
    parsed_guardrails = []
    if guardrails:
        for g in guardrails:
            parts = g.split(":")
            if len(parts) >= 4:
                name, c_val, v_val, status = parts[0].strip(), parts[1].strip(), parts[2].strip(), parts[3].strip().upper()
                is_deg = status in ["FAIL", "DEGRADED", "REGRESSED", "FALSE"]
            elif len(parts) == 3:
                name, c_val, v_val = parts[0].strip(), parts[1].strip(), parts[2].strip()
                status = "OK"
                is_deg = False
            else:
                name, status = parts[0].strip(), "OK"
                c_val, v_val = "-", "-"
                is_deg = False
            if is_deg:
                guardrail_degraded = True
            parsed_guardrails.append({
                "name": name,
                "control": c_val,
                "variant": v_val,
                "status": "DEGRADED ❌" if is_deg else "PASS ✅",
                "degraded": is_deg
            })

    # 7. Recommendation Engine
    is_stat_sig = p_value < alpha
    is_practical_sig = rel_lift_pct >= mde_pct

    if has_srm:
        recommendation = "Stop & Invalidate (SRM Detected)"
        verdict = "STOP_SRM"
        reasoning = (
            f"Sample Ratio Mismatch detected (chi2={chi2_srm:.2f}, p={p_srm:.6f} < 0.001). "
            "Traffic allocation bias indicates an instrumentation or redirection bug. "
            "The experiment is compromised and results cannot be trusted."
        )
        next_step = "Halt experiment immediately, investigate allocation router / tracking scripts, and re-run after resolving the bug."
    elif duration_days < 7:
        recommendation = "Extend the test (Duration Too Short)"
        verdict = "EXTEND_DURATION"
        reasoning = (
            f"Test ran for only {duration_days} days. Must run for at least 1-2 full weekly business cycles "
            "(minimum 7-14 days) to eliminate day-of-week seasonality and novelty effects."
        )
        next_step = f"Keep the experiment running until at least Day 14 before locking in final conclusions."
    elif is_stat_sig and rel_lift_pct > 0:
        if guardrail_degraded:
            recommendation = "Investigate (Guardrail Concern)"
            verdict = "INVESTIGATE"
            reasoning = (
                f"Variant achieved statistically significant lift ({rel_lift_pct:+.2f}%, p={p_value:.4f}), "
                "but one or more guardrail metrics suffered degradation. "
                "Primary gains may be cannibalized by secondary costs."
            )
            next_step = "Conduct trade-off audit with stakeholders before rolling out; analyze if friction was merely displaced."
        else:
            recommendation = "Ship it (100% Rollout)"
            verdict = "SHIP"
            reasoning = (
                f"Statistically significant positive lift ({rel_lift_pct:+.2f}%, p={p_value:.4f} < {alpha}) "
                f"with 95% CI [{ci_lower_rel:+.2f}%, {ci_upper_rel:+.2f}%], no SRM, and zero guardrail degradations."
            )
            next_step = "Roll out variant to 100% of users via feature flag, archive control code, and establish new baseline."
    elif is_stat_sig and rel_lift_pct < 0:
        recommendation = "Don't ship (Negative Impact)"
        verdict = "DONT_SHIP"
        reasoning = (
            f"Variant caused a statistically significant decline ({rel_lift_pct:+.2f}%, p={p_value:.4f} < {alpha}). "
            "Proposed changes hurt user performance."
        )
        next_step = "Revert immediately to Control using instant kill switch. Formulate post-mortem on why hypothesis failed."
    else:
        # Not statistically significant
        if rel_lift_pct > 0 and is_underpowered:
            recommendation = "Extend the test (Underpowered)"
            verdict = "EXTEND_POWER"
            reasoning = (
                f"Positive directional trend ({rel_lift_pct:+.2f}%), but result is not statistically significant (p={p_value:.4f} >= {alpha}). "
                f"Sample size ({min_users} users per variant) is below required power threshold ({n_req_per_variant} users)."
            )
            next_step = f"Extend test run until reaching {n_req_per_variant} users per variant, or until reaching 30 days maximum."
        else:
            recommendation = "Stop the test (Flat / Inconclusive)"
            verdict = "STOP_FLAT"
            reasoning = (
                f"No statistically significant difference detected (lift={rel_lift_pct:+.2f}%, p={p_value:.4f} >= {alpha}). "
                "The tested variation does not move the needle meaningfully."
            )
            next_step = "Kill the experiment, remove variant code, and refocus engineering resources on higher-impact RICE items."

    return {
        "control_users": control_users,
        "control_conv": control_conv,
        "cr_control_pct": cr_control * 100.0,
        "variant_users": variant_users,
        "variant_conv": variant_conv,
        "cr_variant_pct": cr_variant * 100.0,
        "abs_lift_pp": abs_lift * 100.0,
        "rel_lift_pct": rel_lift_pct,
        "se_diff": se_diff,
        "z_score": z_score,
        "p_value": p_value,
        "alpha": alpha,
        "ci_lower_rel": ci_lower_rel,
        "ci_upper_rel": ci_upper_rel,
        "chi2_srm": chi2_srm,
        "p_srm": p_srm,
        "has_srm": has_srm,
        "is_underpowered": is_underpowered,
        "n_req_per_variant": n_req_per_variant,
        "is_stat_sig": is_stat_sig,
        "is_practical_sig": is_practical_sig,
        "guardrail_degraded": guardrail_degraded,
        "guardrails": parsed_guardrails,
        "recommendation": recommendation,
        "verdict": verdict,
        "reasoning": reasoning,
        "next_step": next_step
    }

def format_markdown_report(meta: dict, res: dict) -> str:
    test_name = meta.get("test_name", "A/B Experiment")
    hypothesis = meta.get("hypothesis", "")
    duration_days = meta.get("duration_days", 14)
    metric_name = meta.get("metric_name", "Conversion Rate")
    mde_pct = meta.get("mde_pct", 10.0)

    srm_badge = "❌ FAILED (Allocation Bias)" if res["has_srm"] else "✅ PASSED (No Bias)"
    power_badge = "⚠️ Underpowered (<80% Power)" if res["is_underpowered"] else "✅ Adequate Power"
    sig_badge = "✅ YES (p < 0.05)" if res["is_stat_sig"] else "❌ NO (p >= 0.05)"
    rec_badge = res["recommendation"]

    md = []
    md.append(f"## A/B Test Results: {test_name}\n")
    md.append(f"**Hypothesis**: {hypothesis}  ")
    md.append(f"**Duration**: {duration_days} days | **Sample**: {res['control_users']:,} Control / {res['variant_users']:,} Variant (Total: {res['control_users'] + res['variant_users']:,})  ")
    md.append(f"**Data Quality**: SRM: {srm_badge} (p={res['p_srm']:.4f}) | Power: {power_badge} (Req: ~{res['n_req_per_variant']:,}/var)\n")

    md.append(f"### Primary Metric: {metric_name}\n")
    md.append("| Metric | Control | Variant | Relative Lift | 95% Confidence Interval | p-value | Significant? |")
    md.append("|:---|:---:|:---:|:---:|:---:|:---:|:---:|")
    md.append(
        f"| **{metric_name}** | {res['cr_control_pct']:.2f}% ({res['control_conv']:,}) | "
        f"{res['cr_variant_pct']:.2f}% ({res['variant_conv']:,}) | "
        f"**{res['rel_lift_pct']:+.2f}%** | "
        f"[{res['ci_lower_rel']:+.2f}%, {res['ci_upper_rel']:+.2f}%] | "
        f"**{res['p_value']:.4f}** | "
        f"{sig_badge} |"
    )
    md.append("")

    if res["guardrails"]:
        md.append("### Guardrail Metrics Validation\n")
        md.append("| Guardrail Metric | Control Baseline | Variant Observed | Health Status |")
        md.append("|:---|:---:|:---:|:---:|")
        for g in res["guardrails"]:
            md.append(f"| {g['name']} | {g['control']} | {g['variant']} | {g['status']} |")
        md.append("")

    md.append("### Recommendation & Action Plan\n")
    md.append(f"- **Recommendation**: **{rec_badge}**")
    md.append(f"- **Reasoning**: {res['reasoning']}")
    md.append(f"- **Next Steps**: {res['next_step']}")

    return "\n".join(md)

def main():
    args = parse_args()

    if args.csv:
        cu, cc, vu, vc = load_csv(args.csv)
    else:
        if None in [args.control_users, args.control_conversions, args.variant_users, args.variant_conversions]:
            print(
                "Error: You must provide either --csv or summary counts (-cu, -cc, -vu, -vc).\n"
                "Example: python scripts/runtime/analyze_ab_test.py -cu 1000 -cc 120 -vu 1020 -vc 160",
                file=sys.stderr
            )
            sys.exit(1)
        cu, cc, vu, vc = args.control_users, args.control_conversions, args.variant_users, args.variant_conversions

    meta = {
        "test_name": args.test_name,
        "hypothesis": args.hypothesis,
        "duration_days": args.duration_days,
        "metric_name": args.metric_name,
        "mde_pct": args.mde
    }

    results = analyze_test(
        control_users=cu,
        control_conv=cc,
        variant_users=vu,
        variant_conv=vc,
        expected_split=args.split,
        alpha=args.alpha,
        mde_pct=args.mde,
        duration_days=args.duration_days,
        guardrails=args.guardrail
    )

    if args.json:
        out = {"meta": meta, "results": results}
        print(json.dumps(out, indent=2))
    else:
        print(format_markdown_report(meta, results))

if __name__ == "__main__":
    main()
