# PM Prioritization Frameworks (Prioritization Frameworks for Solo Devs)

**Purpose**: Systematic methods for deciding which features to build first, ensuring limited solo developer resources are utilized optimally.

**Last Updated**: 2026-09-27

---

## 1. RICE Score (Recommended for Solo Devs)

**Formula**: `RICE Score = (Reach × Impact × Confidence) / Effort`

### 1.1 Reach
**Definition**: How many users will be impacted by this feature within a given time period?

**Unit**: Number of users per time period (e.g., users/month, users/quarter)

**Examples**:
- Feature "Password reset": 80% of 100 users = **80 users/quarter**
- Feature "Dark mode": 30% of 100 users = **30 users/quarter**
- Feature "Admin dashboard": 1 admin user = **1 user/quarter**

**Solo Dev Tips**: Use realistic data. If you don't have users yet, estimate based on your target persona (e.g., "50 beta users in Q1, 80% will use this = 40").

---

### 1.2 Impact
**Definition**: How much will this feature impact an individual user?

**Scale** (use multipliers):
- **Massive (3.0)**: Game-changer, fundamentally changes how users interact with the product (e.g., core feature that makes the product useful)
- **High (2.0)**: Significantly improves the experience or solves a major pain point (e.g., real-time notifications eliminating manual refresh)
- **Medium (1.0)**: Clearly noticeable improvement but not essential (e.g., better search/filters)
- **Low (0.5)**: Nice-to-have, minor improvement (e.g., UI polish, animations)
- **Minimal (0.25)**: Barely noticeable (e.g., minor copy tweak)

**Examples**:
- "User authentication" (without this, the product cannot be used) = **Massive (3.0)**
- "Export to PDF" (frequently requested, solves real pain) = **High (2.0)**
- "Dark mode" (aesthetic preference, not essential) = **Low (0.5)**

**Solo Dev Tips**: Avoid marking every feature as "High". Force yourself to rank features relative to each other.

---

### 1.3 Confidence
**Definition**: How confident are you about your Reach and Impact estimates?

**Scale** (percentage):
- **High (100%)**: Strong quantitative data (e.g., 10 user interviews, analytics data, competitors launched this successfully)
- **Medium (80%)**: Some qualitative evidence (e.g., 3–5 user requests, reasonable assumptions)
- **Low (50%)**: Pure hypothesis, no validation yet (e.g., a "gut feeling" that this feature is important)

**Examples**:
- "Payment integration" (clearly needed for monetization) = **100%**
- "Social login" (2 user requests, but unclear how critical it is) = **80%**
- "AI-powered recommendation" (good idea, but no validated demand yet) = **50%**

**Solo Dev Tips**: Low confidence is a signal to do research first (user interviews, prototypes) before building.

---

### 1.4 Effort
**Definition**: How many person-months (or person-weeks) to complete this feature?

**Unit**: Person-months (use 0.25 = 1 week for granularity)

**Examples**:
- **0.25 (1 week)**: Simple CRUD API, minor UI change
- **0.5 (2 weeks)**: Standard feature with integrations (e.g., email notifications)
- **1.0 (1 month)**: Complex feature (e.g., payment system with webhooks)
- **2.0 (2 months)**: Very complex, multi-module (e.g., full admin dashboard + role management)

**Solo Dev Tips**:
- Include testing, documentation, and deployment (not just coding time)
- Add a 20% buffer for unknowns
- If effort > 1.5 months, break it down into smaller user stories

---

### 1.5 RICE Score Calculation Examples

#### Example 1: Password Reset Feature
- **Reach**: 80 users/quarter (80% of 100 beta users will use this)
- **Impact**: 2.0 (High — major pain point if password is forgotten, requiring admin email)
- **Confidence**: 100% (clearly a standard feature)
- **Effort**: 0.25 person-months (1 week)

**RICE Score** = (80 × 2.0 × 1.0) / 0.25 = **640**

---

