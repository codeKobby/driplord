## 2024-07-25 - Make custom interactive widgets accessible

**Learning:** Using `GestureDetector` for custom buttons is an accessibility anti-pattern in Flutter. `GestureDetector` is invisible to screen readers, making the UI inaccessible to visually impaired users.

**Action:** When a custom interactive widget is needed, use `InkWell` to provide visual feedback on tap. Wrap the `InkWell` in a `Semantics` widget with `button: true` and a descriptive `label`. The child of the `InkWell` should then be wrapped in `ExcludeSemantics` to prevent the screen reader from announcing the content twice.
