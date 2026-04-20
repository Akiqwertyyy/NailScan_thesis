/**
 * AI Model Service for NailScan
 * 
 * This service provides integration options for AI/ML models:
 * - TensorFlow.js (local model)
 * - ONNX Runtime (cross-platform)
 * - REST API (cloud services like Gemini, OpenAI, Llama)
 * 
 * Choose the integration method that best fits your needs.
 */

// ============================================================================
// OPTION 1: TensorFlow.js Integration (Recommended for Browser)
// ============================================================================

/**
 * TensorFlow.js Model Service
 * 
 * Installation: pnpm add @tensorflow/tfjs
 * 
 * Model Preparation:
 * 1. Train your model in Python (TensorFlow/Keras)
 * 2. Convert to TensorFlow.js format:
 *    tensorflowjs_converter --input_format=keras ./model.h5 ./public/models/nailscan
 * 3. Place model files in public/models/nailscan/
 */

// Uncomment to use TensorFlow.js (after installing: pnpm add @tensorflow/tfjs)
/*
import * as tf from '@tensorflow/tfjs';

export class TensorFlowModelService {
  private model: tf.LayersModel | null = null;
  private isLoaded = false;

  // Class labels matching your training data
  private readonly labels = [
    'Onychomycosis',
    'Nail Psoriasis',
    'Brittle Nails',
    'Healthy Nail',
    'Unidentified'
  ];

  // Model input size (adjust based on your model)
  private readonly inputSize = { width: 224, height: 224 };

  async loadModel(modelPath = '/models/nailscan/model.json') {
    try {
      console.log('Loading TensorFlow.js model...');
      
      // Set backend (webgl is fastest for most devices)
      await tf.setBackend('webgl');
      
      // Load the model
      this.model = await tf.loadLayersModel(modelPath);
      this.isLoaded = true;
      
      console.log('✅ Model loaded successfully');
      console.log('Model input shape:', this.model.inputs[0].shape);
      
      // Warm up the model
      await this.warmUp();
      
    } catch (error) {
      console.error('❌ Error loading model:', error);
      throw new Error(`Failed to load model: ${error}`);
    }
  }

  private async warmUp() {
    if (!this.model) return;
    
    // Run a dummy prediction to warm up the model
    const dummyInput = tf.zeros([1, this.inputSize.height, this.inputSize.width, 3]);
    const prediction = await this.model.predict(dummyInput) as tf.Tensor;
    prediction.dispose();
    dummyInput.dispose();
    
    console.log('Model warmed up');
  }

  async predict(imageElement: HTMLImageElement | HTMLCanvasElement | ImageData) {
    if (!this.model || !this.isLoaded) {
      throw new Error('Model not loaded. Call loadModel() first.');
    }

    try {
      // Preprocess image
      const tensor = tf.tidy(() => {
        // Convert image to tensor
        let img = tf.browser.fromPixels(imageElement);
        
        // Resize to model input size
        img = tf.image.resizeBilinear(img, [this.inputSize.height, this.inputSize.width]);
        
        // Normalize to [0, 1] range
        img = img.toFloat().div(255.0);
        
        // Add batch dimension [1, height, width, 3]
        return img.expandDims(0);
      });

      // Make prediction
      const prediction = await this.model.predict(tensor) as tf.Tensor;
      const probabilities = await prediction.data();

      // Clean up tensors
      tensor.dispose();
      prediction.dispose();

      // Format results
      return this.formatResults(Array.from(probabilities));

    } catch (error) {
      console.error('❌ Prediction error:', error);
      throw new Error(`Prediction failed: ${error}`);
    }
  }

  private formatResults(probabilities: number[]) {
    // Create result array with labels and confidences
    const results = this.labels.map((label, index) => ({
      condition: label,
      confidence: probabilities[index] * 100,
      probability: probabilities[index]
    }));

    // Sort by confidence (highest first)
    results.sort((a, b) => b.confidence - a.confidence);

    // Get top prediction
    const topPrediction = results[0];

    // Determine type for UI styling
    let type: 'disease' | 'healthy' | 'unidentified';
    if (topPrediction.condition === 'Healthy Nail') {
      type = 'healthy';
    } else if (topPrediction.condition === 'Unidentified' || topPrediction.confidence < 60) {
      type = 'unidentified';
    } else {
      type = 'disease';
    }

    return {
      topPrediction: {
        condition: topPrediction.condition,
        confidence: topPrediction.confidence,
        type
      },
      allPredictions: results,
      timestamp: new Date().toISOString()
    };
  }

  dispose() {
    if (this.model) {
      this.model.dispose();
      this.model = null;
      this.isLoaded = false;
    }
  }
}
*/

// ============================================================================
// OPTION 2: ONNX Runtime Integration
// ============================================================================

