# Product Requirements Document (PRD)

**📋 Document Status: Long-term Vision & Comprehensive Feature Roadmap**

Product Name (Working)

TBD (internally: AI Stylist / Style Companion)

---

**🎯 Phase-2 MVP Focus (Current Priority):**
See `drip_lord_phase2_mvp_prd.md` for current MVP implementation scope focusing on daily hub experience with 2 outfit recommendations, basic closet management, and conversational AI stylist.

This comprehensive PRD outlines the full product vision and premium features beyond the current MVP.

## 1. Product Vision

To give users a personal, always-available professional stylist that understands their real wardrobe, their personal style, and their lifestyle, so they never struggle with what to wear — for any occasion.

This product does not aim to be:

- A generic virtual try-on app
- A fashion marketplace
- A social fashion platform (yet)

It is:

A wardrobe intelligence and styling system powered by AI, normalized visuals, and style learning.

## 2. Target User (Phase-2 MVP)

- Fashion-conscious individuals
- Users who take photos of themselves or their outfits
- Users who want clarity, speed, and confidence when dressing

Not stylists, not designers (yet)

## 3. Core Value Proposition

| Problem | Solution |
|---------|----------|
| Users forget what they own | AI-built visual closet |
| Clothes don't mix well | Canvas-based outfit composition |
| Styling is stressful | AI stylist with memory |
| Try-on apps feel fake | Normalized, clean try-on |
| Switching phones loses data | Cloud-first persistence |

## 4. Scope Definition (IMPORTANT)

🚀 MVP STARTS FROM PHASE 2

No Phase 1 onboarding-heavy UX.

Assumption:
AI learns style primarily from:

- User images
- Closet additions
- Interactions (likes, saves, wears)

### 4.1 Phase-2 MVP Core Flows (Current Priority)

**Daily Hub Experience:**
- App launch → Intro screens → Authentication → Daily Hub
- Daily reset with exactly 2 outfit recommendations
- Each recommendation includes preview, style rating, and explanation
- Quick actions: Add Clothes, Open Closet, Open Canvas, Chat with Stylist

**Simplified Onboarding:**
- Streamlined intro (3-4 slides max)
- Direct path to authentication
- Focus on immediate value delivery

**Core MVP Features (Phase-2 Priority):**
- Manual clothes addition with AI tagging
- Basic closet organization (tops, bottoms, footwear, accessories)
- Style Composer canvas with layering and controls
- Conversational AI stylist companion
- Outfit history and timeline tracking
- Cloud-based persistence and multi-device sync

**Premium Features (Future Phases):**
All advanced capabilities listed below remain in scope but are lower priority for initial MVP.

## 5. Functional Requirements

### 5.1 Authentication & Persistence

**Required**

- Email / OAuth authentication
- Cloud-based storage
- User data must persist across:
  - App reinstalls
  - Phone changes

### 5.2 Closet Creation & Management

#### 5.2.1 Ways to Add Clothes

Users can add clothes via:

- Photo of themselves wearing the item
- Photo of the clothing item alone
- Gallery scan (optional, user-approved)

#### 5.2.2 Gallery Scan (Smart Import)

When enabled:

- App scans gallery
- Detects user's face
- Extracts images containing the user
- Identifies clothing & accessories
- Segments items
- Detects duplicates
- Asks user to confirm matches

⚠️ Must be:

- Opt-in
- Transparent
- Interruptible

#### 5.2.3 Clothing Normalization (Critical)

All extracted clothes are:

- Segmented
- Flattened
- Rotated upright
- Centered
- Normalized to fashion-standard layout

Goal:
Every clothing item looks like:

- An ecommerce flat-lay
- A fashion editorial cut

This normalized version is what appears in:

- Closet view
- Styling canvas
- Try-on
- AI reasoning

#### 5.2.4 Categorization & Metadata

Each clothing item includes:

- Category (top, bottom, footwear, accessory, etc.)
- Sub-category
- Color
- Layer type
- Seasonality
- Style attributes (formal, casual, street, etc.)

User can:

- Edit
- Override
- Merge duplicates

### 5.3 Style Learning System (Style DNA)

#### 5.3.1 Style Learning Inputs

AI learns user style from:

- Closet items
- Saved outfits
- Liked recommendations
- Worn history
- Skipped recommendations

