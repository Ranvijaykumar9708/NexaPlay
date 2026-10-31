# 🎬 NexaPlay — Smart TV & Mobile Cinema OTT Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State%20Management-Riverpod%203.x-8A2BE2)](https://riverpod.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20MVVM%20%2B%20SOLID-success)](#-architecture--design-patterns)
[![Platforms](https://img.shields.io/badge/Platforms-Android%20TV%20%7C%20Google%20TV%20%7C%20Mobile%20%7C%20Web%20%7C%20macOS-blue)](#-platform-support)
[![Language](https://img.shields.io/badge/Bilingual-English%20%7C%20%E0%A4%B9%E0%A4%BF%E0%A4%A8%E0%A5%8D%E0%A4%A6%E0%A5%80%20%F0%9F%87%AE%F0%9F%87%B3-orange)](#-bilingual-localization)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **GitHub One-Liner Description:**  
> *Production-grade Smart TV & Mobile OTT Cinema Platform built with Flutter, Riverpod, Pure MVVM Clean Architecture, and SOLID principles. Features AI Cinephile mood matcher, synchronized Watch Party with live reactions, IMAX & Studio Master audio controls, multi-angle live sports cam, offline downloads, and native English/हिन्दी bilingual support.*

---

## 🌟 Key Highlights & Exclusive Features

### 1. 📺 Smart TV (D-Pad Remote First) & Mobile Companion
- **Full D-Pad Remote Navigation:** Engineered with custom `TVFocusable` wrappers, reactive scale transforms, neon glow borders, and keyboard listeners (`Arrow Keys`, `Enter`, `Back/Esc`).
- **Responsive Layout Engine:** Fluidly transitions between large TV screens (10-foot UI) and mobile handheld companion experience.
- **On-Screen TV Keyboards:** Custom alphanumeric TV keyboard and secure PIN keypad for remote-only input without touch requirements.

### 2. 🤖 AI Cinephile Mood & Voice Matcher (`AI MATCH`)
- Real-time pulse wave animated voice & mood scanner.
- Instant mood classification:
  - 🔥 *High Adrenaline Action*
  - 😂 *Feel-Good Desi Comedy*
  - 🕵️ *Dark Crime & Purvanchal Thriller*
  - 🧠 *Mythological Sci-Fi & Speculative Fiction*
  - ❤️ *Inspiring Real-Life Journey*
- Returns contextual cinema recommendations with a single click.

### 3. 🍿 NexaPlay Live Watch Party (`PARTY ON`)
- Synchronized streaming room creation with 6-character room codes.
- Floating upward physics-based emoji reactions (`🔥`, `❤️`, `👏`, `😂`, `🤯`, `🇮🇳`).
- Live co-watching participant list with real-time room sync.

### 4. 🎛️ Studio Master & IMAX Enhanced Controls (`MASTER AUDIO`)
- **IMAX Enhanced (1.90:1):** Expanded vertical cinema aspect ratio toggle.
- **Dialogue Booster EQ:** Intelligent speech center-channel booster to hear whispered dialogues over explosions and background scores.
- **Dolby Atmos 7.1 Virtualizer:** Spatial audio surround simulation.
- **Playback Speeds:** 0.75x, 1.0x, 1.25x, 1.5x, 2.0x.
- **Cinema Sleep Timer:** 15m, 30m, 45m, 60m, 120m auto-stop.

### 5. 🏏 Multi-Angle Live Sports Cam (`SPORTS MULTICAM`)
- Instant angle switching for cricket and live matches:
  - 🎥 **Main Broadcast Feed**
  - 🎯 **Stump Cam**
  - 🦅 **Tactical Bird's Eye Cam**
  - ⭐ **Superstar Player Cam**

### 6. 📥 Smart Offline Downloads Manager (`DOWNLOADS`)
- Complete offline download queue and local storage gauge (e.g. `28.5 GB / 128.0 GB`).
- 4K Ultra HD & 1080p quality selection with one-tap removal.
- Persistent local playback simulation.

### 7. 🎟️ NexaPlay Premiere Theatrical Pass (`THEATRICAL PASS`)
- VIP early access pass for day-and-date theatrical releases (e.g., *Jawan*, *Kalki 2898 AD*).
- Gold metallic pass modal with single-tap instant ticket redemption.

### 8. 🌐 Bilingual Indian Localization (English + हिन्दी 🇮🇳)
- Instant one-tap global language toggle in header.
- Complete localization for titles, navigation, metadata, subtitles, and system messages in both English and शुद्ध हिन्दी (e.g. *होम, फ़िल्में, वेब सीरीज़, लाइव टीवी, किड्स ज़ोन*).

### 9. 🔒 Multi-Profile & Parental PIN Gate
- Netflix-style multi-profile selector (Adult & Kids profiles).
- Secure 4-digit PIN gate for switching from Kids mode or accessing mature content (`U/A 16+`, `A`).

### 10. ⚡ X-Ray Trivia & Live Soundtrack
- Real-time Amazon Prime Video-style X-Ray overlay showing:
  - Behind-the-scenes trivia and production notes.
  - Full cast filmography.
  - Soundtrack tracklist with singer & music director credits.

---

## 🏛 Architecture & Design Patterns

NexaPlay strictly follows **Clean Architecture** and **MVVM (Model-View-ViewModel)** decoupled via **SOLID Principles**:

```
lib/
├── core/                         # Core Utilities & Infrastructure
│   ├── localization/             # AppStrings (EN / HI dictionaries) & Locale Engine
│   └── theme/                    # Cinema Obsidian Theme (#090A10), Neon Glows & Typography
│
├── domain/                       # Pure Business Rules & Contracts (Dependency Inversion)
│   └── repositories/             # IContentRepository, IProfileRepository, IWatchlistRepository
│
├── data/                         # Data Layer Implementations
│   ├── repositories/             # ContentRepositoryImpl
│   └── mock_data.dart            # Indian Blockbuster Catalogue & 24x7 Live TV Channels
│
├── models/                       # Domain Entities
│   ├── content_item.dart         # Content Metadata, 4K/HDR/Dolby flags, Trivia, Soundtracks
│   ├── live_channel.dart         # EPG schedules & Live Stream URLs
│   ├── profile.dart              # User profile, PIN locks, Kids flag
│   ├── watch_party.dart          # Watch Party room states & reactions
│   └── download_item.dart        # Offline storage entries
│
├── viewmodels/                   # State Management Layer (Riverpod ViewModels)
│   ├── app_providers.dart        # Locale, Profile, Catalogue, Watchlist, VIP, Playback VM
│   ├── watch_party_viewmodel.dart# Sync rooms & Floating reaction streams
│   ├── download_viewmodel.dart   # Storage allocation & Download jobs
│   └── audio_master_viewmodel.dart # IMAX, Dialogue Booster, Sports multicam state
│
├── presentation/                 # Presentation Layer (UI Components & Views)
│   ├── widgets/
│   │   ├── common/               # TVFocusable, FormatBadge (4K, Dolby), EmptyState
│   │   ├── inputs/               # TVVirtualKeyboard, TVNumKeypad
│   │   ├── navigation/           # AppHeader, MobileBottomBar
│   │   ├── content/              # HeroBanner, MovieCard, ContentRow, LiveChannelCard
│   │   ├── overlays/             # ParentalPinDialog, XRayModal, AiVoiceModal,
│   │   │                         # WatchPartyDialog, AudioMasterDialog, PremierePassSheet, VipPassSheet
│   │   └── player/               # SportsMulticamBar, FloatingReactionsOverlay
│   └── views/                    # LiveTvView, DownloadsView
│
└── screens/                      # Main App Routes & Screen Flows
    ├── splash_screen.dart        # Cinematic animated logo reveal
    ├── onboarding_screen.dart    # 3-step feature highlight
    ├── auth_screen.dart          # TV-friendly login & Instant Guest mode
    ├── profile_screen.dart       # Who's Watching selector
    ├── home_screen.dart          # Curated rows & billboard hero banner
    ├── browse_screen.dart        # Filtered Movies, Series, and Kids collections
    ├── search_screen.dart        # Instant search with TV virtual keyboard
    ├── watchlist_screen.dart     # User watchlist manager
    ├── video_player_screen.dart  # Ultra-immersive video player HUD
    ├── content_details_screen.dart# Deep-dive content view
    └── settings_screen.dart      # App diagnostics & preferences
```

---

## 🇮🇳 Rich Indian & Global Content Catalogue

| Title | Type | Audio / Video Specs | Highlights |
| :--- | :--- | :--- | :--- |
| **Jawan** (जवान) | Movie (Blockbuster) | 4K • Dolby Vision • Atmos | Theatrical Pass, X-Ray trivia, dual-role storyline |
| **Mirzapur: S3** (मिर्ज़ापुर) | Web Series | 4K • HDR10+ • 5.1 Surround | Skip Intro (60s), Purvanchal crime drama |
| **Kalki 2898 AD** | Sci-Fi Epic | 4K • Dolby Vision • Atmos | IMAX Theatrical Pass, Bujji & Ashwatthama trivia |
| **12th Fail** (12वीं फेल) | Inspirational Drama | 1080p Full HD • Stereo | True story of Manoj Kumar Sharma IPS |
| **Panchayat: S3** (पंचायत) | Desi Comedy | 1080p Full HD • Hindi | Phulera village chronicles, Skip Intro |
| **Animal** (एनिमल) | Action Thriller | 4K • Dolby Atmos | High adrenaline score, Soundtracks |
| **Stree 2** (स्त्री 2) | Horror Comedy | 4K • Dolby Vision | Sarkata lore, Chanderi universe |
| **Star Plus HD** | 24x7 Live TV | 1080p 60fps Live Stream | *Anupamaa*, *Yeh Rishta Kya Kehlata Hai* |
| **Sony MAX HD** | 24x7 Live TV | 1080p 60fps Live Stream | Non-stop Bollywood movies |
| **Sports 18 HD** | 24x7 Live Sports | 1080p 60fps Live Stream | Multi-cam cricket coverage |
| **Aaj Tak HD** | 24x7 Live News | 1080p Live Stream | National breaking news coverage |

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.24.x or higher)
- [Dart SDK](https://dart.dev/get-dart) (v3.5.x or higher)
- Google Chrome (for web testing) or an Android TV / Google TV Emulator / Device

### 1. Clone the repository
```bash
git clone https://github.com/your-username/nexaplay.git
cd nexaplay
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run static analysis & test suite
```bash
flutter analyze
flutter test
```

### 4. Run Locally

#### Web (Chrome):
```bash
flutter run -d chrome
```

#### Android TV / Google TV:
```bash
# Connect TV via ADB over Wi-Fi or USB:
adb connect <TV_IP_ADDRESS>:5555
flutter run -d <DEVICE_ID>
```

#### macOS Desktop:
```bash
flutter run -d macos
```

#### Production Web Build:
```bash
flutter build web --no-tree-shake-icons
```

---

## 🎮 TV Remote Keybindings Reference

| Remote / Keyboard Key | Action |
| :--- | :--- |
| `Arrow Keys` (↑, ↓, ←, →) | Navigate focus across cards, buttons, and TV keyboard |
| `Enter` / `OK / Select` | Trigger focused item, play content, open modals |
| `Escape` / `Backspace` | Back / Close active overlay / Exit video player |
| `Space` | Play / Pause video playback |
| `Left Arrow` (in player) | Rewind 10 seconds |
| `Right Arrow` (in player)| Fast-forward 10 seconds |

---

## 🛠 Tech Stack

- **Framework:** Flutter & Dart
- **State Management:** Riverpod 3.x (`ChangeNotifierProvider`, `ProviderScope`)
- **Typography:** Google Fonts (`Outfit`)
- **Video Playback:** `video_player` with fallback simulated stream generator
- **Local Persistence:** `shared_preferences`
- **Design System:** Obsidian Black (`#090A10`), Neon Violet (`#8B5CF6`), Cyber Cyan (`#06B6D4`), Gold VIP (`#F5C518`)

---

## 📄 License
This project is open-source under the [MIT License](LICENSE).
