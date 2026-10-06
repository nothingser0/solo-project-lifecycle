# Daily Standup Format

> **Purpose**: Quick daily sync for development team  
> **Duration**: 15 minutes max  
> **When**: Every workday during sprint (M06.5)  
> **Format**: Async (Slack) or Sync (call)

---

## Standup Format

**Each team member answers 3 questions**:

1. **What did I complete yesterday?**
2. **What will I work on today?**
3. **Any blockers or help needed?**

---

## Template: Async Standup (Slack/Discord)

**Channel**: `#standup` or `#daily-updates`  
**Time**: Post by 9:30 AM every workday

```
📅 Standup - [Date]

✅ Yesterday:
- [Task 1 completed]
- [Task 2 completed]

🎯 Today:
- [Task 1 planned]
- [Task 2 planned]

🚧 Blockers:
- None / [Blocker description + who can help]

---

[Your Name]
```

**Example**:
```
📅 Standup - Oct 4, 2024

✅ Yesterday:
- Completed user registration API endpoint
- Fixed password validation bug
- Code review for Sarah's login PR

🎯 Today:
- Write unit tests for registration
- Start email verification feature
- Deploy to staging

🚧 Blockers:
- Need SendGrid API keys from client (waiting 2 days)
- Can continue with mock for now

---

John (Developer)
```

---

## Template: Sync Standup (Call)

**Time**: 9:00 AM daily  
**Duration**: 15 minutes max  
**Format**: Round-robin (each person speaks)

**Facilitator Script**:
```
"Good morning team! Let's do standup. 15 minutes max.
John, you're first - what did you complete, what's today's plan, any blockers?"

[John speaks - 2 min max]

"Thanks John. Sarah, you're next..."

[Sarah speaks - 2 min max]

"Thanks Sarah. Mike, go ahead..."

[Mike speaks - 2 min max]

"Great. Any cross-team discussion needed? If not, let's get back to work!"
```

---

## Standup Anti-Patterns (Avoid!)

❌ **Status Report to Manager**: "Yesterday I worked 8 hours on..."  
✅ **Peer Update**: "I unblocked Sarah by reviewing her PR"

❌ **Problem Solving**: "So the bug is caused by... let me explain..."  
✅ **Flag & Defer**: "Hit a bug, need help from John - let's chat after standup"

❌ **Long Stories**: "So first I tried X, then Y, then Z didn't work..."  
✅ **Brief Summary**: "Completed feature X, blocked on Y"

❌ **Goes Over Time**: 30+ minutes of discussion  
✅ **Timeboxed**: 15 minutes max, defer deep dives

❌ **Skip if "Nothing to Report"**: Team member silent  
✅ **Always Participate**: Even if small update

---

## Standup Variations

### Format 1: Walk the Board

Instead of round-robin, review sprint board:
- Look at "In Progress" column
- Owner speaks about each card
- Move cards to "Done" if complete

**Best for**: Visual teams, small teams (<5 people)

---

### Format 2: Parking Lot

- Quick 3-question round-robin (10 min)
- Note discussion topics in "parking lot"
- After standup: Relevant people stay for parking lot items

**Best for**: Teams with frequent cross-team issues

---

### Format 3: Async Only (No Call)

- Everyone posts in Slack by 9:30 AM
- React with 👀 when you've read all updates
- DM directly if you can unblock someone

**Best for**: Distributed teams, different timezones

---

### Format 4: Hybrid (Async + Weekly Sync)

- Daily: Async updates in Slack
- Monday: 15-min sync call for planning
- Friday: 15-min sync call for demo prep

**Best for**: Remote teams that want some face time

---

## Blocker Escalation

**When to flag a blocker**:
- ✅ Waiting >24 hours for something
- ✅ Don't know how to proceed
- ✅ External dependency (client, API, access)
- ✅ Technical decision needed

**How to flag**:
```
🚧 Blockers:
- [URGENT] Prod database down, can't deploy (need DevOps help NOW)
- Waiting on design approval from client (2 days, not critical yet)
```

**Blocker Categories**:
- 🔴 **Critical**: Blocks all work, need help NOW
- 🟡 **Important**: Slowing down, need help today
- 🟢 **Low**: Can work around, need help this week

---

## Standup Checklist

**For Team Members**:
- [ ] Post update by 9:30 AM (async) or join call (sync)
- [ ] Be specific ("completed login API" not "worked on code")
- [ ] Flag blockers clearly
- [ ] Keep it under 2 minutes
- [ ] Read others' updates (react with 👀)

**For Facilitator** (if sync standup):
- [ ] Start on time (9:00 AM sharp)
- [ ] Keep time (2 min per person max)
- [ ] Cut off problem-solving ("Let's discuss after")
- [ ] Note action items
- [ ] End by 9:15 AM

---

## Example: Full Week of Async Standups

```
📅 Monday, Oct 7, 2024

✅ Weekend:
- N/A (weekend off)

🎯 Today:
- Sprint planning meeting 10 AM
- Setup dev environment for new sprint
- Review sprint backlog

🚧 Blockers:
- None

---

John (Developer)
```

```
📅 Tuesday, Oct 8, 2024

✅ Yesterday:
- Sprint planning completed
- Started user registration feature
- Created database migration

🎯 Today:
- Complete registration API
- Write unit tests
- Code review for Sarah

🚧 Blockers:
- None

---

John (Developer)
```

