# DripLord

A sophisticated AI-powered wardrobe management and styling application built with Flutter. DripLord combines fashion technology with machine learning to provide personalized outfit recommendations, virtual try-on experiences, and intelligent closet organization.

## 🎯 Product Vision

DripLord aims to be your personal AI stylist, helping you:
- Build and organize your digital wardrobe
- Get AI-powered outfit recommendations based on weather, occasion, and personal style
- Experience virtual try-on with normalized clothing visuals
- Track outfit history and preferences
- Discover new styling possibilities

## 🏗️ Architecture Overview

### Tech Stack
- **Framework**: Flutter (Dart SDK ^3.10.4)
- **State Management**: Riverpod 3.0.3 with code generation
- **Backend**: Supabase (PostgreSQL + Auth + Storage)
- **AI Integration**: Google Generative AI API (implemented)
- **Routing**: GoRouter 17.0.1 with StatefulShellRoute
- **UI Framework**: Custom luxury dual-theme system with glassmorphism

### Project Structure
```
lib/
├── core/                    # Core infrastructure
│   ├── components/         # Reusable UI components
│   ├── constants/          # App constants and dimensions
│   ├── providers/          # Riverpod state providers
│   ├── router/             # Navigation and routing
│   ├── services/           # Business logic services
│   └── theme/              # Design system and themes
├── features/               # Feature modules
│   ├── auth/               # Authentication flows
│   ├── closet/             # Wardrobe management
│   ├── home/               # Daily hub and recommendations
│   ├── onboarding/         # User setup flows
│   ├── outfits/            # Outfit creation and management
│   ├── profile/            # User settings and preferences
│   └── try_on/             # Virtual try-on experiences
└── main.dart               # App entry point
```

## 🚀 Quick Start

### Prerequisites
- Flutter 3.38.5 or higher
- Android SDK (for Android builds)
- Xcode (for iOS builds)
- Supabase project with configured tables

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/codeKobby/driplord.git
cd driplord
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure environment**
   - Set up Supabase credentials in `lib/core/constants/app_constants.dart`
   - Configure OAuth providers (Google, Apple) in Supabase dashboard
   - Add required API keys for weather and AI services

4. **Run the application**
```bash
flutter run
```

## 📱 Features

### Core Features
- **AI-Powered Styling**: Daily outfit recommendations with Gemini AI analysis
- **Virtual Try-On**: Professional canvas with layering controls and composition tools
- **Smart Closet**: AI-assisted wardrobe organization with automated categorization
- **Weather Integration**: Real-time weather-based outfit suggestions
- **Style Learning**: AI-powered clothing detection and tagging system

### Authentication
- Email/password authentication
- Google OAuth integration
- Apple Sign-In support
- Secure session management with Supabase

### Wardrobe Management
- Manual clothing item addition
- AI-powered image analysis and categorization
- Smart outfit composition with drag-and-drop interface
- Outfit history and statistics tracking

## 🔧 Development

### Code Generation
This project uses code generation for Riverpod providers:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting and Analysis
```bash
flutter analyze
flutter format lib/
```

### Testing
```bash
flutter test
flutter test --coverage
```

## 📋 Requirements

### System Requirements
- **Flutter**: 3.38.5+
- **Dart**: 3.10.4+
- **Android**: API 21+ (Android 5.0)
- **iOS**: 12.0+
- **Windows**: Visual Studio 2022 (for Windows builds)

### Dependencies
See `pubspec.yaml` for complete dependency list including:
- Supabase Flutter SDK for backend services
- Google Generative AI for AI features
- Image picker for photo capture
- GoRouter for navigation
- Lucide Icons for UI consistency

## 🌐 API Integration

### Supabase Configuration
1. Create Supabase project
2. Run schema from `supabase_schema.sql`
3. Configure authentication providers
4. Set environment variables in app constants

### External APIs
- **Weather API**: Google Weather API or OpenWeatherMap
- **AI Services**: Google Generative AI API
- **OAuth**: Google Cloud Console and Apple Developer Portal

## 🎨 Design System

DripLord implements a luxury dual-theme design system:
- **Dark Theme**: Midnight blue backgrounds with white accents
- **Light Theme**: Warm cream with black text
- **Glassmorphism**: Frosted glass effects throughout
- **Typography**: Inter font family with editorial hierarchy
- **Components**: Consistent button, card, and navigation patterns

See `docs/design_system.md` for complete design specifications.

## 📖 Documentation

- [Design System](docs/design_system.md) - Complete UI/UX guidelines
- [App Architecture](docs/app_routing_architecture.md) - Navigation and routing
- [Product Requirements](docs/drip_lord_product_requirements_document_prd.md) - Full product vision
- [MVP Specification](docs/drip_lord_phase2_mvp_prd.md) - Current implementation scope
- [OAuth Setup](docs/oauth_setup_guide.md) - Authentication configuration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run linting and formatting
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Check the documentation in the `docs/` folder
- Review the implementation in `lib/` for examples
- Create an issue for bug reports or feature requests

## 🙏 Acknowledgments

- Flutter team for the excellent framework
- Supabase for the backend infrastructure
- Google for AI and weather APIs
- Lucide Icons for beautiful iconography
