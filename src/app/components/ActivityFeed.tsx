export function ActivityFeed() {
  const activities = [
    {
      id: 1,
      user: 'Alex Morgan',
      action: 'completed task',
      target: 'Website Redesign',
      time: '5 minutes ago',
      avatar: 'bg-gradient-to-br from-blue-500 to-cyan-400',
    },
    {
      id: 2,
      user: 'Jamie Lee',
      action: 'uploaded file',
      target: 'Q1-Report.pdf',
      time: '1 hour ago',
      avatar: 'bg-gradient-to-br from-green-500 to-emerald-400',
    },
    {
      id: 3,
      user: 'Taylor Swift',
      action: 'commented on',
      target: 'Marketing Campaign',
      time: '2 hours ago',
      avatar: 'bg-gradient-to-br from-purple-500 to-pink-400',
    },
    {
      id: 4,
      user: 'Chris Evans',
      action: 'created project',
      target: 'Mobile App Development',
      time: '3 hours ago',
      avatar: 'bg-gradient-to-br from-orange-500 to-red-400',
    },
  ];

  return (
    <div className="bg-white rounded-xl border border-gray-200 p-6">
      <h2 className="font-semibold text-lg mb-4">Recent Activity</h2>
      <div className="space-y-4">
        {activities.map((activity) => (
          <div key={activity.id} className="flex items-start gap-3">
            <div className={`w-10 h-10 rounded-full ${activity.avatar} flex-shrink-0`} />
            <div className="flex-1 min-w-0">
              <p className="text-sm">
                <span className="font-medium text-gray-900">{activity.user}</span>{' '}
                <span className="text-gray-600">{activity.action}</span>{' '}
                <span className="font-medium text-gray-900">{activity.target}</span>
              </p>
              <p className="text-xs text-gray-500 mt-1">{activity.time}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
