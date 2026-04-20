import { Home, History, Info } from 'lucide-react';
import exampleImage from 'figma:asset/aac5a374fafc1c0435de509591b1922bf8fbab33.png';
import nailBg from '../../assets/nail_bg.jpg';

interface HomeScreenProps {
  onStartDiagnosis: () => void;
  onNavigate: (screen: string) => void;
  currentScreen: string;
}

export function HomeScreen({ onStartDiagnosis, onNavigate, currentScreen }: HomeScreenProps) {
  return (
    <div
      className="h-full flex flex-col relative"
      style={{
        fontFamily: 'Inter, sans-serif',
        backgroundImage: `url(${nailBg})`,
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        backgroundRepeat: 'no-repeat',
      }}
    >
      {/* Dark overlay for readability */}
      <div className="absolute inset-0 bg-black/40 z-0" />

      {/* Content */}
      <div className="flex-1 flex flex-col px-6 pt-12 pb-32 overflow-auto relative z-10">
        {/* Header */}
        <div className="text-center mb-12">
          <div className="w-24 h-24 mx-auto mb-6 flex items-center justify-center">
            <img src={exampleImage} alt="NailScan Logo" className="w-full h-full object-contain drop-shadow-xl rounded-2xl" />
          </div>
          <h1 className="text-3xl font-bold text-white mb-2">NailScan</h1>
          <p className="text-white/80">AI-Powered Nail Health Analysis</p>
        </div>

        {/* Middle Section */}
        <div className="flex-1 flex flex-col items-center justify-center">
          <div className="text-center mb-8 max-w-sm">
            <p className="text-white/90 text-lg leading-relaxed">
              Scan your fingernail to detect possible conditions using advanced AI technology.
            </p>
          </div>

          {/* Primary Button */}
          <button
            onClick={onStartDiagnosis}
            className="w-full max-w-sm bg-gradient-to-r from-[#2563EB] to-[#1d4ed8] text-white py-4 px-8 rounded-2xl text-lg font-semibold hover:shadow-xl transition-all shadow-lg"
          >
            Start Diagnosis
          </button>

          {/* Info Cards */}
          <div className="mt-8 w-full max-w-sm space-y-3">
            <div className="rounded-xl p-4 border border-white/30" style={{ background: 'rgba(255,255,255,0.15)', backdropFilter: 'blur(10px)' }}>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg flex items-center justify-center flex-shrink-0" style={{ background: 'rgba(255,255,255,0.2)' }}>
                  <svg className="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M10 2a8 8 0 100 16 8 8 0 000-16zm1 11H9v-2h2v2zm0-4H9V5h2v4z" />
                  </svg>
                </div>
                <p className="text-sm text-white font-medium">Instant AI-powered analysis</p>
              </div>
            </div>
            <div className="rounded-xl p-4 border border-white/30" style={{ background: 'rgba(255,255,255,0.15)', backdropFilter: 'blur(10px)' }}>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg flex items-center justify-center flex-shrink-0" style={{ background: 'rgba(255,255,255,0.2)' }}>
                  <svg className="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" />
                    <path fillRule="evenodd" d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z" clipRule="evenodd" />
                  </svg>
                </div>
                <p className="text-sm text-white font-medium">Track your nail health history</p>
              </div>
            </div>
          </div>
        </div>

        {/* Disclaimer */}
        <div className="text-center mb-8">
          <p className="text-xs text-white/60 max-w-sm mx-auto leading-relaxed">
            This system provides AI-assisted preliminary screening only. Not a substitute for professional medical advice.
          </p>
        </div>
      </div>

      {/* Bottom Nav */}
      <div className="absolute bottom-0 left-0 right-0 border-t border-white/20 py-4 px-6 z-10" style={{ background: 'rgba(0,0,0,0.45)', backdropFilter: 'blur(12px)' }}>
        <div className="flex gap-3">
          <button
            onClick={() => onNavigate('home')}
            className={`flex-1 py-3 px-4 rounded-xl font-semibold transition-all flex flex-col items-center gap-1 ${currentScreen === 'home'
              ? 'bg-gradient-to-r from-[#2563EB] to-[#1d4ed8] text-white shadow-lg'
              : 'text-white/70 border-2 border-white/20 hover:border-white/50'
              }`}
          >
            <Home className="w-5 h-5" />
            <span className="text-xs">Diagnose</span>
          </button>
          <button
            onClick={() => onNavigate('history')}
            className={`flex-1 py-3 px-4 rounded-xl font-semibold transition-all flex flex-col items-center gap-1 ${currentScreen === 'history'
              ? 'bg-gradient-to-r from-[#2563EB] to-[#1d4ed8] text-white shadow-lg'
              : 'text-white/70 border-2 border-white/20 hover:border-white/50'
              }`}
          >
            <History className="w-5 h-5" />
            <span className="text-xs">History</span>
          </button>
          <button
            onClick={() => onNavigate('about')}
            className={`flex-1 py-3 px-4 rounded-xl font-semibold transition-all flex flex-col items-center gap-1 ${currentScreen === 'about'
              ? 'bg-gradient-to-r from-[#2563EB] to-[#1d4ed8] text-white shadow-lg'
              : 'text-white/70 border-2 border-white/20 hover:border-white/50'
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
