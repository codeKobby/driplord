# DripLord Design System

## Overview

DripLord implements a **Luxury Dark Mode** design system inspired by high-end fashion magazines and luxury retail apps. The design combines editorial sophistication with modern mobile UX patterns.

## 🎨 Color Palette

### Primary Colors
- **Background**: `#0B121C` (Deep Midnight Blue) - Richer than pure black for reduced eye strain
- **Primary**: `#FFFFFF` (Pure White) - High contrast CTAs with black text
- **Secondary**: `#A0A0A0` (Light Gray) - Subtle descriptions and metadata

### Glassmorphism
- **Glass Surface**: `Color(0x40151D2B)` - Semi-transparent overlay
- **Glass Border**: `Color(0x1AFFFFFF)` - Subtle white border

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
- **Icons**: Lucide icons with animated selection

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

- ✅ AppColors - Complete color palette
- ✅ AppTheme - Inter typography, Material 3
- ✅ GlassCard - Enhanced with gradients
- ✅ GlassSurface - Navigation surfaces
- ✅ PrimaryButton - White pill CTA
- ✅ SecondaryButton - Glass outline
- ✅ FollowButton - Social interactions
- ✅ FloatingNavBar - Bottom navigation
- ✅ CircleIconButton - Utility buttons

## 🔄 Updates

**Latest**: Luxury dark mode implementation complete
- Midnight blue background (#0B121C)
- White CTAs with black text
- Inter typography system
- Advanced glassmorphism
- Floating navigation bar
- Updated auth screen design
