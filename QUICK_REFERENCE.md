# NailScan Flutter - Quick Reference Card

## 🚀 Fast Setup (5 Minutes)

```bash
# 1. Create project
flutter create nailscan
cd nailscan

# 2. Copy files (from parent directory)
cp -r ../flutter_app/lib/* lib/
cp ../flutter_app/pubspec.yaml pubspec.yaml

# 3. Install dependencies
flutter pub get

# 4. Run app
flutter run
```

---

## 📱 Common Commands

### Development
```bash
flutter run                    # Run in debug mode
flutter run --release          # Run in release mode
flutter run -d <device-id>     # Run on specific device
```

### Hot Reload
```
r      # Hot reload (fast)
R      # Hot restart (slower, full restart)
q      # Quit
```

### Build
```bash
flutter build apk              # Android APK
flutter build appbundle        # Android App Bundle
flutter build ios              # iOS (Mac only)
```

### Maintenance
```bash
flutter clean                  # Clean build files
flutter pub get                # Get dependencies
flutter pub upgrade            # Upgrade dependencies
flutter doctor                 # Check setup
flutter devices                # List devices
flutter analyze                # Check code quality
flutter test                   # Run tests
```

---

## 📂 File Structure Quick Guide

```
lib/
├── main.dart                  # Start here - app entry
├── screens/                   # All screen files
│   ├── splash_screen.dart     # First screen (2.5s)
│   ├── home_screen.dart       # Main dashboard
│   ├── capture_screen.dart    # Camera/gallery
│   ├── processing_screen.dart # Loading animation
│   ├── result_screen.dart     # Results display
│   ├── history_screen.dart    # Scan history
│   └── about_screen.dart      # App info
├── models/                    # Data structures
│   ├── diagnosis_result.dart  # Result model
│   └── history_item.dart      # History model
└── widgets/                   # Reusable components
    └── bottom_nav_bar.dart    # Navigation bar
```

---

## 🎨 Color Palette

```dart
// Primary Colors
Color(0xFF2563EB)  // Blue - primary actions
Color(0xFF1D4ED8)  // Blue - secondary

// Background
Color(0xFFEFF6FF)  // Light blue background
Colors.white       // White cards/containers

// Text Colors
Color(0xFF111827)  // Dark - headings
Color(0xFF6B7280)  // Medium - body text
Color(0xFF9CA3AF)  // Light - secondary text

// Status Colors
Color(0xFF16A34A)  // Green - healthy/success
Color(0xFFEAB308)  // Yellow - moderate/warning
Color(0xFFDC2626)  // Red - disease/danger
Color(0xFF6B7280)  // Gray - unidentified
```

---

## 🔧 Platform Setup

### Android Permissions
**File:** `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### iOS Permissions
**File:** `ios/Runner/Info.plist`
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access for nail scanning</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access for image selection</string>
```

---

## 📊 Screen Navigation Flow

```
Splash (2.5s auto)
    ↓
Home Screen
    ├── [Start Diagnosis] → Capture Screen
    ├── [History Tab] → History Screen
    └── [About Tab] → About Screen

Capture Screen
    ├── [Take Photo] → Camera
    ├── [Upload Image] → Gallery
    └── [Analyze] → Processing (2s) → Result

Result Screen
    └── [Scan Again] → Home Screen
```

---

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| "Target of URI doesn't exist" | `flutter clean && flutter pub get` |
| Camera not working | Check permissions in manifest/plist |
| Build failed | `flutter clean` then `flutter run` |
| Font not showing | Check fonts/ directory and pubspec.yaml |
| Hot reload stopped | Press `R` (capital) for hot restart |
| Gradle error | Update `android/app/build.gradle` minSdk to 21 |

---

## 📝 Customization Quick Edits

### Change App Name
```dart
// Android: android/app/src/main/AndroidManifest.xml
android:label="Your App Name"

// iOS: ios/Runner/Info.plist
<key>CFBundleName</key>
<string>Your App Name</string>
```

### Change Primary Color
```dart
// lib/main.dart
primaryColor: const Color(0xFFYOURCOLOR),
```

### Change Logo
```dart
// Replace icon in splash_screen.dart and home_screen.dart
Icon(Icons.your_icon, ...)
// OR use image:
Image.asset('assets/images/your_logo.png')
```

