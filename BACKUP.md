Design a **strict offline-first mobile application architecture** with an **optional, user-controlled cloud backup system**.
The system must follow the rules below exactly, without adding assumptions, shortcuts, or real-time sync behaviors.

---

## Core Architectural Principle (Must Not Be Violated)

The **local database is the single source of truth** at all times.

The cloud exists **only as a backup mirror**, never as an authoritative state manager.

---

## Offline-First Rules (Mandatory)

1. The application must:

   * Function fully without internet access
   * Store all core data locally
   * Never require an account to operate

2. All business logic must run locally, including:

   * Interaction tracking
   * Relationship state calculations
   * Insights generation
   * Reminder scheduling
   * SOS behavior

3. No feature should break or degrade when offline, except:

   * Cloud backup
   * Restore from backup
   * Online-only enhancements (if any)

---

## Data Ownership & Scope Rules

Only **explicitly favorited contacts** are eligible for:

* Tracking
* Insights
* Reminders
* Backup

Non-favorited contacts must:

* Remain untracked
* Never be synced
* Never influence reminders or insights

---

## Cloud Backup Rules (Strict)

### 1. Opt-In Only

* Cloud backup must be disabled by default
* User must explicitly enable it
* Clear explanation of what data is backed up

---

### 2. Initial Backup Behavior

When backup is enabled:

* Read the entire local database
* Serialize data into plain, versioned JSON
* Upload to the cloud as a complete snapshot
* Record `lastBackupAt`

No incremental syncing at this stage.

---

### 3. Incremental Sync Rules (After Initial Backup)

* Listen only to **local database changes**
* Batch changes before uploading
* Push updates:

  * On app foreground
  * On explicit user action
  * Or at controlled time intervals

Never push on every state change.

---

### 4. Directionality Constraint

* Sync direction is **Local → Cloud only**
* The cloud must never push live updates into the app
* No real-time listeners from the cloud

---

### 5. Restore Rules

* Restore is an explicit user action
* Restore flow must:

  * Clear the local database
  * Download cloud snapshot
  * Rehydrate the local database
  * Recompute all derived data locally

No automatic merging.
No conflict UI.

---

## Conflict Resolution (Non-Negotiable)

If conflicting data exists:

* Use **last-write-wins based on timestamps**
* No attempt at smart merging
* No multi-device real-time reconciliation

This applies universally.

---

## Data Sync Scope (Be Explicit)

### Sync These Only

* Favorite contacts
* Interaction timestamps
* Preferred call frequency
* Reminder schedules
* Emergency contacts

### Never Sync

* Derived insights
* UI state
* Notification IDs
* Snoozed cards
* Temporary flags
* Cached calculations

Derived data must always be recomputed locally.

---

## SOS Isolation Rule

Emergency and SOS features must:

* Be fully functional offline
* Never depend on cloud availability
* Never depend on backup state
* Never read or write from cloud during execution

---

## Non-Goals (Must Be Explicitly Excluded)

* Real-time cloud sync
* Multi-device live state
* Chat-style synchronization
* Feed-based updates
* Automatic reminder creation
* Background cloud listeners

---

## Output Expectations

The resulting design must clearly define:

* Local data models
* Sync state machine
* Backup lifecycle
* Restore lifecycle
* Failure handling
* Why the cloud is intentionally limited

The explanation must:

* Be technically realistic
* Avoid idealized sync assumptions
* Prioritize correctness over convenience
* Respect platform constraints

The final design should feel **boringly reliable**, not clever.

Do not add features, shortcuts, or interpretations outside these rules.
