Design the **core application flow, logic, and system connections** for this application whose primary purpose is to help users **maintain meaningful relationships through intentional calling**, not messaging-first communication.

This is **not a generic chat app**.
The system must be **favorites-driven**, calm, privacy-aware, and non-overwhelming.

---

## Core Product Principle

Only contacts explicitly marked as **Favorites** are tracked, analyzed, or surfaced for reminders and insights.
All other contacts remain passive and invisible to the system logic.

---

## Required Core Flows (Must Be Explicitly Modeled)

### 1. Onboarding → Favorites as the Gate

* User is clearly informed that:

  * Only favorited contacts are tracked
  * No background tracking of all contacts occurs
* User is encouraged to add **1–3 favorite contacts immediately**
* Permissions requested:

  * Notifications (required)
  * Contacts (optional)
  * Location (optional, explained as SOS-only)

---

### 2. Favorite Contact Lifecycle (Central Entity)

A **Favorite Contact** is the only entity that participates in:

* Interaction tracking
* Reminder logic
* Insights
* Streaks
* Home screen prioritization

Each favorite contact must have:

* Name
* Phone number
* Optional in-app user ID
* Preferred call frequency (daily / weekly / custom)
* Last interaction timestamp

---

### 3. Interaction Tracking Flow

Define **exactly when and how** `lastInteractionAt` is updated:

* Primary method:

  * User initiates a call from inside the app
  * System phone dialer opens
  * Interaction timestamp is updated immediately
* Secondary (optional / future):

  * External call log parsing (Android only)
* No tracking occurs for non-favorites

---

### 4. Relationship State Engine (Local Logic)

For each favorite contact:

* Calculate time since last interaction
* Compare against preferred call frequency
* Derive states such as:

  * On track
  * Approaching overdue
  * Overdue

This logic must:

* Run locally
* Be deterministic
* Avoid server dependency
* Never generate actions without user consent

---

### 5. Insight Generation Rules

Insights are **derived**, not forced.

Examples:

* “You haven’t spoken to John in 12 days”
* “You usually call Mom on Sundays”

Rules:

* Max 1 insight per contact at a time
* Max 2–3 insights on the home screen
* Snoozed insights do not reappear immediately
* No guilt-based language

---

### 6. Reminder Flow (Explicit User Intent Only)

Reminders are created only when the user chooses:

* “Remind me later”
* Or schedules one manually from a contact detail page

Reminder behavior:

* Local notifications
* Actions:

  * Call now (opens system dialer)
  * Remind me later (reschedules notification)

---

### 7. Home Screen Composition Logic

The home screen must be **derived**, not static.

Sections:

1. People to Call Today

   * Overdue favorites
   * Upcoming reminders
2. Smart Insights

   * Generated from relationship state engine
3. Favorites

   * Always visible
   * Always actionable

No feeds. No infinite scrolling. No chat dominance.

---

<!-- ### 8. SOS & Emergency Flow (Parallel, Isolated)

Emergency functionality must:

* Be accessible globally
* Be completely isolated from favorites tracking logic
* Trigger:

  * Emergency call
  * Emergency SMS
  * Live location sharing

SOS must never depend on interaction history or reminders. -->

---

### 9. System Connections (Explicit Mapping Required)

Clearly define how these systems connect:

* Favorites → Interaction Tracker
* Interaction Tracker → Relationship State Engine
* Relationship State Engine → Insights
* Insights → Home Screen
* User Actions → Reminder Scheduler → Notifications
<!-- * SOS → Phone / SMS / Location (isolated path) -->

---

### 10. Constraints & Non-Goals (Must Be Respected)

* Do NOT track all contacts
* Do NOT auto-create reminders
* Do NOT require the other person to install the app
* Do NOT use social-feed or chat-first paradigms
* Do NOT overwhelm the user with data or metrics

---

## Output Expectations

The result must clearly describe:

* The main loop of the application
* What data is stored, where, and why
* What triggers updates and insights
* How each feature connects to the next
* Why favorites are the central abstraction

The explanation should be **implementation-aware**, technically feasible, and suitable for a Flutter-based mobile application.

Focus on **clarity, correctness, and intentionality**, not feature quantity.
