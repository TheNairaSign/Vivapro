# Priority & Display Management System

This document explains the dual-layer priority system in VivaPro and how it is used to manage contact visibility, ranking, and engagement logic.

---

## 🏗 System Overview

VivaPro uses two distinct priority layers to balance user intent with relationship urgency:

1.  **Manual Layer (User-Assigned Priority)**: Represents the **Value** of the connection.
2.  **Automatic Layer (Relationship State)**: Represents the **Cadence** and **Urgency** of the connection.

---

## 1. Manual Priority (`CallPriority`)
Users assign this during the "Add Favorite" or "Edit Favorite" flow. It is stored as a persistent field in the `FavoriteContact` model.

| Level | Intended Role | App Impact |
| :--- | :--- | :--- |
| **High** | Inner Circle | Top-tier visibility; prioritize in lists even when "On Track". |
| **Medium** | Steady Connections | Standard visibility and regular reminders. |
| **Low** | Casual Connections | Lower visibility; minimal engagement prompts. |

> **Note**: Currently, this layer acts primarily as a metadata field and is used for future-proofing advanced ranking algorithms.

---

## 2. Automatic Priority (`RelationshipState`)
This is calculated in real-time by the `RelationshipStateEngine` based on the user's selected **Call Frequency** and the **Last Interaction Date**.

### State Calculation Logic:
*   **Overdue**: Time since last call >= Target Interval.
*   **Never Contacted**: No interaction history found.
*   **Approaching Overdue**: Time since last call >= 80% of Target Interval.
*   **On Track**: Recent interaction within the threshold.

---

## 📈 Contact Display Management

The system uses the layers above to manage different UI sections:

### A. Home Screen Favorites (`FavoritesSection`)
*   **Layout**: Horizontal scrollable list.
*   **Sorting**: Currently defaults to database insertion order.
*   **Future Update**: Will use `CallPriority` (High > Medium > Low) to determine the order of cards.

### B. "People to Call Today"
*   **Filtering**: Includes only contacts in `Overdue`, `Never Contacted`, or `Approaching Overdue` states.
*   **Ranking**: Sorted by relationship urgency. Overdue contacts with the longest delay are pushed to the top.

### C. Relationship Insights
*   **Filtering**: Only displays contacts requiring attention.
*   **Capping**: Limited to the top 3 most urgent connections.
*   **Role of Frequency**: Frequency determines the "Target Days" which directly dictates when a contact appears in this section.

---

## 🔄 Data Model & Persistence
*   **Enum**: `lib/core/enums/priority.dart`
*   **Model Field**: `FavoriteContact.priority`
*   **Database**: Persisted via Isar in the `favoriteContacts` collection.
