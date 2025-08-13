#!/bin/bash

echo "🔧 Building Optimized APK..."

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build optimized APK for specific architecture (arm64-v8a is most common)
echo "📱 Building for arm64-v8a (most common architecture)..."
flutter build apk --release --target-platform android-arm64

# Also build universal APK for testing
echo "🌍 Building universal APK for testing..."
flutter build apk --release

echo "✅ Build complete!"
echo "📊 APK sizes:"
echo "   - arm64-v8a: build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"
echo "   - Universal: build/app/outputs/flutter-apk/app-release.apk"

# Show APK sizes
if [ -f "build/app/outputs/flutter-apk/app-arm64-v8a-release.apk" ]; then
    echo "📏 arm64-v8a APK size: $(du -h build/app/outputs/flutter-apk/app-arm64-v8a-release.apk | cut -f1)"
fi

if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "📏 Universal APK size: $(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)"
fi







