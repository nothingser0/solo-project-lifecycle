# AI Writing Tells — The Structural Blacklist

> **Module**: M04 (copy), M06 (README/docs), M07 (polish audit), M11 (handover docs)
> **Source**: Adapted from `coreyhaines31/marketingskills` (MIT) — `copywriting/references/ai-tells.md`. Patterns and evidence are drawn from Wikipedia's *Signs of AI writing* (WikiProject AI Cleanup) and Kobak et al., excess vocabulary in 15M+ PubMed abstracts (arXiv 2406.07016).
> **Companion**: `references/design/BRAND_VOICE_GUIDE.md` holds the *word* blacklist. This file holds the **shape** blacklist — the reason a draft can avoid every banned word and still read as machine-written.

---

## 1. Why shape beats vocabulary

Most of these devices are old human rhetoric. AI copy gives itself away by using them **by default**, **stacked**, and **with nothing specific behind them**.

That is why a synonym swap does not fix a draft. Replace "robust" with "reliable" and you have a new tell. Replace it with **"99.99% uptime over two years"** and the problem is gone.

| Level | Signal | Confidence |
| :--- | :--- | :--- |
| **Ban** | A tell even once. Do not write it. | Highest |
| **Cap** | Fine once, a tell when repeated or stacked. | Contextual |

**Scopes**: *short copy* = headlines, subheads, hero, CTAs, ads, social, subject lines · *long copy* = page body, articles, long emails · *section* = one hero, one page section, or one short post. CTA microcopy ("No card required") does not count toward the fragment cap.

---

## 2. Structural patterns (these matter more than any word list)

| # | Pattern | Example | Status |
| :-: | :--- | :--- | :--- |
| 1 | **Contrast reveal** — "Not X. Y." | "Not because they're bad. Because each needs a developer." | **Ban** |
| 2 | **Negation list** — "No X, no Y, no Z." | "No setup. No config. No code." | **Ban** |
| 3 | **Trailing pile-on** — long sentence + comma-spliced fragment list | "…which means faster launches, cleaner data, happier teams." | **Ban** |
| 4 | **Rhetorical question, then answer** | "Wondering how to scale? Here's the answer." | **Ban** |
| 5 | **Colon reveal** | "The result: a 40% lift." | **Ban** |
| 6 | **Fragment drumbeat** | "Fast. Simple. Reliable." | Cap: 1 per section |
| 7 | **Reflexive threes** | Three items where two or four are true | Cap: 1 per section |
| 8 | **Em dashes** | — used as a dramatic pause | **Ban in short copy**; 1–2 per page in long copy |
| 9 | **Uniform rhythm** | Every sentence 12–16 words | Cap |
| 10 | **Dodging "is" / "has"** | "Our platform enables teams to…" instead of "Teams can…" | Cap |
| 11 | **Abstract subjects** | "This approach allows for…" | Cap |
| 12 | **False ranges** | "From solo founders to enterprise" (when both are not served) | Cap |
| 13 | **Synonym cycling** | "tool… platform… solution… system" for one thing | Cap |

**The fix for #1** (the most-cited tell): merge into one sentence that carries the reason.

> ✗ Most teams have a list of ideas that never launch. Not because they're bad. Because each needs a developer.
> ✓ Most teams have a list of ideas that never launch, because each needs a developer they can't get.

### 2.1 More structural tells

