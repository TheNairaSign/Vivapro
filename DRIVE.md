Design and implement a **strict, offline-first Google Drive backup feature** for a mobile application, following the rules below **exactly**.
Do not add real-time sync, cloud-driven logic, or assumptions beyond what is explicitly stated.

---

## Core Principle (Non-Negotiable)

The **local database is the single source of truth**.

Google Drive is used **only for backup and restore**, never for live synchronization, conflict resolution, or application logic.

---

## Scope of the Feature

The feature must:

* Work as an **optional, opt-in backup**
* Operate independently of core app functionality
* Never affect offline behavior
* Never introduce real-time cloud listeners

The application must remain fully functional if:

* The user never enables backup
* Google Drive is unavailable
* Authentication fails
* The device is offline

---

## Platform Scope

* Target platform: **Android**
* Backup destination: **Google Drive App Data Folder**
* No visible files in the user’s Drive UI
* No use of public or shared folders

---

## Backup Eligibility Rules (Strict)

### Data That MUST Be Backed Up

Only persist **explicit user-owned data**:

* Favorite contacts
* Interaction timestamps (`lastInteractionAt`)
* Preferred call frequency
* Reminder schedules
* Emergency contacts
* Minimal app settings related to behavior

---

### Data That MUST NEVER Be Backed Up

* Derived insights
* Relationship state calculations
* UI state
* Snoozed cards
* Notification IDs
* Temporary flags
* Cached or computed values

All derived data must be recomputed locally after restore.

---

## Backup Activation Flow

1. Backup is **disabled by default**
2. User explicitly enables “Backup to Google Drive”
3. User is informed:

   * What data is backed up
   * That this is not real-time sync
   * That restore is manual
4. OAuth consent is requested only at this point

No background or silent activation is allowed.

---

## Initial Backup Behavior

When backup is enabled:

1. Read the entire local database
2. Serialize all eligible data into a **single, versioned JSON structure**
3. Compress the file (e.g., gzip)
4. Upload the file to the Google Drive App Data Folder
5. Store `lastBackupAt` locally

No incremental sync occurs before this completes successfully.

---

## Incremental Backup Rules (After Initial Backup)

* Listen **only to local database changes**
* Batch changes into controlled updates
* Upload updated backup:

  * On app foreground
  * On explicit user action
  * Or on a safe time interval

Never upload on every write or state change.

---

## Sync Directionality Constraint

* Backup direction is **Local → Google Drive only**
* The app must never:

  * Listen to Google Drive for live updates
  * Merge cloud data into the local DB automatically
  * Modify local data due to cloud state

---

## Restore Flow (Explicit User Action Only)

Restore must:

1. Be manually initiated by the user
2. Warn that local data will be replaced
3. Delete the local database
4. Download the latest backup file
5. Deserialize and rehydrate local storage
6. Recompute all derived data locally

No partial restore.
No background restore.
No merge UI.

---

## Conflict Resolution Policy

If multiple backups exist:

* Use **last-write-wins** based on backup timestamp
* No attempt at smart merging
* No per-record conflict resolution

This rule must be applied consistently.

---

## Error Handling Requirements

The system must gracefully handle:

* OAuth cancellation
* Network loss mid-backup
* Corrupted backup file
* Version mismatch
* Insufficient Drive storage

In all failure cases:

* The local database must remain untouched
* The app must remain usable
* Clear, human-readable feedback must be shown

---

## Security & Privacy Rules

* Use least-privilege OAuth scopes
* Store no personal data outside the App Data Folder
* Never upload plaintext sensitive data without encryption (if applicable)
* Never share data with third parties

---

## Non-Goals (Explicitly Excluded)

* Real-time cloud sync
* Multi-device live state
* Cross-user data sharing
* Chat-style synchronization
* Background cloud listeners
* Automatic restore on install

---

## Output Expectations

The implementation design must clearly define:

* Backup file structure
* Versioning strategy
* Backup lifecycle
* Restore lifecycle
* Failure recovery paths
* How offline-first guarantees are preserved

The final solution must prioritize:

* Predictability
* Reliability
* User trust
* Simplicity over cleverness

Do not introduce additional features or interpretations outside these rules.
The result should feel **boringly dependable**.
