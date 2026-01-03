# Implementation Plan - DripLord MVP

## Goal Description

Build the MVP for **DripLord**, an AI-powered personal fashion assistant. The goal is to provide users with a digital wardrobe, outfit recommendations, and basic virtual try-on capabilities using Flutter, Supabase, and Gemini.

## 📋 Implementation Phases

### **Phase-2 MVP (Current Priority)**
Focus on streamlined daily hub experience with core functionality:
- Daily reset with exactly 2 outfit recommendations
- Manual clothes addition with AI tagging
- Basic closet organization and management
- Style Composer canvas with layering controls
- Conversational AI stylist companion
- Cloud-based persistence and multi-device sync

### **Future Premium Phases**
- Gallery auto-scanning and social integration
- Advanced AI learning and personalization
- Shopping assistance and size guidance
- Community features and analytics
- All premium features remain in scope but are lower priority

**📖 Related Documents:**
- `drip_lord_phase2_mvp_prd.md`: Current MVP implementation scope
- `drip_lord_product_requirements_document_prd.md`: Long-term vision and premium features

## User Review Required

> [!IMPORTANT] > **API Keys**: We will need a Gemini API key and Supabase credentials.
> **Scope**: This plan focuses on the MVP features: Authentication, Wardrobe Management, and Basic AI Recommendations. Advanced Virtual Try-On with high realism may be iterative.

## 📊 Current State Assessment (Updated: January 2026)

### ✅ What's Working

