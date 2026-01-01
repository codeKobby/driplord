# DripLord App Routing Architecture

## Overview

This document outlines the complete routing architecture for DripLord, including navigation flows, deep linking support, and subpage relationships. The architecture supports both bottom tab navigation and deep linking for seamless user experiences.

## 🗂️ Current Navigation Structure

**Main Navigation (HomeScreen PageView):**
- **Home** → DailyHubScreen (AI recommendations, vibe selectors, closet insights)
- **Closet** → ClosetScreen (wardrobe grid, filtering, add item FAB)
- **Outfits** → OutfitsScreen (favorites carousel, worn history)
- **Profile** → ProfileScreen (settings, preferences, account)

**Existing Subpages:**
- Closet → AddItemScreen (via FAB)
- Closet → TryOnMirrorScreen (item tap)
- Outfits → TryOnMirrorScreen (outfit tap)
- Home → NotificationScreen (via bell icon)

---

## 🏠 Home Page Subpages (DailyHubScreen)

### Weather Integration
**WeatherSettingsScreen:**
- Real weather API (Google Weather API / OpenWeatherMap)
- Location permissions and settings
- Temperature units (Celsius/Fahrenheit)
- Weather update frequency
- Clothing suggestions based on real weather data

**Routes:**
```
/home/weather → WeatherSettingsScreen
```

### Notifications System
**NotificationScreen (Redesign):**
- Simplified design: line separators instead of cards
- Tap notification → routes to related page/feature
- Swipe to delete notifications
- Mark as read/unread functionality
- Notification types: outfit suggestions, wardrobe updates, style tips

**NotificationDetailScreen:**
- Full notification content display
- Related actions (try outfit, view item, etc.)
- Delete/read controls
- Navigation to related features

**Routes:**
```
/home/notifications → NotificationScreen (simplified)
/home/notifications/:id → NotificationDetailScreen
```

### AI-Powered Vibe System
**VibeSettingsScreen:**
- AI analyzes user's style patterns from continuous usage
- Dynamically generates personalized vibes based on learned preferences
- User's selected styles determine available vibe options
- Machine learning on: outfit choices, saved items, worn frequency

**VibeCustomizationScreen:**
- Customize individual vibe preferences
- Style adjustments per vibe
- Color scheme modifications
- Occasion mapping

**Routes:**
```
/home/vibes → VibeSettingsScreen (AI-learned)
/home/vibes/customize → VibeCustomizationScreen
```

### Insights Cards → Closet Children
**Navigation to Closet Subpages:**
- Haven't Worn card → routes to closet unworn items
- Recently Added card → routes to closet recent items
- Grid display: max 2 columns, "X more" overlay on excess items

---

## 👔 Outfits Page Subpages (OutfitsScreen)

### Current Outfits Features:
- Favorites carousel (horizontal scroll)
- Recently worn list (vertical)
- Outfit creation FAB

### Dynamic Organization:
- **Smart Collections**: AI-generated based on user patterns
- **Seasonal Collections**: Spring, Summer, Fall, Winter
- **Occasion Collections**: Work, Casual, Formal, Evening, Date
- **Style Collections**: User-created custom collections

### Proposed Outfits Subpages:

**1. Outfit Management:**
```
/outfits → OutfitsScreen (main)
/outfits/favorites → FavoriteOutfitsScreen
/outfits/history → OutfitHistoryScreen
/outfits/create → OutfitBuilderScreen (enhanced)
```

**2. Outfit Details:**
```
/outfits/:id → OutfitDetailScreen
/outfits/:id/edit → OutfitEditScreen
/outfits/:id/share → OutfitShareScreen
/outfits/:id/duplicate → OutfitDuplicateScreen
/outfits/:id/try-on → TryOnMirrorScreen
```

**3. Collections & Organization:**
```
/outfits/collections → OutfitCollectionsScreen
/outfits/collections/create → CreateCollectionScreen
/outfits/collections/:id → CollectionDetailScreen
/outfits/seasonal/:season → SeasonalOutfitsScreen
/outfits/occasion/:type → OccasionOutfitsScreen
/outfits/smart/:category → SmartOutfitsScreen
```

