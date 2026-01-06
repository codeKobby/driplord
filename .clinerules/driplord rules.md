# Driplord - Cline Rules for MCP Tool Maximization

## 🔧 MANDATORY MCP TOOL USAGE

**THIS IS NOT OPTIONAL - ALL MCP TOOLS MUST BE USED ACTIVELY**

Before implementing ANY feature, coding ANY solution, or making ANY architectural decision:

1. First, consult **context7** for official documentation
2. Then use any other available MCP tools (database, APIs, etc.)
3. Only proceed to code after tool research is complete

**FAILURE TO USE MCP TOOLS BEFORE CODING WILL RESULT IN SUBOPTIMAL IMPLEMENTATIONS**

**NON-NEGOTIABLE REQUIREMENT**: **context7** and **web search** MUST be used for all relevant knowledge acquisition. Do not proceed with implementation without first researching through these tools. This is mandatory for every task involving new concepts, frameworks, packages, or patterns.

---

## 📚 CONTEXT7 USAGE - HIGHEST PRIORITY

**Context7 is your PRIMARY source of truth for all implementations.**

### Required Context7 Lookups:

#### Flutter & Dart

- **ALWAYS** look up current Flutter best practices before creating widgets
- Verify Flutter SDK version compatibility (project uses SDK ^3.10.4)
- Check Material 3 design implementation patterns
- Confirm animation best practices (using `flutter_animate` package)

#### Riverpod State Management

- **MANDATORY**: Look up Riverpod v3.x patterns for:
  - `flutter_riverpod` ^3.0.3 provider patterns
  - StateNotifierProvider vs AutoDispose usage
  - Family modifiers usage
  - AsyncValue handling patterns
  - ConsumerWidget vs ConsumerStatefulWidget selection
- Verify code generation vs non-code-generation approaches

#### Supabase Integration

- **MANDATORY**: Check context7 for `supabase_flutter` ^2.12.0 patterns:
  - Latest Supabase client initialization
  - Auth state management patterns
  - Database query optimization
  - Row Level Security (RLS) integration

#### Google Generative AI

- **MANDATORY**: Look up `google_generative_ai` ^0.4.7 for:
  - Model configuration and initialization
  - Content generation patterns
  - Image input handling (if using image_picker)

#### Package-Specific Patterns

- `lucide_icons` ^0.257.0 icon usage patterns
- `google_fonts` ^6.3.3 font integration
- `flutter_svg` ^2.2.3 SVG rendering
- `image_picker` ^1.2.1 platform-specific handling

### Context7 Query Examples:

**DO THIS:**

```
"flutter riverpod 3.0 asyncvalue handling best practices 2024"
"supabase flutter auth state management patterns"
"flutter material 3 custom theme implementation"
"google_generative_ai flutter sdk content generation"
```

**NOT THIS:**
"Riverpod how to use providers" (already known)

```

---

## 🛠️ AVAILABLE MCP TOOLS - YOU MUST USE THESE

**MCP tools are REQUIRED for every implementation task. Do not skip.**

### 1. **context7** (upstash/context7-mcp)
- **PRIMARY DOCUMENTATION SOURCE** - USE FIRST, USE OFTEN
- Query official documentation for any package/framework
- **Always use before coding:**
  - Flutter/Dart patterns
  - Riverpod state management
  - Supabase Flutter SDK
  - Google Generative AI
  - Any package used in pubspec.yaml
- **Query format:** Be specific with versions
  - Example: "flutter_riverpod 3.0.3 AsyncValue handling patterns"

### 2. **contextstream** (contextstream/mcp-server)
- **CONTEXT TRACKING TOOLSET** - STAY IN CONTEXT
- **USE THIS TO MAINTAIN PROJECT CONTEXT** throughout the session
- Provides extended search and context-aware capabilities
- Complements context7 with contextual awareness
- **Required:** Use before complex implementations to maintain context

### 3. **Supabase MCP** (if available)
- **DATABASE OPERATIONS** - USE FOR ALL SUPABASE ACTIONS
- Use for all Supabase database queries, inserts, updates, deletes
- Use for schema exploration and database structure queries
- Use for Row Level Security (RLS) policy management
- **Mandatory:** All database operations must use Supabase MCP if available

### 4. **browser_action** - Web research (USE WHEN MCP INSUFFICIENT)
- Research when context7/contextstream doesn't have the answer
- Verify information found on official websites
- Check GitHub issues for known bugs/workarounds

### 5. **execute_command** - Flutter/Dart CLI
- Run `flutter` commands (analyze, pub get, etc.)
- Execute build/run commands
- Use for project scaffolding and testing

### 6. **File Operations** - Required for all changes
- `read_file` - Analyze existing code before modifications
- `write_to_file` - Create new files with proper structure
- `replace_in_file` - Make targeted edits to existing files
- **PROHIBITED**: Do not create new versions of existing files unless explicitly told to do so. Always modify existing files in place using `replace_in_file` when possible.

---

## 📋 MANDATORY WORKFLOW FOR EVERY TASK

### Step 1: Research Phase (MCP Tools Required)
```