```
📅 Wednesday, Oct 9, 2024

✅ Yesterday:
- Completed registration API ✓
- Unit tests written ✓
- Reviewed Sarah's PR

🎯 Today:
- Email verification feature
- Deploy to staging
- Fix bug #123

🚧 Blockers:
- 🟡 Need SendGrid API keys (waiting 2 days)
- Can use mock for now

---

John (Developer)
```

```
📅 Thursday, Oct 10, 2024

✅ Yesterday:
- Email verification 80% done
- Deployed to staging
- Bug #123 fixed

🎯 Today:
- Complete email verification
- Integration testing
- Help Sarah with login bug

🚧 Blockers:
- Still waiting on SendGrid keys (Day 3)
- Using mock, but need real keys before sprint end

---

John (Developer)
```

```
📅 Friday, Oct 11, 2024

✅ Yesterday:
- Email verification complete! 🎉
- Integration testing passed
- Helped Sarah debug session issue

🎯 Today:
- Code review backlog (3 PRs)
- Write end-of-sprint summary
- Prepare for sprint demo 3 PM

🚧 Blockers:
- 🔴 SendGrid keys STILL pending (Day 4)
- Blocking production deploy next week
- Escalated to client

---

John (Developer)
```

---

## When to Skip Standup

**OK to skip**:
- ✅ Public holiday
- ✅ Team member on approved leave
- ✅ Team off-site/retreat (replace with other sync)

**NOT OK to skip**:
- ❌ "Too busy to update" (takes 2 minutes)
- ❌ "Nothing to report" (say what you're working on)
- ❌ "Forgot" (set reminder)

---

## Standup Tools

**Async**:
- Slack (channel + Geekbot/Standuply bot)
- Discord
- Email thread (not recommended, gets messy)

**Sync**:
- Google Meet
- Zoom
- Discord voice channel
- In-person (if co-located)

**Project Boards**:
- Linear (walk the board)
- Jira
- Trello
- GitHub Projects

---

## Standup Metrics (Optional)

**Track to improve**:
- Average standup duration (goal: <15 min)
- Blocker resolution time (goal: <24 hours)
- Participation rate (goal: 100%)

**Don't track**:
- Number of tasks completed (creates pressure)
- Hours worked (not relevant)

---

## Standup FAQ

**Q: What if I have nothing to report?**  
A: Say what you're continuing from yesterday. Even "Still working on feature X, 50% done" is useful.

**Q: What if my blocker needs discussion?**  
A: Flag it briefly ("Stuck on bug, need John's help"), then discuss after standup.

**Q: What if I'm remote in different timezone?**  
A: Use async format. Post update within your work hours, team reads when available.

**Q: What if standup always runs long?**  
A: Timekeeper role: Cut off at 2 min per person, defer discussions.

**Q: What if someone always misses standup?**  
A: 1-on-1 with manager. Consistent no-shows indicate disengagement.

---

## Integration with Sprint Workflow

**Daily Cycle** (Mon-Fri):
1. **9:00-9:15 AM**: Daily standup (sync) OR Post update (async)
2. **9:15 AM-5:00 PM**: Development work
3. **5:00 PM**: Commit code, update sprint board
4. **End of day**: Reflect on progress for tomorrow's standup

**Weekly Cycle**:
- **Monday**: Standup + sprint planning (if new sprint)
- **Tuesday-Thursday**: Regular standup
- **Friday**: Standup + demo prep + client update

---

## Standup Template Files

**Slack Message Template** (pin to #standup channel):
```
📌 Daily Standup Format

Post by 9:30 AM every workday:

✅ Yesterday:
- [What you completed]

🎯 Today:
- [What you'll work on]

🚧 Blockers:
- None / [Blocker description]

Use emojis:
🔴 Critical blocker
🟡 Important blocker  
🟢 Low priority blocker
🎉 Feature completed
```

**Slack Reminder Bot** (schedule daily at 9:00 AM):
```
@channel Good morning! Time for daily standup 📅
Please post your update in thread below ⬇️
```

---

## Example: Standup Thread (Async)

```
[9:02 AM] Bot: @channel Good morning! Time for daily standup 📅

[9:08 AM] John:
📅 Oct 4, 2024
✅ Yesterday: Completed registration API, unit tests
🎯 Today: Email verification, staging deploy
🚧 Blockers: None

[9:12 AM] Sarah:
📅 Oct 4, 2024
✅ Yesterday: Login page UI, started session management
🎯 Today: Complete sessions, integration testing
🚧 Blockers: 🟡 Need help debugging cookie issue (John after standup?)

[9:15 AM] John:
@Sarah Sure, let's sync at 10 AM

[9:20 AM] Mike:
📅 Oct 4, 2024
✅ Yesterday: Dashboard wireframes approved
🎯 Today: Hi-fi mockups, responsive layouts
🚧 Blockers: None

[9:25 AM] Sarah:
👀 Read all
```

---

## Standup Checklist

Daily:
- [ ] Post/attend by 9:30 AM
- [ ] Answer 3 questions (yesterday, today, blockers)
- [ ] Be specific and brief (2 min max)
- [ ] Flag blockers clearly
- [ ] Read teammates' updates
- [ ] Follow up on blockers

Weekly (Facilitator):
- [ ] Review standup participation rate
- [ ] Address recurring blockers
- [ ] Adjust format if needed (sync vs async)
- [ ] Share blockers with client/stakeholders

---

## Notes

**Standup is not**:
- ❌ Status report to manager
- ❌ Problem-solving session
- ❌ Sprint planning
- ❌ Code review

**Standup is**:
- ✅ Quick team sync
- ✅ Blocker visibility
- ✅ Accountability
- ✅ Team coordination
