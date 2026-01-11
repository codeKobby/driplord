## 2024-07-22 - Tappable Cards Accessibility

**Learning:** Using `GestureDetector` for custom tappable widgets is an accessibility anti-pattern in Flutter. It provides no auditory feedback for screen readers and lacks visual feedback like a ripple effect, making the UI feel unresponsive and inaccessible.

**Action:** For custom interactive widgets, replace `GestureDetector` with `InkWell` for visual feedback. Wrap the `InkWell` in a `Semantics` widget with `button: true` and a descriptive `label`. The `InkWell`'s child should then be wrapped in `ExcludeSemantics` to avoid double announcements by the screen reader.
