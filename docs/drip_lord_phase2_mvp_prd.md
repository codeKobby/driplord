# DripLord Phase-2 MVP — Revised UX Flow & PRD

**🎯 Document Status: Current MVP Implementation Scope & Priority**

This document defines the **Phase-2 MVP focus** for DripLord, emphasizing the daily hub experience with streamlined user flows.

**📋 Relationship to Comprehensive PRD:**
See `drip_lord_product_requirements_document_prd.md` for long-term vision, premium features, and advanced capabilities beyond current MVP scope.

---

## 1. App Entry & Intro Flow
App Launch → Intro (first time) → Authentication

### Intro / Welcome Screens
- 3–4 slides max
- Explains value, AI stylist concept, privacy, syncing
- CTA: Get Started

---

## 2. Authentication
Screens:
- Login
- Sign Up
- Forgot Password

Forgot Password Flow:
Email → Reset Link Sent → Return to Login

Auth is required. Data is synced and persistent across devices.

---

## 3. Home Screen (Daily Hub)

### Core Elements
- Daily reset (once per day)
- Exactly **2 outfit recommendations**
- Each recommendation includes:
  - Preview
  - Style rating
  - Short explanation

### Quick Actions
- Add Clothes
- Open Closet
- Open Canvas
- Chat with Stylist

---

## 4. Add Clothes Flow

### Entry Points
- Home
- Closet
- Stylist Chat

### Sources
- Take Photo
- Upload Image
- Scan Gallery (face recognition)

### Processing
- Detect user face
- Extract clothes & accessories
- Normalize upright
- Detect duplicates
- Ask for confirmation
- Save to Closet

---

## 5. Closet System

### Categories
- Tops
- Bottoms
- Footwear
- Accessories

Accessories include:
- Scarves
- Belts
- Chains
- Hats
- Bags

### Combos / Sets
- Clothes can exist as:
  - Single items
  - Combos (matched sets)
- AI suggests combos, user confirms or edits

### Actions
- View item
- Edit
- Add to canvas
- Mark as part of set

---

## 6. Style Composer (Canvas)

### Behavior
- Canva / Photoshop-style layering
- Upright alignment
- Neutral background
- Body-zone snapping

### Layer Controls
- Reorder (z-index)
- Lock
- Hide
- Resize
- Rotate

### Canvas Actions
- Save outfit
- Duplicate
- Try on
- Compare
- Share

---

## 7. Compare Mode

- Non-editable snapshots
- Each outfit fits within viewport height (vh)
- Vertical stack
- Scroll for clarity

---

## 8. Try-On System

### Rules
- Always upright
- Pose-normalized
- No original pose preservation

### Flow
Base Image → Normalize Body → Apply Canvas Outfit → Render

### Pose Switching
- Prebuilt poses
- Tap to re-render

---

## 9. AI Stylist Companion

- Always available
- Conversational
- Action-triggering
- Learns from overrides

Actions:
- Try outfit
- Edit canvas
- Add clothes
- Save looks

---

## 10. Outfits & Timeline

- Saved outfits
- Generated outfits
- Shared outfits

### Calendar
- Past outfits
- Planned outfits
- Feeds AI learning

---

## 11. Data & Persistence

- Auth required
- Cloud synced
- Reinstall-safe
- Multi-device support

---

## 12. UX Principles

- AI assists, never blocks
- Visual clarity over realism
- User always in control
- Feels like a personal stylist
