# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter app, package name `vivapro`, app-facing name **"Loop"** (see `MaterialApp.title` and the root widget `Loop` in [lib/core/app.dart](lib/core/app.dart)). It helps users maintain relationships with favorited contacts via reminders, relationship-health scoring, and insights.

## Commands

```bash
flutter pub get                        # install dependencies
flutter run                            # run on a connected device/simulator
flutter analyze                        # static analysis (flutter_lints, see analysis_options.yaml)
flutter test                           # run all tests
flutter test test/widget_test.dart     # run a single test file
```

Isar models (`@collection` classes with a `part '*.g.dart'`) need code generation after changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Models requiring generation: `FavoriteContact`, `ScheduleCall`, `ActivityLog`, `UserProfile`, `CalendarEvent` (see registration in [lib/main.dart](lib/main.dart)).

## Architecture

### Storage: local-first with Isar

The **local Isar database is the single source of truth** — there is no Firebase/Firestore backend despite mentions in older docs (see Documentation caveats below). Isar is opened once in `main()` and injected via Riverpod's `isarProvider` override; each feature's `data/` layer exposes its own cache service (e.g. `favorite_cache_service.dart`, `schedule_cache_service.dart`, `event_cache_service.dart`) that wraps Isar queries for its collection.

Cloud backup (Google Drive, via `google_sign_in`/`googleapis`) is a strictly one-way, opt-in mirror of local data — never a live sync source. Design rules for this are documented in [DRIVE.md](DRIVE.md) and [BACKUP.md](BACKUP.md) (near-duplicate specs): local → Drive only, no cloud listeners, restore is a manual/explicit full replace, derived data (insights, relationship state, UI state) is never backed up and is always recomputed after restore. Implementation lives in `lib/core/services/google_drive_service.dart` and `lib/features/backup/` (`BackupBloc`, `BackupService`, `BackupWorker`) — treat the two markdown specs as the intended design, not a guarantee of current completeness; verify against the code before relying on specific behavior.

### State management: Riverpod + Bloc, split by role

- **Riverpod** (`Provider`, `StreamProvider`) for services, repositories, and data streams — e.g. `contactsRepository`, `scheduleCallManagerProvider`, `isarProvider`.
- **Bloc/Cubit** (`flutter_bloc`) for feature-level UI state/business logic — `ActivityBloc`, `ChatBloc`, `MessageBloc`, `ScheduleCallBloc`, `CalendarEventBloc`, `BackupBloc`. All are wired up via `MultiBlocProvider` in [lib/core/app.dart](lib/core/app.dart).
- A couple of legacy `ChangeNotifierProvider`/`provider` usages remain (e.g. `AddFavoritesProvider`) for narrower, older state.

### Feature-first layout

Each `lib/features/<feature>/` follows roughly:
- `data/` — Isar collection models (`*.dart` + generated `*.g.dart`) and cache services that talk directly to Isar.
- `dom/` (or `domain/`) — an abstract "manager"/use-case interface plus a concrete implementation that combines the cache service with side effects (e.g. `ScheduleCallManager` wraps `ScheduleCacheService` + `NotificationService`). Repository/manager methods return `Either<Failure, T>` (via `dartz`) rather than throwing — follow this pattern for new repository code.
- `presentation/` — `bloc/` (events/state/bloc), `pages/`, `widgets/`, sometimes `providers/`.

Features: `contacts` (favorites — the core entity), `schedule_call`, `events` (device calendar integration), `activity` (activity log/history), `in_app_notifications`, `messaging` (in-app chat — separate from favorites/contacts), `call_reminder`, `backup`, `profile`.

### The relationship engine (core domain logic)

Pipeline: **Isar (`FavoriteContact`) → `RelationshipStateEngine` → `InsightGenerator` → Riverpod stream providers → UI**.

- [lib/core/services/relationship_state_engine.dart](lib/core/services/relationship_state_engine.dart) — pure, static logic. Maps `CallFrequency` (daily/weekly/monthly/yearly/custom) to target days, then compares against `lastInteractionAt` to compute `RelationshipState`: `onTrack`, `approachingOverdue` (≥80% of target), `overdue` (≥100% of target), `neverContacted`. Also generates human-readable insight strings and sorts contacts by call priority.
- [lib/core/services/insight_generator.dart](lib/core/services/insight_generator.dart) — watches the favorites stream, re-runs the engine on every change, filters out `onTrack` contacts, sorts by urgency, and caps output at the top 3 (`insightsStreamProvider`).
- [lib/core/services/interaction_tracker.dart](lib/core/services/interaction_tracker.dart) — the single place that records a call: updates `lastInteractionAt` on the `FavoriteContact` in Isar. Any "Call" action (favorite tile, contact details, notification tap) should go through this so the reactive Isar-backed streams update the UI everywhere at once.
- Priority is two-layered: `FavoriteContact.priority` (`CallPriority` — user-assigned, mostly metadata today) vs. the engine's computed `RelationshipState` (drives urgency/ordering). See [PRIORITY_SYSTEM.md](PRIORITY_SYSTEM.md) and [RELATIONSHIP_LOGIC_FLOW.md](RELATIONSHIP_LOGIC_FLOW.md) for full detail on health-score math and UI color thresholds.

### Notifications & scheduling

`NotificationService` (awesome_notifications-backed) + `BackgroundTaskManager` are initialized in [lib/core/bootstrap.dart](lib/core/bootstrap.dart) before `runApp`. `NotificationHandler` and `foregroundScheduleMonitorProvider` are started post-frame in `Loop.initState` to route notification taps (call now / remind later) and watch for due schedules while the app is foregrounded. Scheduling a call flows through `ScheduleCallManager` (`dom/`), which persists via `ScheduleCacheService` and books the reminder via `NotificationService` in the same call — keep those two in sync when editing either.

## Documentation caveats

- [ARCHITECTURE.md](ARCHITECTURE.md) describes an earlier Firebase/Firestore + `AuthChecker`/sign-in design. **The current codebase has no Firebase dependency and no auth flow** — it's fully local (Isar), no account required. Treat that file's data-flow descriptions (insights, interaction tracking, notification handling) as still broadly accurate, but its persistence/auth claims as stale.
- [DRIVE.md](DRIVE.md) and [BACKUP.md](BACKUP.md) are prescriptive design specs (near-duplicates) for the backup feature, not confirmed-implemented documentation — cross-check against `lib/features/backup/` and `lib/core/services/google_drive_service.dart` before assuming a described behavior exists.
- `.agent/rules/code-style.md` contains standing project conventions (feature-first, no business logic in widgets, repositories return `Either<Failure, T>`, prefer Riverpod / Bloc for larger logic, Material 3 with `Theme.of(context)` only — no hardcoded colors, max ~50-line widget `build` methods, don't add new packages without explanation). Follow these when writing or editing code here.
