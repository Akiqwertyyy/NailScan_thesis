import { LineChart, Line, AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

const data = [
  { name: 'Jan', value: 4000, visitors: 2400 },
  { name: 'Feb', value: 3000, visitors: 1398 },
  { name: 'Mar', value: 2000, visitors: 9800 },
  { name: 'Apr', value: 2780, visitors: 3908 },
  { name: 'May', value: 1890, visitors: 4800 },
  { name: 'Jun', value: 2390, visitors: 3800 },
  { name: 'Jul', value: 3490, visitors: 4300 },
];

export function ChartCard() {
  return (
    <div className="bg-white rounded-xl border border-gray-200 p-6">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h2 className="font-semibold text-lg">Revenue Overview</h2>
          <p className="text-sm text-gray-500 mt-1">Monthly performance metrics</p>
        </div>
        <select className="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-purple-500">
          <option>Last 6 months</option>
          <option>Last year</option>
        </select>
      </div>
      <ResponsiveContainer width="100%" height={300}>
        <AreaChart data={data}>
          <defs>
            <linearGradient id="colorValue" x1="0" y1="0" x2="0" y2="1">
              <stop offset="5%" stopColor="#8b5cf6" stopOpacity={0.3} />
              <stop offset="95%" stopColor="#8b5cf6" stopOpacity={0} />
            </linearGradient>
          </defs>
          <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
          <XAxis dataKey="name" stroke="#9ca3af" fontSize={12} />
          <YAxis stroke="#9ca3af" fontSize={12} />
          <Tooltip />
          <Area
            type="monotone"
            dataKey="value"
            stroke="#8b5cf6"
            strokeWidth={2}
            fillOpacity={1}
            fill="url(#colorValue)"
          />
        </AreaChart>
      </ResponsiveContainer>
    </div>
  );
}