/**
 * ONNX Runtime Service
 * 
 * Installation: pnpm add onnxruntime-web
 * 
 * Model Preparation:
 * 1. Train in PyTorch/TensorFlow
 * 2. Export to ONNX format
 * 3. Place model.onnx in public/models/
 */

// Uncomment to use ONNX Runtime (after installing: pnpm add onnxruntime-web)
/*
import * as ort from 'onnxruntime-web';

export class ONNXModelService {
  private session: ort.InferenceSession | null = null;
  private isLoaded = false;

  private readonly labels = [
    'Onychomycosis',
    'Nail Psoriasis',
    'Brittle Nails',
    'Healthy Nail',
    'Unidentified'
  ];

  async loadModel(modelPath = '/models/model.onnx') {
    try {
      console.log('Loading ONNX model...');
      this.session = await ort.InferenceSession.create(modelPath);
      this.isLoaded = true;
      console.log('✅ ONNX model loaded successfully');
    } catch (error) {
      console.error('❌ Error loading ONNX model:', error);
      throw error;
    }
  }

  async predict(imageData: Float32Array, shape: number[]) {
    if (!this.session || !this.isLoaded) {
      throw new Error('Model not loaded');
    }

    try {
      const tensor = new ort.Tensor('float32', imageData, shape);
      const feeds = { input: tensor };
      const results = await this.session.run(feeds);
      
      const outputData = results.output.data as Float32Array;
      return this.formatResults(Array.from(outputData));
    } catch (error) {
      console.error('❌ ONNX prediction error:', error);
      throw error;
    }
  }

  private formatResults(probabilities: number[]) {
    const results = this.labels.map((label, index) => ({
      condition: label,
      confidence: probabilities[index] * 100
    }));

    results.sort((a, b) => b.confidence - a.confidence);
    return results[0];
  }
}
*/

// ============================================================================
// OPTION 3: REST API Integration (Cloud Services)
// ============================================================================

/**
 * Generic REST API Service
 * Works with custom APIs, Google Gemini, OpenAI, Llama, etc.
 */

export class AIModelAPIService {
  private apiEndpoint: string;
  private apiKey: string;

  constructor(endpoint?: string, apiKey?: string) {
    // Use environment variables or pass directly
    this.apiEndpoint = endpoint || import.meta.env.VITE_API_ENDPOINT || 'http://localhost:8000/api/predict';
    this.apiKey = apiKey || import.meta.env.VITE_API_KEY || '';
  }

  /**
   * Predict using a custom REST API
   */
  async predict(imageFile: File | Blob) {
    try {
      const formData = new FormData();
      formData.append('image', imageFile);

      const response = await fetch(this.apiEndpoint, {
        method: 'POST',
        headers: {
          ...(this.apiKey && { 'Authorization': `Bearer ${this.apiKey}` })
        },
        body: formData
      });

      if (!response.ok) {
        throw new Error(`API request failed: ${response.statusText}`);
      }

      const data = await response.json();
      return this.formatAPIResponse(data);

    } catch (error) {
      console.error('❌ API prediction error:', error);
      throw error;
    }
  }

  /**
   * Predict from base64 image (useful for some APIs)
   */
  async predictFromBase64(base64Image: string) {
    try {
      const response = await fetch(this.apiEndpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          ...(this.apiKey && { 'Authorization': `Bearer ${this.apiKey}` })
        },
        body: JSON.stringify({
          image: base64Image
        })
      });

      if (!response.ok) {
        throw new Error(`API request failed: ${response.statusText}`);
      }

      const data = await response.json();
      return this.formatAPIResponse(data);

    } catch (error) {
      console.error('❌ API prediction error:', error);
      throw error;
    }
  }

  private formatAPIResponse(data: any) {
    // Format API response to match NailScan format
    // Adjust based on your API's response structure
    
    // Example format:
    // {
    //   "predicted_class": "Onychomycosis",
    //   "confidence": 0.985,
    //   "probabilities": {
    //     "Onychomycosis": 0.985,
    //     "Nail Psoriasis": 0.008,
    //     ...
    //   }
    // }

    const condition = data.predicted_class || data.condition || 'Unidentified';
    const confidence = (data.confidence || 0) * 100;

    let type: 'disease' | 'healthy' | 'unidentified';
    if (condition === 'Healthy Nail') {
      type = 'healthy';
    } else if (condition === 'Unidentified' || confidence < 60) {
      type = 'unidentified';
    } else {
      type = 'disease';
    }

    return {
      condition,
      confidence,
      type,
      probabilities: data.probabilities || {},
      timestamp: new Date().toISOString()
    };
  }
}

// ============================================================================
// OPTION 4: Google Gemini Vision API
// ============================================================================

