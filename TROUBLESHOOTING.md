# NailScan - Troubleshooting Guide

Common issues and their solutions.

## 🔍 Installation Issues

### Issue: "pnpm: command not found"

**Cause:** pnpm is not installed or not in PATH

**Solution:**
```bash
npm install -g pnpm
```

Then restart your terminal.

---

### Issue: "Cannot find module 'react'"

**Cause:** Dependencies not installed

**Solution:**
```bash
# Clear cache and reinstall
rm -rf node_modules
pnpm store prune
pnpm install
```

---

### Issue: Port 5173 already in use

**Cause:** Another process is using port 5173

**Solution A:** Kill the process
```bash
# Windows
netstat -ano | findstr :5173
taskkill /PID <PID> /F

# Mac/Linux
lsof -ti:5173 | xargs kill -9
```

**Solution B:** Use different port
```bash
pnpm dev --port 3000
```

---

## 🤖 AI Model Issues

### Issue: Model not loading

**Error:** `Failed to fetch model.json`

**Checklist:**
- [ ] Model files in `public/models/nailscan/`
- [ ] Files named correctly (`model.json`, `*.bin`)
- [ ] Dev server is running
- [ ] Path in code matches file location

**Solution:**
```bash
# Check file structure
ls -R public/models/

# Should see:
# public/models/nailscan/
#   ├── model.json
#   └── group1-shard1of1.bin
```

---

### Issue: "WebGL not supported"

**Error:** `WebGL backend not available`

**Solution:**

1. **Check browser support:**
   - Visit: https://get.webgl.org/
   - Should see spinning cube

2. **Enable WebGL in browser:**
   
   **Chrome/Edge:**
   1. Go to `chrome://settings`
   2. Search "hardware acceleration"
   3. Enable it
   4. Restart browser

   **Firefox:**
   1. Go to `about:config`
   2. Search `webgl.disabled`
   3. Set to `false`

3. **Use CPU backend (slower):**
   ```typescript
   await tf.setBackend('cpu');
   ```

---

### Issue: Predictions are random/incorrect

**Cause:** Model preprocessing doesn't match training

**Solution:**

Check preprocessing pipeline:
```typescript
// Training (Python)
img = img / 255.0  # Normalize [0, 1]

// Inference (JavaScript) - MUST MATCH
const tensor = tf.browser.fromPixels(imageElement)
  .toFloat()
  .div(255.0);  // Same normalization!
```

**Common mistakes:**
- ❌ Wrong image size (224x224 vs 256x256)
- ❌ Wrong normalization (0-1 vs -1 to 1)
- ❌ RGB vs BGR order
- ❌ Different resize methods

---

### Issue: Out of memory

**Error:** `WebGL out of memory`

**Solution:**

```typescript
// Wrap predictions in scope
async predict(image: HTMLImageElement) {
  return tf.tidy(() => {
    // All tensors created here are auto-cleaned
    const tensor = tf.browser.fromPixels(image);
    // ... processing
    return result;
  });
}

// Manually dispose large tensors
const tensor = tf.zeros([1000, 1000, 1000]);
// ... use tensor
tensor.dispose(); // Free memory
```

---

## 🌐 API Integration Issues

### Issue: CORS error

**Error:** `Access to fetch at 'http://localhost:8000' has been blocked by CORS`

**Solution (Flask):**
```python
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Or specific origins:
CORS(app, resources={
    r"/api/*": {"origins": ["http://localhost:5173"]}
})
```

**Solution (Express):**
```javascript
const cors = require('cors');
app.use(cors());
```

---

### Issue: API returns 404

**Cause:** Wrong endpoint URL

**Solution:**

1. **Check API is running:**
   ```bash
   curl http://localhost:8000/api/predict
   ```

2. **Verify endpoint in code:**
   ```typescript
   const aiService = new AIModelAPIService(
     'http://localhost:8000/api/predict'  // Check this!
   );
   ```

3. **Check Flask route:**
   ```python
   @app.route('/api/predict', methods=['POST'])  # Must match!
   def predict():
       # ...
   ```

---

### Issue: API timeout

**Error:** `Failed to fetch` or `Network request failed`

**Solutions:**

1. **Increase timeout:**
   ```typescript
   const response = await fetch(endpoint, {
     method: 'POST',
     body: formData,
     signal: AbortSignal.timeout(30000) // 30 seconds
   });
   ```

