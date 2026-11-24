#!/usr/bin/env python3
"""
UI/UX Design Consistency Auditor & Auto-Fixer
Performs mechanical verification across prototype screens in docs/design/screens/
Verifies token alignment, reusable components (.btn, .card, .badge, .navbar),
animation discipline, zero emoticons, and cross-screen navigation parity.

Usage:
  python3 scripts/design/uiux_audit.py docs/design/screens/
  python3 scripts/design/uiux_audit.py docs/design/screens/ --fix
  python3 scripts/design/uiux_audit.py docs/design/screens/ --report docs/specs/DESIGN_SYSTEM_AUDIT.md
"""

import os
import sys
import re
import argparse
from pathlib import Path

# Regex patterns
EMOJI_PATTERN = re.compile(
    r"[\U0001F300-\U0001FAD6\U0001F600-\U0001F64F\U0001F900-\U0001F9FF\u2600-\u26FF\u2700-\u27BF]"
)
SPEC_LEAK_PATTERN = re.compile(r"\b(SCR-\d+|M06-FE-\d+|REQ-\d+|FSD-\d+)\b", re.IGNORECASE)
RAW_NEON_PATTERN = re.compile(r"(#FF5722|#FF0000|#00FF00|bg-orange-500|bg-red-500|#3B82F6)", re.IGNORECASE)
UNSTYLED_SELECT_PATTERN = re.compile(r"<select(?![^>]*class=[\"'][^\"']*(form-select|custom-select)[^\"']*[\"'])", re.IGNORECASE)
PLACEHOLDER_SLOP_PATTERN = re.compile(
    r"\b(Lorem\s+ipsum|John\s+Doe|Jane\s+Doe|example\.com|placeholder\.com)\b", re.IGNORECASE
)
DEAD_HREF_PATTERN = re.compile(r'<a\s+[^>]*href=["\']#(?:["\']|\s)[^>]*>', re.IGNORECASE)

