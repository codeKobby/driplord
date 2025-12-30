# Product Requirements Document (PRD)

## Product Name

DripLord

## Product Summary

DripLord is an AI-powered personal fashion assistant that helps users decide what to wear, preview outfits on themselves, and make better clothing purchase decisions. The app builds a digital wardrobe by analyzing user photos and uses AI to generate outfit recommendations, virtual try-ons, and size guidance for both owned and online clothing.

The core goal is to reduce outfit uncertainty, improve fashion confidence, and minimize wrong-size purchases.

---

## Problem Statement

Users struggle with:

- Deciding what to wear for different occasions
- Remembering or organizing what clothes they already own
- Knowing how an outfit will actually look on their body
- Choosing correct sizes when shopping online
- Visualizing inspiration outfits on themselves

Existing fashion apps either lack personalization, accurate body fit, or real wardrobe awareness.

---

## Target Users

- Fashion-conscious individuals
- Casual users who struggle with outfit choices
- Online shoppers who want better fit confidence
- Content consumers inspired by outfits on social media
- Users attending events who want curated outfit suggestions

---

## Core Features

### 1. User Profile & Body Data

- User account with cloud-based data sync
- Two body data input methods:
  - AI-assisted body scan using camera
  - Manual entry of body measurements
- Ability to update measurements over time
- Measurement data used for fit prediction and outfit simulation

---

### 2. Digital Wardrobe Creation

- Gallery sync to detect clothing images
- In-app camera for taking outfit photos
- AI detects and categorizes clothing items
- Confirmation flow for duplicate or similar outfits (inspired by Google Photos)
- Manual edit options for clothing metadata
- Automatic wardrobe updates when new photos are detected

---

### 3. Outfit Recommendation Engine

- Outfit suggestions based on:
  - Occasion
  - Weather (Daily Hub context)
  - **Vibe Selectors** (Chill, Bold, Work, Hype) for instant context switching
  - User preferences
  - Available wardrobe items
- Mix-and-match recommendations using existing clothes
- Ability to save, favorite (Heart icon), or discard suggested outfits
- **Digital Closet Insights**: Proactive notifications about unworn items or wardrobe stats.

---

### 4. Virtual Try-On & Visualization

- AI-generated outfit previews applied to the user’s body
- Try-on using:
  - Existing wardrobe items
  - Uploaded images or videos (e.g. social media inspiration)
  - Online shopping product images
- Side-by-side comparison views
- Fit realism based on user measurements

---

### 5. Online Shopping Assistance

- Upload product images from online stores
- AI estimates how items will fit on the user
- Size recommendation based on brand measurements
- Warnings for potential poor fit
- Ability to compare multiple sizes visually

---

### 6. In-Store Shopping Mode

- Camera-based scanning of clothing items
- Real-time fit and style suggestions
- Outfit pairing with existing wardrobe items
- Recommendation of best size to try

---

### 7. Dual-Theme Support

- **Luxury Dark Mode**: Premium midnight blue and glassmorphism.
- **Luxury Light Mode**: Warm cream, gold accents, and sophisticated light-mode glassmorphism.
- Manual toggle in user preferences.

---

### 8. AI Agent System

- Gemini-powered agentic system
- Specialized agents for:
  - Wardrobe analysis
  - Styling recommendations
  - Fit prediction
  - Visual generation
- Agents collaborate to produce final suggestions

---

## Non-Functional Requirements

### Performance

- Fast image processing feedback
- Smooth preview rendering
- Low-latency AI responses

### Reliability

- Cloud data persistence
- Cross-device sync
- Offline access to saved wardrobe data (limited mode)

### Privacy & Security

- Explicit user consent for gallery access
- Secure storage of images and measurements
- Ability to delete data permanently

---

## Tech Stack (High-Level)

### Frontend

- Flutter (Android, iOS, Web)

### Backend

- Supabase (authentication, database, storage)

### AI & ML

- Gemini models for reasoning, vision, and agent orchestration
- On-device lightweight processing where applicable

### Storage

- Cloud-based image and metadata storage
- Structured wardrobe and measurement database

---

## MVP Scope

### Included

- User profiles
- Gallery sync + manual photo capture
- Digital wardrobe creation
- Basic outfit recommendations with Vibe Selectors
- Virtual try-on previews
- Online size recommendation
- Cloud sync across devices
- Dual-theme (Light/Dark) support

### Excluded (Future Versions)

- Social sharing
- Marketplace integrations
- Brand partnerships
- Community features
- Advanced trend analytics

---

## Success Metrics

- User retention
- Outfit recommendation usage
- Virtual try-on engagement
- Reduction in wrong-size purchases (self-reported)
- Daily active usage before events or outings

---

## Risks & Considerations

- Accuracy of body measurement estimation
- User trust in AI-generated previews
- Performance constraints on low-end devices
- Privacy concerns around personal images

---

## Long-Term Vision

DripLord becomes a personal fashion intelligence system that understands the user’s body, style, wardrobe, and lifestyle—serving as a trusted daily decision-maker for what to wear and what to buy.
