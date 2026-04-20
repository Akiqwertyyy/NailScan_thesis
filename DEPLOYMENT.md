# NailScan - Deployment Guide

This guide covers deploying your NailScan app to production.

## 📦 Before Deployment

### Checklist:
- [ ] AI model is integrated and tested
- [ ] Environment variables are set up
- [ ] App tested on multiple devices
- [ ] No console errors in production build
- [ ] Images are optimized
- [ ] Performance is acceptable

---

## 🚀 Deployment Options

### Option 1: Vercel (Recommended - Easiest)

**Best for:** Static frontend with/without API routes

#### Step 1: Install Vercel CLI
```bash
npm i -g vercel
```

#### Step 2: Login
```bash
vercel login
```

#### Step 3: Deploy
```bash
# From your project root
vercel

# Follow prompts:
# - Set up and deploy? Yes
# - Which scope? (Select your account)
# - Link to existing project? No
# - Project name? nailscan
# - In which directory? ./
# - Override settings? No
```

#### Step 4: Set Environment Variables

1. Go to https://vercel.com/dashboard
2. Select your project
3. Go to **Settings** → **Environment Variables**
4. Add your variables:
   ```
   VITE_API_ENDPOINT=https://your-api.com/predict
   VITE_GEMINI_API_KEY=your_key_here
   ```

#### Step 5: Deploy Production
```bash
vercel --prod
```

✅ **Your app is live!**

**Custom Domain:**
1. Go to Project Settings → Domains
2. Add your domain
3. Update DNS records as instructed

---

### Option 2: Netlify

**Best for:** Static sites with easy drag-and-drop

#### Method A: Drag & Drop (Easiest)

1. **Build your app:**
   ```bash
   pnpm build
   ```

2. **Go to:** https://app.netlify.com/drop

3. **Drag** your `dist/` folder to the upload area

4. **Done!** Your site is live at `random-name.netlify.app`

#### Method B: Netlify CLI

1. **Install CLI:**
   ```bash
   npm install -g netlify-cli
   ```

2. **Login:**
   ```bash
   netlify login
   ```

3. **Initialize:**
   ```bash
   netlify init
   ```

4. **Deploy:**
   ```bash
   netlify deploy --prod
   ```

#### Set Environment Variables:

1. Go to Site Settings → Build & Deploy → Environment
2. Add variables:
   ```
   VITE_API_ENDPOINT
   VITE_GEMINI_API_KEY
   ```

3. Redeploy:
   ```bash
   netlify deploy --prod
   ```

---

### Option 3: GitHub Pages

**Best for:** Free hosting for public repositories

#### Step 1: Update vite.config.ts

```typescript
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  base: '/nailscan/', // Your repo name
});
```

#### Step 2: Install gh-pages

```bash
pnpm add -D gh-pages
```

#### Step 3: Update package.json

```json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "predeploy": "pnpm build",
    "deploy": "gh-pages -d dist"
  }
}
```

#### Step 4: Deploy

```bash
pnpm run deploy
```

#### Step 5: Enable GitHub Pages

1. Go to your repo on GitHub
2. Settings → Pages
3. Source: Deploy from branch
4. Branch: `gh-pages` → `/ (root)`
5. Save

✅ **Live at:** `https://yourusername.github.io/nailscan/`

---

### Option 4: AWS S3 + CloudFront

**Best for:** Large-scale production deployments

#### Step 1: Build

```bash
pnpm build
```

#### Step 2: Install AWS CLI

```bash
# macOS
brew install awscli

# Windows (download installer)
# https://aws.amazon.com/cli/

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

#### Step 3: Configure AWS

```bash
aws configure
# Enter:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region (e.g., us-east-1)
# - Default output format: json
```

#### Step 4: Create S3 Bucket

```bash
aws s3 mb s3://nailscan-app
```

#### Step 5: Upload

```bash
aws s3 sync dist/ s3://nailscan-app --delete
```

#### Step 6: Enable Static Website Hosting

```bash
aws s3 website s3://nailscan-app --index-document index.html
```

#### Step 7: Make Public

Create `bucket-policy.json`:
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicReadGetObject",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::nailscan-app/*"
  }]
}
```