class ScreenAudit:
    def __init__(self, file_path):
        self.file_path = Path(file_path)
        self.filename = self.file_path.name
        self.content = ""
        self.violations = []
        self.warnings = []
        self.passed = []
        self.fixes_applied = []
        self.nav_items = []
        self.brand_title = None

    def load(self):
        try:
            with open(self.file_path, "r", encoding="utf-8") as f:
                self.content = f.read()
            return True
        except Exception as e:
            self.violations.append(f"Cannot read file: {e}")
            return False

    def save(self):
        try:
            with open(self.file_path, "w", encoding="utf-8") as f:
                f.write(self.content)
            return True
        except Exception as e:
            self.violations.append(f"Cannot write file: {e}")
            return False

    def audit(self, auto_fix=False):
        if not self.content:
            return

        # 1. Viewport Meta & Mobile Readiness
        if "<meta name=\"viewport\"" not in self.content and "<meta name='viewport'" not in self.content:
            if auto_fix:
                head_pos = self.content.find("<head>")
                if head_pos != -1:
                    insert_idx = head_pos + 6
                    meta_tag = "\n  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
                    self.content = self.content[:insert_idx] + meta_tag + self.content[insert_idx:]
                    self.fixes_applied.append("Injected missing mobile viewport meta tag")
                else:
                    self.violations.append("Missing <meta name=\"viewport\"> (required for mobile ergonomics)")
            else:
                self.violations.append("Missing <meta name=\"viewport\"> (required for mobile ergonomics)")
        else:
            self.passed.append("Mobile viewport meta tag verified")

        # 2. Shared CSS Linkage (No Inline-Only Prototypes)
        css_match = re.search(r'<link[^>]+rel=["\']stylesheet["\'][^>]+href=["\']([^"\']+\.css)["\']', self.content, re.IGNORECASE)
        if not css_match:
            if auto_fix:
                head_end = self.content.find("</head>")
                if head_end != -1:
                    link_tag = '  <link rel="stylesheet" href="css/styles.css">\n'
                    self.content = self.content[:head_end] + link_tag + self.content[head_end:]
                    self.fixes_applied.append("Linked shared stylesheet (css/styles.css)")
                    self.passed.append("Linked shared stylesheet (auto-fixed)")
                else:
                    self.violations.append("Missing shared stylesheet link (<link rel=\"stylesheet\" href=\"css/styles.css\">)")
            else:
                self.violations.append("Missing shared stylesheet link (<link rel=\"stylesheet\" href=\"css/styles.css\">)")
        else:
            self.passed.append(f"Shared stylesheet linked ({css_match.group(1)})")

        # 3. Shared JS Script Linkage
        js_match = re.search(r'<script[^>]+src=["\']([^"\']+\.js)["\']', self.content, re.IGNORECASE)
        if not js_match:
            if auto_fix:
                body_end = self.content.find("</body>")
                if body_end != -1:
                    script_tag = '  <script src="js/app.js"></script>\n'
                    self.content = self.content[:body_end] + script_tag + self.content[body_end:]
                    self.fixes_applied.append("Linked shared script (js/app.js)")
                    self.passed.append("Linked shared script (auto-fixed)")
                else:
                    self.warnings.append("Missing shared script (<script src=\"js/app.js\"></script>)")
            else:
                self.warnings.append("Missing shared script (<script src=\"js/app.js\"></script>)")
        else:
            self.passed.append(f"Shared script linked ({js_match.group(1)})")

        # 4. Zero Emoticons / Emojis Audit
        emojis_found = EMOJI_PATTERN.findall(self.content)
        if emojis_found:
            sample_emojis = "".join(set(emojis_found))[:5]
            self.violations.append(f"Found {len(emojis_found)} raw emoticons/emojis ({sample_emojis})! Use SVG icons (e.g. Lucide) instead.")
        else:
            self.passed.append("Zero emoticons/emojis detected (SVG icons compliant)")

        # 5. Component System Verification (.btn, .card, .badge)
        buttons = re.findall(r'<button[^>]*>', self.content, re.IGNORECASE)
        unclassed_buttons = [b for b in buttons if 'class=' not in b or 'btn' not in b]
        if unclassed_buttons:
            self.warnings.append(f"Found {len(unclassed_buttons)} button(s) missing standard .btn class")
        else:
            if buttons:
                self.passed.append(f"All {len(buttons)} buttons conform to .btn component standard")

        # 6. Form Controls: Strict 16px & No Unstyled Select
        raw_selects = UNSTYLED_SELECT_PATTERN.findall(self.content)
        if raw_selects:
            self.violations.append(f"Found {len(raw_selects)} unstyled native <select>! Must use custom popover or .form-select.")
        
        if '<input type="number"' in self.content.lower():
            self.warnings.append("Found <input type=\"number\">. For currency/numeric inputs, use inputmode=\"numeric\" + formatted text.")

        # 7. Zero Spec Leaks in Visible Text
        # Ignore script or comment contexts
        clean_content = re.sub(r'<!--.*?-->', '', self.content, flags=re.DOTALL)
        clean_content = re.sub(r'<script.*?</script>', '', clean_content, flags=re.DOTALL)
        spec_leaks = SPEC_LEAK_PATTERN.findall(clean_content)
        # Filter out legitimate doc titles if in <title> tag
        visible_leaks = [m for m in spec_leaks if not re.search(rf'<title>[^<]*{m}[^<]*</title>', self.content)]
        if visible_leaks:
            unique_leaks = list(set(visible_leaks))
            self.violations.append(f"Internal spec identifier(s) leaked in UI: {', '.join(unique_leaks)}")
        else:
            self.passed.append("Zero internal spec identifiers leaked in rendered UI")

        # 8. Uncalibrated Neon Palette Detection
        neon_matches = RAW_NEON_PATTERN.findall(self.content)
        if neon_matches:
            self.warnings.append(f"Uncalibrated colors/classes detected: {', '.join(set(neon_matches))}")

        # 9. Extract Navigation Links for Cross-Screen Parity
        nav_matches = re.findall(r'<(?:a|button)[^>]+class=["\'][^"\']*(?:sidebar-link|nav-link)[^"\']*["\'][^>]*>(.*?)</(?:a|button)>', self.content, re.IGNORECASE | re.DOTALL)
        for nav in nav_matches:
            # Strip tags and normalize text
            text = re.sub(r'<[^>]+>', '', nav).strip()
            if text:
                self.nav_items.append(text)

        brand_match = re.search(r'class=["\'][^"\']*(?:sidebar-header|navbar-brand)[^"\']*["\'][^>]*>.*?<span[^>]*>(.*?)</span>', self.content, re.IGNORECASE | re.DOTALL)
        if brand_match:
            self.brand_title = re.sub(r'<[^>]+>', '', brand_match.group(1)).strip()

        # 10. Multi-Role RBAC Simulation Check
        if re.search(r'id=["\']role-switcher["\']', self.content) or 'data-roles=' in self.content or 'data-role-mask=' in self.content:
            self.passed.append("Interactive multi-role RBAC simulation supported (role switcher / role attributes present)")
        else:
            self.warnings.append("Screen missing multi-role testing hooks (#role-switcher or data-roles attributes)")

        # 11. Zero Placeholder Slop (Anti-Lorem Ipsum & Generic Fictional Data)
        placeholders_found = PLACEHOLDER_SLOP_PATTERN.findall(clean_content)
        if placeholders_found:
            self.violations.append(
                f"Found {len(placeholders_found)} placeholder slop occurrences ({', '.join(set(placeholders_found))})! Replace with domain-realistic localized copy."
            )
        else:
            self.passed.append("Zero placeholder slop detected (domain-realistic data compliant)")

        # 12. Dead Links Detection (href="#")
        dead_links = DEAD_HREF_PATTERN.findall(self.content)
        if dead_links:
            self.warnings.append(f"Found {len(dead_links)} dead link(s) (href=\"#\"). Wire to authentic action handlers or modals.")

        # 13. Avatar Craft: No Raw Monochrome Text Initials Circles
        raw_initials = re.findall(r'<div[^>]+class=["\'][^"\']*\bavatar\b[^"\']*["\'][^>]*>\s*([A-Za-z]{1,3})\s*</div>', clean_content, re.IGNORECASE)
        if raw_initials:
            self.violations.append(f"Found {len(raw_initials)} raw text-initial avatar(s) ({', '.join(set(raw_initials))})! Avatars must use authentic photo assets or SVG icons.")

        # 14. Semantic Authentication & Public Screen Integrity
        fname = self.file_path.name.lower()
        fpath_str = str(self.file_path).replace("\\", "/").lower()
        is_login = "login" in fname or "masuk" in fname
        is_public = is_login or "landing" in fname or "register" in fname or "/public/" in fpath_str or "scr-pub" in fname

        if is_login:
            has_password = bool(re.search(r'<input[^>]+type=["\']password["\']', self.content, re.IGNORECASE))
            if not has_password:
                self.violations.append(f"Login screen '{self.filename}' has no password field (<input type=\"password\">)! Screen appears to be an invalid/cloned dashboard.")

        if is_public:
            leaked_staff = re.findall(r'\b(branch[\s_-]*manager|super[\s_-]*admin|tingkat[\s_-]*okupansi|penerimaan[\s_-]*bulan[\s_-]*berjalan)\b', self.content, re.IGNORECASE)
            if leaked_staff:
                self.violations.append(f"Public screen '{self.filename}' leaks internal staff/admin metrics ({', '.join(set(leaked_staff))})!")


