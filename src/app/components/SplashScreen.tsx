import exampleImage from 'figma:asset/aac5a374fafc1c0435de509591b1922bf8fbab33.png';

export function SplashScreen() {
  return (
    <div className="h-full bg-gradient-to-b from-blue-50 to-white flex flex-col items-center justify-between px-6 py-12" style={{ fontFamily: 'Inter, sans-serif' }}>
      {/* Top Section - 40% space */}
      <div className="flex-[4] flex items-center justify-center">
        <div className="w-32 h-32 flex items-center justify-center">
          <img src={exampleImage} alt="NailScan Logo" className="w-full h-full object-contain drop-shadow-2xl rounded-3xl" />
        </div>
      </div>

      {/* Center Section */}
      <div className="flex-[6] flex flex-col items-center justify-center text-center px-4">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          NailScan
        </h1>
        <p className="text-gray-600 text-base max-w-xs leading-relaxed">
          AI-Powered Nail Health Analysis
        </p>
      </div>

      {/* Bottom Section */}
      <div className="flex-[2] flex items-center justify-center">
        <div className="flex gap-2">
          <div className="w-2 h-2 bg-[#2563EB] rounded-full animate-bounce" style={{ animationDelay: '0ms' }} />
          <div className="w-2 h-2 bg-[#2563EB] rounded-full animate-bounce" style={{ animationDelay: '150ms' }} />
          <div className="w-2 h-2 bg-[#2563EB] rounded-full animate-bounce" style={{ animationDelay: '300ms' }} />
        </div>
      </div>
    </div>
  );
}