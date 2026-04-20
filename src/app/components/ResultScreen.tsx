import { AlertCircle, Lightbulb, ChevronLeft, ChevronRight } from 'lucide-react';
import { useState } from 'react';

interface ResultScreenProps {
  onScanAgain: () => void;
}

export function ResultScreen({ onScanAgain }: ResultScreenProps) {
  const [currentResultIndex, setCurrentResultIndex] = useState(0);

  const results = [
    {
      condition: 'Onychomycosis',
      confidence: 94.8,
      riskLevel: 'Moderate' as 'Low' | 'Moderate' | 'High',
      cardColor: 'from-red-50 to-white border-red-200',
      badgeColor: 'from-red-100 to-red-50 border-red-200 text-red-600',
      shape: 'Irregular edges with thickened nail plate',
      color: 'Yellow-brown discoloration throughout',
      texture: 'Rough, brittle surface with visible debris',
      description:
        'Onychomycosis is a fungal infection of the nail. It may cause discoloration, thickening, and separation from the nail bed. Early detection and treatment can prevent progression.',
      underlyingCauses: [
        'Dermatophyte fungi (most common)',
        'Yeast infections (Candida species)',
        'Non-dermatophyte molds',
      ],
      symptoms: [
        'Thickened nails',
        'Yellow, brown, or white discoloration',
        'Brittle, crumbly, or ragged nail edges',
        'Distorted nail shape',
        'Separation from nail bed',
        'Dark debris buildup under nail',
      ],
      treatment: [
        'Antifungal medications (oral or topical)',
        'Laser therapy in some cases',
        'Surgical nail removal for severe cases',
        'Duration: 6-12 months for full recovery',
      ],
    },
    {
      condition: 'Acral Lentiginous Melanoma (ALM)',
      confidence: 88.3,
      riskLevel: 'High' as 'Low' | 'Moderate' | 'High',
      cardColor: 'from-red-50 to-white border-red-200',
      badgeColor: 'from-red-100 to-red-50 border-red-200 text-red-600',
      shape: 'Irregular pigmentation patterns along nail matrix',
      color: 'Dark brown to black longitudinal streaks',
      texture: 'Normal surface texture with pigmentation changes',
      description:
        'Acral Lentiginous Melanoma (ALM) is a rare but serious form of skin cancer that affects the nail matrix. It presents as dark pigmentation, often in a longitudinal band. Early detection is critical for successful treatment.',
      underlyingCauses: [
        'Genetic predisposition',
        'UV radiation exposure (less common for ALM)',
        'Trauma history (possible trigger)',
      ],
      symptoms: [
        'Dark brown or black band in nail',
        'Pigmentation extending to cuticle (Hutchinson\'s sign)',
        'Band widening over time',
        'Nail plate changes or destruction',
        'Ulceration or bleeding in advanced cases',
      ],
      treatment: [
        'Immediate dermatology/oncology referral',
        'Biopsy for definitive diagnosis',
        'Surgical excision of affected tissue',
        'Possible amputation in advanced cases',
        'Regular monitoring and follow-up',
      ],
    },
    {
      condition: 'Nail Clubbing',
      confidence: 86.7,
      riskLevel: 'Moderate' as 'Low' | 'Moderate' | 'High',
      cardColor: 'from-orange-50 to-white border-orange-200',
      badgeColor: 'from-orange-100 to-orange-50 border-orange-200 text-orange-600',
      shape: 'Bulbous fingertip with increased nail curvature',
      color: 'Normal pink to slightly blue-tinted nail bed',
      texture: 'Smooth surface with exaggerated convex curvature',
      description:
        'Nail clubbing is characterized by enlargement of the fingertips and increased nail curvature. It can be associated with various underlying medical conditions affecting the heart, lungs, or gastrointestinal system.',
      underlyingCauses: [
        'Chronic lung diseases (COPD, lung cancer)',
        'Cardiovascular conditions (congenital heart disease)',
        'Gastrointestinal disorders (IBD, cirrhosis)',
        'Hyperthyroidism',
      ],
      symptoms: [
        'Bulbous enlargement of fingertips',
        'Increased nail curvature (convex)',
        'Loss of normal nail bed angle',
        'Spongy or floating sensation at nail base',
        'Possible shortness of breath (if lung-related)',
      ],
      treatment: [
        'Treat underlying medical condition',
        'Comprehensive medical evaluation required',
        'Pulmonary or cardiac assessment',
        'No direct treatment for clubbing itself',
        'Regular monitoring of progression',
      ],
    },
    {
      condition: 'Healthy Nail',
      confidence: 98.2,
      riskLevel: 'Low' as 'Low' | 'Moderate' | 'High',
      cardColor: 'from-green-50 to-white border-green-200',
      badgeColor: 'from-green-100 to-green-50 border-green-200 text-green-600',
      shape: 'Normal, smooth, and evenly curved nail plate',
      color: 'Pink nail bed with white lunula visible',
      texture: 'Smooth, uniform surface without irregularities',
      description:
        'The nail appears healthy with no visible abnormalities detected. The nail shows normal color, shape, and texture characteristics consistent with good nail health.',
      underlyingCauses: [
        'Proper nutrition and hydration',
        'Good nail hygiene practices',
        'Absence of trauma or infection',
      ],
      symptoms: [
        'Pink, uniform nail bed color',
        'Smooth nail surface',
        'Normal thickness and strength',
        'No discoloration or irregularities',
        'Healthy cuticle condition',
      ],
      treatment: [
        'Maintain current nail care routine',
        'Keep nails clean and trimmed',
        'Moisturize cuticles regularly',
        'Protect nails from harsh chemicals',
        'Continue balanced diet with adequate nutrients',
      ],
    },
    {
      condition: 'Unidentified',
      confidence: 42.1,
      riskLevel: 'Low' as 'Low' | 'Moderate' | 'High',
      cardColor: 'from-gray-50 to-white border-gray-300',
      badgeColor: 'from-gray-100 to-gray-50 border-gray-200 text-gray-600',
      shape: 'Unclear or atypical presentation',
      color: 'Inconclusive color analysis',
      texture: 'Unable to determine texture pattern',
      description:
        'The AI model could not confidently identify a specific condition based on the provided image. This may be due to image quality, unusual presentation, or a condition outside the training dataset.',
      underlyingCauses: [
        'Poor image quality or lighting',
        'Atypical condition presentation',
        'Condition outside detection scope',
        'Multiple overlapping conditions',
      ],
      symptoms: [
        'Confidence score below threshold',
        'No clear pattern match',
        'Ambiguous visual features',
      ],
      treatment: [
        'Consult a dermatologist for professional evaluation',
        'Provide high-quality images if retaking photo',
        'Describe any symptoms to healthcare provider',
        'Consider in-person clinical examination',
      ],
    },
  ];

  const result = results[currentResultIndex];

  const getRiskLevelColor = (level: 'Low' | 'Moderate' | 'High') => {
    switch (level) {
      case 'Low':
        return { bg: 'bg-green-50', border: 'border-green-300', text: 'text-green-700' };
      case 'Moderate':
        return { bg: 'bg-yellow-50', border: 'border-yellow-300', text: 'text-yellow-700' };
      case 'High':
        return { bg: 'bg-red-50', border: 'border-red-300', text: 'text-red-700' };
    }
  };

  const riskColors = getRiskLevelColor(result.riskLevel);

  return (
    <div className="h-full bg-gradient-to-b from-blue-50 to-white flex flex-col overflow-auto" style={{ fontFamily: 'Inter, sans-serif' }}>
      {/* Header */}
      <div className="px-6 py-4 bg-white/80 backdrop-blur-sm border-b border-blue-100">
        <div className="flex items-center justify-between">
          <button
            onClick={() => setCurrentResultIndex((prev) => (prev - 1 + results.length) % results.length)}
            className="p-2 hover:bg-blue-50 rounded-lg transition-colors"
            aria-label="Previous result"
          >
            <ChevronLeft className="w-5 h-5 text-[#2563EB]" />
          </button>
          <div className="flex-1 text-center">
            <h1 className="text-xl font-semibold text-gray-900">Diagnosis Result</h1>
            <p className="text-xs text-gray-500 mt-1">Example {currentResultIndex + 1} of {results.length}</p>
          </div>
          <button
            onClick={() => setCurrentResultIndex((prev) => (prev + 1) % results.length)}
            className="p-2 hover:bg-blue-50 rounded-lg transition-colors"
            aria-label="Next result"
          >
            <ChevronRight className="w-5 h-5 text-[#2563EB]" />
          </button>
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 px-6 py-6 space-y-6">
        {/* Main Result Card */}
        <div className={`bg-gradient-to-br ${result.cardColor} rounded-2xl p-6 shadow-sm`}>
          <div className="text-center mb-6">
            <p className="text-sm text-gray-600 mb-2">Detected Condition</p>
            <h2 className="text-3xl font-bold text-gray-900 mb-4">{result.condition}</h2>
            <div className={`inline-block bg-gradient-to-br ${result.badgeColor} px-6 py-3 rounded-xl shadow-sm`}>
              <p className="text-sm text-gray-600 mb-1">Confidence Score</p>
              <p className="text-4xl font-bold">{result.confidence}%</p>
            </div>
          </div>

          {/* Analysis Details */}
          <div className="mt-8 space-y-3">
            <p className="text-sm font-semibold text-gray-700 mb-3">Analysis Details</p>
            
            <div className="bg-white rounded-xl p-4 border border-blue-100 shadow-sm">
              <div className="flex items-start gap-3">
                <div className="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                  <svg className="w-4 h-4 text-[#2563EB]" fill="currentColor" viewBox="0 0 20 20">
                    <rect x="4" y="4" width="12" height="12" opacity="0.5"/>
                  </svg>
                </div>
                <div className="flex-1">
                  <p className="text-xs text-gray-600 mb-1">Shape</p>
                  <p className="text-sm text-gray-900">{result.shape}</p>
                </div>
              </div>
            </div>

            <div className="bg-white rounded-xl p-4 border border-blue-100 shadow-sm">
              <div className="flex items-start gap-3">
                <div className="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                  <svg className="w-4 h-4 text-[#2563EB]" fill="currentColor" viewBox="0 0 20 20">
                    <circle cx="10" cy="10" r="8" opacity="0.5"/>
                  </svg>
                </div>
                <div className="flex-1">
                  <p className="text-xs text-gray-600 mb-1">Color</p>
                  <p className="text-sm text-gray-900">{result.color}</p>
                </div>
              </div>
            </div>

            <div className="bg-white rounded-xl p-4 border border-blue-100 shadow-sm">
              <div className="flex items-start gap-3">
                <div className="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                  <svg className="w-4 h-4 text-[#2563EB]" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M4 4 L16 4 L10 10 Z" opacity="0.5"/>
                  </svg>
                </div>
                <div className="flex-1">
                  <p className="text-xs text-gray-600 mb-1">Texture</p>
                  <p className="text-sm text-gray-900">{result.texture}</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Condition Description */}
        <div className="bg-white rounded-2xl p-6 border border-blue-100 shadow-sm">
          <h3 className="text-sm font-semibold text-gray-900 mb-3">Condition Description</h3>
          <p className="text-sm text-gray-700 leading-relaxed">{result.description}</p>
        </div>

        {/* Underlying Causes */}
        <div className="bg-white rounded-2xl p-6 border border-blue-100 shadow-sm">
          <h3 className="text-sm font-semibold text-gray-900 mb-4">Underlying Causes</h3>
          <ul className="space-y-2">
            {result.underlyingCauses.map((cause, index) => (
              <li key={index} className="text-sm text-gray-700 leading-relaxed flex items-start gap-2">
                <span className="text-[#2563EB] mt-1">•</span>
                <span>{cause}</span>
              </li>
            ))}
          </ul>
        </div>

        {/* Common Symptoms */}
        <div className="bg-gradient-to-br from-purple-50 to-white rounded-2xl p-6 border border-purple-200 shadow-sm">
          <h3 className="text-sm font-semibold text-gray-900 mb-4">Common Symptoms</h3>
          <ul className="space-y-2">
            {result.symptoms.map((symptom, index) => (
              <li key={index} className="text-sm text-gray-700 leading-relaxed flex items-start gap-2">
                <span className="text-purple-600 mt-1">•</span>
                <span>{symptom}</span>
              </li>
            ))}
          </ul>
        </div>

        {/* Treatment Options */}
        <div className="bg-gradient-to-br from-green-50 to-white rounded-2xl p-6 border border-green-200 shadow-sm">
          <h3 className="text-sm font-semibold text-gray-900 mb-4">Treatment Options</h3>
          <ul className="space-y-2">
            {result.treatment.map((option, index) => (
              <li key={index} className="text-sm text-gray-700 leading-relaxed flex items-start gap-2">
                <span className="text-green-600 mt-1">•</span>
                <span>{option}</span>
              </li>
            ))}
          </ul>
          <div className="mt-4 p-3 bg-green-100 rounded-lg">
            <p className="text-xs text-gray-700">
              <strong>Note:</strong> Treatment should be prescribed by a healthcare professional based on proper diagnosis.
            </p>
          </div>
        </div>

        {/* Risk Level Indicator */}
        <div className={`${riskColors.bg} rounded-2xl p-6 border-2 ${riskColors.border}`}>
          <div className="flex items-center justify-between mb-3">
            <h3 className="text-sm font-semibold text-gray-900">Risk Level</h3>
            <span className={`${riskColors.text} font-bold text-lg`}>{result.riskLevel}</span>
          </div>
          <div className="w-full bg-white rounded-full h-3 overflow-hidden">
            <div
              className={`h-full transition-all ${
                result.riskLevel === 'Low'
                  ? 'bg-green-500 w-1/3'
                  : result.riskLevel === 'Moderate'
                  ? 'bg-yellow-500 w-2/3'
                  : 'bg-red-500 w-full'
              }`}
            />
          </div>
        </div>

        {/* Nail Care Tips */}
        <div className="bg-gradient-to-br from-amber-50 to-white border-2 border-amber-200 rounded-2xl p-6">
          <div className="flex gap-3 mb-4">
            <Lightbulb className="w-5 h-5 text-amber-600 flex-shrink-0 mt-0.5" />
            <h3 className="text-sm font-semibold text-gray-900">Nail Care Tips</h3>
          </div>
          <ul className="space-y-2.5 ml-8">
            <li className="text-sm text-gray-700 leading-relaxed flex items-start gap-2">
              <span className="text-amber-600 mt-0.5">•</span>
              <span>Keep nails clean and dry</span>
            </li>
            <li className="text-sm text-gray-700 leading-relaxed flex items-start gap-2">
              <span className="text-amber-600 mt-0.5">•</span>
              <span>Avoid sharing nail tools</span>
            </li>
            <li className="text-sm text-gray-700 leading-relaxed flex items-start gap-2">
              <span className="text-amber-600 mt-0.5">•</span>
              <span>Trim nails regularly</span>
            </li>
            <li className="text-sm text-gray-700 leading-relaxed flex items-start gap-2">
              <span className="text-amber-600 mt-0.5">•</span>
              <span>Seek professional consultation if symptoms persist</span>
            </li>
          </ul>
        </div>

        {/* Recommendation */}
        <div className="bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-[#2563EB]/30 rounded-2xl p-6">
          <div className="flex gap-3">
            <AlertCircle className="w-5 h-5 text-[#2563EB] flex-shrink-0 mt-0.5" />
            <div>
              <h3 className="text-sm font-semibold text-[#2563EB] mb-2">Recommendation</h3>
              <p className="text-sm text-gray-700 leading-relaxed">
                This result is AI-generated and intended for preliminary screening only. Please
                consult a licensed healthcare professional for confirmation and treatment.
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom Button */}
      <div className="px-6 py-6 border-t border-blue-100 bg-white/80 backdrop-blur-sm">
        <button
          onClick={onScanAgain}
          className="w-full bg-gradient-to-r from-[#2563EB] to-[#1d4ed8] text-white py-4 px-6 rounded-2xl font-semibold hover:shadow-xl transition-all shadow-lg"
        >
          Scan Again
        </button>
      </div>
    </div>
  );
}