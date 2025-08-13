@echo off
echo 🔧 Building Optimized APK...

REM Clean previous builds
flutter clean

REM Get dependencies
flutter pub get

REM Build optimized APK for specific architecture (arm64-v8a is most common)
echo 📱 Building for arm64-v8a (most common architecture)...
flutter build apk --release --target-platform android-arm64

REM Also build universal APK for testing
echo 🌍 Building universal APK for testing...
flutter build apk --release

echo ✅ Build complete!
echo 📊 APK sizes:
echo    - arm64-v8a: build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
echo    - Universal: build/app/outputs/flutter-apk/app-release.apk

pause