| Pattern | Example | Status |
| :--- | :--- | :--- |
| **Hyphenated compound overuse** | "the report is high-quality" | Cap: hyphenate only when attributive (`a high-quality report`), drop it in predicate position (`the report is high quality`) |
| **Persuasive authority tropes** | "The real question is…", "At its core…", "What really matters…" | **Ban** — ceremony in place of a point |
| **Fragmented headers** | A heading followed by a one-line paragraph restating the heading | **Ban** — delete the warm-up sentence |
| **Diff-anchored writing** | "This function was added to replace the previous approach…" | **Ban** outside changelogs — describe the thing as it is, not the change |
| **Aphorism formulas** | "Symmetry is the language of trust." "Efficiency becomes a trap." | **Ban** — replace with the concrete claim it gestures at |
| **Conversational rhetorical openers** | "Honestly?" "Look," "Here's the thing" as a standalone hook | **Ban** — a person being honest just says the thing |
| **Collaborative artifacts** | "I hope this helps!", "Let me know if you'd like me to expand" | **Ban** in delivered content — chatbot correspondence pasted as prose |
| **Knowledge-cutoff disclaimers** | "While specific details are limited…", "maintains a low profile" | **Ban** — say what is not known, or cut the sentence. Never dress a guess as fact |
| **Sycophantic tone** | "Great question!", "You're absolutely right!" | **Ban** |
| **Inline-header vertical lists** | `- **UX:** The UX has been improved.` | Cap — collapse to prose unless it is genuinely a reference table |
| **Boldface overuse** | Every other phrase in bold | Cap |
| **Curly quotes** | “…” | Cap — only a tell stacked with others; most editors curl automatically |

**On em dashes — a contradiction in the source, resolved here.** The upstream skill bans em dashes outright (§14) *and* lists them as a false positive ("many editors and journalists use them often; evidence only when paired with formulaic rhythm"). Both cannot hold. This framework keeps the contextual rule: **a lone em dash is not evidence; em dashes plus short-sentence drama plus a rule of three is.** In short copy (headline, subhead, CTA, subject line) treat them as banned, because there is no room for a genuine editorial aside.

---

## 3. Openers, closers and setups (all Ban)

| Pattern | Example | Instead |
| :--- | :--- | :--- |
| Era opener | "In today's fast-paced world…" | Open with the customer's problem |
| False-choice opener | "Whether you're a solo founder or a Fortune 500…" | Name who the page is for |
| "Imagine…" | "Imagine never chasing an invoice again." | Show the actual before and after |
| "When it comes to…" | "When it comes to billing…" | Start with the subject |
| Throat-clearing | "Here's the thing:" / "The truth is" / "Let me be clear" | Cut it. If the claim cannot stand alone, it needs evidence, not a drumroll |
| Announcing | "In this guide, we'll explore…" / "Let's dive in" | Start with the content |
| Recap ending | "In conclusion" / "Ultimately" / "At the end of the day" | End on the last concrete point or the CTA |
| Fake-profound kicker | "Because growth shouldn't wait." | Cut it. End on a concrete sentence |
| Filler transitions | "It's worth noting" / "Moreover" / "Additionally" | Delete — the sentence usually works without it |

---

## 4. Marketing phrases (all Ban)

| Phrase | Instead |
| :--- | :--- |
| "Say goodbye to X" / "Say hello to Y" | Show the new workflow: "Reconciliation runs nightly. You review the exceptions." |
| "Unlock / unleash the power of X" | Name the outcome and the number |
| "X, reimagined" / "X, redefined" | Say what is actually different |
| "Take X to the next level" | Name the metric and the target |
| "Transform the way you work" | A before and after with numbers |
| "The X you deserve" | The specific gap you close |
| "The future of X is here" | What ships today |
| "Built for teams who move fast" | The real customer and trigger |
| "Everything you need to X" / "all-in-one" | The 2–3 things buyers actually check |
| "Effortless" / "in just a few clicks" | The real step count or time |
| "Join thousands of happy customers" | The real count, logos, or a named quote |
| "Game-changer" / "this changes everything" | What changes, for whom, by how much |

---

## 5. Vocabulary

**Ban**: delve, tapestry, testament to, realm, embark, beacon, multifaceted, paradigm, synergy, myriad, plethora, meticulous, intricate, utilize, leverage (as a verb), supercharge, turbocharge, game-changer, "ever-evolving landscape", "plays a crucial role".