2. **Check API performance:**
   - Model inference might be slow
   - Use smaller model
   - Add caching

3. **Check network:**
   ```bash
   # Test API directly
   curl -X POST -F "image=@test.jpg" http://localhost:8000/api/predict
   ```

---

## 📱 Camera Issues

### Issue: Camera not working

**Error:** `NotAllowedError: Permission denied`

**Solution:**

1. **Check browser permissions:**
   - Chrome: Click camera icon 🎥 in address bar → Select "Allow"
   - Firefox: Click info icon → Permissions → Camera → Allow
   - Safari: Safari menu → Settings for This Website → Camera → Allow

2. **The app now auto-handles this:**
   - When camera permission is denied, it automatically opens the file picker
   - You can upload an image instead
   - A helpful error message appears with instructions

3. **Use HTTPS (Required for camera):**
   - Camera API requires HTTPS (except localhost)
   - If deploying, ensure SSL certificate is active
   - For local testing: use `http://localhost:5173` (works without HTTPS)

4. **Fallback to file input:**
   Already implemented! If camera fails, click "Upload Image" button instead.

5. **Enable camera in browser settings:**
   
   **Chrome:**
   - Go to `chrome://settings/content/camera`
   - Ensure "Sites can ask to use your camera" is enabled
   - Check if your site is not blocked
   
   **Firefox:**
   - Go to `about:preferences#privacy`
   - Scroll to Permissions → Camera
   - Ensure not blocked

---

### Issue: Camera shows black screen

**Cause:** Using wrong camera or constraints

**Solution:**

```typescript
// Try different constraints
const mediaStream = await navigator.mediaDevices.getUserMedia({
  video: {
    facingMode: { ideal: 'environment' },  // Prefer back camera
    width: { ideal: 1920 },
    height: { ideal: 1080 }
  }
});
```

**List available cameras:**
```typescript
const devices = await navigator.mediaDevices.enumerateDevices();
const cameras = devices.filter(d => d.kind === 'videoinput');
console.log('Available cameras:', cameras);
```

---

## 🎨 UI/Display Issues

### Issue: App looks broken on mobile

**Cause:** Missing viewport meta tag

**Solution:**

Check `index.html` has:
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

---

### Issue: Tailwind styles not working

**Cause:** Tailwind not configured properly

**Solution:**

1. **Check Tailwind is installed:**
   ```bash
   pnpm list tailwindcss
   ```

2. **Check vite.config.ts:**
   ```typescript
   import tailwindcss from '@tailwindcss/vite'
   
   export default defineConfig({
     plugins: [react(), tailwindcss()]
   })
   ```

3. **Check theme.css is imported:**
   ```typescript
   // main.tsx
   import './styles/theme.css'
   ```

---

### Issue: Fonts not loading

**Cause:** Font import path wrong

**Solution:**

Check `fonts.css`:
```css
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
```

Make sure it's imported in `main.tsx`:
```typescript
import './styles/fonts.css'
```

---

## 🔐 Environment Variables Issues

### Issue: Environment variables undefined

**Error:** `import.meta.env.VITE_API_KEY is undefined`

**Solutions:**

1. **Create .env file:**
   ```bash
   cp .env.example .env
   ```

2. **Use correct prefix:**
   ```bash
   # ✅ Correct (Vite requires VITE_ prefix)
   VITE_API_KEY=abc123
   
   # ❌ Wrong
   API_KEY=abc123
   ```

3. **Restart dev server:**
   ```bash
   # Stop server (Ctrl+C)
   pnpm dev
   ```

4. **Check access:**
   ```typescript
   console.log('API Key:', import.meta.env.VITE_API_KEY);
   ```

---

## 🚀 Build/Deploy Issues

### Issue: Build fails

**Error:** `Error: Could not resolve './components/...'`

**Solution:**

1. **Check imports:**
   ```typescript
   // ✅ Correct
   import { HomeScreen } from './components/HomeScreen';
   
   // ❌ Wrong (case sensitive!)
   import { HomeScreen } from './components/homescreen';
   ```

2. **Clear cache:**
   ```bash
   rm -rf node_modules/.vite
   pnpm build
   ```

---

### Issue: Production build is huge

**Cause:** Model files included in bundle

**Solution:**

1. **Keep models in public folder** (not src)

2. **Quantize model:**
   ```bash
   tensorflowjs_converter \
     --input_format=keras \
     --quantization_bytes 1 \  # Reduce size
     ./model.h5 \
     ./public/models/nailscan
   ```

