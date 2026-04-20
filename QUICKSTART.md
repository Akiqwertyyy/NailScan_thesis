# NailScan - Quick Start Guide for AI Integration

This guide will help you integrate your trained AI model into NailScan in just a few steps.

## 🎯 Choose Your Integration Method

### Method 1: TensorFlow.js (Best for Browser)
✅ **Use if:** Your model is trained in TensorFlow/Keras  
✅ **Pros:** Runs entirely in browser, no server needed, fast inference  
✅ **Cons:** Model size affects load time  

### Method 2: REST API (Most Flexible)
✅ **Use if:** You have a Python backend or use cloud services  
✅ **Pros:** Easy to deploy, works with any model format, scalable  
✅ **Cons:** Requires internet connection, API hosting  

### Method 3: ONNX Runtime
✅ **Use if:** Your model is in PyTorch or ONNX format  
✅ **Pros:** Cross-platform, good performance  
✅ **Cons:** Slightly larger bundle size  

### Method 4: Cloud AI Services (Easiest)
✅ **Use if:** You want to use Google Gemini, OpenAI Vision, etc.  
✅ **Pros:** No model training needed, pre-trained AI  
✅ **Cons:** Costs money, less control, requires API key  

---

## 🚀 Quick Setup (5 Minutes)

### Step 1: Install NailScan

```bash
# Clone/download the project
cd nailscan

# Install dependencies
pnpm install

# Start dev server
pnpm dev
```

Open http://localhost:5173 in your browser.

---

### Step 2: Choose Your AI Integration

#### Option A: TensorFlow.js (Recommended)

**1. Install TensorFlow.js:**
```bash
pnpm add @tensorflow/tfjs
```

**2. Convert your Keras model:**
```bash
# In your Python environment
pip install tensorflowjs

# Convert model
tensorflowjs_converter \
  --input_format=keras \
  ./your_model.h5 \
  ./public/models/nailscan
```

**3. Place model files:**
```
nailscan/
└── public/
    └── models/
        └── nailscan/
            ├── model.json
            └── group1-shard1of1.bin
```

**4. Update CaptureScreen.tsx:**

Uncomment these lines:
```typescript
// Line 6: Uncomment
import { TensorFlowModelService } from './AIModelService';

// Line 23: Uncomment
const aiService = new TensorFlowModelService();

// Line 30-31: Uncomment
loadAIModel();
```

**5. Update AIModelService.tsx:**

Uncomment the TensorFlow section (lines ~40-160) and at the bottom:
```typescript
export default TensorFlowModelService;
```

✅ **Done!** Your model is now integrated.

---

#### Option B: REST API (Custom Backend)

**1. Create a Python Flask API:**

```python
# api.py
from flask import Flask, request, jsonify
from tensorflow import keras
import numpy as np
from PIL import Image
import io

app = Flask(__name__)
model = keras.models.load_model('your_model.h5')

@app.route('/api/predict', methods=['POST'])
def predict():
    # Get image from request
    file = request.files['image']
    img = Image.open(io.BytesIO(file.read()))
    
    # Preprocess
    img = img.resize((224, 224))
    img_array = np.array(img) / 255.0
    img_array = np.expand_dims(img_array, axis=0)
    
    # Predict
    predictions = model.predict(img_array)[0]
    
    labels = ['Onychomycosis', 'Nail Psoriasis', 
              'Brittle Nails', 'Healthy Nail', 'Unidentified']
    
    result = {
        'predicted_class': labels[np.argmax(predictions)],
        'confidence': float(np.max(predictions)),
        'probabilities': {label: float(prob) 
                         for label, prob in zip(labels, predictions)}
    }
    
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
```

**2. Run the API:**
```bash
python api.py
```

**3. Update CaptureScreen.tsx:**

```typescript
// Line 7: Uncomment
import { AIModelAPIService } from './AIModelService';

// Line 25: Uncomment
const aiService = new AIModelAPIService('http://localhost:8000/api/predict');
```

**4. Update AIModelService.tsx:**
```typescript
export default AIModelAPIService;
```

✅ **Done!** Your API is connected.

---

#### Option C: Google Gemini Vision (No Model Training!)

**1. Get API Key:**
- Visit https://makersuite.google.com/app/apikey
- Create API key

**2. Add to environment:**
```bash
# Create .env file in project root
echo "VITE_GEMINI_API_KEY=your_api_key_here" > .env
```

**3. Update CaptureScreen.tsx:**
```typescript
// Line 8: Uncomment
import { GeminiVisionService } from './AIModelService';

// Line 26: Uncomment
const aiService = new GeminiVisionService();
```

**4. Update handleAnalyze function:**
```typescript
const handleAnalyze = async () => {
  if (capturedImage) {
    try {
      const result = await aiService.analyzeNailImage(capturedImage);
      console.log('Result:', result);
      onCapture(); // Proceed to results screen
    } catch (error) {
      console.error('Analysis failed:', error);
    }
  }
};
```

**5. Update AIModelService.tsx:**
```typescript
export default GeminiVisionService;
```

✅ **Done!** Using Google's AI.

---

## 📊 Model Training Guide