- **Complete Flutter Architecture**: Full app structure with Supabase, Riverpod, Go Router, and Gemini AI
- **Luxury Dual-Theme System**: Production-ready dark/light themes with midnight blue (#0B121C) and cream (#FBF9F6) palettes
- **Advanced Glassmorphism**: Configurable blur effects (20px sigma), optimized performance with tileMode.decal
- **Routing Architecture**: Comprehensive route definitions for all major screens and subpages using StatefulShellRoute
- **Home Screen (Daily Hub)**: Sophisticated AI outfit recommendations with PageView carousel, vibe selectors (Chill, Bold, Work, Hype), history tracking, and interactive OutfitHeroCard components with redesigned compact layout
- **Closet Screen**: Grid view with filtering chips, image picker integration (camera/gallery), empty states, card animations, and category filtering
- **Navigation System**: Floating glass nav bar with proper stateful shell routing, animated transitions, and fixed RenderFlex overflow issues
- **UI Component Library**: GlassCard, PrimaryButton, SecondaryButton, OAuthButton, FixedAppBar, AuthDivider
- **State Management**: Riverpod providers for theme, closet, outfits, history, recommendations, and mirror functionality
- **Authentication Setup**: Supabase auth with Google/Apple OAuth UI components (requires API keys)
- **Onboarding Flow**: Welcome carousel, style preferences, body measurements screens
- **Weather Integration**: Weather provider with geolocator and weather package
- **Animation System**: Flutter Animate with staggered entrance effects and smooth transitions
- **UI Polish**: Fixed RenderFlex overflow in navigation, reduced padding and roundness throughout homepage for more compact design, optimized thumbnail spacing

### ❌ Critical Gaps (Remaining Work)

| Area                 | Issue                                 | Impact                   | Priority |
| -------------------- | ------------------------------------- | ------------------------ | -------- |
| **Data Persistence**| No Supabase database integration      | Core MVP feature missing | P0 |
| **AI Integration**  | Gemini API not connected              | No AI features working   | P0 |
| **Image Upload**    | Supabase Storage not implemented      | Cannot add clothing      | P0 |
| **Virtual Try-On**  | Style Composer has placeholder UI     | No try-on functionality  | P1 |
| **OAuth Setup**     | API keys not configured               | Cannot sign in           | P1 |
| **Empty States**    | Some screens lack proper empty state handling | Poor UX for new users | P2 |

## 🎨 UI/UX Issues by Priority

### P0 - Blocking Issues (Fix Immediately)

#### 1. **Broken User Journey** - ✅ FIXED

- Redirects to Home after Auth
- Navigation flow established

#### 2. **No OAuth Authentication** - ✅ IMPLEMENTED

- Google Sign-In added (requires client IDs)
- Apple Sign-In added
- UI updated with OAuth buttons

### P1 - Essential Improvements

#### 3. **Missing Design System Components**

| Component          | Status     | Purpose                        |
| ------------------ | ---------- | ------------------------------ |
| `AppGradients`     | ❌ Missing | Reusable gradient presets      |
| `GlassButton`      | ❌ Missing | Glass-morphic button variant   |
| `GlassBottomSheet` | ❌ Missing | Bottom sheet with glass effect |
| `GlassDialog`      | ❌ Missing | Alert/confirm dialogs          |
| `OAuthButton`      | ❌ Missing | Google/Apple sign-in buttons   |
| `AuthDivider`      | ❌ Missing | "Or continue with" divider     |
| `ShimmerLoading`   | ❌ Missing | Loading skeleton states        |

#### 4. **Glass Card System Complete**

- ✅ Configurable blur intensity (20px sigma default)
- ✅ GlassSurface component for navigation bars
- ✅ Gradient overlays and subtle borders
- ✅ Enhanced with proper tileMode for better performance

#### 5. **Design Tokens Complete**

- ✅ Luxury dark mode color palette implemented
- ✅ Gradient colors added to `AppColors` class
- ✅ Glass surface colors and borders defined
- ✅ Consistent across all components

### P2 - UX Polish

#### 6. **Missing User Guidance**

- No "Skip" button on onboarding
- No empty state illustrations
- No success/error animations

#### 7. **Accessibility**

- Text contrast may fail WCAG AA
- No haptic feedback configuration
- Missing keyboard actions (Done/Next)

#### 8. **Performance**

- 10px blur can be heavy on low-end devices
- No shimmer loading states (causes layout shift)

## 📋 Implementation Plan

### Phase 1: Design System Foundation

1. Create `AppGradients` class with reusable gradient presets
2. Create `GlassConfig` class for configurable blur/opacity
3. Update `AppColors` with gradient and glass surface colors

### Phase 2: Core Components

1. Create `GlassButton` - secondary button with glass effect
2. Create `GlassBottomSheet` - bottom sheet with glass styling
3. Create `GlassDialog` - modal dialogs
4. Create `OAuthButton` - Google/Apple sign-in
5. Create `AuthDivider` - "Or continue with" divider
6. Create `ShimmerLoading` - skeleton loader

### Phase 3: OAuth Integration

1. Configure Supabase OAuth providers (Google, Apple)
2. Create `AuthService` for OAuth handling
3. Update AuthScreen with OAuth buttons

### Phase 4: Core Navigation & Screens

1. **Refactor Navigation**:

   - ✅ Updated `FloatingNavBar` items to: Home, Closet, Outfits, Profile.
   - ✅ Implemented `HomeScreen` shell.
   - ✅ Implemented context-aware **Floating Action Button (FAB)** with "Stylist" label.

2. **Home Screen (Daily Hub)**:

   - ✅ AI outfit suggestion with weather context.
   - ✅ **Vibe Selectors** (Chill, Bold, Work, Hype).
   - ✅ Actions: Try this look, Regenerate, Heart (Save).
   - ✅ **Closet Insights** card added.

3. **Closet Screen**:

   - ✅ Digital inventory categorized grid.
   - FAB: Add clothing item (Camera/Gallery).

4. **Outfits Screen**:

   - ✅ History of won and saved looks.
   - FAB: Create new combination.

5. **Profile Screen**:

   - ✅ Added **Theme Toggle** (Light/Dark).
   - ✅ Added Profile Stat cards.

6. **Contextual Flow: Try-On / Mirror**:
   - ✅ Integration from Home, Closet, and Outfits.

### Design Strategy: "Luxury Dark Mode"

> **Editorial Fashion App**: Inspired by high-end fashion magazines and luxury retail apps. Combines the sophistication of Vogue with modern mobile UX patterns.

- **Visual Identity (Luxury Dark Mode)**:

  - _Vibe_: Sophisticated, editorial, premium fashion experience.
  - _Color Palette_:
    - **Background**: Deep Midnight Blue (`#0B121C`) – Richer than pure black for reduced eye strain.
    - **Primary**: Pure White (`#FFFFFF`) – High contrast CTAs with black text.
    - **Secondary**: Light Gray (`#A0A0A0`) – Subtle descriptions and metadata.
    - **Glass Surfaces**: Semi-transparent overlays with frosted blur effects.
  - _Typography_: **Inter** (Clean, modern sans-serif throughout – headings and body).
  - _Shapes_: High-radius pill buttons (100% border-radius) and rounded cards.

- **UX Principles (Fashion Editorial)**:
  - _Simplicity_: Editorial layout with generous whitespace, letting content breathe.
  - _Focus_: Large, high-quality imagery as the hero element.
  - _Navigation_: Floating glass navigation bar detached from bottom edge.
  - _Interaction_: Smooth animations and micro-interactions for premium feel.

#### UI Components

- **Style**: **Advanced Glassmorphism** with configurable blur intensity (20px sigma).
- **Cards**: Enhanced GlassCard with gradient overlays and subtle borders.
- **Buttons**: Pill-shaped primary buttons (white), outline secondary buttons.
- **Navigation**: Floating glass bottom bar with animated selection states.
- **Motion**: Smooth fades, scale animations, and staggered entrance effects.

### 1. Project Setup

- Initialize a new Flutter app: `drip_lord`
- Setup Supabase project (Auth, DB, Storage buckets)
- Add dependencies: `supabase_flutter`, `google_generative_ai`, `image_picker`, `flutter_riverpod` (state management).

### 2. Database Schema (Supabase)

- **profiles**: `id`, `user_id`, `body_measurements` (JSON), `preferences`
- **wardrobe_items**: `id`, `user_id`, `image_url`, `category`, `color`, `brand`, `created_at`
- **outfits**: `id`, `user_id`, `item_ids` (array), `occasion`, `created_at`

### 3. Feature Implementation

#### Onboarding Flow (Conversion Optimized)

- [ ] **Welcome Screen**: Carousel highlighting value propositions.
- [ ] **Style Preferences**: Select style archetypes (Streetwear, Minimalist, etc.) _before_ signing up.
- [ ] **Body Data Input**:
  - Manual input (Height, Weight) to generate initial recommendations.
  - (Optional) Skip for now.
- [ ] **Sign Up / Login**: Presented _after_ users have invested time in setup, to save their profile.

#### Profile Management

- [ ] **Profile Screen**: View/Edit measurements and settings.

#### Digital Wardrobe

- [ ] **In-App Camera/Gallery**: Use `image_picker` to capture clothing.
- [ ] **Storage**: Upload images to Supabase Storage bucket `wardrobe`.
- [ ] **AI Tagging**: Send image to Gemini Vision to extract metadata (Category, Color, Style) before saving to DB.
- [ ] **UI**: Grid view of user's clothes, filterable by category.

#### Outfit Recommendation

- [ ] **Recommendation Engine**: Prompt Gemini with user's wardrobe items (JSON list) + generic occasion context to generate outfit combinations.
- [ ] **Display**: Show generated combos as lists of images.

#### Virtual Try-On (MVP)

- [ ] **Visualization**: Allow user to select an item and a user photo. Send to Gemini Vision for a "conceptual" try-on generation or overlay (depending on API capabilities for generation vs. analysis). _Initial version might be a collage or simple overlay._

## Verification Plan

### Automated Tests

- `flutter test` for core logic (AI service parsing, models).

### Manual Verification

- **Auth**: Sign up a new user, verify row created in `profiles`.
- **Upload**: Take a photo of a shirt, verify it appears in Wardrobe with correct tags (e.g., "Blue T-Shirt").
- **Recommendation**: Ask for "Casual Friday" outfit, verify logical suggestion from owned items.