Apply policy:
```bash
aws s3api put-bucket-policy --bucket nailscan-app --policy file://bucket-policy.json
```

✅ **Live at:** `http://nailscan-app.s3-website-us-east-1.amazonaws.com`

#### Optional: Add CloudFront CDN

1. Go to AWS Console → CloudFront
2. Create Distribution
3. Origin: Your S3 bucket
4. Configure SSL certificate
5. Add custom domain

---

## 🔐 Environment Variables in Production

### Vercel
```bash
vercel env add VITE_API_ENDPOINT
# Enter value when prompted
```

### Netlify
```bash
netlify env:set VITE_API_ENDPOINT "https://api.example.com/predict"
```

### GitHub Pages
⚠️ **Warning:** GitHub Pages is static - don't expose API keys!

Use a backend proxy or serverless functions.

---

## 🤖 Deploying Your AI Model

### Option A: Deploy with Frontend (TensorFlow.js)

1. **Build with model:**
   ```bash
   # Ensure models are in public/models/
   pnpm build
   ```

2. **Deploy normally** - models will be included

⚠️ **Note:** Large models increase bundle size

**Optimization:**
```bash
# Quantize model to reduce size
tensorflowjs_converter \
  --input_format=keras \
  --quantization_bytes 1 \
  ./model.h5 \
  ./public/models/nailscan
```

---

### Option B: Deploy Model as Separate API

#### Using Flask + Heroku

**1. Create Flask API** (`api.py`):
```python
from flask import Flask, request, jsonify
from tensorflow import keras
import numpy as np
from PIL import Image
import io

app = Flask(__name__)
model = keras.models.load_model('model.h5')

@app.route('/api/predict', methods=['POST'])
def predict():
    file = request.files['image']
    img = Image.open(io.BytesIO(file.read())).resize((224, 224))
    img_array = np.array(img) / 255.0
    img_array = np.expand_dims(img_array, axis=0)
    
    predictions = model.predict(img_array)[0]
    labels = ['Onychomycosis', 'Nail Psoriasis', 'Brittle Nails', 'Healthy Nail', 'Unidentified']
    
    return jsonify({
        'predicted_class': labels[np.argmax(predictions)],
        'confidence': float(np.max(predictions)),
        'probabilities': {label: float(prob) for label, prob in zip(labels, predictions)}
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
```

**2. Create requirements.txt:**
```
flask==3.0.0
tensorflow==2.15.0
pillow==10.1.0
numpy==1.24.3
flask-cors==4.0.0
gunicorn==21.2.0
```

**3. Create Procfile:**
```
web: gunicorn api:app
```

**4. Deploy to Heroku:**
```bash
heroku login
heroku create nailscan-api
git add .
git commit -m "Deploy API"
git push heroku main
```

**5. Update Frontend:**
```typescript
const aiService = new AIModelAPIService('https://nailscan-api.herokuapp.com/api/predict');
```

---

### Option C: AWS Lambda (Serverless)

**1. Install Serverless Framework:**
```bash
npm install -g serverless
```

**2. Create handler.py:**
```python
import json
import boto3
import numpy as np

def predict(event, context):
    # Your model inference code
    return {
        'statusCode': 200,
        'body': json.dumps({
            'predicted_class': 'Onychomycosis',
            'confidence': 0.95
        })
    }
```

**3. Create serverless.yml:**
```yaml
service: nailscan-api

provider:
  name: aws
  runtime: python3.9
  region: us-east-1

functions:
  predict:
    handler: handler.predict
    events:
      - http:
          path: api/predict
          method: post
          cors: true
```

**4. Deploy:**
```bash
serverless deploy
```