### Dataset Structure
```
nail_dataset/
├── train/
│   ├── onychomycosis/       (500+ images)
│   ├── nail_psoriasis/      (500+ images)
│   ├── brittle_nails/       (500+ images)
│   ├── healthy/             (500+ images)
│   └── unidentified/        (500+ images)
└── validation/
    └── (same structure, 20% of data)
```

### Training Script (Python)
```python
import tensorflow as tf
from tensorflow import keras

# Load data
train_ds = keras.preprocessing.image_dataset_from_directory(
    'nail_dataset/train',
    image_size=(224, 224),
    batch_size=32
)

val_ds = keras.preprocessing.image_dataset_from_directory(
    'nail_dataset/validation',
    image_size=(224, 224),
    batch_size=32
)

# Build model
base_model = keras.applications.EfficientNetV2L(
    include_top=False,
    weights='imagenet',
    input_shape=(224, 224, 3)
)

model = keras.Sequential([
    base_model,
    keras.layers.GlobalAveragePooling2D(),
    keras.layers.Dropout(0.3),
    keras.layers.Dense(5, activation='softmax')
])

# Compile
model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

# Train
history = model.fit(
    train_ds,
    validation_data=val_ds,
    epochs=20
)

# Save
model.save('nailscan_model.h5')
```

---

## 🧪 Testing Your Integration

### 1. Test with Console Logs

Add to CaptureScreen.tsx handleAnalyze:
```typescript
const handleAnalyze = async () => {
  if (capturedImage) {
    console.log('🔍 Starting analysis...');
    
    try {
      // For TensorFlow.js
      const img = new Image();
      img.src = capturedImage;
      await img.decode();
      const result = await aiService.predict(img);
      
      console.log('✅ Result:', result);
      console.log('📊 Condition:', result.topPrediction.condition);
      console.log('📈 Confidence:', result.topPrediction.confidence);
      
    } catch (error) {
      console.error('❌ Error:', error);
    }
    
    onCapture(); // Go to results
  }
};
```

### 2. Check Browser DevTools
- Press F12
- Go to Console tab
- Click "Analyze Image"
- You should see prediction results

### 3. Verify Model Loading
```typescript
useEffect(() => {
  const loadModel = async () => {
    console.log('⏳ Loading model...');
    await aiService.loadModel();
    console.log('✅ Model ready!');
  };
  loadModel();
}, []);
```

---

## 🐛 Common Issues & Fixes

### Issue 1: Model Not Loading
```
Error: Failed to fetch model.json
```

**Fix:**
- Check file path: `public/models/nailscan/model.json`
- Verify file exists in public folder
- Clear browser cache (Ctrl+Shift+R)

### Issue 2: CORS Error with API
```
Access-Control-Allow-Origin error
```

**Fix (Flask):**
```python
from flask_cors import CORS
app = Flask(__name__)
CORS(app)
```

### Issue 3: Low Confidence Scores
```
All predictions below 50%
```

**Fix:**
- Check image preprocessing matches training
- Verify normalization (divide by 255)
- Ensure image size matches model input (224x224)

### Issue 4: Out of Memory
```
WebGL out of memory
```

**Fix:**
```typescript
import * as tf from '@tensorflow/tfjs';

// Add at start of predict()
tf.engine().startScope();

// Add at end
tf.engine().endScope();
```

---

## 📈 Performance Optimization

### 1. Model Size Reduction
```bash
# Quantize model for smaller size
tensorflowjs_converter \
  --input_format=keras \
  --quantization_bytes 1 \
  ./model.h5 \
  ./public/models/nailscan
```

### 2. Caching
```typescript
let cachedModel: tf.LayersModel | null = null;

async loadModel() {
  if (cachedModel) {
    this.model = cachedModel;
    return;
  }
  this.model = await tf.loadLayersModel('/models/model.json');
  cachedModel = this.model;
}
```

### 3. WebGL Backend (Fastest)
```typescript
await tf.setBackend('webgl');
await tf.ready();
```

---

## 🚀 Deployment

### Deploy to Vercel
```bash
# Install Vercel CLI
pnpm add -g vercel

# Deploy
vercel
```

### Deploy to Netlify
```bash
# Build
pnpm build

# Upload dist/ folder to Netlify
```

### Environment Variables (Production)
```bash
# Add in hosting platform dashboard
VITE_API_ENDPOINT=https://your-api.com/predict
VITE_GEMINI_API_KEY=your_key_here
```

---

## 📚 Resources

- [TensorFlow.js Guide](https://www.tensorflow.org/js/guide)
- [Model Conversion Guide](https://www.tensorflow.org/js/guide/conversion)
- [ONNX Runtime Web](https://onnxruntime.ai/docs/tutorials/web/)
- [Google Gemini API](https://ai.google.dev/tutorials/web_quickstart)

---

## ✅ Success Checklist

- [ ] Model loads without errors
- [ ] Predictions return reasonable confidence scores (>80%)
- [ ] Results display correctly in app
- [ ] History saves scan results
- [ ] App works on mobile devices
- [ ] Performance is acceptable (<2s inference)

---

## 🎉 You're All Set!

Your NailScan app is now powered by AI! 

**Next Steps:**
1. Test with various nail images
2. Fine-tune confidence thresholds
3. Add more training data
4. Deploy to production

**Need Help?** Check the main README.md for detailed documentation.
