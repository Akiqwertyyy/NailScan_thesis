import { ArrowLeft, Camera, Image, X, AlertCircle } from 'lucide-react';
import { useState, useRef, useEffect } from 'react';
// Import your chosen AI service (uncomment the one you want to use)
// import { TensorFlowModelService } from './AIModelService';
// import { ONNXModelService } from './AIModelService';
// import { AIModelAPIService } from './AIModelService';
// import { GeminiVisionService } from './AIModelService';
import MockAIService from './AIModelService'; // Default: Mock service for testing

interface CaptureScreenProps {
  onBack: () => void;
  onCapture: () => void;
}

export function CaptureScreen({ onBack, onCapture }: CaptureScreenProps) {
  const [capturedImage, setCapturedImage] = useState<string | null>(null);
  const [isCameraOpen, setIsCameraOpen] = useState(false);
  const [stream, setStream] = useState<MediaStream | null>(null);
  const [cameraError, setCameraError] = useState<string | null>(null);
  const videoRef = useRef<HTMLVideoElement>(null);

  // AI Model Service (uncomment and use your chosen service)
  // const aiService = new TensorFlowModelService(); // For TensorFlow.js
  // const aiService = new ONNXModelService(); // For ONNX
  // const aiService = new AIModelAPIService(); // For REST API
  // const aiService = new GeminiVisionService(); // For Google Gemini
  const aiService = new MockAIService(); // Default: Mock service

  useEffect(() => {
    // Load AI model on component mount (if using TensorFlow.js or ONNX)
    // Uncomment if using TensorFlow.js or ONNX:
    // loadAIModel();

    return () => {
      // Cleanup: stop camera when component unmounts
      if (stream) {
        stream.getTracks().forEach(track => track.stop());
      }
    };
  }, [stream]);

  // Example: Loading TensorFlow.js or ONNX model
  // const loadAIModel = async () => {
  //   try {
  //     await aiService.loadModel();
  //     console.log('✅ AI Model loaded and ready');
  //   } catch (error) {
  //     console.error('❌ Failed to load AI model:', error);
  //   }
  // };

  const handleFileUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setCapturedImage(reader.result as string);
        setCameraError(null); // Clear any previous errors
      };
      reader.readAsDataURL(file);
    }
  };

  const handleTakePhoto = async () => {
    setCameraError(null); // Clear previous errors
    
    try {
      const mediaStream = await navigator.mediaDevices.getUserMedia({ 
        video: { 
          facingMode: 'environment',
          width: { ideal: 1920 },
          height: { ideal: 1080 }
        },
        audio: false 
      });
      setStream(mediaStream);
      setIsCameraOpen(true);
      
      // Wait for next frame to ensure videoRef.current is ready
      setTimeout(() => {
        if (videoRef.current) {
          videoRef.current.srcObject = mediaStream;
          // Explicitly play the video
          videoRef.current.play().catch((err) => {
            console.warn('Video autoplay prevented:', err);
          });
        }
      }, 100);
    } catch (error: any) {
      // Don't log the error to console - it's expected behavior
      
      // Set user-friendly error message
      let errorMessage = '';
      
      if (error.name === 'NotAllowedError') {
        errorMessage = 'Camera permission was denied. Please use the "Upload Image" button below to select a photo from your gallery instead.';
      } else if (error.name === 'NotFoundError') {
        errorMessage = 'No camera found on this device. Please use the "Upload Image" button below to select a photo from your gallery.';
      } else if (error.name === 'NotReadableError') {
        errorMessage = 'Camera is already in use by another application. Please close other apps using the camera, or use the "Upload Image" button below.';
      } else {
        errorMessage = 'Unable to access camera. Please use the "Upload Image" button below to select a photo from your gallery.';
      }
      
      setCameraError(errorMessage);
    }
  };

  const handleCaptureFromCamera = () => {
    if (videoRef.current) {
      const canvas = document.createElement('canvas');
      canvas.width = videoRef.current.videoWidth;
      canvas.height = videoRef.current.videoHeight;
      const ctx = canvas.getContext('2d');
      if (ctx) {
        ctx.drawImage(videoRef.current, 0, 0);
        const imageData = canvas.toDataURL('image/jpeg');
        setCapturedImage(imageData);
        handleCloseCamera();
      }
    }
  };

  const handleCloseCamera = () => {
    if (stream) {
      stream.getTracks().forEach(track => track.stop());
      setStream(null);
    }
    setIsCameraOpen(false);
  };

  const handleUploadImage = () => {
    // Trigger file input for gallery
    document.getElementById('upload-input')?.click();
  };

  const handleAnalyze = () => {
    if (capturedImage) {
      onCapture();
    }
  };

  const handleRetake = () => {
    setCapturedImage(null);
  };

  // Camera view
  if (isCameraOpen) {
    return (
      <div className="h-full bg-black flex flex-col" style={{ fontFamily: 'Inter, sans-serif' }}>
        {/* Camera Header */}
        <div className="flex items-center justify-between px-6 py-4 bg-black/50 absolute top-0 left-0 right-0 z-10">
          <button onClick={handleCloseCamera} className="p-2 text-white">
            <X className="w-6 h-6" />
          </button>
          <h1 className="text-white font-semibold">Take Photo</h1>
          <div className="w-10" />
        </div>

        {/* Camera Preview */}
        <div className="flex-1 flex items-center justify-center">
          <video
            ref={videoRef}
            autoPlay
            playsInline
            className="w-full h-full object-cover"
          />
        </div>

        {/* Capture Button */}
        <div className="absolute bottom-8 left-0 right-0 flex justify-center">
          <button
            onClick={handleCaptureFromCamera}
            className="w-20 h-20 bg-white rounded-full border-4 border-gray-300 hover:border-[#2563EB] transition-colors shadow-lg"
          />
        </div>
      </div>
    );
  }

  return (
    <div className="h-full bg-gradient-to-b from-blue-50 to-white flex flex-col" style={{ fontFamily: 'Inter, sans-serif' }}>
      {/* Header */}
      <div className="flex items-center px-6 py-4 bg-white/80 backdrop-blur-sm border-b border-blue-100">
        <button onClick={onBack} className="p-2 -ml-2 text-gray-700 hover:text-[#2563EB] transition-colors">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h1 className="flex-1 text-center text-xl font-semibold text-gray-900 pr-10">
          Capture Nail Image
        </h1>
      </div>

      {/* Content */}
      <div className="flex-1 flex flex-col px-6 py-8">
        {/* Instruction */}
        <div className="mb-6">
          <div className="bg-blue-50 border border-blue-200 rounded-xl p-4">
            <p className="text-sm font-semibold text-gray-900 mb-2">For better scan results:</p>
            <ul className="text-sm text-gray-700 space-y-1.5">
              <li className="flex items-start gap-2">
                <span className="text-[#2563EB] mt-0.5">•</span>
                <span>Ensure good lighting</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-[#2563EB] mt-0.5">•</span>
                <span>Keep the nail clearly visible</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-[#2563EB] mt-0.5">•</span>
                <span>Avoid shadows</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-[#2563EB] mt-0.5">•</span>
                <span>Keep the nail clean</span>
              </li>
            </ul>
          </div>
        </div>

        {/* Image Placeholder */}
        <div className="flex-1 flex items-center justify-center mb-8">
          {capturedImage ? (
            <div className="w-full max-w-sm aspect-square rounded-2xl overflow-hidden border-2 border-[#2563EB] shadow-lg">
              <img
                src={capturedImage}
                alt="Captured nail"
                className="w-full h-full object-cover"
              />
            </div>
          ) : (
            <div className="w-full max-w-sm aspect-square bg-white border-2 border-dashed border-blue-200 rounded-2xl flex flex-col items-center justify-center">
              <Camera className="w-16 h-16 text-blue-300 mb-3" />
              <p className="text-gray-500 text-sm">No image selected</p>
            </div>
          )}
        </div>

        {/* Action Buttons */}
        {capturedImage ? (
          <div className="space-y-3">
            <button
              onClick={handleAnalyze}
              className="w-full bg-gradient-to-r from-[#2563EB] to-[#1d4ed8] text-white py-4 px-6 rounded-2xl font-semibold hover:shadow-xl transition-all shadow-lg"
            >
              Analyze Image
            </button>
            <button
              onClick={handleRetake}
              className="w-full bg-white border-2 border-blue-200 text-gray-700 py-4 px-6 rounded-2xl font-semibold hover:border-[#2563EB] hover:text-[#2563EB] transition-colors"
            >
              Retake Photo
            </button>
          </div>
        ) : (
          <div className="space-y-3">
            {/* Hidden file inputs */}
            <input
              type="file"
              id="camera-file-input"
              accept="image/*"
              capture="environment"
              onChange={handleFileUpload}
              className="hidden"
            />
            <input
              type="file"
              id="upload-input"
              accept="image/*"
              onChange={handleFileUpload}
              className="hidden"
            />

            <button
              onClick={handleTakePhoto}
              className="w-full bg-gradient-to-r from-[#2563EB] to-[#1d4ed8] text-white py-4 px-6 rounded-2xl font-semibold hover:shadow-xl transition-all shadow-lg flex items-center justify-center gap-2"
            >
              <Camera className="w-5 h-5" />
              Take Photo
            </button>
            <button
              onClick={handleUploadImage}
              className="w-full bg-white border-2 border-blue-200 text-gray-700 py-4 px-6 rounded-2xl font-semibold hover:border-[#2563EB] hover:text-[#2563EB] transition-colors flex items-center justify-center gap-2"
            >
              <Image className="w-5 h-5" />
              Upload Image
            </button>
          </div>
        )}
        
        {/* Camera Error Message */}
        {cameraError && (
          <div className="mt-4 bg-amber-50 border border-amber-200 rounded-xl p-4">
            <div className="flex gap-3">
              <AlertCircle className="w-5 h-5 text-amber-600 flex-shrink-0 mt-0.5" />
              <div>
                <p className="text-sm font-semibold text-amber-900 mb-1">Camera Not Available</p>
                <p className="text-sm text-amber-800 leading-relaxed">{cameraError}</p>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}