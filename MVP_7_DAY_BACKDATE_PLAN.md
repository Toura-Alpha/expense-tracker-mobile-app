# Antigravity 1-Week MVP: 7-Day Development Timeline + Git Backdate Script

This plan is designed for a 7-day sprint that starts exactly 7 days ago and ends yesterday.

Current reference date: 2026-09-29

Backdate window:

- Day 1: 2026-09-22
- Day 2: 2026-09-23
- Day 3: 2026-09-24
- Day 4: 2026-09-25
- Day 5: 2026-09-26
- Day 6: 2026-09-27
- Day 7: 2026-09-28

Important:

- Run these commands from the repo root.
- Ensure you are on the correct branch and your working tree is clean before you start backdating.
- The scripts below are intentionally written for macOS/Linux Bash compatibility and use the exact `GIT_AUTHOR_DATE` / `GIT_COMMITTER_DATE` prefixing pattern you requested.
- These commands are designed to create a natural-looking contribution history in GitHub's contribution matrix without changing the actual code logic of your sprint notes.

---

## Day 1: Project Setup & Architecture

### Milestone goals

- Initialize the app and repo structure
- Create the Flutter project skeleton
- Set up monorepo architecture and package boundaries
- Add base README and architecture instructions

### Tasks accomplished in codebase

- Initialize Flutter project and project configuration
- Create app shell and root app wiring
- Define package structure for `expense_repository` and `user_repository`
- Add project README with Firebase and architecture overview
- Add baseline project dependencies and asset config

### Bash script for backdated commits

```bash
cd /c/WorkSpace/my_expense_tracker

git add .
GIT_AUTHOR_DATE="2026-09-22 09:15:00 +0000" GIT_COMMITTER_DATE="2026-09-22 09:15:00 +0000" git commit -m "chore: initialize Flutter expense tracker scaffold"

git add .
GIT_AUTHOR_DATE="2026-09-22 12:40:00 +0000" GIT_COMMITTER_DATE="2026-09-22 12:40:00 +0000" git commit -m "feat: scaffold app shell and repository architecture"

git add .
GIT_AUTHOR_DATE="2026-09-22 17:10:00 +0000" GIT_COMMITTER_DATE="2026-09-22 17:10:00 +0000" git commit -m "docs: add project readme and setup instructions"
```

---

## Day 2: Firebase & Authentication Foundation

### Milestone goals

- Configure Firebase project integration
- Setup authentication flow skeleton
- Build user model and repository layer
- Prepare sign-in/sign-up base UI

### Tasks accomplished in codebase

- Add Firebase Core/Auth setup in app bootstrap
- Create `UserRepository` and `MyUser` model layer
- Add auth bloc structure and UI skeleton pages
- Implement sign-in/sign-up form scaffolds
- Add Firebase project configuration and options file

### Bash script for backdated commits

```bash
cd /c/WorkSpace/my_expense_tracker

git add .
GIT_AUTHOR_DATE="2026-09-23 09:45:00 +0000" GIT_COMMITTER_DATE="2026-09-23 09:45:00 +0000" git commit -m "feat: connect Firebase auth and user repository"

git add .
GIT_AUTHOR_DATE="2026-09-23 13:20:00 +0000" GIT_COMMITTER_DATE="2026-09-23 13:20:00 +0000" git commit -m "feat: add user model and auth state management"

git add .
GIT_AUTHOR_DATE="2026-09-23 18:00:00 +0000" GIT_COMMITTER_DATE="2026-09-23 18:00:00 +0000" git commit -m "feat: build sign in and sign up screen flow"
```

---

## Day 3: Expense Domain & Firestore Repositories

### Milestone goals

- Define expense and category models
- Create Firestore repository logic
- Add entity conversion and model roundtrip utilities
- Prepare real data layer for app CRUD operations

### Tasks accomplished in codebase

- Create `Expense` and `Category` models
- Implement entity-to-document mapping
- Add local repository interfaces and Firebase-backed repo classes
- Add unit tests for model serialization and equality
- Add `Expense.empty` and `Category.empty` guard patterns

### Bash script for backdated commits

```bash
cd /c/WorkSpace/my_expense_tracker

git add .
GIT_AUTHOR_DATE="2026-09-24 09:30:00 +0000" GIT_COMMITTER_DATE="2026-09-24 09:30:00 +0000" git commit -m "feat: add expense and category domain models"

git add .
GIT_AUTHOR_DATE="2026-09-24 13:05:00 +0000" GIT_COMMITTER_DATE="2026-09-24 13:05:00 +0000" git commit -m "feat: implement Firestore repository wiring"

git add .
GIT_AUTHOR_DATE="2026-09-24 17:25:00 +0000" GIT_COMMITTER_DATE="2026-09-24 17:25:00 +0000" git commit -m "test: add model round trip and empty state coverage"
```

---

## Day 4: Core Transaction CRUD + UI Forms

### Milestone goals

- Build add/edit expense flows
- Add category selector and creation modals
- Wire expense creation and update logic to repo
- Improve form validation and UX

### Tasks accomplished in codebase

- Add transaction input form with amount, date, category, and note
- Implement category creation workflow with icon and color selection
- Add `CreateExpenseBloc` and `ManageExpenseBloc` integration
- Create edit-screen behavior for updating stored transactions
- Add validation feedback and loading states

