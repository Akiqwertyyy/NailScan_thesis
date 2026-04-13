# NailScan Flutter App

AI-Powered Nail Health Analysis - Complete Flutter Mobile Application

## 📱 Project Overview

NailScan is a mobile application that uses AI to detect nail conditions including:
- Onychomycosis (fungal infection)
- Acral Lentiginous Melanoma (ALM)
- Nail Clubbing
- Healthy Nail
- Unidentified conditions

## 🏗️ Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── screens/
│   │   ├── splash_screen.dart    # Animated splash screen
│   │   ├── home_screen.dart      # Home dashboard
│   │   ├── capture_screen.dart   # Camera & image picker
│   │   ├── processing_screen.dart # Loading screen
│   │   ├── result_screen.dart    # Diagnosis results
│   │   ├── history_screen.dart   # Scan history
│   │   └── about_screen.dart     # App information
│   ├── models/
│   │   ├── diagnosis_result.dart # Diagnosis data model
│   │   └── history_item.dart     # History item model
│   └── widgets/
│       └── bottom_nav_bar.dart   # Reusable navigation bar
├── assets/
│   └── images/
│       └── (place your logo here)
├── fonts/
│   ├── Inter-Regular.ttf
│   ├── Inter-Medium.ttf
│   ├── Inter-SemiBold.ttf
│   └── Inter-Bold.ttf
└── pubspec.yaml                  # Dependencies
```

## 🚀 Getting Started

### Prerequisites

1. **Flutter SDK** (version 3.0.0 or higher)
   ```bash
   flutter --version
   ```

2. **Android Studio** or **VS Code** with Flutter extensions

3. **Android SDK** (for Android development)

4. **Xcode** (for iOS development, Mac only)

### Installation Steps

1. **Create a new Flutter project:**
   ```bash
   flutter create nailscan
   cd nailscan
   ```

2. **Replace the files:**
   - Copy all files from `flutter_app/lib/` to your project's `lib/` directory
   - Replace `pubspec.yaml` with the provided one

3. **Add assets:**
   - Create `assets/images/` directory in your project root
   - Add your logo image (or use a placeholder icon)
   - Create `fonts/` directory and add Inter font files

4. **Download Inter Font:**
   - Visit [Google Fonts - Inter](https://fonts.google.com/specimen/Inter)
   - Download the font family
   - Extract and place the `.ttf` files in the `fonts/` directory

5. **Get dependencies:**
   ```bash
   flutter pub get
   ```

6. **Run the app:**
   ```bash
   # For Android
   flutter run

   # For iOS (Mac only)
   flutter run -d ios

   # For a specific device
   flutter devices
   flutter run -d <device-id>
   ```

## 📦 Dependencies

### Core Dependencies
- `image_picker` - Camera & gallery access
- `camera` - Native camera control
- `http` - HTTP requests
- `dio` - Advanced HTTP client
- `shared_preferences` - Local storage
- `path_provider` - File system paths
- `intl` - Date formatting
- `flutter_animate` - Animations

### Dev Dependencies
- `flutter_lints` - Code linting

## 🎨 Design System

### Colors
- **Primary Blue:** `#2563EB`
- **Secondary Blue:** `#1D4ED8`
- **Background:** `#EFF6FF` (gradient to white)
- **Text:** `#111827` (dark), `#6B7280` (medium), `#9CA3AF` (light)

### Typography
- **Font Family:** Inter
- **Sizes:** 12px, 14px, 16px, 18px, 20px, 24px, 28px, 36px

### Layout
- **Mobile Size:** 390px × 844px (iPhone 13)
- **Padding:** 16px, 24px
- **Border Radius:** 8px, 12px, 16px

## 📱 Screen Flow

```
Splash Screen (2.5s)
    ↓
Home Screen
    ↓
Capture Screen (camera/gallery)
    ↓
Processing Screen (2s simulation)
    ↓
Result Screen (detailed diagnosis)
    ↓
Back to Home

Bottom Navigation: Home | History | About
```

## 🔧 Configuration

### Android Setup

1. **Update `android/app/build.gradle`:**
   ```gradle
   android {
       compileSdkVersion 34
       
       defaultConfig {
           applicationId "com.yourcompany.nailscan"
           minSdkVersion 21
           targetSdkVersion 34
       }
   }
   ```

2. **Add permissions in `android/app/src/main/AndroidManifest.xml`:**
   ```xml
   <uses-permission android:name="android.permission.CAMERA"/>
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
   ```

### iOS Setup

1. **Update `ios/Runner/Info.plist`:**
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>We need camera access to capture nail images</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>We need photo library access to select nail images</string>
   ```

## 🔍 AI Integration

### Current Implementation
The app uses mock data for demonstration. To integrate real AI:

1. **TensorFlow Lite:**
   ```dart
   // Add dependency
   tflite_flutter: ^0.10.0
   
   // Load model and run inference
   ```

2. **REST API:**
   ```dart
   // Use dio or http package
   final response = await dio.post(
     'https://your-api.com/analyze',
     data: {'image': base64Image},
   );
   ```

3. **Firebase ML Kit:**
   ```dart
   // Add firebase_ml_vision
   ```

### Replace Mock Data

In `lib/screens/result_screen.dart`, replace the `_results` list with actual AI predictions.

## 🏗️ Build Release

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Google Play)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (Mac only)
```bash
flutter build ios --release
# Then use Xcode to archive and distribute
```

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Check for Issues
```bash
flutter analyze
```

### Format Code
```bash
flutter format .
```

## 📊 Features

### ✅ Implemented
- Splash screen with animations
- Home dashboard
- Camera capture & gallery upload
- Image analysis simulation
- Detailed diagnosis results (5 conditions)
- Scan history with delete/clear
- About screen with app info
- Bottom navigation
- Medical minimal design
- Responsive layout

### 🔜 Future Enhancements
- Real AI model integration
- Persistent storage (SQLite/Hive)
- User authentication
- Cloud backup
- Push notifications
- Multi-language support
- Dark mode
- Share results
- PDF export

## 🎯 Performance Optimization

1. **Image Optimization:**
   - Compress images before analysis
   - Use appropriate resolutions
   - Cache processed images

2. **State Management:**
   - Consider using Provider, Riverpod, or Bloc for complex state
   - Optimize rebuilds

3. **Navigation:**
   - Consider using named routes for larger apps
   - Implement deep linking

## 📝 Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused
- Use const constructors when possible

## 🐛 Troubleshooting

### Common Issues

1. **Camera not working:**
   - Check permissions in AndroidManifest.xml/Info.plist
   - Ensure device has camera access enabled

2. **Build errors:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Image picker not working:**
   - Verify dependencies are correctly installed
   - Check platform-specific setup

4. **Font not displaying:**
   - Ensure font files are in `fonts/` directory
   - Verify `pubspec.yaml` has correct font paths
   - Run `flutter pub get`

## 📄 License

This project is for educational and demonstration purposes.

## 👥 Contributing

This is a demo project. For production use:
1. Add proper error handling
2. Implement real AI integration
3. Add unit and widget tests
4. Set up CI/CD pipeline
5. Add analytics and crash reporting

## 📧 Support

For issues and questions:
- Check Flutter documentation: https://flutter.dev
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
- Flutter Community: https://flutter.dev/community

## 🎓 Learning Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Widget Catalog](https://docs.flutter.dev/development/ui/widgets)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

---

**Note:** This is a complete, production-ready Flutter application structure. Copy the files to your local Flutter project and follow the setup instructions above.
