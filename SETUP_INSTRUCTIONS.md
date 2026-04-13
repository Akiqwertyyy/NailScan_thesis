# NailScan Flutter - Complete Setup Instructions

## 🎯 Quick Start Guide

Follow these steps to set up and run the NailScan Flutter application on your local machine.

---

## Step 1: Install Flutter

### Windows
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Extract to `C:\src\flutter`
3. Add to PATH: `C:\src\flutter\bin`
4. Run `flutter doctor` in terminal

### macOS
```bash
# Install using Homebrew
brew install flutter

# OR download from flutter.dev and extract
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

### Linux
```bash
# Download and extract
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.x.x-stable.tar.xz
tar xf flutter_linux_3.x.x-stable.tar.xz

# Add to PATH in ~/.bashrc
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

---

## Step 2: Install Android Studio (for Android Development)

1. Download from [developer.android.com/studio](https://developer.android.com/studio)
2. Install Android Studio
3. Open Android Studio → SDK Manager → Install:
   - Android SDK Platform (API 34)
   - Android SDK Build-Tools
   - Android Emulator
4. Install Flutter plugin:
   - Android Studio → Settings → Plugins → Search "Flutter" → Install
   - Also install Dart plugin

---

## Step 3: Install Xcode (for iOS Development - Mac Only)

```bash
# Install Xcode from App Store
# Then install command line tools:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# Install CocoaPods
sudo gem install cocoapods
```

---

## Step 4: Create New Flutter Project

```bash
# Create project
flutter create nailscan
cd nailscan

# Verify creation
flutter doctor
```

---

## Step 5: Copy Project Files

### Option A: Manual Copy

1. **Copy all Dart files:**
   ```
   From flutter_app/lib/ → To nailscan/lib/
   ```

2. **Replace pubspec.yaml:**
   ```
   From flutter_app/pubspec.yaml → To nailscan/pubspec.yaml
   ```

3. **Create asset directories:**
   ```bash
   mkdir -p assets/images
   mkdir -p fonts
   ```

### Option B: Using Terminal (Mac/Linux)

```bash
# From the directory containing flutter_app/
cp -r flutter_app/lib/* nailscan/lib/
cp flutter_app/pubspec.yaml nailscan/pubspec.yaml
mkdir -p nailscan/assets/images
mkdir -p nailscan/fonts
```

### Option C: Using Command Prompt (Windows)

```cmd
xcopy flutter_app\lib nailscan\lib /E /I /Y
copy flutter_app\pubspec.yaml nailscan\pubspec.yaml
mkdir nailscan\assets\images
mkdir nailscan\fonts
```

---

## Step 6: Add Assets

### Add Logo Image
1. Create or find a logo image (PNG format recommended)
2. Save as `assets/images/logo.png`
3. OR use placeholder - the app will show a fingerprint icon

### Add Inter Font
1. Download Inter font from [Google Fonts](https://fonts.google.com/specimen/Inter)
2. Extract the font files
3. Copy these files to `fonts/` directory:
   - `Inter-Regular.ttf`
   - `Inter-Medium.ttf`
   - `Inter-SemiBold.ttf`
   - `Inter-Bold.ttf`

**OR** use default system font by commenting out font family in `pubspec.yaml`

---

## Step 7: Install Dependencies

```bash
cd nailscan

# Get all packages
flutter pub get

# Verify no errors
flutter pub outdated
```

---

## Step 8: Configure Platform-Specific Settings

### Android Configuration

**File: `android/app/build.gradle`**

```gradle
android {
    namespace "com.yourcompany.nailscan"
    compileSdkVersion 34
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    defaultConfig {
        applicationId "com.yourcompany.nailscan"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}
```

**File: `android/app/src/main/AndroidManifest.xml`**

Add before `<application>`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

### iOS Configuration (Mac Only)

**File: `ios/Runner/Info.plist`**

Add before `</dict>`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to capture nail images for analysis</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select nail images</string>
<key>NSMicrophoneUsageDescription</key>
<string>Camera requires microphone access</string>
```

---

## Step 9: Set Up Emulator/Device

### Android Emulator

```bash
# List available emulators
flutter emulators

# Create new emulator (if none exists)
# Open Android Studio → AVD Manager → Create Virtual Device
# Choose Pixel 5 or similar
# Download System Image (API 34)
# Create and start emulator

# OR use command line
flutter emulators --launch <emulator_id>
```

### Physical Android Device

1. Enable Developer Options on your device:
   - Settings → About Phone → Tap "Build Number" 7 times
2. Enable USB Debugging:
   - Settings → Developer Options → USB Debugging
3. Connect device via USB
4. Run `flutter devices` to verify

### iOS Simulator (Mac Only)

```bash
# List available simulators
flutter emulators

# Launch iPhone simulator
open -a Simulator

# OR
flutter emulators --launch apple_ios_simulator
```

### Physical iOS Device (Mac Only)

1. Connect iPhone/iPad via USB
2. Trust computer on device
3. In Xcode: Signing & Capabilities → Select your team
4. Run `flutter devices` to verify

---

## Step 10: Run the App

```bash
# Check connected devices
flutter devices

# Run on first available device
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release

# Run with hot reload (default in debug mode)
flutter run
# Press 'r' to hot reload
# Press 'R' to hot restart
# Press 'q' to quit
```

---

## Step 11: Verify Everything Works

### Check Splash Screen
- App should show animated splash for 2.5 seconds
- Logo should fade in
- Three bouncing dots at bottom

### Check Home Screen
- "Start Diagnosis" button should be visible
- Bottom navigation with 3 tabs
- Blue gradient background

### Check Camera
- Tap "Start Diagnosis"
- Tap "Take Photo" - camera should open
- Tap "Upload Image" - gallery should open
- Select/capture an image
- Image should display with border

### Check Analysis
- Tap "Analyze Image"
- Processing screen with spinner (2 seconds)
- Results screen with diagnosis

### Check Navigation
- Tap "History" in bottom nav - should show sample history
- Tap "About" in bottom nav - should show app info
- All navigation should be smooth

---

## 🐛 Troubleshooting

### Issue: "Target of URI doesn't exist"

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Camera permission denied

**Android Solution:**
- Check `AndroidManifest.xml` has camera permissions
- Go to device Settings → Apps → NailScan → Permissions → Enable Camera

**iOS Solution:**
- Check `Info.plist` has usage descriptions
- Device Settings → NailScan → Enable Camera

### Issue: Image picker not working

**Solution:**
```bash
# Upgrade dependencies
flutter pub upgrade

# Clear cache
flutter clean
rm -rf build/
flutter pub get
flutter run
```

### Issue: Font not displaying

**Solution:**
1. Verify font files are in `fonts/` directory
2. Check `pubspec.yaml` indentation (YAML is space-sensitive)
3. Run `flutter clean && flutter pub get`
4. Restart app

### Issue: Build fails on iOS

**Solution:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

### Issue: Hot reload not working

**Solution:**
- Press `R` (capital R) for hot restart instead of `r`
- Or restart the app completely

---

## 📊 Testing the App

### Run All Tests
```bash
flutter test
```

### Check Code Quality
```bash
flutter analyze
```

### Format Code
```bash
flutter format lib/
```

---

## 🏗️ Building for Production

### Android APK (Debug)
```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

### Android APK (Release)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (For Google Play)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (Mac Only)
```bash
flutter build ios --release

# Then open in Xcode for signing and upload:
open ios/Runner.xcworkspace
```

---

## 📱 Installing on Device

### Android - Install APK
```bash
# Via USB
flutter install

# OR manually
adb install build/app/outputs/flutter-apk/app-release.apk

# OR share APK file and install on device
```

### iOS - Install via TestFlight
1. Build in Xcode
2. Archive → Distribute to App Store Connect
3. Submit for TestFlight
4. Invite testers via email

---

## 🎨 Customization

### Change App Name

**Android:** `android/app/src/main/AndroidManifest.xml`
```xml
<application
    android:label="Your App Name"
```

**iOS:** `ios/Runner/Info.plist`
```xml
<key>CFBundleName</key>
<string>Your App Name</string>
```

### Change Package Name

```bash
# Use rename package
flutter pub global activate rename
flutter pub global run rename --bundleId com.yourcompany.yourapp
```

### Change App Icon

1. Create app icon (1024x1024 PNG)
2. Use tool like [appicon.co](https://appicon.co) to generate all sizes
3. Replace icons in:
   - `android/app/src/main/res/mipmap-*/`
   - `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

---

## 🔒 Signing (For Production)

### Android Signing

1. Generate keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>
```

3. Update `android/app/build.gradle`

### iOS Signing

1. Open Xcode
2. Select project → Signing & Capabilities
3. Select your Apple Developer team
4. Enable "Automatically manage signing"

---

## ✅ Final Checklist

- [ ] Flutter installed and `flutter doctor` shows no errors
- [ ] Android Studio or Xcode installed
- [ ] Project created and files copied
- [ ] Assets added (fonts, images)
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Emulator/device connected
- [ ] App runs successfully
- [ ] Camera works
- [ ] Image picker works
- [ ] Navigation works
- [ ] No errors in console

---

## 🎓 Next Steps

1. **Customize branding:** Change colors, fonts, logo
2. **Integrate real AI:** Replace mock data with actual ML model
3. **Add persistence:** Use Hive or SQLite for history
4. **Add authentication:** Firebase Auth or custom backend
5. **Deploy to stores:** Google Play and App Store
6. **Add analytics:** Firebase Analytics or similar
7. **Add crash reporting:** Sentry or Firebase Crashlytics

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Codelabs](https://docs.flutter.dev/codelabs)
- [Dart Language](https://dart.dev/guides)
- [Flutter Widget Catalog](https://docs.flutter.dev/development/ui/widgets)
- [Flutter YouTube Channel](https://www.youtube.com/c/flutterdev)

---

**🎉 Congratulations!** You now have a fully functional Flutter app. Happy coding!