**Cap** (two in a paragraph means rewrite the paragraph): seamless, robust, streamline, empower, elevate, unlock, unleash, harness, foster, enhance, optimize, cutting-edge, innovative, revolutionary, transformative, holistic, comprehensive, pivotal, crucial, vital, powerful, next-level, world-class, best-in-class, landscape, navigate, ecosystem, journey (unless literal).

**Cap** (empty intensifiers): truly, genuinely, incredibly, deeply, fundamentally, significantly, simply, actually, literally, quietly.

> **These lists drift.** "Delve" peaked in 2024; "enhance", "showcase", "foster" and "align with" rose afterwards. Treat the words as current examples and lean on the **structural patterns and the tests**, which do not go stale.

---

## 6. Hedges, puffery and weasels

- **Hedge stacks** (Cap): "can help you potentially reduce…" — state what you know, or scope the claim honestly.
- **Importance puffery** (Ban): "marks a pivotal moment", "redefines the category".
- **Weasel sources** (Ban): "experts agree", "studies show", "trusted by industry leaders". Name the source or cut it.
- **Invented labels** (Cap): "the integration tax", "the growth trap". Only coin a term you will define and use consistently.

---

## 7. Tone and formatting

- **Chummy openers** (Ban in email/social): "Great question!", "Let's be honest…", "We get it."
- **Fake vulnerability** (Ban): "I'll be honest, I was skeptical too…" with no real story.
- **Over-explaining** (Cap): "Let's break this down", "Think of it as…"
- **Hype punctuation** (Ban): "Ready to level up?!" — exclamation points and interrobangs in body copy.
- **Emoji as structure** (Ban in B2B): 🚀 ✨ ✅ leading bullets or headings.
- **Bold label on every bullet** (Cap): keep it for reference tables, not every list.
- **Parallel bullet openers** (Cap): every bullet starting "Ensures… / Provides… / Enables…".
- **Title Case Everywhere** (Cap): use sentence case unless the brand guide says otherwise.
- **Unicode decoration** (Ban): arrows, ×, 𝗯𝗼𝗹𝗱 letters in body copy.
- **Label headings** (Cap): "What / Why / How" sections. Write headings that make a claim.

---

## 8. Second-generation tells

These appear in copy that has **already been de-slopped**. The banned words and contrast reveals are gone, but the draft still reads as generated because the model swapped one habit for another. Check these **after** fixing the patterns above.

| Tell | Example | Fix |
| :--- | :--- | :--- |
| **Wisdom-shaped sentences** (Ban) | "Great tools get out of the way." "Speed is a feature." | A sentence shaped like an insight that nobody would disagree with. Replace with the specific fact it gestures at, or cut |
| **Performed cleverness** (Cap) | "Your inbox, minus the noise." | Unexpected word pairings built to sound witty. Keep one only if the brand is playful **and** it says something true |
| **Staccato bursts** (Cap) | "It's fast. It's simple. And it just works." | Three or more short sentences in a row as a rhythm device. Merge into one sentence that carries a fact |
| **Perfect balance** (Cap) | Every section has a heading, two sentences and three bullets | Real writers spend more words on what they care about. Let the strongest section run long |
| **Omniscient casual** (Cap) | Chatty voice that never admits a limit | Casual tone plus total certainty reads as generated. Scope claims; say who the product is **not** for |
| **Self-narration** (Ban) | "Here's why this matters." "This is where it gets interesting." | Sentences commenting on the copy itself. Delete |
| **Tidy closers** (Ban) | "Because your team deserves better." | A quotable last line that could close any page. End on a number, a named customer, the offer, or the CTA |
| **Reflexive specificity** (Cap) | Every claim has a suspiciously round stat | Specificity copied as a style. Every number must be real and sourced — mark gaps `[NEED: proof]` instead of filling them |

## 8A. The claim-evidence audit (run before a document ships)

`[NEED: proof]` is a rule you apply while writing. This is the check you run **after**, and it catches what the rule misses: numbers that got filled in with something plausible.

**Extract every number and attributive claim, then sort each into three buckets.**

