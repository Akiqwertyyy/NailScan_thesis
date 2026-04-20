import { ArrowLeft, CheckCircle2, Circle } from 'lucide-react';
import { useState } from 'react';

interface QuestionnaireScreenProps {
  onBack: () => void;
  onContinue: () => void;
}

interface Answer {
  question: string;
  answer: 'yes' | 'no' | null;
}

export function QuestionnaireScreen({ onBack, onContinue }: QuestionnaireScreenProps) {
  const [answers, setAnswers] = useState<Answer[]>([
    { question: 'Have you experienced nail injury or trauma recently?', answer: null },
    { question: 'Do you have a history of nail infections?', answer: null },
    { question: 'Have you noticed nail discoloration, thickening, or lines?', answer: null },
  ]);

  const handleAnswer = (index: number, answer: 'yes' | 'no') => {
    const newAnswers = [...answers];
    newAnswers[index].answer = answer;
    setAnswers(newAnswers);
  };

  return (
    <div className="h-full bg-gradient-to-b from-blue-50 to-white flex flex-col" style={{ fontFamily: 'Inter, sans-serif' }}>
      {/* Header */}
      <div className="flex items-center px-6 py-4 bg-white/80 backdrop-blur-sm border-b border-blue-100">
        <button onClick={onBack} className="p-2 -ml-2 text-gray-700 hover:text-[#2563EB] transition-colors">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h1 className="flex-1 text-center text-xl font-semibold text-gray-900 pr-10">
          Pre-Scan Questions
        </h1>
      </div>

      {/* Content */}
      <div className="flex-1 overflow-auto px-6 py-8">
        <div className="max-w-md mx-auto">
          {/* Info */}
          <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-6">
            <p className="text-sm text-gray-700 leading-relaxed">
              <strong>Optional:</strong> These questions help provide additional context for the analysis. You can skip and proceed directly to scanning.
            </p>
          </div>

          {/* Questions */}
          <div className="space-y-6">
            {answers.map((item, index) => (
              <div key={index} className="bg-white rounded-xl p-5 shadow-sm border border-blue-100">
                <p className="text-gray-900 font-medium mb-4 leading-relaxed">
                  {index + 1}. {item.question}
                </p>
                <div className="flex gap-3">
                  <button
                    onClick={() => handleAnswer(index, 'yes')}
                    className={`flex-1 py-3 px-4 rounded-xl font-medium transition-all ${
                      item.answer === 'yes'
                        ? 'bg-[#2563EB] text-white shadow-md'
                        : 'bg-gray-50 text-gray-700 hover:bg-gray-100 border border-gray-200'
                    }`}
                  >
                    {item.answer === 'yes' ? (
                      <span className="flex items-center justify-center gap-2">
                        <CheckCircle2 className="w-5 h-5" />
                        Yes
                      </span>
                    ) : (
                      'Yes'
                    )}
                  </button>
                  <button
                    onClick={() => handleAnswer(index, 'no')}
                    className={`flex-1 py-3 px-4 rounded-xl font-medium transition-all ${
                      item.answer === 'no'
                        ? 'bg-[#2563EB] text-white shadow-md'
                        : 'bg-gray-50 text-gray-700 hover:bg-gray-100 border border-gray-200'
                    }`}
                  >
                    {item.answer === 'no' ? (
                      <span className="flex items-center justify-center gap-2">
                        <CheckCircle2 className="w-5 h-5" />
                        No
                      </span>
                    ) : (
                      'No'
                    )}
                  </button>
                </div>
              </div>
            ))}
          </div>

          {/* Note */}
          <div className="mt-6 text-center">
            <p className="text-xs text-gray-500 leading-relaxed">
              These questions are for context only and do not replace image analysis.
            </p>
          </div>
        </div>
      </div>

      {/* Bottom Actions */}
      <div className="px-6 py-6 bg-white border-t border-gray-200">
        <div className="max-w-md mx-auto space-y-3">
          <button
            onClick={onContinue}
            className="w-full bg-gradient-to-r from-[#2563EB] to-[#1d4ed8] text-white py-4 px-6 rounded-2xl font-semibold hover:shadow-xl transition-all shadow-lg"
          >
            Continue to Scan
          </button>
          <button
            onClick={onContinue}
            className="w-full text-gray-600 py-3 text-sm font-medium hover:text-gray-900 transition-colors"
          >
            Skip Questions
          </button>
        </div>
      </div>
    </div>
  );
}
