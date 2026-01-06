PALETTE'S JOURNAL - CRITICAL LEARNINGS ONLY
---
## 2024-07-25 - GestureDetector is an anti-pattern
**Learning:** Using `GestureDetector` for custom buttons is an accessibility anti-pattern. The correct pattern is to replace it with `InkWell` and wrap it in `Semantics` and `ExcludeSemantics` widgets.
**Action:** Always use the `Semantics` widget to make custom interactive Flutter widgets accessible.