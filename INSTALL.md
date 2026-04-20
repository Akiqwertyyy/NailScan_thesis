# Installation Guide - Step by Step

This guide will walk you through installing NailScan on your computer using Visual Studio Code.

## 📋 Prerequisites Checklist

Before starting, you need:

- [ ] **Windows 10/11, macOS 10.14+, or Linux**
- [ ] **At least 2GB free disk space**
- [ ] **Internet connection**
- [ ] **Administrator access** (to install software)

---

## Step 1: Install Node.js

Node.js is required to run the development server.

### Windows:
1. Go to https://nodejs.org/
2. Click the **"LTS"** (Long Term Support) green button
3. Download the `.msi` installer
4. Run the installer
5. Click **Next** through all steps (keep default settings)
6. Click **Install** and wait
7. Click **Finish**

### macOS:
1. Go to https://nodejs.org/
2. Click the **"LTS"** green button
3. Download the `.pkg` installer
4. Open the downloaded file
5. Follow installation wizard
6. Enter your password when prompted

### Linux (Ubuntu/Debian):
```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Verify Installation:
1. Open **Terminal** (macOS/Linux) or **Command Prompt** (Windows)
   - Windows: Press `Win + R`, type `cmd`, press Enter
   - macOS: Press `Cmd + Space`, type `terminal`, press Enter
   
2. Type this command and press Enter:
   ```bash
   node --version
   ```
   
3. You should see something like: `v20.11.0`

✅ Node.js is installed!

---

## Step 2: Install pnpm (Package Manager)

pnpm is faster and more efficient than npm.

### All Platforms:

Open Terminal/Command Prompt and run:

```bash
npm install -g pnpm
```

Wait for installation to complete (may take 1-2 minutes).

### Verify Installation:
```bash
pnpm --version
```

You should see something like: `8.15.0`

✅ pnpm is installed!

---

## Step 3: Install Visual Studio Code

VS Code is the code editor we'll use.

### Windows:
1. Go to https://code.visualstudio.com/
2. Click **"Download for Windows"**
3. Run the downloaded `VSCodeSetup.exe`
4. Accept the agreement
5. Click **Next** through all steps
6. **Important:** Check ✅ "Add to PATH"
7. Click **Install**
8. Click **Finish**

### macOS:
1. Go to https://code.visualstudio.com/
2. Click **"Download for Mac"**
3. Open the downloaded `.zip` file
4. Drag **Visual Studio Code** to **Applications** folder
5. Open **Applications** and launch **Visual Studio Code**

### Linux (Ubuntu/Debian):
```bash
sudo apt update
sudo apt install code
```

✅ VS Code is installed!

---

## Step 4: Get the NailScan Project

### Option A: Download as ZIP (Easiest)

1. Download the project ZIP file
2. Right-click the ZIP → **Extract All**
3. Choose a location (e.g., `Desktop` or `Documents`)
4. Remember this location!

### Option B: Clone from Git (If available)

```bash
cd Desktop
git clone https://github.com/your-repo/nailscan.git
cd nailscan
```

---

## Step 5: Open Project in VS Code

### Method 1: From VS Code

1. Open **Visual Studio Code**
2. Click **File** → **Open Folder** (Windows/Linux)
   - OR **File** → **Open** (macOS)
3. Navigate to your `nailscan` folder
4. Click **Select Folder**

### Method 2: From File Explorer

1. Navigate to your `nailscan` folder
2. Right-click in the folder
3. Select **"Open with Code"** (if available)

---

## Step 6: Install Project Dependencies

Now we'll install all the packages NailScan needs.

1. **Open Terminal in VS Code:**
   - Press `` Ctrl + ` `` (backtick key, usually below Esc)
   - OR: Click **Terminal** → **New Terminal** in top menu

2. **You should see something like:**
   ```
   PS C:\Users\YourName\Desktop\nailscan>
   ```

3. **Run this command:**
   ```bash
   pnpm install
   ```

4. **Wait for installation** (2-5 minutes)
   - You'll see lots of text scrolling
   - Wait for it to finish
   - You should see: `✓ packages installed`

✅ Dependencies installed!

---

## Step 7: Start the Development Server

Let's run the app!

1. **In the VS Code terminal, run:**
   ```bash
   pnpm dev
   ```

2. **You should see:**
   ```
   VITE v5.1.0  ready in 500 ms

   ➜  Local:   http://localhost:5173/
   ➜  Network: use --host to expose
   ➜  press h + enter to show help
   ```

3. **Open your web browser**

4. **Go to:** http://localhost:5173/

✅ NailScan is running!

---

## Step 8: View on Mobile Dimensions

