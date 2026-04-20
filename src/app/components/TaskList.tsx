import { CheckCircle2, Circle, MoreVertical } from 'lucide-react';

export function TaskList() {
  const tasks = [
    { id: 1, title: 'Design new landing page', completed: true, priority: 'high' },
    { id: 2, title: 'Update API documentation', completed: false, priority: 'medium' },
    { id: 3, title: 'Review pull requests', completed: false, priority: 'high' },
    { id: 4, title: 'Client meeting preparation', completed: true, priority: 'low' },
    { id: 5, title: 'Fix responsive issues', completed: false, priority: 'medium' },
  ];

  const priorityColors = {
    high: 'bg-red-100 text-red-700',
    medium: 'bg-yellow-100 text-yellow-700',
    low: 'bg-green-100 text-green-700',
  };

  return (
    <div className="bg-white rounded-xl border border-gray-200 p-6">
      <div className="flex items-center justify-between mb-4">
        <h2 className="font-semibold text-lg">Tasks</h2>
        <button className="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors text-sm">
          New Task
        </button>
      </div>
      <div className="space-y-3">
        {tasks.map((task) => (
          <div
            key={task.id}
            className="flex items-center gap-3 p-3 rounded-lg hover:bg-gray-50 group"
          >
            <button className="text-gray-400 hover:text-purple-600">
              {task.completed ? (
                <CheckCircle2 className="w-5 h-5 text-purple-600" />
              ) : (
                <Circle className="w-5 h-5" />
              )}
            </button>
            <span
              className={`flex-1 text-sm ${
                task.completed ? 'line-through text-gray-400' : 'text-gray-700'
              }`}
            >
              {task.title}
            </span>
            <span
              className={`px-2 py-1 rounded text-xs font-medium ${
                priorityColors[task.priority as keyof typeof priorityColors]
              }`}
            >
              {task.priority}
            </span>
            <button className="opacity-0 group-hover:opacity-100 text-gray-400 hover:text-gray-600">
              <MoreVertical className="w-4 h-4" />
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
