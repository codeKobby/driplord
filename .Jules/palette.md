## 2024-06-03 - Inaccessible GestureDetector Buttons

**Learning:** Using `GestureDetector` for interactive elements that function as buttons is an accessibility anti-pattern in Flutter. It doesn't provide the necessary semantic information for screen readers, nor does it offer visual feedback (like a ripple effect) on interaction, which is a standard UX pattern.

**Action:** Replace `GestureDetector` with `InkWell` to provide visual feedback. Wrap the `InkWell` in a `Semantics` widget with `button: true` and a descriptive `label`. The `InkWell`'s child should then be wrapped in `ExcludeSemantics` to prevent screen readers from announcing the content twice.