### Screen Details:

**OutfitDetailScreen:**
- Full outfit display with all component items
- Item breakdown with links to individual pieces
- Try-on integration with outfit preview
- Edit/share/delete/duplicate actions
- Wear tracking and statistics

**OutfitBuilderScreen (Enhanced):**
- Visual drag-drop interface for item selection
- Real-time outfit preview and compatibility checking
- AI-powered suggestions for missing pieces
- Save/discard with naming options
- Style consistency validation

**OutfitShareScreen:**
- Social media sharing (Instagram, Pinterest, etc.)
- Export options (image collage, PDF, link)
- Privacy controls and sharing permissions
- Outfit inspiration tagging

**OutfitCollectionsScreen:**
- Browse all collections (user-created + smart)
- Collection creation and management
- Quick access to favorite collections
- Collection statistics and usage tracking

**SmartOutfitsScreen:**
- AI-curated outfit collections
- Based on: weather, occasion, user preferences
- Learn from user feedback and interactions
- Dynamic updates based on new wardrobe items

### Navigation Triggers:

**From OutfitsScreen:**
```dart
// Collection taps
Navigator.push(context, MaterialPageRoute(
  builder: (_) => SeasonalOutfitsScreen(season: 'summer')
));

// Outfit taps
Navigator.push(context, MaterialPageRoute(
  builder: (_) => OutfitDetailScreen(outfitId: outfit.id)
));

// FAB actions
Navigator.push(context, MaterialPageRoute(
  builder: (_) => const OutfitBuilderScreen()
));
```

### Design Requirements:
- **Carousel Layout**: Horizontal scrolling for outfit previews
- **Grid Views**: 2-column layout for collection browsing
- **Visual Hierarchy**: Clear outfit imagery with overlay information
- **Action States**: Favorite, share, try-on, edit indicators

---

## 🎨 **Style Composer (Outfit Styling & Planning)**

### **Implementation Specification**

**Purpose:** Unified page for outfit styling and planning with progressive enhancement

#### **Core UX Structure (Basic View)**

**Outfit Stack Layout:**
- Vertical list of clothing items (Top → Bottom → Footwear → Accessories)
- Each item: Product image, name/category, optional metadata
- Mirrors mental outfit assembly process

**Item Interaction Controls:**
- **Per-item actions:** Replace, Remove, Swap, View Details
- Self-contained components with individual state/callbacks

```dart
class OutfitItem {
  final String id;
  final String category;
  final String imageUrl;
  final Map<String, dynamic> metadata;
  final VoidCallback onReplace;
  final VoidCallback onRemove;
  final VoidCallback onViewDetails;
}
```

**Global Outfit Actions:**
- Save outfit, Regenerate entire outfit, Try on (advanced), Discard
- Operate on complete outfit object

```dart
class Outfit {
  final String id;
  final List<String> itemIds;
  final Map<String, dynamic> context; // occasion, weather
  final String source; // 'ai_generated' | 'user_created'
  final DateTime createdAt;
}
```

#### **Replacement & Editing Logic**

**Item Replacement Flow:**
1. Determine item category
2. AI filters: closet inventory + weather/occasion/style constraints
3. Show replacement selector

**Replacement Sources (Priority):**
1. User's closet
2. Saved outfits
3. AI-suggested combinations
4. Shopping links (future)

**Smart Constraints:**
- Color harmony, formality level, weather suitability, fit compatibility
- Enforced before UI rendering

```dart
bool validateReplacement(ClothingItem oldItem, ClothingItem newItem, OutfitContext context)
```

#### **AI Responsibilities**

- Assemble initial outfits
- Explain item compatibility (optional)
- Suggest coherent replacements
- Maintain style consistency during edits
- **Does not render images** - focuses on reasoning and selection

#### **Regeneration Modes**

- **Item level:** Regenerate single piece
- **Category level:** Regenerate footwear, tops, etc.
- **Outfit level:** Regenerate entire look