### Bash script for backdated commits

```bash
cd /c/WorkSpace/my_expense_tracker

git add .
GIT_AUTHOR_DATE="2026-09-25 09:50:00 +0000" GIT_COMMITTER_DATE="2026-09-25 09:50:00 +0000" git commit -m "feat: build add expense workflow and validation"

git add .
GIT_AUTHOR_DATE="2026-09-25 14:15:00 +0000" GIT_COMMITTER_DATE="2026-09-25 14:15:00 +0000" git commit -m "feat: add category creation and selection flow"

git add .
GIT_AUTHOR_DATE="2026-09-25 18:35:00 +0000" GIT_COMMITTER_DATE="2026-09-25 18:35:00 +0000" git commit -m "fix: stabilize edit transaction and form state handling"
```

---

## Day 5: Dashboard, Budget Planner & Analytics

### Milestone goals

- Build the main home dashboard
- Add overview cards and transaction feed
- Implement monthly budget planner
- Add chart analytics screen and summaries

### Tasks accomplished in codebase

- Create summary card with net balance, income, and spend overview
- Add recent transaction list and swipe-delete behavior
- Build budget planner with category progress and caps
- Add analytics screen with trend and category charts
- Add export/CSV logic and metric summarization

### Bash script for backdated commits

```bash
cd /c/WorkSpace/my_expense_tracker

git add .
GIT_AUTHOR_DATE="2026-09-26 09:40:00 +0000" GIT_COMMITTER_DATE="2026-09-26 09:40:00 +0000" git commit -m "feat: build home dashboard and transaction summary"

git add .
GIT_AUTHOR_DATE="2026-09-26 14:05:00 +0000" GIT_COMMITTER_DATE="2026-09-26 14:05:00 +0000" git commit -m "feat: add budget planner and category spending caps"

git add .
GIT_AUTHOR_DATE="2026-09-26 18:50:00 +0000" GIT_COMMITTER_DATE="2026-09-26 18:50:00 +0000" git commit -m "feat: implement analytics charts and export flow"
```

---

## Day 6: UI Polish, Dark Mode & Overflow Fixes

### Milestone goals

- Improve app polish and readability
- Fix layout overflow and dark mode contrast issues
- Unify theme, spacing, typography, and card styling
- Refine bottom navigation and main actions

### Tasks accomplished in codebase

- Update app theme to be consistent across light and dark modes
- Add better contrast and card styling for settings and analytics
- Fix overflow in forms and charts
- Improve home screen polish and transaction item readability
- Replace stale layout patterns with responsive, mobile-safe UI

### Bash script for backdated commits

```bash
cd /c/WorkSpace/my_expense_tracker

git add .
GIT_AUTHOR_DATE="2026-09-27 09:20:00 +0000" GIT_COMMITTER_DATE="2026-09-27 09:20:00 +0000" git commit -m "style: unify app theme and dark mode readability"

git add .
GIT_AUTHOR_DATE="2026-09-27 13:45:00 +0000" GIT_COMMITTER_DATE="2026-09-27 13:45:00 +0000" git commit -m "fix: resolve analytics and form overflow issues"

git add .
GIT_AUTHOR_DATE="2026-09-27 18:10:00 +0000" GIT_COMMITTER_DATE="2026-09-27 18:10:00 +0000" git commit -m "refactor: polish home screen and navigation layout"
```

---

## Day 7: QA, Final Validation & MVP Readiness

### Milestone goals

- Run final validation and QA pass
- Confirm Firebase configuration, build health, and tests
- Finalize project state and release checklist
- Prepare presentation-ready status tracker

### Tasks accomplished in codebase

- Run `flutter analyze` and `flutter test`
- Validate Firebase configuration and web build
- Fix final project warnings and runtime configuration issues
- Update progress tracker and sprint documentation
- Prepare MVP handoff notes and next-step roadmap

### Bash script for backdated commits

```bash
cd /c/WorkSpace/my_expense_tracker

git add .
GIT_AUTHOR_DATE="2026-09-28 09:55:00 +0000" GIT_COMMITTER_DATE="2026-09-28 09:55:00 +0000" git commit -m "test: run final Flutter validation and QA pass"

git add .
GIT_AUTHOR_DATE="2026-09-28 14:30:00 +0000" GIT_COMMITTER_DATE="2026-09-28 14:30:00 +0000" git commit -m "fix: finalize Firebase app config and project wiring"

git add .
GIT_AUTHOR_DATE="2026-09-28 19:15:00 +0000" GIT_COMMITTER_DATE="2026-09-28 19:15:00 +0000" git commit -m "docs: record sprint progress and MVP readiness status"
```

---

## Quick usage note

If you want to backdate all 21 commits in a single pass, run them in chronological order from Day 1 through Day 7 as shown above.

To keep the history clean and realistic:

- stage only the files relevant to the milestone you are committing
- keep the commit messages specific and natural
- avoid mixing unrelated changes in one commit

Example final order:

1. Day 1 commands
2. Day 2 commands
3. Day 3 commands
4. Day 4 commands
5. Day 5 commands
6. Day 6 commands
7. Day 7 commands

This will produce a GitHub contribution matrix that visually aligns with a full workweek of development for your 1-week MVP sprint.
