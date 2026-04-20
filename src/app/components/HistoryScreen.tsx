import { Home, History, Info, ChevronRight, Trash2, X } from 'lucide-react';
import { useState } from 'react';

interface HistoryScreenProps {
  onNavigate: (screen: string) => void;
  currentScreen: string;
}

export function HistoryScreen({ onNavigate, currentScreen }: HistoryScreenProps) {
  const [historyItems, setHistoryItems] = useState([
    {
      id: 1,
      condition: 'Onychomycosis',
      confidence: 98.5,
      date: 'Feb 18, 2026',
      message: 'Fungal infection detected with high confidence. Consult dermatologist for treatment.',
      type: 'disease' as const,
    },
    {
      id: 2,
      condition: 'Acral Lentiginous Melanoma (ALM)',
      confidence: 91.2,
      date: 'Feb 15, 2026',
      message: 'Dark pigmentation patterns detected. Immediate dermatology consultation recommended.',
      type: 'disease' as const,
    },
    {
      id: 3,
      condition: 'Healthy Nail',
      confidence: 97.8,
      date: 'Feb 12, 2026',
      message: 'No abnormalities detected. Nail appears healthy.',
      type: 'healthy' as const,
    },
    {
      id: 4,
      condition: 'Nail Clubbing',
      confidence: 87.3,
      date: 'Feb 10, 2026',
      message: 'Nail shape changes detected. May require medical evaluation.',
      type: 'disease' as const,
    },
    {
      id: 5,
      condition: 'Unidentified',
      confidence: 45.2,
      date: 'Feb 8, 2026',
      message: 'Low confidence - condition not in detection scope. Professional consultation recommended.',
      type: 'unidentified' as const,
    },
  ]);

  const [showClearConfirm, setShowClearConfirm] = useState(false);

  const deleteItem = (id: number) => {
    setHistoryItems(historyItems.filter(item => item.id !== id));
  };

  const clearAll = () => {
    setHistoryItems([]);
    setShowClearConfirm(false);
  };

  const getCardStyle = (type: 'disease' | 'healthy' | 'unidentified') => {
    switch (type) {
      case 'healthy':
        return 'border-green-200 bg-gradient-to-br from-green-50 to-white';
      case 'unidentified':
        return 'border-gray-300 bg-gradient-to-br from-gray-50 to-white';
      default:
        return 'border-red-200 bg-gradient-to-br from-red-50 to-white';
    }
  };

  const getBadgeStyle = (type: 'disease' | 'healthy' | 'unidentified') => {
    switch (type) {
      case 'healthy':
        return 'bg-green-100 text-green-700 border border-green-200';
      case 'unidentified':
        return 'bg-gray-100 text-gray-700 border border-gray-200';
      default:
        return 'bg-red-100 text-red-700 border border-red-200';
    }
  };

  return (
    <div className="h-full bg-gradient-to-b from-blue-50 to-white flex flex-col relative" style={{ fontFamily: 'Inter, sans-serif' }}>
      {/* Header */}
      <div className="px-6 py-4 bg-white/80 backdrop-blur-sm border-b border-blue-100">
        <h1 className="text-xl font-semibold text-gray-900 text-center">Scan History</h1>
      </div>

      {/* Content */}
      <div className="flex-1 px-6 py-6 space-y-4 overflow-auto pb-28">
        {historyItems.length === 0 ? (
          <div className="flex flex-col items-center justify-center h-full text-center px-6">
            <div className="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mb-4">
              <History className="w-10 h-10 text-gray-400" />
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">No History Yet</h3>
            <p className="text-sm text-gray-500">Your scan history will appear here</p>
          </div>
        ) : (
          <>
            <div className="space-y-4">
              {historyItems.map((item) => (
                <div
                  key={item.id}
                  className={`relative w-full border-2 rounded-2xl p-5 shadow-sm ${getCardStyle(item.type)}`}
                >
                  <div className="flex items-start justify-between mb-3 pr-8">
                    <div className="flex-1">
                      <h3 className="font-semibold text-gray-900 text-lg mb-1">{item.condition}</h3>
                      <p className="text-sm text-gray-500">{item.date}</p>
                    </div>
                    <span
                      className={`text-sm font-bold px-3 py-1.5 rounded-lg ${getBadgeStyle(item.type)}`}
                    >
                      {item.confidence}%
                    </span>
                  </div>
                  <p className="text-sm text-gray-700 leading-relaxed bg-white/60 rounded-lg p-3">
                    {item.message}
                  </p>
                  <button
                    onClick={() => deleteItem(item.id)}
                    className="absolute top-3 right-3 w-8 h-8 bg-white/80 hover:bg-red-50 rounded-full flex items-center justify-center transition-colors border border-gray-200 hover:border-red-300"
                    aria-label="Delete this scan"
                  >
                    <Trash2 className="w-4 h-4 text-red-500" />
                  </button>
                </div>
              ))}
            </div>
            <button
              onClick={() => setShowClearConfirm(true)}
              className="mt-6 w-full bg-gradient-to-r from-red-500 to-red-600 text-white font-semibold py-3 px-4 rounded-xl hover:from-red-600 hover:to-red-700 transition-all shadow-md"
            >
              Clear All History
            </button>
          </>
        )}

        {/* Confirmation Modal */}
        {showClearConfirm && (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-6">
            <div className="bg-white rounded-2xl shadow-2xl max-w-sm w-full p-6">
              <div className="flex items-center justify-between mb-4">
                <h2 className="text-xl font-bold text-gray-900">Clear All History?</h2>
                <button
                  onClick={() => setShowClearConfirm(false)}
                  className="w-8 h-8 bg-gray-100 hover:bg-gray-200 rounded-full flex items-center justify-center transition-colors"
                >
                  <X className="w-5 h-5 text-gray-600" />
                </button>
              </div>
              <p className="text-gray-600 mb-6">
                This will permanently delete all {historyItems.length} scan{historyItems.length !== 1 ? 's' : ''} from your history. This action cannot be undone.
              </p>
              <div className="flex gap-3">
                <button
                  onClick={() => setShowClearConfirm(false)}
                  className="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-700 font-semibold py-3 rounded-xl transition-colors"
                >
                  Cancel
                </button>
                <button
                  onClick={clearAll}
                  className="flex-1 bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700 text-white font-semibold py-3 rounded-xl transition-all shadow-md"
                >
                  Clear All
                </button>
              </div>
            </div>
          </div>
        )}
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