#### **Advanced Mode: Virtual Try-On (Optional)**

**Entry Points:**
- "Try on avatar" button
- "See this on me" action
- **Never automatic** - explicit opt-in

**Avatar Rendering:**
- User body profile (measurements/scan)
- Selected outfit items
- Neutral pose/background

**Performance Safeguards:**
- Clear loading states
- Cached recent renders
- Instant exit to basic view

#### **Composer Modes**

```
/try-on → StyleComposerScreen (main studio)
/try-on/item/:id → StyleComposerScreen(mode: ComposerMode.tryOn)
/try-on/outfit/:id → StyleComposerScreen(mode: ComposerMode.view)
/try-on/compose → StyleComposerScreen(mode: ComposerMode.manual)
/try-on/ai/:vibe → StyleComposerScreen(mode: ComposerMode.ai)
```

**Mode Definitions:**
- **tryOn:** Single item preview on user avatar
- **view:** Complete outfit display
- **manual:** Drag-drop composition interface
- **ai:** AI-generated with suggestions
- **edit:** Modify existing outfits

#### **Navigation Integration**

**From Closet:**
```dart
// Try single item
Navigator.push(context, MaterialPageRoute(
  builder: (_) => StyleComposerScreen(
    mode: ComposerMode.tryOn,
    initialItemId: item.id,
  ),
));

// Manual composition starting with item
Navigator.push(context, MaterialPageRoute(
  builder: (_) => StyleComposerScreen(
    mode: ComposerMode.manual,
    initialItems: [item],
  ),
));
```

**From Outfits:**
```dart
// View complete outfit
Navigator.push(context, MaterialPageRoute(
  builder: (_) => StyleComposerScreen(
    mode: ComposerMode.view,
    outfitId: outfit.id,
  ),
));

// Edit existing outfit
Navigator.push(context, MaterialPageRoute(
  builder: (_) => StyleComposerScreen(
    mode: ComposerMode.edit,
    outfitId: outfit.id,
  ),
));
```

**From Home (AI Suggestions):**
```dart
// AI-generated composition
Navigator.push(context, MaterialPageRoute(
  builder: (_) => StyleComposerScreen(
    mode: ComposerMode.ai,
    vibe: selectedVibe,
    weatherContext: currentWeather,
  ),
));
```

### **Data Model Summary**

```json
// Outfit Object
{
  "id": "outfit_123",
  "items": ["top_456", "bottom_789", "shoe_101"],
  "context": {
    "occasion": "casual",
    "weather": "warm",
    "vibe": "chill"
  },
  "source": "ai_generated",
  "createdAt": "2024-01-01T10:00:00Z"
}

// Enhanced ClothingItem
{
  "id": "item_456",
  "category": "top",
  "imageUrl": "https://...",
  "attributes": {
    "color": "neutral",
    "fit": "relaxed",
    "season": "all",
    "brand": "Uniqlo"
  },
  "isFavorite": false,
  "wearCount": 0,
  "lastWorn": null
}
```

### **Implementation Principles**

- **Outfit planning ≠ virtual try-on** (separate concerns)
- **Item-level actions over global actions** (granular control)
- **AI enforces logic before UI** (prevents invalid combinations)
- **Advanced features are opt-in** (progressive enhancement)
- **Fast basic flow is sacred** (performance first)

### **Screen Structure**

```
┌─────────────────────────────────┐
│ [Fixed Header] Style Composer   │
├─────────────────────────────────┤
│ Camera/Mirror View              │
│ (Real-time try-on)              │
├─────────────────────────────────┤
│ Outfit Stack                    │
│ • Top item (replace/remove)     │
│ • Bottom item (replace/remove)  │
│ • Footwear (replace/remove)     │
│ • Accessories (optional)        │
├─────────────────────────────────┤
│ Composition Tools               │
│ • Item selector                 │
│ • AI suggestions                │
│ • Save/Share actions            │
└─────────────────────────────────┘
```

---

## 🎯 Implementation Priorities

