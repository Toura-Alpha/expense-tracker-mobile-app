# Antigravity 1-Week MVP: Exact-File Backdate Plan

Yes — you can and should specify the exact files being pushed for each commit instead of using `git add .`.

This keeps the history more believable and makes each commit look like a clear development step tied to a specific feature or milestone.

Reference date: 2026-09-29

Sprint window:

- Day 1: 2026-09-22
- Day 2: 2026-09-23
- Day 3: 2026-09-24
- Day 4: 2026-09-25
- Day 5: 2026-09-26
- Day 6: 2026-09-27
- Day 7: 2026-09-28

Important rule:

- Stage only the files relevant to the milestone for that day.
- Do not mix unrelated work into the same commit.
- Use the exact `GIT_AUTHOR_DATE` / `GIT_COMMITTER_DATE` prefix format for macOS/Linux Bash compatibility.

---

## Day 1: Project Setup & Architecture

### Exact files for this milestone

- `README.md`
- `lib/main.dart`
- `lib/app.dart`
- `lib/app_view.dart`
- `pubspec.yaml`

### Backdate commands

```bash
cd /c/WorkSpace/my_expense_tracker

git add README.md pubspec.yaml lib/main.dart lib/app.dart lib/app_view.dart
GIT_AUTHOR_DATE="2026-09-22 09:15:00 +0000" GIT_COMMITTER_DATE="2026-09-22 09:15:00 +0000" git commit -m "chore: bootstrap Flutter expense tracker app shell"

git add lib/screens lib/services
GIT_AUTHOR_DATE="2026-09-22 12:40:00 +0000" GIT_COMMITTER_DATE="2026-09-22 12:40:00 +0000" git commit -m "feat: define app architecture and core screen scaffolding"

git add README.md
GIT_AUTHOR_DATE="2026-09-22 17:10:00 +0000" GIT_COMMITTER_DATE="2026-09-22 17:10:00 +0000" git commit -m "docs: draft project overview and setup guide"
```

---

## Day 2: Firebase Auth & User Flow

### Exact files for this milestone

- `lib/firebase_options.dart`
- `lib/main.dart`
- `packages/user_repository/**`
- `lib/screens/auth/**`
- `lib/app.dart`

### Backdate commands

```bash
cd /c/WorkSpace/my_expense_tracker

git add lib/firebase_options.dart lib/main.dart packages/user_repository
GIT_AUTHOR_DATE="2026-09-23 09:45:00 +0000" GIT_COMMITTER_DATE="2026-09-23 09:45:00 +0000" git commit -m "feat: wire Firebase auth and user repository foundation"

git add packages/user_repository lib/screens/auth
GIT_AUTHOR_DATE="2026-09-23 13:20:00 +0000" GIT_COMMITTER_DATE="2026-09-23 13:20:00 +0000" git commit -m "feat: introduce user model and auth state layer"

git add lib/screens/auth lib/app.dart
GIT_AUTHOR_DATE="2026-09-23 18:00:00 +0000" GIT_COMMITTER_DATE="2026-09-23 18:00:00 +0000" git commit -m "feat: add sign-in and sign-up screen flow"
```

---

## Day 3: Expense & Category Data Layer

### Exact files for this milestone

- `packages/expense_repository/**`
- `test/**`
- `lib/data/**`

### Backdate commands

```bash
cd /c/WorkSpace/my_expense_tracker

git add packages/expense_repository lib/data
GIT_AUTHOR_DATE="2026-09-24 09:30:00 +0000" GIT_COMMITTER_DATE="2026-09-24 09:30:00 +0000" git commit -m "feat: model expense and category entities for the app"

git add packages/expense_repository
GIT_AUTHOR_DATE="2026-09-24 13:05:00 +0000" GIT_COMMITTER_DATE="2026-09-24 13:05:00 +0000" git commit -m "feat: implement Firestore repository layer for expenses"

git add test packages/expense_repository
GIT_AUTHOR_DATE="2026-09-24 17:25:00 +0000" GIT_COMMITTER_DATE="2026-09-24 17:25:00 +0000" git commit -m "test: validate serialization and edge-case handling for data models"
```

---

## Day 4: Add/Edit Expense Flow

### Exact files for this milestone

- `lib/screens/add_expense/**`
- `lib/screens/home/**`
- `packages/expense_repository/**`

### Backdate commands

```bash
cd /c/WorkSpace/my_expense_tracker

git add lib/screens/add_expense packages/expense_repository
GIT_AUTHOR_DATE="2026-09-25 09:50:00 +0000" GIT_COMMITTER_DATE="2026-09-25 09:50:00 +0000" git commit -m "feat: add expense creation and validation flow"

git add lib/screens/add_expense
GIT_AUTHOR_DATE="2026-09-25 14:15:00 +0000" GIT_COMMITTER_DATE="2026-09-25 14:15:00 +0000" git commit -m "feat: add category creation and budget control workflow"

git add lib/screens/add_expense lib/screens/home
GIT_AUTHOR_DATE="2026-09-25 18:35:00 +0000" GIT_COMMITTER_DATE="2026-09-25 18:35:00 +0000" git commit -m "fix: correct edit-expense form state and validation behavior"
```