---

## 🔑 Important Files to Edit

| What to Change | File to Edit |
|----------------|--------------|
| App colors | `lib/main.dart` (theme) |
| App name | `AndroidManifest.xml`, `Info.plist` |
| Logo/icon | `splash_screen.dart`, `home_screen.dart` |
| Mock data | `result_screen.dart` (_results list) |
| Dependencies | `pubspec.yaml` |
| Permissions | `AndroidManifest.xml`, `Info.plist` |

---

## 📦 Key Dependencies

```yaml
image_picker: ^1.0.7    # Camera + gallery
camera: ^0.10.5+9       # Camera control
http: ^1.2.0            # API calls
shared_preferences      # Local storage
intl                    # Date formatting
```

---

## ✅ Testing Checklist

- [ ] App launches without errors
- [ ] Splash screen shows (2.5s)
- [ ] Home screen displays correctly
- [ ] "Start Diagnosis" button works
- [ ] Camera opens (permissions granted)
- [ ] Gallery opens
- [ ] Image displays after selection
- [ ] "Analyze" triggers processing
- [ ] Results screen shows diagnosis
- [ ] Bottom navigation works (all 3 tabs)
- [ ] History shows items
- [ ] Delete buttons work
- [ ] About screen displays

---

## 🚢 Pre-Release Checklist

- [ ] Change app name
- [ ] Change package identifier
- [ ] Add custom app icon
- [ ] Replace logo placeholder
- [ ] Remove mock data
- [ ] Add real AI integration
- [ ] Test on real devices
- [ ] Add error logging
- [ ] Set up analytics
- [ ] Create privacy policy
- [ ] Update version numbers
- [ ] Sign app (Android keystore/iOS cert)
- [ ] Test release build
- [ ] Prepare store listings

---

## 💡 Pro Tips

1. **Use Hot Reload:** Save time - press `r` instead of restarting
2. **Check Console:** Errors appear in terminal where you ran `flutter run`
3. **Use DevTools:** `flutter pub global activate devtools` then `flutter pub global run devtools`
4. **Format Code:** `flutter format lib/` keeps code clean
5. **Widget Inspector:** Press `i` in terminal to enable widget inspection
6. **Performance:** Press `p` to show performance overlay

---

## 📱 Device Testing

### Emulator
```bash
# List available
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_id>

# Run app
flutter run
```

### Physical Device
```bash
# Check connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

---

## 🎓 Key Dart/Flutter Concepts

### StatelessWidget
- No internal state
- Only depends on input parameters
- Examples: Splash, Processing screens

### StatefulWidget
- Has mutable state
- Can update UI with `setState()`
- Examples: Capture, Result, History screens

### Navigation
```dart
// Navigate to screen
setState(() {
  _currentScreen = 'capture';
});
```

### Styling
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
  ),
)
```

---

## 🔗 Helpful Links

- **Docs:** https://docs.flutter.dev
- **Packages:** https://pub.dev
- **Samples:** https://flutter.github.io/samples/
- **Codelabs:** https://docs.flutter.dev/codelabs
- **YouTube:** https://youtube.com/c/flutterdev

---

## 💾 Version Control

```bash
# Initialize git
git init
git add .
git commit -m "Initial Flutter NailScan app"

# .gitignore (auto-created by Flutter)
# Already ignores: build/, .dart_tool/, *.iml, etc.
```

---

## 🎯 Next Features to Add

1. **Persistent Storage** - Save history to database
2. **Authentication** - User accounts
3. **Real AI** - Integrate actual ML model
4. **Sharing** - Share results
5. **Dark Mode** - Theme toggle
6. **Localization** - Multi-language
7. **Animations** - Hero animations
8. **Cloud Sync** - Backup to cloud
9. **PDF Export** - Generate reports
10. **Notifications** - Scan reminders

---

**📌 Quick Access:**
- Full setup: `/flutter_app/SETUP_INSTRUCTIONS.md`
- Documentation: `/flutter_app/README.md`
- Project summary: `/FLUTTER_PROJECT_SUMMARY.md`

---

**✨ You're ready to build!** Keep this reference handy while developing.
