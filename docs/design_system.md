# DripLord Design System

## Overview

DripLord implements a **Luxury Dark Mode** design system inspired by high-end fashion magazines and luxury retail apps. The design combines editorial sophistication with modern mobile UX patterns.

## 🎨 Color Palette

### Primary Colors

- **Background**: `#0B121C` (Deep Midnight Blue) - Richer than pure black for reduced eye strain
- **Primary**: `#FFFFFF` (Pure White) - High contrast CTAs with black text
- **Secondary**: `#A0A0A0` (Light Gray) - Subtle descriptions and metadata

### Luxury Light Mode

- **Background**: `#FBF9F6` (Warm Cream White)
- **Primary**: `#000000` (Pure Black)
- **Secondary**: `#8C8C8C` (Soft Gray)
- **Surface**: `#FFFFFF` (White)
- **Accents**: Gold/Cream highlights

### Glassmorphism

- **Glass Surface**: `Color(0x40151D2B)` (Dark Mode) / `Color(0x0D000000)` (Light Mode)
- **Glass Border**: `Color(0x1AFFFFFF)` (Dark Mode) / `Color(0x0D000000)` (Light Mode)

### Supporting Colors

- **Surface**: `#151D2B` - Card backgrounds
- **Surface Light**: `#1E2A3D` - Lighter surface variants
- **Text Primary**: `#FFFFFF` - Main text
- **Text Secondary**: `#A0A0A0` - Secondary text
- **Text On Primary**: `#0B121C` - Text on white buttons

## 📝 Typography

**Font Family**: Inter (Google Fonts)

### Scale

- **Display Large**: 40px, 700 weight, -0.5 letter spacing
- **Display Medium**: 32px, 700 weight, -0.3 letter spacing
- **Display Small**: 28px, 600 weight, -0.2 letter spacing
- **Headline Large**: 24px, 600 weight
- **Headline Medium**: 20px, 600 weight
- **Headline Small**: 18px, 600 weight
- **Body Large**: 16px, 400 weight, 1.5 line height
- **Body Medium**: 14px, 400 weight, 1.5 line height
- **Label Large**: 14px, 600 weight, 0.5 letter spacing

## 🔘 Components

### Buttons

#### Primary Button

- **Background**: White (`#FFFFFF`)
- **Foreground**: Black text (`#0B121C`)
- **Shape**: Pill (100% border radius)
- **Padding**: Horizontal XL (24px), Vertical MD (12px)
- **Typography**: Inter 14px, 600 weight

#### Secondary Button

- **Background**: Transparent
- **Border**: Glass border (`#1AFFFFFF`)
- **Foreground**: White text
- **Shape**: Pill (100% border radius)

#### Follow Button

- **States**: Following (outlined) / Follow (filled)
- **Size**: Compact (36px height)

### Cards

#### GlassCard

- **Blur**: 20px sigma (configurable)
- **Background**: Gradient overlay (80% → 60% opacity)
- **Border**: Subtle white border
- **Shadow**: Inner shadow for depth

#### GlassSurface

- **Use**: Full-width navigation and bottom sheets
- **Blur**: 30px sigma for stronger effect
- **Border**: Top border only

### Navigation

#### FloatingNavBar

- **Position**: Detached from bottom edge (16px margin)
- **Background**: Glass surface with blur
- **Animation**: Smooth state transitions
- **Icons**:
  - Home: `LucideIcons.home`
  - Closet: `LucideIcons.shirt`
  - Outfits: `LucideIcons.bookmark`
  - Profile: `LucideIcons.user`
- **Active State**: Glowing active item with capsule background

## 🎯 Design Principles

### Luxury Dark Mode

- **Depth**: Avoid pure black, use rich midnight blue
- **Contrast**: White CTAs with black text for accessibility
- **Glassmorphism**: Frosted blur effects for modern feel
- **Typography**: Clean Inter font throughout

### Editorial Layout

- **Whitespace**: Generous padding and margins
- **Hierarchy**: Clear visual hierarchy with typography
- **Focus**: Content as hero, UI as supporting element
- **Consistency**: Pill shapes and glass effects throughout

### Interaction Design

- **Animation**: Smooth 200ms transitions
- **Feedback**: Visual state changes and micro-interactions
- **Accessibility**: High contrast ratios, proper touch targets

## 📱 Implementation Notes

### Performance

- Glass effects use `tileMode: TileMode.decal` for better performance
- Blur radius optimized (20-30px) for mobile devices
- Colors defined as const for compile-time optimization

### Accessibility

- Text contrast meets WCAG AA standards
- Touch targets minimum 44px
- Focus indicators for keyboard navigation

### Maintenance

- Colors centralized in `AppColors` class
- Components use theme values for consistency
- Documentation updated with design changes

## 🚀 Usage Examples

### Basic Glass Card

```dart
GlassCard(
  child: Text('Content'),
)
```

### Primary Button

```dart
PrimaryButton(
  text: 'Continue',
  onPressed: () => {},
)
```

### Navigation

```dart
FloatingNavBar(
  currentIndex: 0,
  onTap: (index) => {},
)
```

## 📋 Component Checklist

- ✅ AppColors - Complete color palette with gradients and glass effects
- ✅ AppTheme - Inter typography, Material 3 with dual-theme support
- ✅ GlassCard - Enhanced with configurable blur (20px sigma) and gradients
- ✅ GlassSurface - Navigation surfaces with optimized tileMode.decal
- ✅ PrimaryButton - White pill CTA with black text
- ✅ SecondaryButton - Glass outline with blur effects
- ✅ OAuthButton - Google/Apple sign-in buttons
- ✅ AuthDivider - "Or continue with" separator
- ✅ FixedAppBar - Consistent subpage headers with solid backgrounds
- ✅ FloatingNavBar - Glass-morphic bottom navigation with state transitions
- ✅ OutfitHeroCard - Complex card component with hero images and overlays
- ❌ GlassButton - Missing (secondary glass variant)
- ❌ GlassBottomSheet - Missing
- ❌ GlassDialog - Missing
- ❌ ShimmerLoading - Missing skeleton states

## 🔄 Updates

**Latest**: Complete app architecture with sophisticated UI components (January 2026)

- ✅ Luxury dual-theme system fully implemented
- ✅ Advanced glassmorphism with performance optimizations
- ✅ Comprehensive routing with StatefulShellRoute navigation
- ✅ Sophisticated Home screen with PageView carousel and vibe selectors
- ✅ Complete Closet screen with grid view, filtering, and empty states
- ✅ Outfit recommendation system with interactive cards
- ✅ Virtual try-on screens with multiple modes
- ✅ Weather integration and settings screens
- ✅ Profile screen with theme toggle and statistics
- ✅ Onboarding flow with carousel and preference selection
- ✅ Authentication screens with OAuth UI (needs API keys)
- ✅ Full Riverpod state management across all features