3. **Check bundle size:**
   ```bash
   pnpm build
   # Check dist/ folder size
   du -sh dist/
   ```

---

### Issue: 404 errors after deploy

**Cause:** React Router needs server configuration

**Solution:**

**Vercel:** Create `vercel.json`:
```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

**Netlify:** Create `public/_redirects`:
```
/*  /index.html  200
```

**Nginx:**
```nginx
location / {
  try_files $uri $uri/ /index.html;
}
```

---

## 🐛 Runtime Errors

### Issue: "Uncaught ReferenceError: process is not defined"

**Cause:** Node.js code in browser

**Solution:**

Add to `vite.config.ts`:
```typescript
export default defineConfig({
  define: {
    'process.env': {}
  }
})
```

---

### Issue: Images not loading in production

**Cause:** Wrong path after build

**Solution:**

```typescript
// ❌ Wrong
import img from '../images/photo.jpg'

// ✅ Correct (use public folder)
// Place in: public/images/photo.jpg
<img src="/images/photo.jpg" />
```

---

## 🔧 Development Issues

### Issue: Hot reload not working

**Cause:** File watcher limit reached (Linux)

**Solution:**
```bash
# Increase file watch limit
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

---

### Issue: TypeScript errors

**Error:** `Property 'x' does not exist on type 'y'`

**Solution:**

1. **Check types:**
   ```typescript
   // Define proper interface
   interface Result {
     condition: string;
     confidence: number;
   }
   
   const result: Result = await aiService.predict(img);
   ```

2. **Use type assertion (temporary):**
   ```typescript
   const result = await aiService.predict(img) as any;
   ```

---

## 📊 Performance Issues

### Issue: App is slow

**Solutions:**

1. **Use React DevTools Profiler:**
   - Install React DevTools extension
   - Record performance
   - Find slow components

2. **Lazy load components:**
   ```typescript
   const ResultsScreen = lazy(() => import('./ResultsScreen'));
   ```

3. **Memoize expensive calculations:**
   ```typescript
   const expensiveValue = useMemo(() => {
     return heavyCalculation(data);
   }, [data]);
   ```

4. **Use smaller AI model:**
   - Switch from EfficientNetV2-L to MobileNetV3
   - Reduce image input size

---

## 🆘 Getting More Help

### Enable Debug Mode

```typescript
// In CaptureScreen.tsx
const handleAnalyze = async () => {
  console.log('🔍 Debug: Starting analysis');
  console.log('📷 Image:', capturedImage);
  
  try {
    const result = await aiService.predict(img);
    console.log('✅ Result:', JSON.stringify(result, null, 2));
  } catch (error) {
    console.error('❌ Error details:', error);
    console.trace(); // Show full stack trace
  }
};
```

### Check Browser Console

1. Open DevTools: Press `F12`
2. Go to **Console** tab
3. Look for red errors
4. Copy error message for debugging

### Check Network Tab

1. Open DevTools: Press `F12`
2. Go to **Network** tab
3. Filter by **XHR** or **Fetch**
4. Check API requests:
   - Status code (should be 200)
   - Response data
   - Request payload

---

## 📚 Resources

- [Vite Troubleshooting](https://vitejs.dev/guide/troubleshooting.html)
- [React DevTools](https://react.dev/learn/react-developer-tools)
- [TensorFlow.js Guide](https://www.tensorflow.org/js/guide)
- [Chrome DevTools](https://developer.chrome.com/docs/devtools/)

---

## Still Stuck?

1. **Check browser console** for errors
2. **Search error message** on Google/Stack Overflow
3. **Review main README.md** for setup steps
4. **Check QUICKSTART.md** for AI integration
5. **Verify all prerequisites** are installed

---

## Common Error Messages

| Error | Likely Cause | Quick Fix |
|-------|--------------|-----------|
| `Cannot find module 'X'` | Missing dependency | `pnpm install` |
| `WebGL out of memory` | Memory leak | Use `tf.tidy()` |
| `CORS error` | API not configured | Add CORS headers |
| `Permission denied` | Camera blocked | Check browser permissions |
| `404 Not Found` | Wrong path | Check file paths |
| `Failed to fetch` | API down | Check API is running |
| `Port already in use` | Port occupied | Use different port |
| `Module not found` | Wrong import path | Check relative paths |

---

✅ **Problem Solved?** Great! Get back to building amazing features!