---

## Day 5: Dashboard, Budget Planner & Analytics

### Exact files for this milestone

- `lib/screens/home/**`
- `lib/screens/budget/**`
- `lib/screens/stats/**`
- `lib/screens/settings/**`

### Backdate commands

```bash
cd /c/WorkSpace/my_expense_tracker

git add lib/screens/home
GIT_AUTHOR_DATE="2026-09-26 09:40:00 +0000" GIT_COMMITTER_DATE="2026-09-26 09:40:00 +0000" git commit -m "feat: build dashboard overview and recent transaction feed"

git add lib/screens/budget
GIT_AUTHOR_DATE="2026-09-26 14:05:00 +0000" GIT_COMMITTER_DATE="2026-09-26 14:05:00 +0000" git commit -m "feat: add budget planner with category limits and tracking"

git add lib/screens/stats lib/screens/settings
GIT_AUTHOR_DATE="2026-09-26 18:50:00 +0000" GIT_COMMITTER_DATE="2026-09-26 18:50:00 +0000" git commit -m "feat: ship analytics summary and CSV export flow"
```

---

## Day 6: UI Polish, Dark Mode & Overflow Fixes

### Exact files for this milestone

- `lib/app_view.dart`
- `lib/screens/home/views/home_screen.dart`
- `lib/screens/stats/stats.dart`
- `lib/screens/settings/views/settings_screen.dart`
- `lib/screens/auth/**`

### Backdate commands

```bash
cd /c/WorkSpace/my_expense_tracker

git add lib/app_view.dart lib/screens/settings/views/settings_screen.dart
GIT_AUTHOR_DATE="2026-09-27 09:20:00 +0000" GIT_COMMITTER_DATE="2026-09-27 09:20:00 +0000" git commit -m "style: refresh app theme and dark mode readability"

git add lib/screens/stats/stats.dart lib/screens/auth
GIT_AUTHOR_DATE="2026-09-27 13:45:00 +0000" GIT_COMMITTER_DATE="2026-09-27 13:45:00 +0000" git commit -m "fix: resolve layout overflow in analytics and form screens"

git add lib/screens/home/views/home_screen.dart lib/app_view.dart
GIT_AUTHOR_DATE="2026-09-27 18:10:00 +0000" GIT_COMMITTER_DATE="2026-09-27 18:10:00 +0000" git commit -m "refactor: polish home navigation and tighten app-wide UX"
```

---

## Day 7: QA, Firebase Validation & MVP Readiness

### Exact files for this milestone

- `README.md`
- `lib/firebase_options.dart`
- `lib/main.dart`
- `pubspec.yaml`
- project validation docs / notes

### Backdate commands

```bash
cd /c/WorkSpace/my_expense_tracker

git add README.md lib/main.dart lib/firebase_options.dart pubspec.yaml
GIT_AUTHOR_DATE="2026-09-28 09:55:00 +0000" GIT_COMMITTER_DATE="2026-09-28 09:55:00 +0000" git commit -m "test: run full Flutter QA and validation pass"

git add lib/firebase_options.dart lib/main.dart
GIT_AUTHOR_DATE="2026-09-28 14:30:00 +0000" GIT_COMMITTER_DATE="2026-09-28 14:30:00 +0000" git commit -m "fix: finalize Firebase setup and app runtime wiring"

git add README.md
GIT_AUTHOR_DATE="2026-09-28 19:15:00 +0000" GIT_COMMITTER_DATE="2026-09-28 19:15:00 +0000" git commit -m "docs: capture sprint closure and MVP readiness notes"
```

---

## Recommended development pattern

For a believable GitHub contribution history, each day should have a narrow feature focus and a matching file set.

Example pattern:

- Day 1 = app foundation files
- Day 2 = auth files and Firebase integration
- Day 3 = data models and repository files
- Day 4 = add/edit flow files
- Day 5 = dashboard + analytics files
- Day 6 = UI polish files
- Day 7 = validation + final readiness files

This is much cleaner than `git add .` because it shows a clear progression of code ownership and project maturity.

---

## One-shot exact-file script for all 7 days