---

## 📱 Progressive Web App (PWA)

Make NailScan installable on mobile devices!

### Step 1: Create manifest.json

**public/manifest.json:**
```json
{
  "name": "NailScan - AI Nail Health Detection",
  "short_name": "NailScan",
  "description": "AI-powered fingernail disease detection",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#2563EB",
  "orientation": "portrait",
  "icons": [
    {
      "src": "/icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

### Step 2: Add to index.html

```html
<link rel="manifest" href="/manifest.json">
<meta name="theme-color" content="#2563EB">
<link rel="apple-touch-icon" href="/icon-192.png">
```

### Step 3: Create Service Worker

Install plugin:
```bash
pnpm add -D vite-plugin-pwa
```

Update vite.config.ts:
```typescript
import { VitePWA } from 'vite-plugin-pwa';

export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      manifest: {
        name: 'NailScan',
        short_name: 'NailScan',
        theme_color: '#2563EB',
      }
    })
  ]
});
```

✅ **Users can now install NailScan to their home screen!**

---

## 🔒 Security Best Practices

### 1. Environment Variables
- Never commit `.env` to Git
- Use different keys for dev/production
- Rotate API keys regularly

### 2. API Security
```python
# Add rate limiting
from flask_limiter import Limiter

limiter = Limiter(app, key_func=lambda: request.remote_addr)

@app.route('/api/predict', methods=['POST'])
@limiter.limit("10 per minute")
def predict():
    # ...
```

### 3. HTTPS Only
- Always use HTTPS in production
- Enable HSTS headers
- Use secure cookies

### 4. CORS Configuration
```python
from flask_cors import CORS

CORS(app, resources={
    r"/api/*": {
        "origins": ["https://nailscan.com"],
        "methods": ["POST"],
        "allow_headers": ["Content-Type"]
    }
})
```

---

## 📊 Performance Optimization

### 1. Image Optimization
```bash
# Install image optimizer
pnpm add -D vite-plugin-imagemin
```

### 2. Code Splitting
Already handled by Vite!

### 3. Lazy Loading
```typescript
import { lazy, Suspense } from 'react';

const ResultsScreen = lazy(() => import('./ResultsScreen'));

// Use:
<Suspense fallback={<div>Loading...</div>}>
  <ResultsScreen />
</Suspense>
```

### 4. Compression
Most hosts (Vercel, Netlify) auto-compress. For custom servers:

**Nginx:**
```nginx
gzip on;
gzip_types text/plain text/css application/json application/javascript;
```

---

## 📈 Analytics & Monitoring

### Google Analytics

1. **Get tracking ID** from https://analytics.google.com

2. **Add to index.html:**
```html
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

### Sentry (Error Tracking)

```bash
pnpm add @sentry/react
```

```typescript
import * as Sentry from "@sentry/react";

Sentry.init({
  dsn: "your-sentry-dsn",
  environment: "production",
});
```

---

## 🧪 Testing Before Deploy

```bash
# Build production version
pnpm build

# Preview locally
pnpm preview

# Test on mobile:
# 1. Get your local IP: ipconfig (Windows) or ifconfig (Mac/Linux)
# 2. On phone, visit: http://YOUR_IP:4173
```

---

## 📝 Deployment Checklist

- [ ] All features tested
- [ ] No console errors
- [ ] Mobile responsive
- [ ] Fast load time (<3s)
- [ ] AI model works
- [ ] Environment variables set
- [ ] HTTPS enabled
- [ ] Custom domain configured (optional)
- [ ] Analytics added
- [ ] Error tracking enabled
- [ ] SEO metadata added
- [ ] Social sharing images

---

## 🎉 You're Live!

Congratulations! Your NailScan app is deployed!

**Post-Deployment:**
1. Test on multiple devices
2. Monitor error logs
3. Check analytics
4. Gather user feedback
5. Iterate and improve

**Need help?** Check the main README.md for support resources.
