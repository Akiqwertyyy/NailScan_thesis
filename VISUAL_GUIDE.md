# 🎨 NailScan - Visual Feature Guide

A visual walkthrough of all screens and features in the NailScan app.

---

## 📱 App Overview

**Platform:** Mobile-first web application  
**Dimensions:** 390px × 844px (iPhone 13)  
**Design:** Medical minimal with blue (#2563EB) accents  
**Font:** Inter  

---

## 🎬 Screen Flow

```
Splash Screen (2s)
      ↓
Home Dashboard
      ↓
Capture Screen ──→ Camera View
      ↓
Processing Screen (AI Analysis)
      ↓
Results Screen
      ↓
History Screen ←→ About Screen
```

---

## 📺 Screen Descriptions

### 1. Splash Screen (Entry Point)

**Purpose:** App branding and loading  
**Duration:** 2 seconds  
**Elements:**
- 🎯 Finger icon in blue gradient rounded square (112×112px)
- 📱 "NailScan" title (36px, bold)
- 💬 "AI-Powered Nail Health Detection" subtitle
- 💙 Three animated loading dots (blue)
- 🎨 Gradient background (blue-50 to white)

**User Action:** None (auto-transitions)

---

### 2. Home Dashboard

**Purpose:** Main entry point for diagnosis  
**Elements:**

**Header Section:**
- 👆 Finger logo (96×96px, blue gradient)
- 📱 "NailScan" title
- 💬 "AI-Powered Nail Health Analysis" subtitle

**Info Cards (3 gradient cards):**
1. **"5 Detection Types"** 
   - Icon: Layers (medical conditions)
   - Gradient: Blue to purple
   - Text: "Comprehensive nail health analysis"

2. **"AI-Powered"**
   - Icon: Brain (AI/ML)
   - Gradient: Purple to pink
   - Text: "Advanced neural network analysis"

3. **"Instant Results"**
   - Icon: Zap (speed)
   - Gradient: Pink to orange
   - Text: "Get results in seconds"

**Main Action:**
- 🔵 Large "Start Diagnosis" button
- Gradient: Blue-600 to blue-700
- Shadow: Large drop shadow
- Full width with rounded corners

**Bottom Navigation:**
- 🏠 Diagnose (active - blue)
- 📜 History (gray)
- ℹ️ About (gray)

---

### 3. Capture Screen

**Purpose:** Take or upload nail photo  
**Elements:**

**Header:**
- ← Back button
- "Capture Nail Image" title (centered)

**Instructions:**
- 💬 "Ensure proper lighting and full nail visibility for best results"

**Image Area:**
- Large square placeholder (max 100% width, aspect ratio 1:1)
- Dashed border (blue-200)
- 📷 Camera icon when empty
- Captured image preview when filled
- Blue border (blue-600) when image selected

**Action Buttons (No Image):**
- 📷 "Take Photo" (primary - blue gradient)
- 🖼️ "Upload Image" (secondary - white with blue border)

**Action Buttons (With Image):**
- ✅ "Analyze Image" (primary - blue gradient)
- 🔄 "Retake Photo" (secondary - white)

**Special:** Opens native camera or file picker

---

### 4. Camera View (Modal)

**Purpose:** Live camera preview for photo capture  
**Elements:**

**Overlay:**
- ✕ Close button (top right, white)
- "Take Photo" title (top center, white)
- Black/transparent background

**Camera Preview:**
- Full screen video feed
- Real-time camera stream
- Environment (back) camera preferred

**Capture Button:**
- ⚪ Large circular white button (80×80px)
- Gray border (12px)
- Centered at bottom
- Hover: Blue border

**User Action:** Tap button to capture frame

---

### 5. Processing Screen

**Purpose:** Show AI analysis in progress  
**Elements:**

**Header:**
- ← Back button
- "Processing" title

**Main Content (Centered):**
- 🔄 Animated spinner (72×72px, blue)
- Multiple concentric circles
- Rotation animation

**Status Text:**
- "Analyzing Your Nail Image" (bold, 24px)
- "Our AI is examining your nail for potential conditions..." (gray)

**Analysis Steps (3 animated cards):**
1. 🎨 "Analyzing Color Patterns"
2. 📐 "Detecting Shape Anomalies"
3. 🔍 "Examining Texture Features"

**Features:**
- Cards fade in one by one
- Check marks appear when "complete"
- Smooth opacity transitions
- Auto-transitions to results (2-3s)

---

### 6. Results Screen

**Purpose:** Display AI diagnosis results  
**Elements:**

**Header:**
- ← Back button
- "Diagnosis Results" title

**Result Card (Large):**
- 🎯 Condition icon/emoji
- Condition name (28px, bold)
- Confidence score badge (e.g., "94.5%")
- Color-coded border:
  - 🔴 Red: Disease detected
  - 🟢 Green: Healthy
  - ⚪ Gray: Unidentified
- Gradient background matching type

**Confidence Score:**
- Large percentage (48px)
- Circular progress indicator
- Color matches condition type

**Details Section:**
- 📊 "Analysis Details" heading
- Detailed description of condition
- Symptoms/characteristics
- Background: White card with blue border

**Other Predictions (Optional):**
- "Other Possible Conditions"
- List of 2-4 alternatives with percentages
- Smaller cards, gray styling

**Recommendations Card:**
- 💡 Light bulb icon
- "Recommended Actions"
- Medical advice (e.g., "Consult a dermatologist")
- Yellow/amber background

**Action Buttons:**
- 🏠 "Back to Home" (primary)
- 💾 "Save to History" (secondary) - auto-saves on load

**Footer:**
- ⚠️ Disclaimer: "This is not a medical diagnosis"
- Small gray text

---

### 7. History Screen

**Purpose:** View past scan results  
**Elements:**

**Header:**
- "Scan History" title (centered)
- No back button (nav tab)

**History Items (Scrollable List):**

Each item shows:
- 🩺 Condition name (18px, bold)
- 📅 Date (e.g., "Feb 18, 2026")
- 🎯 Confidence badge (e.g., "98.5%")
- 💬 Brief message about condition
- 🗑️ Delete button (top right, red trash icon)

**Color Coding:**
- 🔴 Disease: Red gradient card
- 🟢 Healthy: Green gradient card
- ⚪ Unidentified: Gray gradient card

**Action Button (When items exist):**
- 🗑️ "Clear All History" (red gradient, bottom)
- Confirmation modal before clearing

**Empty State (No history):**
- 📜 History icon (gray, 80×80px)
- "No History Yet" title
- "Your scan history will appear here" subtitle
- Centered vertically

**Confirmation Modal:**
- "Clear All History?" title
- Count of items (e.g., "5 scans")
- Warning: "This action cannot be undone"
- Two buttons:
  - "Cancel" (gray)
  - "Clear All" (red gradient)

**Bottom Navigation:**
- 🏠 Diagnose (gray)
- 📜 History (active - blue)
- ℹ️ About (gray)

---

### 8. About Screen

**Purpose:** App information and education  
**Elements:**

**Header:**
- "About" title (centered)

**App Info Card (Top):**
- 👆 Finger logo (80×80px)
- "NailScan" title (24px)
- "Version 1.0.0" (gray)
- Centered design

**Section: What is NailScan?**
- White card with blue border
- Description paragraph
- Purpose and functionality

**Section: Detectable Conditions**
- White card
- 5 conditions listed:
  1. 🔵 Onychomycosis (Fungal Infection)
  2. 🔵 Nail Psoriasis
  3. 🔵 Brittle Nails
  4. 🟢 Healthy Nails
  5. ⚪ Unidentified (Out of Scope)
- Colored dots indicate type

**Section: How It Works**
- White card
- 3 numbered steps with blue badges:
  1. 📷 Capture photo
  2. 🤖 AI analyzes
  3. 📊 Get results
- Each step has icon and description

**Disclaimer Card (Important):**
- 🚨 Alert icon (blue)
- Blue gradient background
- "Important Notice" heading (blue)
- Medical disclaimer text
- Border: Blue-300 (2px)

**Footer:**
- "Last Updated: February 2026"
- "Powered by EfficientNetV2-L" (small, gray)

**Bottom Navigation:**
- 🏠 Diagnose (gray)
- 📜 History (gray)
- ℹ️ About (active - blue)

---

## 🎨 Design System

### Colors:

**Primary:**
- Blue-600: `#2563EB` (main brand color)
- Blue-700: `#1d4ed8` (darker shade)
- Blue-50: `#EFF6FF` (light background)

**Condition Types:**
- Red-50 to Red-200: Disease conditions
- Green-50 to Green-200: Healthy nails
- Gray-50 to Gray-300: Unidentified

**Gradients:**
- Primary: `from-[#2563EB] to-[#1d4ed8]`
- Cards: `from-blue-50 to-white`
- Red: `from-red-500 to-red-600`

### Typography:

**Font Family:** Inter (Google Fonts)

**Sizes:**
- H1: 32-36px (Splash, Home)
- H2: 24-28px (Results condition name)
- H3: 20-24px (Section headers)
- Body: 16px (standard text)
- Small: 14px (captions)
- Tiny: 12px (footer notes)

**Weights:**
- Regular: 400
- Medium: 500
- Semibold: 600
- Bold: 700

### Spacing:

**Padding:**
- Screen edges: 24px (1.5rem)
- Cards: 20-24px
- Buttons: 16px vertical, 24px horizontal

**Margins:**
- Between sections: 24-32px
- Between cards: 16px

**Border Radius:**
- Small: 8px
- Medium: 12px
- Large: 16px
- XL: 24px
- Buttons: 16-24px

### Shadows:

**Cards:**
```css
shadow-sm: 0 1px 2px rgba(0,0,0,0.05)
shadow-md: 0 4px 6px rgba(0,0,0,0.07)
shadow-lg: 0 10px 15px rgba(0,0,0,0.1)
shadow-xl: 0 20px 25px rgba(0,0,0,0.15)
```

---

## 🎭 Animations

### Splash Screen:
- Loading dots: Bounce animation (150ms delay each)
- Duration: 2 seconds total

### Processing Screen:
- Spinner: 360° rotation (2s infinite)
- Cards: Fade in sequentially (0.3s each)
- Check marks: Scale in (0.2s)

### Buttons:
- Hover: Scale 1.02, shadow increase
- Active: Scale 0.98
- Transition: 200ms ease

### Navigation:
- Tab switch: 300ms color transition
- Icon change: 200ms ease

### History Delete:
- Item removal: Fade out + slide left (300ms)
- Modal: Fade in background, scale up content

---

## 🔢 Component Counts

- **Total Screens:** 8
- **Navigation Tabs:** 3
- **Info Cards (Home):** 3
- **Action Buttons:** 2-3 per screen
- **History Items:** 5 (demo data)
- **Detectable Conditions:** 5
- **Processing Steps:** 3

---

## 📊 Interaction Flows

### Happy Path (New User):
```
1. Open app → Splash (2s)
2. See Home → Tap "Start Diagnosis"
3. Capture Screen → Tap "Take Photo"
4. Camera opens → Capture
5. Image preview → Tap "Analyze"
6. Processing (2s) → See results
7. Results → Tap "Back to Home"
8. Check History tab → See saved scan
```

### Delete History:
```
1. Go to History tab
2. Tap trash icon on item → Item deleted
   OR
2. Tap "Clear All" → Modal appears
3. Confirm → All history cleared
4. See empty state
```

---

## 🎯 User Experience Features

### Accessibility:
- High contrast colors
- Large tap targets (44×44px minimum)
- Clear labels and icons
- Screen reader compatible

### Feedback:
- Loading indicators
- Success/error states
- Confirmation modals
- Progress animations

### Error Handling:
- Camera permission denied → Falls back to file upload
- No image selected → Button disabled
- Failed analysis → Error message + retry

---

## 📱 Responsive Behavior

**Target Device:** iPhone 13 (390×844px)

**Works on:**
- iPhone SE to iPhone 14 Pro Max
- Android devices (similar sizes)
- Tablets (with letterboxing)

**Not optimized for:**
- Desktop (>768px) - will show mobile view centered
- Very small screens (<360px)

---

## 🎨 Sample Color Codes

```css
/* Primary Blues */
--blue-50: #eff6ff;
--blue-100: #dbeafe;
--blue-200: #bfdbfe;
--blue-600: #2563eb;  /* Main brand */
--blue-700: #1d4ed8;

/* Condition Colors */
--red-50: #fef2f2;
--red-100: #fee2e2;
--red-500: #ef4444;

--green-50: #f0fdf4;
--green-100: #dcfce7;
--green-500: #22c55e;

--gray-50: #f9fafb;
--gray-100: #f3f4f6;
--gray-400: #9ca3af;

/* Text */
--gray-900: #111827;  /* Main text */
--gray-600: #4b5563;  /* Secondary text */
--gray-500: #6b7280;  /* Muted text */
```

---

## ✅ Feature Checklist

- [x] Splash screen with branding
- [x] Home dashboard with info cards
- [x] Camera capture functionality
- [x] File upload support
- [x] Real-time camera preview
- [x] AI processing animation
- [x] Results display with confidence
- [x] History tracking
- [x] Individual item deletion
- [x] Clear all history
- [x] Confirmation modals
- [x] Bottom navigation
- [x] About screen with info
- [x] Medical disclaimer
- [x] Color-coded conditions
- [x] Smooth animations
- [x] Responsive design
- [x] Empty states
- [x] Loading states

---

This visual guide can be used for:
- 📊 Presentations
- 👥 Team onboarding
- 📱 User testing
- 🎨 Design reviews
- 📝 Documentation
- 🚀 Investor demos

---

**Pro Tip:** Open the app in browser DevTools (F12) → Device Mode → iPhone 13 to see exactly what's described here!
