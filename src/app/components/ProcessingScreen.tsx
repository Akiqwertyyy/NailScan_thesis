export function ProcessingScreen() {
  return (
    <div className="h-full bg-gradient-to-b from-blue-50 to-white flex flex-col items-center justify-center px-6" style={{ fontFamily: 'Inter, sans-serif' }}>
      {/* Loading Spinner */}
      <div className="mb-8">
        <div className="w-20 h-20 border-4 border-blue-100 border-t-[#2563EB] rounded-full animate-spin" />
      </div>

      {/* Text */}
      <div className="text-center max-w-sm">
        <p className="text-gray-900 text-xl font-semibold mb-2">
          Analyzing your nail...
        </p>
        <p className="text-gray-600 leading-relaxed">
          Our AI is examining color, shape, and texture patterns
        </p>
        <p className="text-gray-400 text-sm mt-4">(EfficientNetV2-L)</p>
      </div>
    </div>
  );
}