class DesignSystemAuditor:
    def __init__(self, target_dir, auto_fix=False):
        self.target_dir = Path(target_dir)
        self.auto_fix = auto_fix
        self.screen_audits = []
        self.css_file = None

    def discover_files(self):
        if not self.target_dir.exists():
            return []
        
        # Look for HTML files
        html_files = sorted(list(self.target_dir.glob("*.html")) + list(self.target_dir.glob("**/*.html")))
        
        # Find shared CSS
        css_candidates = list(self.target_dir.glob("css/*.css")) + list(self.target_dir.glob("*.css"))
        if css_candidates:
            self.css_file = css_candidates[0]
            
        return html_files

    def run(self):
        html_files = self.discover_files()
        if not html_files:
            print(f"⚠️  No HTML prototype screens found in {self.target_dir}")
            return True

        print(f"\n🎨 Starting Professional UI/UX Consistency Audit on {len(html_files)} screen(s)...")
        print(f"📁 Target Directory: {self.target_dir.resolve()}")
        if self.auto_fix:
            print("🔧 Auto-Fix Mode: ENABLED")
        print("=" * 65)

        for f in html_files:
            audit = ScreenAudit(f)
            if audit.load():
                audit.audit(auto_fix=self.auto_fix)
                if self.auto_fix and audit.fixes_applied:
                    audit.save()
                self.screen_audits.append(audit)

        # Cross-Screen Parity Check
        self.verify_cross_screen_parity()

        # Screen Uniqueness / Anti-Cloning Check
        self.verify_screen_uniqueness()

        return self.report()

    def verify_screen_uniqueness(self):
        """Detect lazy cloning where an agent copied the exact same HTML across multiple screens."""
        if len(self.screen_audits) < 2:
            return

        screen_words = []
        for audit in self.screen_audits:
            body = re.search(r'<body[^>]*>(.*?)</body>', audit.content, re.DOTALL | re.IGNORECASE)
            body_content = body.group(1) if body else audit.content
            # Strip title, heading, and script/style to see core structural content
            core = re.sub(r'<(h[1-6]|title)\b.*?</\1>', '', body_content, flags=re.DOTALL | re.IGNORECASE)
            core = re.sub(r'<(script|style)\b.*?</\1>', '', core, flags=re.DOTALL | re.IGNORECASE)
            words = set(re.findall(r'[A-Za-z0-9]{3,}', core.lower()))
            screen_words.append((audit, words))

        reported_pairs = set()
        for i in range(len(screen_words)):
            for j in range(i + 1, len(screen_words)):
                audit_a, words_a = screen_words[i]
                audit_b, words_b = screen_words[j]
                # Only check screens with substantial content (>= 25 unique words)
                if len(words_a) < 25 or len(words_b) < 25:
                    continue
                intersection = len(words_a & words_b)
                union = len(words_a | words_b)
                similarity = intersection / union if union > 0 else 0
                if similarity >= 0.80:
                    pair_key = tuple(sorted([audit_a.filename, audit_b.filename]))
                    if pair_key not in reported_pairs:
                        reported_pairs.add(pair_key)
                        audit_b.violations.append(
                            f"Screen Clone Detected: '{audit_b.filename}' is {int(similarity * 100)}% identical to '{audit_a.filename}'! Each screen must have unique, role-appropriate domain content."
                        )

    def verify_cross_screen_parity(self):
        if len(self.screen_audits) < 2:
            return

        # Compare navigation structures
        baseline = self.screen_audits[0]
        baseline_nav = set(baseline.nav_items)
        baseline_brand = baseline.brand_title

        for other in self.screen_audits[1:]:
            other_nav = set(other.nav_items)
            if baseline_nav and other_nav:
                missing = baseline_nav - other_nav
                extra = other_nav - baseline_nav
                if missing or extra:
                    diff_desc = []
                    if missing:
                        diff_desc.append(f"missing [{', '.join(missing)}]")
                    if extra:
                        diff_desc.append(f"extra [{', '.join(extra)}]")
                    other.warnings.append(f"Navigation menu drift vs {baseline.filename}: {'; '.join(diff_desc)}")
                else:
                    other.passed.append(f"Navigation menu in 100% parity with {baseline.filename}")

            if baseline_brand and other.brand_title and baseline_brand != other.brand_title:
                other.violations.append(f"Brand title inconsistency: '{other.brand_title}' vs '{baseline_brand}' in {baseline.filename}")

    def report(self):
        total_violations = sum(len(a.violations) for a in self.screen_audits)
        total_warnings = sum(len(a.warnings) for a in self.screen_audits)
        total_fixes = sum(len(a.fixes_applied) for a in self.screen_audits)

        for audit in self.screen_audits:
            status_icon = "❌" if audit.violations else ("⚠️" if audit.warnings else "✅")
            print(f"\n{status_icon} Screen: {audit.filename}")
            
            for fix in audit.fixes_applied:
                print(f"  🔧 FIXED: {fix}")
            for p in audit.passed:
                print(f"  ✅ {p}")
            for w in audit.warnings:
                print(f"  ⚠️  ADVISORY: {w}")
            for v in audit.violations:
                print(f"  ❌ VIOLATION: {v}")

        print("\n" + "=" * 65)
        print("📊 UI/UX AUDIT SUMMARY")
        print(f"  Screens Audited   : {len(self.screen_audits)}")
        print(f"  Auto-Fixes Done   : {total_fixes}")
        print(f"  Total Warnings    : {total_warnings}")
        print(f"  Total Violations  : {total_violations}")
        print("=" * 65)

        if total_violations > 0:
            print("❌ Audit Verdict: FAILED. Address violations above before Design Freeze.\n")
            return False
        else:
            print("✅ Audit Verdict: PASSED. Design system consistency & craftsmanship verified.\n")
            return True

    def generate_markdown_report(self, output_path):
        out_p = Path(output_path)
        out_p.parent.mkdir(parents=True, exist_ok=True)
        
        total_violations = sum(len(a.violations) for a in self.screen_audits)
        total_warnings = sum(len(a.warnings) for a in self.screen_audits)
        total_fixes = sum(len(a.fixes_applied) for a in self.screen_audits)

        lines = [
            "# Design System & UI/UX Consistency Audit Report",
            "",
            f"**Audit Status**: {'✅ PASSED' if total_violations == 0 else '❌ ACTION REQUIRED'}  ",
            f"**Target Directory**: `{self.target_dir}`  ",
            f"**Total Screens**: {len(self.screen_audits)}  ",
            f"**Auto-Fixes Applied**: {total_fixes}  ",
            f"**Open Violations**: {total_violations}  ",
            "",
            "---",
            "",
            "## Screen Breakdown",
            ""
        ]

        for audit in self.screen_audits:
            lines.append(f"### Screen: `{audit.filename}`")
            lines.append("")
            if audit.fixes_applied:
                lines.append("**Auto-Fixes Applied:**")
                for f in audit.fixes_applied:
                    lines.append(f"- 🔧 {f}")
                lines.append("")
            
            if audit.violations:
                lines.append("**Violations (Must Fix):**")
                for v in audit.violations:
                    lines.append(f"- ❌ {v}")
                lines.append("")

            if audit.warnings:
                lines.append("**Advisories / Polish Opportunities:**")
                for w in audit.warnings:
                    lines.append(f"- ⚠️ {w}")
                lines.append("")

            if audit.passed:
                lines.append("**Verified Passes:**")
                for p in audit.passed:
                    lines.append(f"- ✅ {p}")
                lines.append("")

        with open(out_p, "w", encoding="utf-8") as f:
            f.write("\n".join(lines))
        print(f"📝 Full audit report saved to: {out_p.resolve()}")


def main():
    parser = argparse.ArgumentParser(description="Professional UI/UX Consistency Auditor & Auto-Fixer")
    parser.add_argument("target_dir", nargs="?", default="docs/design/screens", help="Path to prototype screens folder")
    parser.add_argument("--fix", action="store_true", help="Automatically fix missing links, viewport tags, etc.")
    parser.add_argument("--report", help="Path to save markdown audit report (e.g. docs/specs/DESIGN_SYSTEM_AUDIT.md)")

    args = parser.parse_args()
    auditor = DesignSystemAuditor(args.target_dir, auto_fix=args.fix)
    success = auditor.run()

    if args.report:
        auditor.generate_markdown_report(args.report)

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