#### Example 2: AI-Powered Smart Suggestions
- **Reach**: 50 users/quarter (assume 50% of users will try this feature)
- **Impact**: 2.0 (High — could save users significant time)
- **Confidence**: 50% (no user requests yet, pure hypothesis)
- **Effort**: 2.0 person-months (requires ML model, training data, API integration)

**RICE Score** = (50 × 2.0 × 0.5) / 2.0 = **25**

---

#### Example 3: Dark Mode
- **Reach**: 30 users/quarter (30% prefer dark mode based on informal survey)
- **Impact**: 0.5 (Low — aesthetic preference, not a functional improvement)
- **Confidence**: 80% (3 user requests, survey data)
- **Effort**: 0.25 person-months (1 week for CSS + toggle logic)

**RICE Score** = (30 × 0.5 × 0.8) / 0.25 = **48**

---

#### Prioritization Result:
1. **Password Reset (640)** ← Build first
2. **Dark Mode (48)** ← Build second
3. **AI Suggestions (25)** ← Defer to later (high effort, low confidence)

---

### 1.6 RICE Score Worksheet Template

| Feature | Reach | Impact | Confidence | Effort | RICE Score | Priority |
| :--- | ---: | ---: | ---: | ---: | ---: | :--- |
| Password reset | 80 | 2.0 | 1.0 | 0.25 | **640** | P0 (Now) |
| Email notifications | 100 | 1.0 | 1.0 | 0.5 | **200** | P1 (Next) |
| Dark mode | 30 | 0.5 | 0.8 | 0.25 | **48** | P2 (Later) |
| Export to PDF | 60 | 1.0 | 1.0 | 0.25 | **240** | P1 (Next) |
| AI suggestions | 50 | 2.0 | 0.5 | 2.0 | **25** | P3 (Defer) |
| Social login | 40 | 0.5 | 0.8 | 0.5 | **32** | P2 (Later) |

**Sort by RICE Score** (highest first) for execution priority.

---

## 2. MoSCoW Prioritization (Must/Should/Could/Won't)

**Use for**: Quick triage at project kickoff (before detailed scoring)

### Must Have (P0)
- **Definition**: Without this feature, the product is unusable or does not deliver core value
- **Criteria**: MVP razor — maximum 3–5 features in this category
- **Examples**: User authentication, core processing engine, basic dashboard

### Should Have (P1)
- **Definition**: Important but not a launch blocker; add in beta or post-launch
- **Criteria**: Features that significantly enhance UX or retention
- **Examples**: Password reset, email notifications, export results

### Could Have (P2)
- **Definition**: Nice-to-have, additional improvements if time/budget permits
- **Criteria**: Requested features that are not urgent
- **Examples**: Dark mode, social login, advanced filters

### Won't Have (P3)
- **Definition**: Out of scope for current release; revisit in the future
- **Criteria**: Complex, low confidence, or outside immediate focus areas
- **Examples**: Mobile app, multi-language support, third-party API

**Solo Dev Tips**: Start with MoSCoW for a rough cut, then use RICE to rank details within "Should Have" and "Could Have".

---

## 3. Value vs Effort Matrix (2×2 Grid)

**Use for**: Quick visual prioritization (useful for presentations or stakeholders)

```
      HIGH VALUE
           │
   Quick   │   Strategic
   Wins    │   Bets
  (DO NOW) │ (PLAN CAREFULLY)
───────────┼───────────────── EFFORT
   Low     │   Money
   Hanging │   Pits
   Fruit   │  (AVOID)
           │
      LOW VALUE
```

### Quadrant 1: Quick Wins (High Value, Low Effort)
- **Action**: Do now, prioritize highest
- **Examples**: Password reset (high user need, 1 week effort)

### Quadrant 2: Strategic Bets (High Value, High Effort)
- **Action**: Plan carefully, break into phases
- **Examples**: Payment integration (critical for revenue, but complex)

### Quadrant 3: Low Hanging Fruit (Low Value, Low Effort)
- **Action**: Do if spare time permits, or delegate
- **Examples**: UI polish, copy improvements

### Quadrant 4: Money Pits (Low Value, High Effort)
- **Action**: Avoid or defer indefinitely
- **Examples**: AI features with unclear ROI, over-engineered architecture

