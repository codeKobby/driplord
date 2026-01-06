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
- ✅ SortDropdown - Custom dropdown for sorting and filtering
- ✅ FilterChips - Tag-based filtering with visual feedback
- ✅ SearchBar - Search input component
- ❌ GlassButton - Missing (secondary glass variant)
- ❌ GlassBottomSheet - Missing
- ❌ GlassDialog - Missing
- ❌ ShimmerLoading - Missing skeleton states

## 🔄 Updates

**Latest**: Complete app architecture with sophisticated UI components (January 2026)

### Current Implementation Status

#### ✅ Fully Implemented (UI/UX)
- Luxury dual-theme system with Material 3
- Advanced glassmorphism with performance optimizations
- Comprehensive routing with StatefulShellRoute navigation
- Sophisticated Home screen with outfit recommendation UI
- Complete Closet screen with grid view, filtering, and empty states
- Outfit recommendation system with interactive cards
- Virtual try-on screens with multiple composition modes
- Authentication screens with OAuth UI (backend integration pending)
- Profile screen with theme toggle and statistics
- Onboarding flow with carousel and preference selection
- Weather integration and settings screens
- Full Riverpod state management across all features

#### 🔄 In Development
- AI-powered style learning system
- Advanced outfit composition algorithms
- Enhanced try-on avatar customization
- Smart closet organization features

#### 📋 Missing Components
- GlassButton - Basic glass variant button
- GlassBottomSheet - Glassmorphic bottom sheets
- GlassDialog - Glassmorphic dialog components
- ShimmerLoading - Skeleton loading states

### Architecture Implementation

#### State Management
- **Riverpod 3.0.3**: Provider-based state management
- **AutoDispose**: Memory-efficient providers for screens
- **AsyncValue**: Pattern for async data handling
- **Family**: Generic providers with parameters

#### Navigation
- **GoRouter 17.0.1**: Declarative routing
- **StatefulShellRoute**: Bottom navigation with nested routes
- **Deep Linking**: URL scheme support for external navigation
- **Route Guards**: Authentication and authorization checks

#### Backend Integration
- **Supabase**: Real-time database, authentication, and storage
- **Google Generative AI**: Content generation and style analysis
- **Image Processing**: AI-powered clothing segmentation
- **Weather APIs**: Real-time weather integration

#### Performance Optimizations
- **Glass Effects**: Optimized blur with TileMode.decal
- **Image Caching**: Efficient image loading and memory management
- **Provider Listening**: Minimal rebuilds with targeted state updates
- **Widget Reuse**: Efficient widget tree management

### Component Library Status

#### ✅ Implemented Components
- **GlassCard**: Enhanced with configurable blur and gradients
- **GlassSurface**: Navigation surfaces with optimized performance
- **PrimaryButton**: White pill CTA with black text
- **SecondaryButton**: Glass outline with blur effects
- **OAuthButton**: Google/Apple sign-in buttons
- **AuthDivider**: "Or continue with" separator
- **FixedAppBar**: Consistent subpage headers with solid backgrounds
- **FloatingNavBar**: Glass-morphic bottom navigation with state transitions
- **OutfitHeroCard**: Complex card component with hero images and overlays
- **SortDropdown**: Custom dropdown for sorting and filtering
- **FilterChips**: Tag-based filtering with visual feedback

#### 🚧 Under Development
- **Advanced Search**: Full-text search with AI suggestions
- **Loading States**: Skeleton screens and progress indicators
- **Error Boundaries**: Graceful error handling and recovery
- **Accessibility**: Enhanced screen reader support

### Styling System

#### Color System
```dart
// Primary Palette
const background = Color(0xFF0B121C); // Deep Midnight Blue
const primary = Color(0xFFFFFFFF);    // Pure White
const secondary = Color(0xFFA0A0A0);  // Light Gray

// Glass Effects
const glassSurface = Color(0x40151D2B); // Dark Mode
const glassBorder = Color(0x1AFFFFFF);  // Dark Mode
```

#### Typography System
- **Font**: Inter from Google Fonts
- **Scale**: Material 3 typography scale
- **Weights**: 100-900 with strategic usage
- **Line Height**: Optimized for readability

#### Layout System
- **Spacing**: AppDimensions constants for consistency
- **Grid**: 12-column responsive grid system
- **Breakpoints**: Mobile-first responsive design
- **Flexbox**: Modern layout with constraints

### Integration Status

#### Authentication (Configurable)
- Email/Password: Fully implemented
- Google OAuth: UI ready, requires API keys
- Apple Sign-In: UI ready, requires API keys
- Session Management: Supabase integration

#### AI Features
- **Image Analysis**: Clothing segmentation and categorization
- **Style Generation**: Outfit recommendation algorithms
- **Content Creation**: Google Generative AI integration
- **Personalization**: User preference learning

#### External Services
- **Weather APIs**: Google Weather API integration
- **Image Processing**: AI-powered clothing extraction
- **Cloud Storage**: Supabase for image and data storage
- **Real-time Updates**: WebSocket connections for sync