For the best experience, view as a mobile device:

### Chrome/Edge:

1. Press `F12` to open DevTools
2. Press `Ctrl+Shift+M` (Windows) or `Cmd+Shift+M` (Mac)
3. Click the device dropdown at the top
4. Select **iPhone 13** or **iPhone 14 Pro**
5. OR: Select **Responsive** and set:
   - Width: `390px`
   - Height: `844px`

### Firefox:

1. Press `F12` to open DevTools
2. Click the **phone/tablet icon** in top right
3. Select **iPhone 13**

---

## 🎉 Success! NailScan is Running

You should now see the NailScan splash screen!

### What You'll See:
1. **Splash Screen** with finger icon and "NailScan" logo
2. After 2 seconds → **Home Screen**
3. Three tabs at bottom: **Diagnose**, **History**, **About**

---

## Common Installation Issues

### Issue 1: "pnpm: command not found"

**Fix:**
```bash
npm install -g pnpm
```

Close and reopen your terminal.

---

### Issue 2: "Port 5173 is already in use"

**Fix:**

Another app is using port 5173.

**Option A:** Stop other apps and try again

**Option B:** Use different port:
```bash
pnpm dev --port 3000
```
Then open: http://localhost:3000/

---

### Issue 3: Package installation fails

**Fix:**

Clear cache and retry:
```bash
pnpm store prune
pnpm install
```

---

### Issue 4: VS Code terminal not opening

**Fix:**

Use external terminal:

**Windows:**
1. Press `Win + R`
2. Type `cmd`
3. Navigate: `cd Desktop\nailscan`
4. Run: `pnpm dev`

**macOS:**
1. Open Terminal
2. Navigate: `cd ~/Desktop/nailscan`
3. Run: `pnpm dev`

---

## Next Steps

### For Developers:

1. **Explore the code:**
   - `src/app/App.tsx` - Main app file
   - `src/app/components/` - All screen components
   - `src/styles/theme.css` - Color and design system

2. **Make changes:**
   - Edit any file
   - Save (`Ctrl+S` or `Cmd+S`)
   - App automatically reloads in browser!

3. **Add AI model:**
   - See `QUICKSTART.md` for AI integration guide
   - See `README.md` for detailed docs

### For Testing:

1. **Navigate through the app:**
   - Click **"Start Diagnosis"** on home screen
   - Try **"Take Photo"** or **"Upload Image"**
   - View **History** tab
   - Read **About** tab

2. **Test features:**
   - Delete individual history items
   - Clear all history
   - Check responsive design

---

## Stopping the Server

When you're done:

1. Go to VS Code terminal
2. Press `Ctrl+C`
3. You'll see: `Shutdown complete`

---

## Restarting Later

To run NailScan again:

1. Open VS Code
2. Open the `nailscan` folder
3. Open Terminal (`` Ctrl + ` ``)
4. Run: `pnpm dev`
5. Open: http://localhost:5173/

---

## Building for Production

When ready to deploy:

```bash
pnpm build
```

This creates a `dist/` folder with optimized files you can upload to any web host.

---

## Getting Help

### Check the logs:
- Look at VS Code terminal for error messages
- Check browser Console (F12 → Console tab)

### Common commands:
```bash
pnpm dev          # Start development server
pnpm build        # Build for production
pnpm preview      # Preview production build
pnpm lint         # Check code quality
```

---

## System Requirements

**Minimum:**
- 4GB RAM
- Modern browser (Chrome 90+, Firefox 88+, Safari 14+, Edge 90+)
- Screen resolution: 1280x720 or higher

**Recommended:**
- 8GB RAM
- Chrome or Edge (best performance)
- 1920x1080 or higher

---

## 📁 Project Structure

After installation, your folder should look like:

```
nailscan/
├── node_modules/        (installed packages - don't edit)
├── public/              (static files, images)
├── src/
│   ├── app/
│   │   ├── components/  (screen components)
│   │   ├── App.tsx      (main app)
│   │   └── main.tsx     (entry point)
│   └── styles/          (CSS files)
├── .env                 (environment variables - create if needed)
├── package.json         (project info)
├── README.md            (main documentation)
├── QUICKSTART.md        (AI integration guide)
└── INSTALL.md           (this file)
```

---

## ✅ Installation Complete!

You've successfully installed NailScan! 🎉

**What's Next?**
- Explore the app interface
- Read `QUICKSTART.md` to add AI functionality
- Read `README.md` for detailed features
- Start customizing!

**Questions?**
- Check browser console for errors (F12)
- Review error messages in VS Code terminal
- Ensure all prerequisites are installed

Happy developing! 🚀