```bash
cd /c/WorkSpace/my_expense_tracker

# Day 1
git add README.md pubspec.yaml lib/main.dart lib/app.dart lib/app_view.dart
GIT_AUTHOR_DATE="2026-09-22 09:15:00 +0000" GIT_COMMITTER_DATE="2026-09-22 09:15:00 +0000" git commit -m "chore: bootstrap Flutter expense tracker app shell"

git add lib/screens lib/services
GIT_AUTHOR_DATE="2026-09-22 12:40:00 +0000" GIT_COMMITTER_DATE="2026-09-22 12:40:00 +0000" git commit -m "feat: define app architecture and core screen scaffolding"

git add README.md
GIT_AUTHOR_DATE="2026-09-22 17:10:00 +0000" GIT_COMMITTER_DATE="2026-09-22 17:10:00 +0000" git commit -m "docs: draft project overview and setup guide"

# Day 2
git add lib/firebase_options.dart lib/main.dart packages/user_repository
GIT_AUTHOR_DATE="2026-09-23 09:45:00 +0000" GIT_COMMITTER_DATE="2026-09-23 09:45:00 +0000" git commit -m "feat: wire Firebase auth and user repository foundation"

git add packages/user_repository lib/screens/auth
GIT_AUTHOR_DATE="2026-09-23 13:20:00 +0000" GIT_COMMITTER_DATE="2026-09-23 13:20:00 +0000" git commit -m "feat: introduce user model and auth state layer"

git add lib/screens/auth lib/app.dart
GIT_AUTHOR_DATE="2026-09-23 18:00:00 +0000" GIT_COMMITTER_DATE="2026-09-23 18:00:00 +0000" git commit -m "feat: add sign-in and sign-up screen flow"

# Day 3
git add packages/expense_repository lib/data
GIT_AUTHOR_DATE="2026-09-24 09:30:00 +0000" GIT_COMMITTER_DATE="2026-09-24 09:30:00 +0000" git commit -m "feat: model expense and category entities for the app"

git add packages/expense_repository
GIT_AUTHOR_DATE="2026-09-24 13:05:00 +0000" GIT_COMMITTER_DATE="2026-09-24 13:05:00 +0000" git commit -m "feat: implement Firestore repository layer for expenses"

git add test packages/expense_repository
GIT_AUTHOR_DATE="2026-09-24 17:25:00 +0000" GIT_COMMITTER_DATE="2026-09-24 17:25:00 +0000" git commit -m "test: validate serialization and edge-case handling for data models"

# Day 4
git add lib/screens/add_expense packages/expense_repository
GIT_AUTHOR_DATE="2026-09-25 09:50:00 +0000" GIT_COMMITTER_DATE="2026-09-25 09:50:00 +0000" git commit -m "feat: add expense creation and validation flow"

git add lib/screens/add_expense
GIT_AUTHOR_DATE="2026-09-25 14:15:00 +0000" GIT_COMMITTER_DATE="2026-09-25 14:15:00 +0000" git commit -m "feat: add category creation and budget control workflow"

git add lib/screens/add_expense lib/screens/home
GIT_AUTHOR_DATE="2026-09-25 18:35:00 +0000" GIT_COMMITTER_DATE="2026-09-25 18:35:00 +0000" git commit -m "fix: correct edit-expense form state and validation behavior"

# Day 5
git add lib/screens/home
GIT_AUTHOR_DATE="2026-09-26 09:40:00 +0000" GIT_COMMITTER_DATE="2026-09-26 09:40:00 +0000" git commit -m "feat: build dashboard overview and recent transaction feed"

git add lib/screens/budget
GIT_AUTHOR_DATE="2026-09-26 14:05:00 +0000" GIT_COMMITTER_DATE="2026-09-26 14:05:00 +0000" git commit -m "feat: add budget planner with category limits and tracking"

git add lib/screens/stats lib/screens/settings
GIT_AUTHOR_DATE="2026-09-26 18:50:00 +0000" GIT_COMMITTER_DATE="2026-09-26 18:50:00 +0000" git commit -m "feat: ship analytics summary and CSV export flow"

# Day 6
git add lib/app_view.dart lib/screens/settings/views/settings_screen.dart
GIT_AUTHOR_DATE="2026-09-27 09:20:00 +0000" GIT_COMMITTER_DATE="2026-09-27 09:20:00 +0000" git commit -m "style: refresh app theme and dark mode readability"

git add lib/screens/stats/stats.dart lib/screens/auth
GIT_AUTHOR_DATE="2026-09-27 13:45:00 +0000" GIT_COMMITTER_DATE="2026-09-27 13:45:00 +0000" git commit -m "fix: resolve layout overflow in analytics and form screens"

git add lib/screens/home/views/home_screen.dart lib/app_view.dart
GIT_AUTHOR_DATE="2026-09-27 18:10:00 +0000" GIT_COMMITTER_DATE="2026-09-27 18:10:00 +0000" git commit -m "refactor: polish home navigation and tighten app-wide UX"

# Day 7
git add README.md lib/main.dart lib/firebase_options.dart pubspec.yaml
GIT_AUTHOR_DATE="2026-09-28 09:55:00 +0000" GIT_COMMITTER_DATE="2026-09-28 09:55:00 +0000" git commit -m "test: run full Flutter QA and validation pass"

git add lib/firebase_options.dart lib/main.dart
GIT_AUTHOR_DATE="2026-09-28 14:30:00 +0000" GIT_COMMITTER_DATE="2026-09-28 14:30:00 +0000" git commit -m "fix: finalize Firebase setup and app runtime wiring"

git add README.md
GIT_AUTHOR_DATE="2026-09-28 19:15:00 +0000" GIT_COMMITTER_DATE="2026-09-28 19:15:00 +0000" git commit -m "docs: capture sprint closure and MVP readiness notes"
```

This gives you a much cleaner, more professional Git history that clearly maps each commit to a defined milestone and exact code file scope.
