# Usability Test Plan: [Project Name]

**Test Date**: [YYYY-MM-DD]  
**Iteration**: #[1/2/3]  
**Moderator**: [Name]  
**Observer**: [Name, optional]

---

## 1. Test Objectives

Validate 3-5 critical user journeys:

1. **[Objective 1]**: [Example: "New user can complete onboarding in <5 minutes without assistance"]
2. **[Objective 2]**: [Example: "User can find and export monthly report without a tutorial"]
3. **[Objective 3]**: [Example: "User understands document approval status on the dashboard"]
4. **[Objective 4]**: [...]
5. **[Objective 5]**: [...]

---

## 2. Participant Profile

**Target Demographics**:
- Role/Job Title: [Example: "HR Manager at a 50-500 employee company"]
- Tech Proficiency: [Beginner / Intermediate / Advanced]
- Domain Experience: [Example: "Familiar with Excel, previously used HRIS"]
- Geographic: [If relevant: "US/Global, fluent in English"]

**Screening Questions** (Send via Google Forms/Typeform):
1. How many employees do you manage? [ ] <50 [ ] 50-200 [ ] 200-500 [ ] >500
2. What tools do you currently use for [use case]? [Open text]
3. How often do you perform [relevant task]? [ ] Daily [ ] Weekly [ ] Monthly [ ] Rarely

**Recruitment Target**: Minimum **5 participants** per iteration

**Incentive**: [Example: "$15 gift card per session (45 minutes)"]

---

## 3. Test Tasks (Scenarios)

> **Writing Rules**: Use user intent, NOT UI navigation instructions ("click button X").

### Task 1: [Task Name — example: "First-Time Onboarding"]
**Scenario**:  
> "Imagine your first day using this system. Your company has just subscribed. Create your account and add 3 new employees (use dummy data)."

**Success Criteria**: User completes task without getting stuck >2 minutes, without asking moderator for help.

---

### Task 2: [Task Name — example: "Generate Monthly Report"]
**Scenario**:  
> "It's the end of the month. Your manager asks for the attendance report of all employees for September in Excel format. Try to obtain that report."

**Success Criteria**: User finds export feature in <3 clicks, successfully downloads file.

---

### Task 3: [Task Name]
**Scenario**:  
> [Write realistic scenario...]

**Success Criteria**: [...]

---

### Task 4: [Task Name]
**Scenario**:  
> [...]

**Success Criteria**: [...]

---

### Task 5: [Task Name]
**Scenario**:  
> [...]

**Success Criteria**: [...]

---

## 4. Testing Protocol

### Pre-Test (5 minutes)
1. Moderator introduction and session objectives
2. Explain think-aloud protocol:  
   > "Please speak your thoughts aloud while using this application, as if you are thinking out loud. There are no right or wrong answers."
3. Confirm recording consent (audio/screen)
4. Background questions (optional): Experience with similar tools

### During Test (30 minutes)
- **Observer's Role**: Record verbatim quotes, time on task, errors, and emotional cues (frustration, confusion, delight)
- **Moderator Prompts** (only if user is stuck >2 minutes):
  - "What are you looking for right now?"
  - "What do you expect to happen after clicking this?"
  - **DO NOT** give navigation clues ("try clicking the left menu")

### Post-Test (10 minutes)
1. Debrief: "Which part was easiest? Most confusing?"
2. SUS Questionnaire (10 questions — see Section 5)
3. Open feedback: "Any suggestions for improvement?"

---

## 5. System Usability Scale (SUS) Questionnaire

**Instructions**: Scale 1 (Strongly Disagree) to 5 (Strongly Agree)

1. I think that I would like to use this system frequently.
2. I found the system unnecessarily complex.
3. I thought the system was easy to use.
4. I think that I would need the support of a technical person to be able to use this system.
5. I found the various functions in this system were well integrated.
6. I thought there was too much inconsistency in this system.
7. I would imagine that most people would learn to use this system very quickly.
8. I found the system very cumbersome to use.
9. I felt very confident using the system.
10. I needed to learn a lot of things before I could get going with this system.

**SUS Score Calculation**:
- Odd questions (1, 3, 5, 7, 9): Score = (Rating - 1)
- Even questions (2, 4, 6, 8, 10): Score = (5 - Rating)
- Total = (Sum of all scores) × 2.5
- **Range**: 0-100 (not a percentage!)

**Interpretation**:
- <60: Poor (F)
- 60-69: Marginal (D)
- **70-79: Acceptable (C)** ← Minimum gate M04
- 80-89: Good (B)
- ≥90: Excellent (A)

---

## 6. Observation Data Collection Template

| Participant | Task | Completion (Y/N) | Time (min:sec) | Errors | Verbatim Quote | Notes |
| :---: | :---: | :---: | :---: | :---: | :--- | :--- |
| P1 | Task 1 | Y | 4:32 | 1 (clicked wrong menu) | "Where is the submit button?" | Confused by icon-only button |
| P1 | Task 2 | N | 8:15 | 3 | "Why is there no Export?" | Missed dropdown in table header |
| P2 | Task 1 | Y | 3:05 | 0 | "Wow, that was easy" | — |
| ... | ... | ... | ... | ... | ... | ... |

---

## 7. Post-Test Analysis Checklist

- [ ] Calculate average SUS score across all participants
- [ ] Identify top 3 pain points (highest error rate + negative quotes)
- [ ] List features/flows with <70% task completion rate
- [ ] Prioritize fixes: P0 (blockers), P1 (major friction), P2 (polish)
- [ ] Document iteration plan for next design revision

**Output**: Summary report for design iteration review (share with designer/PM).
