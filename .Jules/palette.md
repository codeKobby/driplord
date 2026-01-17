## 2024-07-22 - Accessible Custom Tappable Widgets

**Learning:** The codebase uses `GestureDetector` for custom tappable widgets like image cards and gender selectors. This is an accessibility anti-pattern because it provides no semantic information for screen readers and lacks tactile feedback (ripple effect) for all users.

**Action:** For future custom interactive elements, I will use a combination of `Material` and `InkWell` to provide visual feedback, and wrap it in a `Semantics` widget to provide a descriptive label for screen readers. This ensures the component is accessible to screen reader users and more intuitive for everyone.
