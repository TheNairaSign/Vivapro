# Relationship Intelligence & Insight Flow

This document outlines the architecture and data flow of the relationship management system in VivaPro, specifically focusing on how interaction data is transformed into actionable insights and UI elements.

---

## 🏗 System Architecture

The relationship system is built as a reactive pipeline:
**Data Store** → **State Engine** → **Insight Generator** → **UI Providers** → **User Interface**

### 1. The Core: `RelationshipStateEngine`
`lib/core/services/relationship_state_engine.dart`

This is a pure logic class (static methods) responsible for calculating the "health" of a relationship.

*   **Frequency Mapping**: Converts `CallFrequency` (daily, weekly, monthly, yearly) into a `targetDays` integer.
*   **State Calculation (`calculateState`)**:
    *   Compares `DateTime.now()` with `contact.lastInteractionAt`.
    *   Determines the `RelationshipState`:
        *   `neverContacted`: No timestamp exists.
        *   `overdue`: Days since interaction >= `targetDays`.
        *   `approachingOverdue`: Days since interaction >= 80% of `targetDays`.
        *   `onTrack`: Everything else.
*   **Priority Logic**: Defines which relationships need the most attention.
    *   *High*: Overdue, Never Contacted.
    *   *Medium*: Approaching Overdue.
    *   *Low*: On Track.

### 2. The Orchestrator: `InsightGenerator`
`lib/core/services/insight_generator.dart`

This class transforms raw relationship states into high-level `ContactInsight` objects.

*   **Reactive Stream (`watchInsights`)**: 
    1.  Listens to the `FavoritesRepository`.
    2.  Whenever a contact is added, removed, or a call is logged, it re-calculates everything.
*   **Insight Rules (from core.md)**:
    *   **Filtering**: Only generates insights for contacts that are NOT `onTrack`.
    *   **Capping**: Limits the output to the **top 3** most urgent insights to avoid overwhelming the user.
    *   **Prioritization**: Uses `_comparePriority` to ensure "Overdue" contacts appear before "Approaching Overdue".

---

## 🔄 Function Interaction Flow

1.  **Repository Update**: A user logs a call. `FavoritesRepository` emits a new list of `FavoriteContact`.
2.  **Generator Trigger**: `watchInsights()` receives the list.
3.  **Engine Analysis**: For each contact, `RelationshipStateEngine.calculateState(contact)` is called.
4.  **Insight Filtering**: `_shouldGenerateInsight(state)` returns true if the state requires attention.
5.  **Message Construction**: `RelationshipStateEngine.generateInsightMessage(contact)` creates a dynamic, non-guilt-based string (e.g., *"You haven't spoken to Sarah in 5 days"*).
6.  **Sorting & Limit**: Insights are sorted by priority and the list is sliced to `take(3)`.

---

## 🎨 UI Display & Health Logic
`lib/pages/home/widgets/insights/insights_section.dart`

The Home Screen consumes this data via the `insightsStreamProvider`.

### Relationship Health Score
The app calculates a global "Health Score" (0–100%) for your inner circle:
*   **Base Score**: 100%.
*   **Reductions**: -20% for every **High** priority insight (Overdue), -10% for every **Medium** priority insight.
*   **Result**: If you have 2 overdue friends and 1 approaching overdue, your health score is 50%.

### Visual Feedback System
The `InsightsSection` uses several layers of visual cues to communicate health:

| Score | Color | Sentiment | Theme Implementation |
| :--- | :--- | :--- | :--- |
| **100%** | `primary` | Perfect | Smooth theme-matching green/blue |
| **81-99%** | `Color(0xFF4CAF50)` | Great | Success Green |
| **61-80%** | `Color(0xFFFFC107)` | Warning | Amber |
| **41-60%** | `Color(0xFFFF9800)` | Slipping | Orange |
| **0-40%** | `Color(0xFFF44336)` | Critical | Danger Red |

**UI Elements affected by Health Color:**
*   **Health Container Background**: Subtle 10% opacity tint of the health color.
*   **Percentage Text**: Bold display of the score in full health color.
*   **Dashboard Icon**: The `peopleOutline` icon changes color to match the relationship health.
*   **Insight Cards**: The main card displays the most urgent specific insight message.

---

## 📡 Providers & Subscriptions

*   `insightGeneratorProvider`: Singleton service.
*   `insightsStreamProvider`: UI-bound stream of the top 3 insights.
*   `peopleToCallTodayProvider`: List of contacts filtered and sorted for the "To Call Today" checklist.