### Phase 1: Core Infrastructure
1. Create `FixedAppBar` component with solid backgrounds
2. Install and configure `go_router` for routing
3. Set up deep linking support

### Phase 2: Home Subpages
1. Implement `WeatherSettingsScreen` with real weather API
2. Redesign `NotificationScreen` with line separators
3. Create `NotificationDetailScreen` with actions
4. Build `VibeSettingsScreen` with AI-learned vibes
5. Update DailyHubScreen navigation triggers

### Phase 3: Closet Subpages
1. Create `ClosetInsightsScreen` overview
2. Build `UnwornItemsScreen` and `RecentItemsScreen`
3. Implement item detail pages
4. Add closet settings page

### Phase 4: Outfits & Profile
1. Build outfit subpages (detail, builder, share)
2. Create profile subpages (edit, preferences)
3. Implement full routing system

### Phase 5: Polish & Deep Linking
1. Add deep linking support
2. Implement navigation guards
3. Test all flows and edge cases

---

## 📋 Route Definitions Summary

**Core App:**
```
/ → WelcomeScreen
/auth/signin → AuthScreen(initialIsLogin: true)
/auth/signup → AuthScreen(initialIsLogin: false)
/auth/forgot-password → ForgotPasswordScreen
/home → HomeScreen (Bottom Tab Container)
```

**Home Subpages:**
```
/home/notifications → NotificationScreen
/home/notifications/:id → NotificationDetailScreen
/home/weather → WeatherSettingsScreen
/home/vibes → VibeSettingsScreen
/home/vibes/customize → VibeCustomizationScreen
```

**Closet Subpages:**
```
/closet → ClosetScreen
/closet/item/:id → ItemDetailScreen
/closet/add → AddItemScreen
/closet/add/camera → AddItemScreen(camera: true)
/closet/add/gallery → AddItemScreen(gallery: true)
/closet/add/url → AddItemScreen(url: true)
/closet/add/auto-scan → AutoScanSetupScreen (Premium)
/closet/add/social/:platform → SocialLinkScreen (Premium)
/closet/add/purchase-history → PurchaseHistoryScreen (Premium)
/closet/settings → ClosetSettingsScreen
/closet/insights → ClosetInsightsScreen
/closet/insights/unworn → UnwornItemsScreen
/closet/insights/recent → RecentItemsScreen
/closet/insights/favorites → FavoriteItemsScreen
/closet/insights/most-worn → MostWornItemsScreen
/closet/insights/seasonal/:season → SeasonalItemsScreen
```

---

## 🎨 Design Requirements

### Fixed Headers
- All subpages use `FixedAppBar` with solid background
- Prevent content leakage from scrolling
- Consistent back navigation
- Title styling matches design system

### Grid Constraints
- Insights cards: max 2 columns
- Excess items: "X more" overlay on second image
- Tap "X more" → full list view

### Dynamic Content
- Vibe selectors: AI-generated based on user patterns
- Notifications: contextual routing to related features
- Weather: real-time data with location permissions

---

## 🔗 Deep Linking Support

**URL Scheme:** `driplord://`

**Examples:**
- `driplord://home/notifications/123` → Specific notification
- `driplord://closet/item/456` → Item details
- `driplord://home/weather` → Weather settings

**Platform Setup:**
- iOS: URL Schemes in Info.plist
- Android: Intent filters in AndroidManifest.xml
- Web: Hash routing fallback

---

## 📊 Success Metrics

- **Navigation**: Smooth transitions, no layout shifts
- **Deep Linking**: All URLs work from external sources
- **UX**: Intuitive flows, proper back navigation
- **Performance**: Fast loading, efficient state management
- **Reliability**: Consistent routing across app restarts

---

## 🚀 Next Steps

1. **Start Implementation**: Begin with `FixedAppBar` component
2. **Weather Integration**: Set up real weather API
3. **Notification Redesign**: Simplify design, add actions
4. **Vibe AI System**: Implement dynamic vibe generation
5. **Closet Insights**: Build child pages under closet

**Ready to begin implementation?** Let's start with the fixed headers and weather API integration.
