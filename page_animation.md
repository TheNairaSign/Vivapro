# Telegram-Style Interactive Back Swipe Gesture in Flutter

## Goal
Implement a Telegram-style interactive back swipe gesture in Flutter where the previous screen is teased during the gesture and the navigation pop only commits if the gesture crosses a threshold or velocity condition.

## Core Requirements (Must Follow Exactly)

### Navigation Behavior
*   The current route must respond to edge swipes (left edge for LTR).
*   Swiping must **not** immediately pop the route.
*   The previous route must be visibly revealed underneath during the gesture.
*   **Releasing the gesture:**
    *   Completes pop if `progress ≥ threshold` OR swipe velocity exceeds threshold.
    *   Cancels pop and animates back if below threshold.

### Gesture Handling
*   Use `GestureDetector` or `Listener`.
*   Gesture must start only within a configurable edge width (e.g., 20–32px).
*   Gesture progress must be calculated as: `progress = dragDistance / screenWidth`.
*   Progress must be clamped between `0.0` and `1.0`.

### Animation Control
*   Use a single `AnimationController` driven by gesture progress.
*   The animation must be **percent-driven**, not time-driven, while dragging.
*   **On release:**
    *   Use `controller.forward()` or `controller.reverse()`.
    *   Apply velocity-based completion if swipe speed is high.

### Visual Effects (Telegram-like)
*   **Current page:** Translates horizontally following the finger.
*   **Previous page:**
    *   Slight scale (e.g., `0.95 → 1.0`).
    *   Optional subtle dim overlay that fades out as progress increases.
*   **Shadow:** A soft shadow on the left edge of the current page during drag.

### Route Structure
*   Must use a custom `PageRoute` (not default `MaterialPageRoute`).
*   The route must be **non-opaque** so the previous screen is visible.
*   No usage of `WillPopScope` for gesture handling.

### Commit Logic
*   Pop threshold must be configurable (default ≈ `0.3`).
*   **Velocity override:** Fast swipe completes pop even if distance < threshold.
*   **On cancel:**
    *   Page must animate back smoothly to origin.
    *   No visual snapping or flicker.

### Platform Rules
*   Gesture should only activate on iOS-style platforms unless explicitly enabled.
*   Android system back gesture must not conflict.

### Performance Constraints
*   No unnecessary rebuilds during drag.
*   Use `AnimatedBuilder` or equivalent.
*   No frame drops during continuous dragging.

### Code Quality Rules
*   Clean separation between:
    *   Gesture logic
    *   Animation logic
    *   Route logic
*   Reusable and configurable implementation.
*   No external navigation libraries.

## Explicit Non-Goals (Must NOT Do)
*   ❌ **Do NOT** trigger `Navigator.pop()` before gesture completion.
*   ❌ **Do NOT** use `CupertinoPageRoute`’s default back gesture.
*   ❌ **Do NOT** rely on implicit animations.
*   ❌ **Do NOT** fake the effect with timed animations.
*   ❌ **Do NOT** block interaction during the gesture.

## Expected Result
*   The page tracks the user’s finger exactly.
*   The previous page is teased in real time.
*   Cancelling the swipe feels elastic and natural.
*   Completing the swipe feels instant and intentional.
*   Behavior matches Telegram’s back navigation feel as closely as possible within Flutter.