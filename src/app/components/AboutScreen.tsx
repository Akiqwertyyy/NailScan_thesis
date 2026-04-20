import { Home, History, Info, AlertCircle } from 'lucide-react';
import exampleImage from 'figma:asset/aac5a374fafc1c0435de509591b1922bf8fbab33.png';

interface AboutScreenProps {
  onNavigate: (screen: string) => void;
  currentScreen: string;
}

export function AboutScreen({ onNavigate, currentScreen }: AboutScreenProps) {
  return (
    <div className="h-full bg-gradient-to-b from-blue-50 to-white flex flex-col relative" style={{ fontFamily: 'Inter, sans-serif' }}>
      {/* Header */}
      <div className="px-6 py-4 bg-white/80 backdrop-blur-sm border-b border-blue-100">
        <h1 className="text-xl font-semibold text-gray-900 text-center">About</h1>
      </div>

      {/* Content */}
      <div className="flex-1 px-6 py-6 space-y-6 overflow-auto pb-28">
        <div className="max-w-md mx-auto space-y-6">
          {/* App Info */}
          <div className="text-center">
            <div className="w-20 h-20 mx-auto mb-4 flex items-center justify-center">
              <img src={exampleImage} alt="NailScan Logo" className="w-full h-full object-contain drop-shadow-lg rounded-2xl" />
            </div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">NailScan</h2>
            <p className="text-gray-600">Version 1.0.0</p>
          </div>

          {/* Description */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-blue-100">
            <h3 className="font-semibold text-gray-900 mb-3">What is NailScan?</h3>
            <p className="text-sm text-gray-700 leading-relaxed">
              NailScan is a mobile application designed to assist in identifying visible nail conditions using image analysis. It aims to provide quick preliminary screening based on nail appearance patterns.
            </p>
          </div>

          {/* Conditions Detected */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-blue-100">
            <h3 className="font-semibold text-gray-900 mb-4">Conditions Detected</h3>
            <div className="space-y-2">
              <div className="flex items-center gap-3">
                <div className="w-2 h-2 bg-[#2563EB] rounded-full"></div>
                <p className="text-sm text-gray-900">Onychomycosis</p>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-2 h-2 bg-[#2563EB] rounded-full"></div>
                <p className="text-sm text-gray-900">Acral Lentiginous Melanoma (ALM)</p>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-2 h-2 bg-[#2563EB] rounded-full"></div>
                <p className="text-sm text-gray-900">Nail Clubbing</p>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                <p className="text-sm text-gray-900">Healthy Nail</p>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-2 h-2 bg-gray-400 rounded-full"></div>
                <p className="text-sm text-gray-900">Unidentified</p>
              </div>
            </div>
          </div>

          {/* How it Works */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-blue-100">
            <h3 className="font-semibold text-gray-900 mb-4">How It Works</h3>
            <p className="text-sm text-gray-700 leading-relaxed mb-4">
              The user captures or uploads a nail image. The system analyzes visible patterns such as color, shape, and texture to estimate the most likely condition.
            </p>
            <div className="space-y-4">
              <div className="flex gap-3">
                <div className="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                  <span className="text-sm font-bold text-[#2563EB]">1</span>
                </div>
                <div className="flex-1">
                  <p className="text-sm text-gray-700">Capture or upload a clear photo of your fingernail</p>
                </div>
              </div>
              <div className="flex gap-3">
                <div className="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                  <span className="text-sm font-bold text-[#2563EB]">2</span>
                </div>
                <div className="flex-1">
                  <p className="text-sm text-gray-700">AI analyzes color, shape, and texture patterns</p>
                </div>
              </div>
              <div className="flex gap-3">
                <div className="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                  <span className="text-sm font-bold text-[#2563EB]">3</span>
                </div>
                <div className="flex-1">
                  <p className="text-sm text-gray-700">Receive instant results with confidence scores</p>
                </div>
              </div>
            </div>
          </div>

          {/* Disclaimer */}
          <div className="bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-[#2563EB]/30 rounded-2xl p-6">
            <div className="flex gap-3">
              <AlertCircle className="w-5 h-5 text-[#2563EB] flex-shrink-0 mt-0.5" />
              <div>
                <h3 className="font-semibold text-[#2563EB] mb-2">Important Notice</h3>
                <p className="text-sm text-gray-700 leading-relaxed">
                  This application is intended for preliminary screening only and does not replace professional medical diagnosis. Always consult a qualified healthcare professional for proper medical advice and treatment.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* 3 Floating Buttons - Fixed at Bottom */}
      <div className="absolute bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-gray-200 py-4 px-6 shadow-lg">
        <div className="flex gap-3">
          <button
            onClick={() => onNavigate('home')}
            className={`flex-1 py-3 px-4 rounded-xl font-semibold transition-all flex flex-col items-center gap-1 ${
              currentScreen === 'home'
                ? 'bg-gradient-to-r from-[#2563EB] to-[#1d4ed8] text-white shadow-lg'
                : 'bg-white border-2 border-gray-200 text-gray-600 hover:border-[#2563EB] hover:text-[#2563EB]'
            }`}
          >
            <Home className="w-5 h-5" />
            <span className="text-xs">Diagnose</span>
          </button>
          <button
            onClick={() => onNavigate('history')}
            className={`flex-1 py-3 px-4 rounded-xl font-semibold transition-all flex flex-col items-center gap-1 ${
              currentScreen === 'history'
                ? 'bg-gradient-to-r from-[#2563EB] to-[#1d4ed8] text-white shadow-lg'
                : 'bg-white border-2 border-gray-200 text-gray-600 hover:border-[#2563EB] hover:text-[#2563EB]'
            }`}
          >
            <History className="w-5 h-5" />
            <span className="text-xs">History</span>
          </button>
          <button
            onClick={() => onNavigate('about')}
            className={`flex-1 py-3 px-4 rounded-xl font-semibold transition-all flex flex-col items-center gap-1 ${
              currentScreen === 'about'
                ? 'bg-gradient-to-r from-[#2563EB] to-[#1d4ed8] text-white shadow-lg'
                : 'bg-white border-2 border-gray-200 text-gray-600 hover:border-[#2563EB] hover:text-[#2563EB]'
            }`}
          >
            <Info className="w-5 h-5" />
            <span className="text-xs">About</span>
          </button>
        </div>
      </div>
    </div>
  );
}