# NailScan - AI-Powered Fingernail Disease Detection

NailScan is a mobile-first web application mockup that demonstrates AI-powered fingernail disease detection using medical minimal design principles.

## 🎨 Features

- **Medical-Grade Design**: Clean white interface with medical blue (#2563EB) accents
- **5 Detection Categories**:
  - Onychomycosis (Fungal Infection)
  - Nail Psoriasis
  - Brittle Nails
  - Healthy Nails
  - Unidentified (Out of Scope)
- **Complete User Flow**:
  - Splash Screen
  - Home Dashboard
  - Capture Screen (Photo Input)
  - Processing Screen (AI Analysis)
  - Results Screen (Diagnosis with Confidence Scores)
  - History Screen (Track Past Scans)
  - About Screen (App Information)
- **History Management**: Delete individual scans or clear all history
- **Responsive Design**: Optimized for iPhone 13 dimensions (390px × 844px)

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v18 or higher) - [Download Node.js](https://nodejs.org/)
- **pnpm** (Package Manager) - Install via: `npm install -g pnpm`
- **Visual Studio Code** - [Download VS Code](https://code.visualstudio.com/)

## 🚀 Installation Instructions

### Step 1: Clone or Download the Project

If you have the project files, place them in a folder on your computer.

### Step 2: Open in Visual Studio Code

1. Open **Visual Studio Code**
2. Click **File** → **Open Folder**
3. Navigate to your project folder and click **Select Folder**

### Step 3: Install Dependencies

1. Open the integrated terminal in VS Code:
   - Press `` Ctrl + ` `` (backtick) or
   - Click **Terminal** → **New Terminal** in the menu

2. In the terminal, run:
   ```bash
   pnpm install
   ```

   This will install all required dependencies (React, Tailwind CSS, TypeScript, etc.)

### Step 4: Start the Development Server

Once installation is complete, run:

```bash
pnpm dev
```

You should see output like:
```
  VITE v5.x.x  ready in xxx ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
```

### Step 5: View the App

1. Open your web browser
2. Navigate to: **http://localhost:5173/**
3. The NailScan app will load

### Step 6: Mobile View (Recommended)

For the best experience, view the app in mobile dimensions:

1. Open **Chrome DevTools**: Press `F12` or `Ctrl+Shift+I` (Windows) / `Cmd+Option+I` (Mac)
2. Click the **Toggle Device Toolbar** icon (or press `Ctrl+Shift+M` / `Cmd+Shift+M`)
3. Select **iPhone 13** or set custom dimensions: **390px × 844px**

## 🛠 Development

### Project Structure

```
nailscan/
├── src/
│   ├── app/
│   │   ├── components/
│   │   │   ├── SplashScreen.tsx
│   │   │   ├── HomeScreen.tsx
│   │   │   ├── CaptureScreen.tsx
│   │   │   ├── ProcessingScreen.tsx
│   │   │   ├── ResultsScreen.tsx
│   │   │   ├── HistoryScreen.tsx
│   │   │   ├── AboutScreen.tsx
│   │   │   └── AIModelService.tsx
│   │   ├── App.tsx
│   │   └── main.tsx
│   └── styles/
│       ├── theme.css
│       └── fonts.css
├── package.json
└── README.md
```

### Available Scripts

- `pnpm dev` - Start development server
- `pnpm build` - Build for production
- `pnpm preview` - Preview production build
- `pnpm lint` - Run ESLint

## 🤖 AI Model Integration

NailScan is designed to integrate with custom AI models for fingernail disease detection. See the **AI Model Integration Guide** below.

---

## 🧠 AI Model Integration Guide

### Overview

NailScan supports integration with various AI/ML frameworks:
- **TensorFlow.js** (Recommended for web)
- **ONNX Runtime**
- **Custom REST APIs** (Google Gemini, OpenAI, Llama, etc.)

### Option 1: TensorFlow.js (Recommended)

#### Step 1: Install TensorFlow.js

```bash
pnpm add @tensorflow/tfjs
```

#### Step 2: Prepare Your Model

1. **Train your model** using Python (TensorFlow/Keras)
2. **Convert to TensorFlow.js format**:
   ```bash
   tensorflowjs_converter \
     --input_format=keras \
     ./model.h5 \
     ./public/models/nailscan
   ```

3. **Place model files** in `public/models/nailscan/`:
   - `model.json`
   - `group1-shard1of1.bin` (weight files)

#### Step 3: Update AIModelService.tsx

The `AIModelService.tsx` component handles model loading and predictions. Update it to load your custom model:

```typescript
import * as tf from '@tensorflow/tfjs';

export class NailScanAI {
  private model: tf.LayersModel | null = null;

  async loadModel() {
    try {
      // Load your custom model
      this.model = await tf.loadLayersModel('/models/nailscan/model.json');
      console.log('Model loaded successfully');
    } catch (error) {
      console.error('Error loading model:', error);
    }
  }

  async predict(imageElement: HTMLImageElement) {
    if (!this.model) {
      throw new Error('Model not loaded');
    }

    // Preprocess image
    const tensor = tf.browser.fromPixels(imageElement)
      .resizeNearestNeighbor([224, 224]) // Adjust to your model's input size
      .toFloat()
      .div(255.0)
      .expandDims();

    // Make prediction
    const prediction = await this.model.predict(tensor) as tf.Tensor;
    const probabilities = await prediction.data();

    // Clean up
    tensor.dispose();
    prediction.dispose();

    return this.formatResults(probabilities);
  }

  private formatResults(probabilities: Float32Array | Int32Array | Uint8Array) {
    const labels = [
      'Onychomycosis',
      'Nail Psoriasis',
      'Brittle Nails',
      'Healthy Nail',
      'Unidentified'
    ];

    const results = labels.map((label, index) => ({
      condition: label,
      confidence: probabilities[index] * 100
    }));

    // Sort by confidence
    results.sort((a, b) => b.confidence - a.confidence);

    return results[0]; // Return top prediction
  }
}
```

#### Step 4: Integrate in CaptureScreen

Update `CaptureScreen.tsx` to use the AI model:

```typescript
import { NailScanAI } from './AIModelService';

// Inside your component
const aiModel = new NailScanAI();

// Load model on component mount
useEffect(() => {
  aiModel.loadModel();
}, []);

// When processing image
const handleImageCapture = async (imageElement: HTMLImageElement) => {
  const result = await aiModel.predict(imageElement);
  // Display result
  console.log('Prediction:', result);
};
```

---

### Option 2: REST API Integration (Gemini, OpenAI, Llama)

If your model is hosted on a server or you're using cloud AI services:

#### Example: Google Gemini Vision API

```typescript
// AIModelService.tsx
export class NailScanAPI {
  private apiKey = 'YOUR_API_KEY_HERE';
  private apiEndpoint = 'https://generativelanguage.googleapis.com/v1/models/gemini-pro-vision:generateContent';

  async analyzeImage(base64Image: string) {
    const response = await fetch(`${this.apiEndpoint}?key=${this.apiKey}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        contents: [{
          parts: [
            {
              text: "Analyze this fingernail image for diseases: Onychomycosis, Nail Psoriasis, Brittle Nails, or Healthy. Provide confidence score."
            },
            {
              inline_data: {
                mime_type: "image/jpeg",
                data: base64Image
              }
            }
          ]
        }]
      })
    });

    const data = await response.json();
    return this.parseResponse(data);
  }

  private parseResponse(data: any) {
    // Parse API response and format for NailScan
    // Implementation depends on API response structure
  }
}
```

#### Example: Custom Llama Model API

```typescript
export class LlamaModelAPI {
  private apiEndpoint = 'http://your-server.com/api/predict';

  async predict(imageFile: File) {
    const formData = new FormData();
    formData.append('image', imageFile);

    const response = await fetch(this.apiEndpoint, {
      method: 'POST',
      body: formData
    });

    const result = await response.json();
    return {
      condition: result.predicted_class,
      confidence: result.confidence * 100,
      probabilities: result.all_probabilities
    };
  }
}
```

---

### Option 3: ONNX Runtime

For models trained in PyTorch or exported to ONNX format:

#### Step 1: Install ONNX Runtime

```bash
pnpm add onnxruntime-web
```

#### Step 2: Convert Your Model

```python
# Python - Convert PyTorch to ONNX
import torch

model = YourPyTorchModel()
dummy_input = torch.randn(1, 3, 224, 224)

torch.onnx.export(
    model,
    dummy_input,
    "model.onnx",
    export_params=True,
    opset_version=11
)
```

#### Step 3: Implement in JavaScript

```typescript
import * as ort from 'onnxruntime-web';

export class ONNXModelService {
  private session: ort.InferenceSession | null = null;

  async loadModel() {
    this.session = await ort.InferenceSession.create('/models/model.onnx');
  }

  async predict(imageData: Float32Array) {
    if (!this.session) throw new Error('Model not loaded');

    const tensor = new ort.Tensor('float32', imageData, [1, 3, 224, 224]);
    const feeds = { input: tensor };
    const results = await this.session.run(feeds);
    
    return results.output.data;
  }
}
```

---

### Model Training Specifications

For best results, train your model with these specifications:

**Input:**
- Image Size: 224×224 or 256×256 pixels
- Format: RGB (3 channels)
- Normalization: [0, 1] or ImageNet mean/std

**Output:**
- 5 classes: [Onychomycosis, Nail Psoriasis, Brittle Nails, Healthy, Unidentified]
- Activation: Softmax
- Format: Probability distribution (sum = 1.0)

**Recommended Architecture:**
- EfficientNetV2-L (as mentioned in app)
- ResNet-50
- MobileNetV3 (for faster inference)

**Dataset Structure:**
```
dataset/
├── train/
│   ├── onychomycosis/
│   ├── nail_psoriasis/
│   ├── brittle_nails/
│   ├── healthy/
│   └── unidentified/
└── val/
    └── (same structure)
```

---

## 🔐 Security Notes

- **Never commit API keys** to version control
- Use environment variables: Create `.env` file:
  ```
  VITE_API_KEY=your_api_key_here
  ```
- Access in code: `import.meta.env.VITE_API_KEY`
- Add `.env` to `.gitignore`

---

## 📱 Testing Your Model

1. **Test with sample images** in `public/test-images/`
2. **Verify predictions** match expected results
3. **Check confidence scores** are reasonable (>80% for good predictions)
4. **Test edge cases** (blurry images, poor lighting, etc.)

---

## 🐛 Troubleshooting

### Model Not Loading
- Check file paths in `public/models/`
- Verify model format (TensorFlow.js requires `model.json`)
- Check browser console for errors

### CORS Errors
- Ensure API endpoints allow cross-origin requests
- Use proxy in development (vite.config.ts)

### Low Performance
- Use smaller model (MobileNet)
- Reduce image resolution
- Enable WebGL backend for TensorFlow.js

---

## 📞 Support

For issues or questions:
- Check browser console for errors
- Review model loading in Network tab
- Verify image preprocessing matches training

---

## 📄 License

This is a demonstration mockup for educational purposes.

---

## 🙏 Acknowledgments

- Built with React + TypeScript + Tailwind CSS
- Icons by Lucide React
- Medical design inspired by modern healthcare applications
