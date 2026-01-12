## 2024-07-25 - Making `GestureDetector` Accessible in Flutter

**Learning:** Using `GestureDetector` for custom interactive widgets (like icon buttons) is an accessibility anti-pattern. Screen readers like TalkBack or VoiceOver don't recognize it as a tappable element, so it's completely invisible to visually impaired users. Additionally, it provides no visual feedback (like a ripple effect) on interaction.

**Action:** For any custom button or interactive element, replace `GestureDetector` with `InkWell`. Then, to ensure it's properly announced by screen readers, wrap the `InkWell` in a `Semantics` widget with the `button: true` property and a descriptive `label`. The direct child of the `InkWell` should also be wrapped in `ExcludeSemantics` to prevent the screen reader from announcing the content (e.g., the icon) twice. This makes the widget both interactive and accessible.
