import { Home, BarChart3, Users, Settings, FileText, Calendar, Bell } from 'lucide-react';

export function Sidebar() {
  const menuItems = [
    { icon: Home, label: 'Dashboard', active: true },
    { icon: BarChart3, label: 'Analytics', active: false },
    { icon: Users, label: 'Team', active: false },
    { icon: FileText, label: 'Projects', active: false },
    { icon: Calendar, label: 'Calendar', active: false },
    { icon: Bell, label: 'Notifications', active: false },
    { icon: Settings, label: 'Settings', active: false },
  ];

  return (
    <aside className="w-64 bg-white border-r border-gray-200 flex flex-col">
      {/* Logo */}
      <div className="p-6 border-b border-gray-200">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 bg-gradient-to-br from-purple-600 to-blue-500 rounded-lg" />
          <span className="font-semibold text-xl">AppName</span>
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex-1 p-4">
        <ul className="space-y-1">
          {menuItems.map((item) => (
            <li key={item.label}>
              <button
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${
                  item.active
                    ? 'bg-purple-50 text-purple-700'
                    : 'text-gray-600 hover:bg-gray-50'
                }`}
              >
                <item.icon className="w-5 h-5" />
                <span>{item.label}</span>
              </button>
            </li>
          ))}
        </ul>
      </nav>

      {/* User Profile */}
      <div className="p-4 border-t border-gray-200">
        <div className="flex items-center gap-3 p-3 rounded-lg hover:bg-gray-50 cursor-pointer">
          <div className="w-10 h-10 bg-gradient-to-br from-pink-500 to-orange-400 rounded-full" />
          <div className="flex-1 min-w-0">
            <p className="font-medium text-sm truncate">Sarah Johnson</p>
            <p className="text-xs text-gray-500 truncate">sarah@company.com</p>
          </div>
        </div>
      </div>
    </aside>
  );
}