| Bucket | Meaning | Action |
| :--- | :--- | :--- |
| **Supported** | The value appears in a source document you can point to (the client brief, the test log, the API response) | Keep. Record where. |
| **Attributed** | The sentence carries a citation, a named source, or a prior-work reference | Keep. The attribution is the evidence. |
| **Needs evidence** | Neither — the number exists only in this draft | **This is the finding.** Restate it from a real source, attribute it, or remove it. |

**What counts as a claim worth auditing**: percentages, monetary amounts, durations, counts, "N× faster", "up to N users", uptime figures, and any sentence in the shape "studies show" / "experts agree" / "industry leading".

**Where it applies in this framework** — every artifact a client reads:
- `PROPOSAL_DECK.md`, `QUOTATION_EMAIL.md` — a fabricated benchmark in a proposal is a contractual problem
- `README.md`, `USER_MANUAL.md` — handover artifacts that outlive the engagement
- `SITE_COPY` / landing copy — "10,000+ users" with 40 users is the classic
- `BENCHMARK.md`, load-test reports — the number must trace to a run, not to a memory of a run

**The rule that makes it work**: a number with no source is *not* a weakness to be softened — it is a defect, and the fix is removal or `[NEED: <what you need>]`, never a rounder-looking guess. A missing number costs one question. An invented one costs the client's trust and, in a proposal, the contract.

**Do not run this on internal drafts.** It is a gate before delivery, not a writing style; applied too early it interrupts the draft with questions you have not answered yet.

---

## 9. Rewrite rules

1. **Rewrite from the facts.** Go back to the mechanism, the number, the customer, the step — and write that. Synonym swaps produce new tells.
2. **Specificity test.** Every claim sentence needs a number, a name, a mechanism, or a concrete action.
3. **Swap test.** If the line would work unchanged on a competitor's site, rewrite it.
4. **Stacking test.** Two or more Cap patterns in one paragraph means rewrite the paragraph.
5. **Do not invent to de-slop.** Replacing "industry-leading" with a made-up statistic is worse than the original. Mark it `[NEED: proof]` and ask.
6. **Choose devices on purpose.** A fragment you picked once, for a reason, is copywriting. The same device on every line is slop.
7. **Keep the brand's register.** A formal sentence that makes a specific claim is fine. Flattening an enterprise voice into clipped startup copy is its own tell.
8. **Vary the fixes.** If every reveal becomes ", because…" and every negation list becomes "There's nothing to X", those are the new tics.
9. **Flag a missing differentiator.** If no headline can pass the swap test with what you have, write the best one and mark `[NEED: differentiator vs. named competitors]`.

---

## 10. The self-check (run on every draft)