┌─────────────────────────────────────────────────────────────┐
│ 1. use_mcp_tool → context7: Look up relevant documentation │
│ 2. use_mcp_tool → Any other relevant MCP tools │
│ 3. browser_action → Web research if needed │
│ 4. ONLY THEN: Begin implementation │
└─────────────────────────────────────────────────────────────┘

````

### Step 2: Implementation Phase
- Use findings from Step 1 to guide all code decisions
- Follow documented best practices exactly
- Match project conventions (Flutter, Riverpod patterns)

### Step 3: Verification Phase
- Cross-reference implementation with context7 docs
- Ensure no outdated patterns slip in

---

## 🎯 PROJECT-SPECIFIC RULES

### Architecture Requirements
- **Feature-based folder structure**: `lib/features/{feature}/`
- **Core components**: `lib/core/components/{type}/`
- **Shared constants**: `lib/core/constants/`
- **Theme management**: `lib/core/theme/`

### State Management (Riverpod v3)
```dart
// REQUIRED PATTERN - Always verify with context7
// Providers should be in feature folders or core providers
// Use AutoDispose for screen-level providers
// AsyncValue pattern for async data
````

### UI Components

- Glass morphism cards in `lib/core/components/cards/glass_card.dart`
- Primary buttons in `lib/core/components/buttons/primary_button.dart`
- Use `lucide_icons` for consistent iconography
- Implement Material 3 design with custom theme

### Code Quality

- **NULL SAFETY**: Dart is null-safe - no exceptions!
- **CONST CONSTRUCTORS**: Use whenever possible
- **LINT RULES**: Follow `analysis_options.yaml` (flutter_lints ^6.0.0)
- **ASYNC/AWAIT**: Always proper error handling
- **THEME COLORS MANDATORY**: **NON-NEGOTIABLE** - Never use hardcoded colors. Always use theme colors from `lib/core/theme/app_colors.dart` and `lib/core/theme/app_theme.dart`. No exceptions. Use `Theme.of(context)` or theme extension methods. Hardcoded colors will result in immediate rejection.

---

## 🚫 PROHIBITED PATTERNS (Without Context7 Verification)

- Manual ProviderScope wrapping (use proper Riverpod setup)
- StatelessWidget for complex state (use ConsumerWidget)
- setState for shared state (use Riverpod)
- Hardcoded values (use AppDimensions constants)
- Direct Supabase calls without auth guard
- Generative AI calls without proper error handling

---

## 📖 QUICK REFERENCE COMMANDS

**When in doubt, query context7:**

- "flutter riverpod 2024 latest patterns"
- "supabase flutter 2.x authentication"
- "flutter 3.10 new features"
- "dart null safety best practices"

---

## ✅ MCP TOOL USAGE CHECKLIST

Before finalizing ANY code:

- [ ] Did you query context7 for framework-specific patterns?
- [ ] Did you verify Riverpod patterns for this use case?
- [ ] Did you check Supabase SDK latest practices?
- [ ] Did you use project MCP tools for database/schema info?
- [ ] Is the implementation aligned with current best practices?

---

## 🎓 LEARNING FROM MCP TOOLS

**Every implementation is an opportunity to learn:**

1. Context7 provides authoritative, up-to-date info
2. MCP tools evolve - check them even for familiar patterns
3. Flutter/Dart changes frequently - verify, don't assume

---

## 💡 EFFECTIVE CONTEXT7 PROMPTS

**Be specific about:**

- Package version (e.g., "flutter_riverpod 3.0.3")
- Use case (e.g., "auth state management")
- Platform (e.g., "iOS Android web")
- Flutter version compatibility

**Example:**

> "How to implement protected routes with flutter_riverpod 3.0.3 and Supabase auth state, including automatic token refresh?"

---

## 🔄 CONTINUOUS VERIFICATION

**At the start of each session:**

1. Query context7 for any recent Flutter/Riverpod updates
2. Check for breaking changes in used packages
3. Verify no better patterns exist for current implementation

---

## 📝 SUMMARY

| Action               | Required Tool                           |
| -------------------- | --------------------------------------- |
| Flutter widgets      | context7 → patterns                     |
| State management     | context7 → Riverpod docs                |
| Backend integration  | context7 → Supabase docs                |
| AI features          | context7 → Gemini docs                  |
| Package usage        | context7 → Package docs                 |
| Project DB schema    | **Supabase MCP** (REQUIRED)             |
| Documentation lookup | **context7** (REQUIRED)                 |
| Context tracking     | **contextstream** (REQUIRED)            |
| Web research         | browser_action (fallback)               |
| CLI operations       | execute_command                         |
| File operations      | read_file/write_to_file/replace_in_file |

**REMEMBER: context7 first, contextstream second, everything else third. No exceptions.**