#### 5.3.2 Style DNA Behavior

- Generated automatically
- Updates continuously
- No manual setup required
- Used globally across app

### 5.4 Outfit Canvas (Core Experience)

#### 5.4.1 Canvas Functionality

- Drag-and-drop clothing items
- Layer-based composition
- Logical constraints (e.g., shoes on feet)
- Accessories supported
- Save, edit, duplicate outfits

#### 5.4.2 Canvas as Source of Truth

Anything on the canvas:

- Can be tried on
- Can be shared
- Can be reconstructed on another user's device

### 5.5 Virtual Try-On (Normalized)

#### 5.5.1 Try-On Rules

- Uses upright, normalized user image
- Does not preserve original pose
- Prioritizes clarity and realism over pose fidelity

#### 5.5.2 Technology Stack (Master Design)

**Fashn.ai API Integration:**
- Professional virtual try-on service
- Smart cost control with caching system
- Hash-based duplicate prevention (BodyID + ItemIDs)
- Credit consumption model for API calls

**Gateway Architecture:**
- Supabase Edge Function (try-on-gateway)
- Cache-first approach to minimize costs
- User credit validation before API calls
- Result storage in Supabase Storage

#### 5.5.3 Pose Variants

- Predefined pose library
- User taps to re-render outfit in different pose
- Same outfit, same clothes, different stance

#### 5.5.4 Try-On Inputs

- User base image (body model)
- Outfit canvas layers
- Accessories included
- Pose specification

### 5.6 AI Stylist (Chat Companion)

#### 5.6.1 Personality (Phase-2 MVP)

- Always available
- Conversational
- Action-triggering
- Learns from overrides

#### 5.6.2 Personality (Full Vision)

- Friendly
- Professional
- Supportive
- Feels like your stylist, not a bot

#### 5.6.3 Architecture (Master Design)

**Google ADK Agent Framework:**
- Google Agent Development Kit (ADK) with Python/Cloud Run
- LangChain framework for reasoning and tool use
- RAG queries against user_facts vector table
- Tool-based outfit generation and recommendations

**Level 3 Memory:**
- Persists user facts ("User hates yellow") into user_facts vector table
- Semantic search across user preferences and closet items
- Background creation of outfit payloads

#### 5.6.4 Capabilities

Recommend outfits
Explain why something works
Suggest improvements
Answer contextual questions:

- Occasion
- Weather
- Calendar events
- Trend analysis from IG scraping

**Phase-2 MVP Actions:**
- Try outfit
- Edit canvas
- Add clothes
- Save looks

**Advanced Actions (Future):**
- Search closet with natural language
- Generate outfit from trend recipes
- Personal styling advice based on memory

### 5.7 Recommendations

- Daily recommendations reset once per day
- AI explains reasoning
- Max 2 recommended outfits at a time (for clarity)

### 5.8 Outfit History & Timeline

Track:

- Past outfits
- Planned outfits
- Calendar-based timeline view

Helps avoid repeats
Helps learn user preferences

### 5.9 Sharing & Reconstruction

User can share an outfit blueprint

Receiver's AI:

- Attempts to recreate using their own closet
- Suggests closest alternatives if items missing

## 6. Non-Functional Requirements

### Performance

- Async AI calls
- No blocking UI
- Graceful fallbacks

### Cost Control

- Edge-first processing
- Serverless GPU
- Batch jobs

### Privacy

- Explicit permissions
- On-device preprocessing
- Clear data ownership

## 7. Explicit MVP Exclusions (Phase-3)

❌ Live AR try-on
❌ Real-time camera overlay
❌ Body proportion fitting
❌ 3D avatars
❌ Full fashion marketplace

## 8. Success Metrics (MVP)

- Closet completion rate
- Outfit saves per user
- Try-on usage
- Recommendation acceptance rate
- Weekly active usage

## 9. Product Feeling (Non-Negotiable)

The user should feel like they have their own professional stylist in their pocket, who:

- Knows their clothes
- Understands their taste
- Removes friction
- Builds confidence

## 10. MVP Outcome Definition

Phase-2 MVP is successful if:

- Users build a real closet
- AI recommendations feel personal
- Try-on feels clean and believable
- Users return daily for styling help