1. **Search for the bans** — look for "not ", "isn't", "no ", "without", "?", ":" and "—" in headlines, subheads and short copy; check each hit against patterns 1–5 and 8.
2. **Read every sentence over 20 words** — more than two commas means check for a trailing pile-on (#3).
3. **Count the caps** — fragments, threes, and Cap vocabulary per section.
4. **Read it aloud** — mark anywhere you would sound like a press release or a LinkedIn post.
5. **Apply the swap test** to the headline, subhead and every section heading.
6. **Scan for second-generation tells** — the last line of every section, wisdom-shaped sentences, and whether all sections are about the same length.

**If a fix needs information you do not have** (a number, a customer, a mechanism), flag it rather than writing around it.

---

## 10.1 What NOT to flag (false positives)

Every rule above can fire on clean human writing. Before rewriting, check that you are not gutting legitimate prose. **The signal is a cluster, not an isolated hit.**

| Not evidence on its own | Why |
| :--- | :--- |
| Perfect grammar and consistent style | Professional writers and editors produce this |
| Mixed casual and formal registers | Common in technical fields and in neurodivergent prose |
| "Bland" or dry prose | AI has *specific* tells; generic dryness is just dry writing |
| Formal or academic vocabulary | AI overuses *specific* fancy words, not all fancy words. Do not flatten "ostensibly" or "constituent" |
| Salutation and sign-off on a comment | Predates ChatGPT by centuries |
| One transition word ("however", "additionally") | AI-coded only when piled up |
| Curly quotes alone | Most editors and CMSes curl automatically |
| Em dashes alone | Many journalists use them constantly (see §2.1) |
| One short emphatic sentence | Humans use clipped sentences to land a point |
| "Honestly" mid-sentence | Ordinary in casual writing — the tell is the standalone theatrical opener |
| Unsourced claims | Most of the web is unsourced; that proves nothing |
| Clean, complex formatting | Visual editors and templates produce this without AI |
| Text inside quotations, titles, proper names, or examples | Do not "fix" a phrase that is being discussed rather than used |

**The test**: a single em dash means nothing; em dashes plus rule-of-three plus "vibrant tapestry" plus a "Conclusion" section is a confession.

---

## 10.2 Signs of human writing (preserve these)

Over-editing destroys the thing that made the draft sound human. When you see these, lean toward leaving the prose alone.

| Signal | What it looks like |
| :--- | :--- |
| **Hard-to-fabricate specificity** | A real address, a weird quote, "the lawyer who used to work upstairs from my dentist". Models round specifics off; humans hoard them |
| **Mixed feelings and unresolved tension** | "I think this is mostly good, but it bothers me, and I can't fully explain why." Models default to clean takes |
| **Era-bound references** | Slang, memes and in-jokes that map to a specific year and subculture. Models lag a year or more |
| **Defensible editorial choices** | If the writer can explain *why* they cut a line or chose a word, that is a strong human signal |
| **Sentence-length variety** | Real writing alternates short and long; AI drifts toward an even mid-length cadence |
| **Genuine asides and self-corrections** | "(I keep wanting to say 'almost' here, but it really was certain.)" Models rarely interrupt themselves |
| **Anything written before 30 Nov 2022** | ChatGPT's public launch — with rare exceptions, not AI-written |

**The rule this implies**: humanising is not the same as neutralising. Deleting every rough edge produces the flat, voiceless register that is itself a tell. The upstream skill calls this out directly: *avoiding AI patterns is only half the job; sterile writing is just as obvious as slop.*

**Scope guard**: personality belongs in blog posts, essays, opinion and personal writing. For encyclopedic, technical, legal or reference text, **neutral and plain is the correct human voice** — do not inject opinions or first person there. This matters for `USER_MANUAL.md` and API documentation, where a chatty voice would be the defect.

---

## 10.3 The copy-specific audit (three questions)

For copy (headlines, microcopy, subject lines), the self-check above is necessary but not sufficient — a line can pass every pattern test and still be dead. Run these three, and cut or rewrite any line that fails one:

1. **Name the feeling the reader has the moment this line reaches them.** Does the line meet that feeling, or talk past it? A frustrated person needs the fix in the first three words; a skeptical person needs proof before adjectives.
2. **Could the reader repeat what this promises after one read, in their own words?** If not, the line is too abstract to transmit.
3. **Would this line survive alone on a billboard, or does it only sound good next to the other variants?** A line that needs its siblings to make sense is not a line.

**Delivering variants**: lead with the pick, one line of commentary per variant at most, and justify by the reader's feeling — never "this one is punchier".

---

## 11. Where this applies in this framework

| Artifact | Why it matters here |
| :--- | :--- |
| `DESIGN_SPEC.md` / `STATE_COPY.md` | Error, empty and success copy is the most-read text in the product |
| `README.md` / `USER_MANUAL.md` | The handover artifact the client keeps after you leave |
| `PROPOSAL_DECK.md` / `QUOTATION_EMAIL.md` | Copy that decides whether the contract is signed — run §8A before sending |
| M07 `POLISH_AUDIT` row 23–25 | AI-slop tells are already a blocking audit row — this file is the detail behind it |
| Any agent-written summary | An agent describing its own work defaults to these patterns most of all |