**Solo Dev Tips**: When in doubt, ask yourself: "Is this effort worth 10x the result?" If not, it belongs in the Money Pit.

---

## 4. Kano Model (User Satisfaction vs Feature Presence)

**Use for**: Understanding feature types based on user psychology and reactions

### Performance Features
- **Definition**: The more present, the higher the satisfaction (linear relationship)
- **Examples**: Speed (faster = better), accuracy (higher = better)
- **Priority**: Medium (invest until diminishing returns set in)

### Basic Features (Must-Haves)
- **Definition**: If absent, users are extremely dissatisfied. If present, users remain neutral (expected baseline).
- **Examples**: Security (HTTPS, auth), data persistence (no data loss)
- **Priority**: P0 (must exist, but do not over-invest)

### Excitement Features (Delighters)
- **Definition**: If absent, users remain neutral. If present, users are delighted (unexpected value).
- **Examples**: Dark mode, playful animations, Easter eggs
- **Priority**: P2–P3 (great for differentiation, but low priority for MVP)

**Solo Dev Tips**: Focus on Basic features first (prevent dissatisfaction), then Performance features (deliver promised value), and only then Excitement features (differentiation).

---

## 5. ICE Score (Simplified RICE)

**Formula**: `ICE Score = (Impact + Confidence + Ease) / 3`

**Use when**: RICE is too complex or you need a faster method

- **Impact**: Scale 1–10 (1 = minimal, 10 = massive)
- **Confidence**: Scale 1–10 (1 = pure guess, 10 = validated data)
- **Ease**: Scale 1–10 (1 = very hard, 10 = trivial)

**Examples**:
- Password reset: (8 + 10 + 8) / 3 = **8.7**
- AI suggestions: (8 + 4 + 2) / 3 = **4.7**

**Solo Dev Tips**: Use ICE for quick triage, RICE for final prioritization.

---

## 6. Weighted Scoring Model (Custom Criteria)

**Use when**: You have specific criteria beyond RICE (e.g., strategic alignment, tech debt reduction)

### Example Criteria:
- User Value (30% weight)
- Revenue Impact (25% weight)
- Strategic Alignment (20% weight)
- Technical Feasibility (15% weight)
- Risk Reduction (10% weight)

**Scoring**: Each criterion rated 1–5, multiply by weight, sum total.

**Solo Dev Tips**: Don't over-complicate. RICE covers most scenarios. Use weighted scoring only if there are unique constraints (e.g., complying with specific client requirements).

---

## 7. Prioritization Anti-Patterns (What NOT to Do)

### ❌ HiPPO (Highest Paid Person's Opinion)
- **Problem**: Prioritizing based on whoever shouts the loudest or holds the highest title
- **Fix**: Use an objective, data-driven framework (RICE)

### ❌ "Everything is P0"
- **Problem**: All features are deemed urgent; no true priority exists
- **Fix**: Enforce relative ranking. Maximum 3–5 features in P0.

### ❌ "Shiny Object Syndrome"
- **Problem**: Constantly chasing new features without finishing existing ones
- **Fix**: Commit to the roadmap; resist new ideas mid-sprint

### ❌ "Build It Because We Can"
- **Problem**: Prioritizing technically cool features that provide zero user value
- **Fix**: Every feature must deliver clear user value (not tech flexing)

### ❌ "Analysis Paralysis"
- **Problem**: Spending excessive time analyzing/prioritizing instead of building
- **Fix**: Time-box prioritization (max 2 hours), use rough estimates, iterate later

---

## 8. Practical Prioritization Workflow (Solo Dev)

### Step 1: Brain Dump (15 min)
- List all feature ideas (from user feedback, competitive analysis, own ideas)
- Aim for 20–30 items

### Step 2: MoSCoW Quick Triage (30 min)
- Categorize: Must (P0), Should (P1), Could (P2), Won't (P3)
- If more than 5 items are in "Must", re-evaluate (too many)

