import { useState, useEffect } from 'react';
import { SplashScreen } from './components/SplashScreen';
import { HomeScreen } from './components/HomeScreen';
import { QuestionnaireScreen } from './components/QuestionnaireScreen';
import { CaptureScreen } from './components/CaptureScreen';
import { ProcessingScreen } from './components/ProcessingScreen';
import { ResultScreen } from './components/ResultScreen';
import { HistoryScreen } from './components/HistoryScreen';
import { AboutScreen } from './components/AboutScreen';

type Screen = 'splash' | 'home' | 'questionnaire' | 'capture' | 'processing' | 'result' | 'history' | 'about';

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>('splash');

  useEffect(() => {
    if (currentScreen === 'splash') {
      const timer = setTimeout(() => {
        setCurrentScreen('home');
      }, 2500);
      return () => clearTimeout(timer);
    }
  }, [currentScreen]);

  const handleStartDiagnosis = () => {
    setCurrentScreen('questionnaire');
  };

  const handleQuestionnaireBack = () => {
    setCurrentScreen('home');
  };

  const handleQuestionnaireContinue = () => {
    setCurrentScreen('capture');
  };

  const handleCapture = () => {
    setCurrentScreen('processing');
    setTimeout(() => {
      setCurrentScreen('result');
    }, 2000);
  };

  const handleScanAgain = () => {
    setCurrentScreen('home');
  };

  const handleBack = () => {
    setCurrentScreen('questionnaire');
  };

  const handleNavigate = (screen: string) => {
    setCurrentScreen(screen as Screen);
  };

  return (
    <div className="size-full flex items-center justify-center bg-gray-100">
      {/* Mobile Container - iPhone 13 size: 390px x 844px */}
      <div className="w-[390px] h-[844px] bg-white shadow-2xl relative overflow-hidden">
        {currentScreen === 'splash' && <SplashScreen />}
        {currentScreen === 'home' && (
          <HomeScreen
            onStartDiagnosis={handleStartDiagnosis}
            onNavigate={handleNavigate}
            currentScreen={currentScreen}
          />
        )}
        {currentScreen === 'questionnaire' && (
          <QuestionnaireScreen 
            onBack={handleQuestionnaireBack} 
            onContinue={handleQuestionnaireContinue} 
          />
        )}
        {currentScreen === 'capture' && (
          <CaptureScreen onBack={handleBack} onCapture={handleCapture} />
        )}
        {currentScreen === 'processing' && <ProcessingScreen />}
        {currentScreen === 'result' && <ResultScreen onScanAgain={handleScanAgain} />}
        {currentScreen === 'history' && (
          <HistoryScreen onNavigate={handleNavigate} currentScreen={currentScreen} />
        )}
        {currentScreen === 'about' && (
          <AboutScreen onNavigate={handleNavigate} currentScreen={currentScreen} />
        )}
      </div>
    </div>
  );
}