/**
 * Google Gemini Vision API Service
 * 
 * Setup:
 * 1. Get API key from https://makersuite.google.com/app/apikey
 * 2. Add to .env: VITE_GEMINI_API_KEY=your_key_here
 */

export class GeminiVisionService {
  private apiKey: string;
  private apiEndpoint = 'https://generativelanguage.googleapis.com/v1/models/gemini-pro-vision:generateContent';

  constructor(apiKey?: string) {
    this.apiKey = apiKey || import.meta.env.VITE_GEMINI_API_KEY || '';
  }

  async analyzeNailImage(base64Image: string, mimeType = 'image/jpeg') {
    try {
      const prompt = `
        You are a medical AI assistant specializing in fingernail disease detection.
        Analyze this fingernail image and classify it into ONE of these categories:
        1. Onychomycosis (fungal infection)
        2. Nail Psoriasis
        3. Brittle Nails
        4. Healthy Nail
        5. Unidentified (if unclear or out of scope)
        
        Provide your response in this JSON format:
        {
          "condition": "condition name",
          "confidence": 0.95,
          "analysis": "brief explanation",
          "recommendation": "medical recommendation"
        }
      `;

      const response = await fetch(`${this.apiEndpoint}?key=${this.apiKey}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          contents: [{
            parts: [
              { text: prompt },
              {
                inline_data: {
                  mime_type: mimeType,
                  data: base64Image.split(',')[1] // Remove data:image/jpeg;base64, prefix
                }
              }
            ]
          }]
        })
      });

      if (!response.ok) {
        throw new Error(`Gemini API error: ${response.statusText}`);
      }

      const data = await response.json();
      return this.parseGeminiResponse(data);

    } catch (error) {
      console.error('❌ Gemini API error:', error);
      throw error;
    }
  }

  private parseGeminiResponse(data: any) {
    try {
      const text = data.candidates[0].content.parts[0].text;
      
      // Extract JSON from response (Gemini might wrap it in markdown)
      const jsonMatch = text.match(/\{[\s\S]*\}/);
      if (!jsonMatch) {
        throw new Error('Could not parse Gemini response');
      }

      const result = JSON.parse(jsonMatch[0]);

      let type: 'disease' | 'healthy' | 'unidentified';
      if (result.condition === 'Healthy Nail') {
        type = 'healthy';
      } else if (result.condition === 'Unidentified' || result.confidence < 0.6) {
        type = 'unidentified';
      } else {
        type = 'disease';
      }

      return {
        condition: result.condition,
        confidence: result.confidence * 100,
        type,
        analysis: result.analysis,
        recommendation: result.recommendation,
        timestamp: new Date().toISOString()
      };

    } catch (error) {
      console.error('Error parsing Gemini response:', error);
      throw error;
    }
  }
}

// ============================================================================
// MOCK SERVICE (For Testing)
// ============================================================================

/**
 * Mock AI Service for testing without a real model
 */

export class MockAIService {
  async predict(delay = 2000): Promise<{
    condition: string;
    confidence: number;
    type: 'disease' | 'healthy' | 'unidentified';
    analysis: string;
  }> {
    // Simulate API delay
    await new Promise(resolve => setTimeout(resolve, delay));

    // Random prediction for testing
    const predictions = [
      {
        condition: 'Onychomycosis',
        confidence: 94.5,
        type: 'disease' as const,
        analysis: 'Fungal infection detected with high confidence. Visible discoloration and thickening.'
      },
      {
        condition: 'Healthy Nail',
        confidence: 98.2,
        type: 'healthy' as const,
        analysis: 'No abnormalities detected. Nail appears healthy with normal color and texture.'
      },
      {
        condition: 'Nail Psoriasis',
        confidence: 89.7,
        type: 'disease' as const,
        analysis: 'Signs of pitting and discoloration consistent with nail psoriasis.'
      },
      {
        condition: 'Brittle Nails',
        confidence: 87.3,
        type: 'disease' as const,
        analysis: 'Evidence of brittleness and splitting. May indicate nutritional deficiency.'
      },
      {
        condition: 'Unidentified',
        confidence: 45.2,
        type: 'unidentified' as const,
        analysis: 'Low confidence detection. Condition may be outside training scope.'
      }
    ];

    return predictions[Math.floor(Math.random() * predictions.length)];
  }
}

// ============================================================================
// EXPORT DEFAULT SERVICE
// ============================================================================

/**
 * Export the service you want to use
 * 
 * Uncomment the service you want to use:
 * - export default TensorFlowModelService; (for local TensorFlow.js models)
 * - export default ONNXModelService; (for ONNX models)
 * - export default AIModelAPIService; (for custom REST APIs)
 * - export default GeminiVisionService; (for Google Gemini)
 * - export default MockAIService; (for testing)
 */

export default MockAIService;