### Step 3: RICE Scoring (1–2 hours)
- Score all P0 and P1 items with RICE
- Use worksheet/spreadsheet for tracking

### Step 4: Sort & Review (15 min)
- Sort by RICE score descending
- Sanity check: "Does this order make sense intuitively?"
- Adjust if there are outliers (e.g., RICE is high but intuitively not urgent)

### Step 5: Commit to Top 5 (5 min)
- Pick top 5 for "Now" (current sprint/cycle)
- Next 5–10 go to "Next"
- The rest go to "Later" or "Icebox"

### Step 6: Revisit Monthly
- Re-score based on new data (user feedback, market changes)
- Promote/demote features as needed

**Total Time**: ~3 hours per month (worth it to avoid building the wrong things)

---

## 9. Tools for Prioritization

### Spreadsheet (Google Sheets / Excel)
- **Pros**: Simple, flexible, free
- **Cons**: Manual calculation, no automation
- **Best for**: Solo dev, < 50 features

### Notion Database
- **Pros**: Visual (board/table view), formulas for auto-calculating RICE
- **Cons**: Requires setup
- **Best for**: Solo dev who wants integration with project docs

### Linear (Issues)
- **Pros**: Built-in priority field, roadmap view, integrates with dev workflow
- **Cons**: No native RICE scoring (requires custom fields)
- **Best for**: Solo dev already using Linear for issue tracking

### Productboard
- **Pros**: Purpose-built for product prioritization, RICE built-in, user feedback aggregation
- **Cons**: Expensive ($20/month+), overkill for solo dev
- **Best for**: Small teams (2+ people) or solo devs with budget

**Recommendation**: Start with Google Sheets (template below), upgrade to Notion/Linear if you need integration.

---

## 10. RICE Scoring Spreadsheet Template

**Copy this to Google Sheets / Excel**:

```
| Feature Name | Reach | Impact | Confidence | Effort | RICE Score | Priority | Status | Owner | Notes |
|--------------|-------|--------|------------|--------|------------|----------|--------|-------|-------|
| Password reset | 80 | 2.0 | 1.0 | 0.25 | =B2*C2*D2/E2 | P0 | Backlog | Dev | Standard feature |
| Email notifs | 100 | 1.0 | 1.0 | 0.5 | =B3*C3*D3/E3 | P1 | Backlog | Dev | Use SendGrid |
| Dark mode | 30 | 0.5 | 0.8 | 0.25 | =B4*C4*D4/E4 | P2 | Backlog | Dev | Low effort win |
```

**Formulas**:
- RICE Score column: `=Reach*Impact*Confidence/Effort`
- Sort by RICE Score descending for auto-prioritization

**Template Note**: Spreadsheet calculations can be replicated using Markdown tables above or managed in client PM tools (Jira, Linear, Notion).

---

## 11. When to Re-Prioritize (Triggers)

- **Weekly**: Quick review of top 5 items (still relevant?)
- **Monthly**: Full re-scoring of backlog
- **Ad-hoc triggers**:
  - Major user feedback (5+ requests for the same feature)
  - Competitor launches a similar feature
  - Technical blocker discovered (effort increased 2x)
  - Strategy pivot (target user changes)
  - Scope cut needed (deadline pressure, reduce to P0 only)

---

## 12. Summary Cheat Sheet

**Choose Framework Based On**:
- **RICE**: Default choice, balanced and data-driven
- **MoSCoW**: Quick triage, early-stage project
- **Value/Effort Matrix**: Visual presentation for stakeholders
- **Kano Model**: Understanding user psychology/satisfaction
- **ICE**: Faster than RICE, less granular

**Solo Dev Golden Rules**:
1. **Max 5 items in "Now"** — focus beats quantity
2. **Score ruthlessly** — not everything is high impact
3. **Use data** — interviewing 5 users beats 100 assumptions
4. **Revisit monthly** — priorities change, backlog should too
5. **Communicate decisions** — write down why feature X > Y (for your future self)

---

**📌 Next Steps**: Apply RICE to your backlog → Move top 5 to "Now" → Start building → Revisit next month
