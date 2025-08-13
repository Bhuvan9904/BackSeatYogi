# 🧘‍♀️ BackSeatYogi

A minimalist wellness companion app for mindful travel. Transform your daily commute into a peaceful meditation journey with guided practices, ambient music, and mindful reflection tools.

![BackSeatYogi Banner](assets/images/banner.png)

## ✨ Features

### 🎵 **Audio Meditation**
- **Curated Lo-Fi Collection**: 25+ ambient tracks for relaxation
- **Background Audio Playback**: Seamless audio experience during travel
- **Audio Controls**: Play, pause, skip, and volume control
- **Offline Access**: All audio files included in the app

### 🧘‍♂️ **Guided Practices**
- **Meditation Sessions**: Structured practices for different durations
- **Breathing Exercises**: Guided breathing techniques
- **Mindful Moments**: Quick 1-5 minute practices
- **Practice Player**: Dedicated screen for immersive sessions

### 📱 **Core Features**
- **Home Dashboard**: Quick access to all features
- **Streak Tracking**: Build consistent meditation habits
- **Travel Logs**: Record your mindful journey experiences
- **Reflection Journal**: Capture thoughts and insights
- **Alarm System**: Set meditation reminders
- **Settings**: Customize your experience

### 🎯 **Wellness Tools**
- **Badge System**: Earn achievements for consistency
- **Progress Tracking**: Monitor your meditation journey
- **Responsive Design**: Works on all screen sizes
- **Dark/Light Theme**: Comfortable viewing in any environment

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.8.1)
- Dart SDK
- Android Studio / VS Code
- Android SDK (for Android builds)
- Xcode (for iOS builds, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Bhuvan9904/BackSeatYogi.git
   cd BackSeatYogi
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive models** (if needed)
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screenshots

### Main Screens
- **Home Screen**: Dashboard with quick access to features
- **Practice Player**: Immersive meditation experience
- **Travel Logs**: Record and reflect on your journey
- **Streak Tracker**: Monitor your consistency
- **Settings**: Customize app preferences

## 🏗️ Project Structure

```
lib/
├── app/                    # App configuration and theme
├── core/                   # Core services and utilities
│   ├── constants/         # App constants and configuration
│   ├── services/          # Business logic services
│   └── utils/             # Utility functions
├── data/                  # Data layer
│   ├── models/            # Data models and entities
│   └── repositories/      # Data repositories
├── domain/                # Domain layer
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business use cases
├── presentation/          # UI layer
│   ├── navigation/        # App routing
│   ├── screens/           # App screens
│   └── widgets/           # Reusable UI components
└── providers/             # State management
```

## 🛠️ Tech Stack

### **Frontend**
- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **Provider**: State management
- **Material Design**: UI components

### **Storage & Data**
- **Hive**: Local database
- **Shared Preferences**: Settings storage
- **Path Provider**: File system access

### **Audio & Media**
- **Just Audio**: Audio playback
- **Audio Service**: Background audio
- **Flutter Local Notifications**: Push notifications

### **Development Tools**
- **Build Runner**: Code generation
- **Flutter Lints**: Code quality
- **Hive Generator**: Database code generation

## 📦 Dependencies

### Core Dependencies
```yaml
provider: ^6.1.1          # State management
hive: ^2.2.3              # Local database
just_audio: ^0.9.36       # Audio playback
flutter_svg: ^2.0.9       # SVG support
intl: ^0.19.0             # Internationalization
flutter_local_notifications: ^17.2.3  # Notifications
```

## 🎨 Design Philosophy

BackSeatYogi follows a **minimalist design approach** with:
- **Clean Interface**: Uncluttered, focused user experience
- **Calming Colors**: Soothing color palette for relaxation
- **Responsive Layout**: Adapts to different screen sizes
- **Accessibility**: Inclusive design for all users

## 🔧 Configuration

### Audio Files
- Location: `assets/audio/386_Music/`
- Format: MP3
- Size: Optimized for mobile devices
- License: Royalty-free music collection

### Build Configuration
- **Android**: Configured for API level 21+
- **iOS**: Supports iOS 12.0+
- **Web**: Responsive web design
- **Desktop**: Windows, macOS, Linux support

## 🚀 Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Audio Credits**: 386 Music for the ambient tracks
- **Icons**: Material Design Icons
- **Community**: Flutter and Dart communities

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/Bhuvan9904/BackSeatYogi/issues)
- **Email**: chbhuvi111@gmail.com (Personal)
- **LinkedIn**: [Ch Bhuvan Kumar](https://linkedin.com/in/ch-bhuvan-kumar)

## 🎯 Roadmap

- [ ] **Social Features**: Share achievements with friends
- [ ] **Cloud Sync**: Backup data to cloud storage
- [ ] **Custom Audio**: Upload personal meditation tracks
- [ ] **Analytics**: Detailed progress insights
- [ ] **Offline Mode**: Enhanced offline functionality
- [ ] **Wearable Integration**: Smartwatch support

---

**Made with ❤️ by [Bhuvan9904](https://github.com/Bhuvan9904)**

*Transform your commute into a mindful journey* 🚗🧘‍♀️✨
