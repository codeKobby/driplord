# Implementation Plan - DripLord MVP

## Goal Description

Build the MVP for **DripLord**, an AI-powered personal fashion assistant. The goal is to provide users with a digital wardrobe, outfit recommendations, and basic virtual try-on capabilities using Flutter, Supabase, and Gemini.

## User Review Required

> [!IMPORTANT] > **API Keys**: We will need a Gemini API key and Supabase credentials.
> **Scope**: This plan focuses on the MVP features: Authentication, Wardrobe Management, and Basic AI Recommendations. Advanced Virtual Try-On with high realism may be iterative.

## 📊 Current State Assessment

### ✅ What's Working

- __Luxury Dark Mode Design System__: Complete theme overhaul with deep midnight blue background (#0B121C), pure white CTAs, and Inter typography
- __Enhanced Glassmorphism__: Advanced GlassCard with configurable blur (20px sigma), gradient overlays, and GlassSurface for navigation
- __Modern Button System__: Primary (white pill), Secondary (glass outline), and Follow buttons with consistent styling
- __Floating Navigation__: Glassmorphism bottom navigation bar with animated selection states
- __Updated Auth Screen__: Luxury layout with decorative gradients, improved form controls, and smooth animations
- __Onboarding Flow__: 3-screen carousel with animations (using `flutter_animate`)
- __Body Measurements__: Manual input with sliders + gender selection

### ❌ Critical Gaps

| Area | Issue | Impact |
|------|-------|--------|
| __Navigation__ | No home screen after auth | User journey is broken |
| __OAuth__ | No Google/Apple sign-in | Friction in sign-up flow |
| __Components__ | Missing glass dialogs, bottom sheets, OAuth buttons | Limited UI patterns |
| __UX Flow__ | Ends at auth, no redirect to home | Blocked user journey |
| __Empty States__ | No visual feedback for empty wardrobe | Poor user guidance |
| __Digital Wardrobe__ | No implementation yet | Core MVP feature missing |

## 🎨 UI/UX Issues by Priority

### P0 - Blocking Issues (Fix Immediately)

#### 1. __Broken User Journey__

- Onboarding → Body Measurements → Auth → __Dead End__
- __Fix__: Create Home Screen with bottom navigation, redirect authenticated users from Auth

#### 2. __No OAuth Authentication__

- Only email/password available
- __Fix__: Add Google + Apple Sign-In buttons (Supabase supports both)

### P1 - Essential Improvements

#### 3. __Missing Design System Components__

| Component | Status | Purpose |
|-----------|--------|---------|
| `AppGradients` | ❌ Missing | Reusable gradient presets |
| `GlassButton` | ❌ Missing | Glass-morphic button variant |
| `GlassBottomSheet` | ❌ Missing | Bottom sheet with glass effect |
| `GlassDialog` | ❌ Missing | Alert/confirm dialogs |
| `OAuthButton` | ❌ Missing | Google/Apple sign-in buttons |
| `AuthDivider` | ❌ Missing | "Or continue with" divider |
| `ShimmerLoading` | ❌ Missing | Loading skeleton states |

#### 4. __Glass Card System Complete__

- ✅ Configurable blur intensity (20px sigma default)
- ✅ GlassSurface component for navigation bars
- ✅ Gradient overlays and subtle borders
- ✅ Enhanced with proper tileMode for better performance

#### 5. __Design Tokens Complete__

- ✅ Luxury dark mode color palette implemented
- ✅ Gradient colors added to `AppColors` class
- ✅ Glass surface colors and borders defined
- ✅ Consistent across all components

### P2 - UX Polish

#### 6. __Missing User Guidance__

- No "Skip" button on onboarding
- No empty state illustrations
- No success/error animations

#### 7. __Accessibility__

- Text contrast may fail WCAG AA
- No haptic feedback configuration
- Missing keyboard actions (Done/Next)

#### 8. __Performance__

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

### Phase 4: Home Screen & Navigation

1. Create HomeScreen with bottom navigation (Wardrobe, AI, Profile)
2. Update AuthScreen to redirect to Home when authenticated
3. Add logout functionality

### Phase 5: Polish & Accessibility

1. Add skip button to onboarding
2. Add empty state widgets
3. Configure haptic feedback
4. Add keyboard actions

## 🎯 Recommended Execution Order

```javascript
Phase 1 (Design Foundation) → Phase 2 (Components) →
Phase 3 (OAuth) → Phase 4 (Home/Nav) → Phase 5 (Polish)
```

__Total Estimated Time__: 4-6 hours for all improvements

## Proposed Changes

### Tech Stack

- **Frontend**: Flutter (Mobile)
- **Backend**: Supabase (Auth, PostgreSQL, Storage)
- **AI**: Gemini (Vision & Text)

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
