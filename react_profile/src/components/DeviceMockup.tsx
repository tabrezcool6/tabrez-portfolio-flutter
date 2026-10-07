import React, { useState } from 'react';
import { 
  CheckCircle2, 
  Circle, 
  Send, 
  Sparkles, 
  Wifi, 
  Battery, 
  Heart, 
  Bookmark, 
  Search,
  Plus,
  Layers
} from 'lucide-react';

interface DeviceMockupProps {
  activeScreen?: string;
  onScreenChange?: (screen: string) => void;
}

export const DeviceMockup: React.FC<DeviceMockupProps> = ({ 
  activeScreen: externalScreen,
  onScreenChange 
}) => {
  const [internalScreen, setInternalScreen] = useState<'blog' | 'tasks' | 'chat' | 'widgets'>('blog');
  const activeTab = (externalScreen as 'blog' | 'tasks' | 'chat' | 'widgets') || internalScreen;

  const handleTabSelect = (tab: 'blog' | 'tasks' | 'chat' | 'widgets') => {
    setInternalScreen(tab);
    if (onScreenChange) onScreenChange(tab);
  };

  // Interactive state for tasks
  const [tasks, setTasks] = useState([
    { id: 1, title: 'Implement BLoC state transitions', done: true, priority: 'High' },
    { id: 2, title: 'Deployment on Play Store and App Store', done: true, priority: 'Critical' },
    { id: 3, title: 'Add widget pump tests for auth form', done: false, priority: 'Medium' },
    { id: 4, title: 'Profile 120 FPS sliver scroll performance', done: false, priority: 'High' },
  ]);
  const [newTaskInput, setNewTaskInput] = useState('');

  const toggleTask = (id: number) => {
    setTasks(prev => prev.map(t => t.id === id ? { ...t, done: !t.done } : t));
  };

  const addTask = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newTaskInput.trim()) return;
    setTasks(prev => [
      ...prev,
      { id: Date.now(), title: newTaskInput.trim(), done: false, priority: 'Normal' }
    ]);
    setNewTaskInput('');
  };

  // Interactive state for Connect Chat
  const [messages, setMessages] = useState([
    { id: 1, sender: 'Sameens Team', text: 'Hey Tabrez! How is the new Flutter release looking?', time: '10:41 AM', isMe: false },
    { id: 2, sender: 'Tabrez', text: 'Clean Architecture refactor is live. 0 frame drops, buttery 120 FPS!', time: '10:42 AM', isMe: true },
    { id: 3, sender: 'Sameens Team', text: 'Incredible work on the state stream isolation. Deploying now 🚀', time: '10:42 AM', isMe: false },
  ]);
  const [chatInput, setChatInput] = useState('');

  const sendChatMessage = (e: React.FormEvent) => {
    e.preventDefault();
    if (!chatInput.trim()) return;
    setMessages(prev => [
      ...prev,
      { id: Date.now(), sender: 'Tabrez', text: chatInput.trim(), time: '10:43 AM', isMe: true }
    ]);
    setChatInput('');
  };

  // Interactive state for InsightBlog
  const [likedArticles, setLikedArticles] = useState<Record<number, boolean>>({ 1: true });
  const [bookmarkedArticles, setBookmarkedArticles] = useState<Record<number, boolean>>({ 1: true });

  const toggleLike = (id: number) => {
    setLikedArticles(prev => ({ ...prev, [id]: !prev[id] }));
  };

  const toggleBookmark = (id: number) => {
    setBookmarkedArticles(prev => ({ ...prev, [id]: !prev[id] }));
  };

  // Interactive state for Widgets Matrix
  const [sliderValue, setSliderValue] = useState(75);
  const [activeChip, setActiveChip] = useState('BLoC');

  return (
    <div className="flex flex-col items-center w-full max-w-sm sm:max-w-md mx-auto">
      {/* Screen selector pills */}
      <div className="flex items-center gap-1.5 p-1 mb-6 bg-white/[0.06] backdrop-blur-md rounded-full border border-white/10 text-xs">
        <button
          type="button"
          onClick={() => handleTabSelect('blog')}
          className={`px-3 py-1.5 rounded-full font-medium transition-all cursor-pointer ${
            activeTab === 'blog' ? 'bg-white text-black shadow-md' : 'text-neutral-400 hover:text-white'
          }`}
        >
          Articles
        </button>
        <button
          type="button"
          onClick={() => handleTabSelect('tasks')}
          className={`px-3 py-1.5 rounded-full font-medium transition-all cursor-pointer ${
            activeTab === 'tasks' ? 'bg-white text-black shadow-md' : 'text-neutral-400 hover:text-white'
          }`}
        >
          iTask
        </button>
        <button
          type="button"
          onClick={() => handleTabSelect('chat')}
          className={`px-3 py-1.5 rounded-full font-medium transition-all cursor-pointer ${
            activeTab === 'chat' ? 'bg-white text-black shadow-md' : 'text-neutral-400 hover:text-white'
          }`}
        >
          Connect API
        </button>
        <button
          type="button"
          onClick={() => handleTabSelect('widgets')}
          className={`px-3 py-1.5 rounded-full font-medium transition-all cursor-pointer ${
            activeTab === 'widgets' ? 'bg-white text-black shadow-md' : 'text-neutral-400 hover:text-white'
          }`}
        >
          Flutter UI
        </button>
      </div>

      {/* iPhone 16 Pro Titanium Hardware Chassis */}
      <div className="relative w-[300px] sm:w-[340px] h-[620px] sm:h-[680px] bg-[#1a1a1c] rounded-[52px] p-3 shadow-[0_25px_60px_-15px_rgba(0,0,0,0.9),0_0_0_1px_rgba(255,255,255,0.15)] ring-1 ring-white/10">
        {/* Outer Titanium Edge Reflection */}
        <div className="absolute inset-0 rounded-[52px] border border-white/20 pointer-events-none opacity-40"></div>
        
        {/* Hardware side buttons simulation */}
        <div className="absolute -left-[3px] top-[115px] w-[3px] h-[28px] bg-neutral-600 rounded-l-sm" title="Action Button"></div>
        <div className="absolute -left-[3px] top-[160px] w-[3px] h-[50px] bg-neutral-600 rounded-l-sm" title="Volume Up"></div>
        <div className="absolute -left-[3px] top-[220px] w-[3px] h-[50px] bg-neutral-600 rounded-l-sm" title="Volume Down"></div>
        <div className="absolute -right-[3px] top-[170px] w-[3px] h-[75px] bg-neutral-600 rounded-r-sm" title="Power Button"></div>

        {/* OLED Screen Bezel */}
        <div className="relative w-full h-full bg-[#000000] rounded-[42px] overflow-hidden border border-black flex flex-col justify-between select-none">
          
          {/* Status Bar & Dynamic Island */}
          <div className="relative z-30 pt-3 px-6 flex items-center justify-between text-white text-[12px] font-medium tracking-tight">
            <span>9:41</span>
            
            {/* Dynamic Island */}
            <div className="absolute left-1/2 -translate-x-1/2 top-2.5 h-[28px] w-[96px] bg-black rounded-full flex items-center justify-between px-2.5 border border-white/10 shadow-inner group transition-all hover:w-[130px]">
              <div className="w-2.5 h-2.5 rounded-full bg-blue-500/80 animate-pulse"></div>
              <div className="text-[9px] text-neutral-400 font-mono tracking-tighter truncate opacity-0 group-hover:opacity-100 transition-opacity">
                Flutter 120Hz
              </div>
              <div className="w-2.5 h-2.5 rounded-full bg-emerald-500/80"></div>
            </div>

            <div className="flex items-center gap-1.5 text-neutral-300">
              <Wifi className="w-3.5 h-3.5" />
              <Battery className="w-3.5 h-3.5" />
            </div>
          </div>

          {/* Interactive Screen Content Container */}
          <div className="flex-1 overflow-y-auto px-4 pt-3 pb-8 text-neutral-100 text-xs">
            
            {/* SCREEN 1: InsightBlog */}
            {activeTab === 'blog' && (
              <div className="space-y-3.5 animate-fadeIn">
                <div className="flex items-center justify-between pt-1">
                  <div>
                    <span className="text-[10px] text-neutral-400 uppercase tracking-widest font-mono">InsightBlog</span>
                    <h4 className="text-base font-bold text-white tracking-tight">Today's Stories</h4>
                  </div>
                  <div className="w-7 h-7 rounded-full bg-neutral-800 border border-white/10 flex items-center justify-center">
                    <Search className="w-3.5 h-3.5 text-neutral-400" />
                  </div>
                </div>

                {/* Article Card 1 */}
                <div className="p-3.5 rounded-2xl bg-neutral-900/90 border border-white/10 space-y-2.5">
                  <div className="flex items-center justify-between text-[10px] text-neutral-400">
                    <span className="text-blue-400 font-medium">Architecture</span>
                    <span>4 min read</span>
                  </div>
                  <h5 className="text-sm font-semibold text-white leading-snug">
                    Mastering BLoC & Clean Architecture in Flutter
                  </h5>
                  <p className="text-neutral-400 text-[11px] line-clamp-2 leading-relaxed">
                    How separating presentation, domain, and data layers prevents UI regressions and keeps state immutable.
                  </p>
                  <div className="flex items-center justify-between pt-1 border-t border-white/5 text-neutral-400">
                    <button 
                      type="button"
                      onClick={() => toggleLike(1)} 
                      className={`flex items-center gap-1 cursor-pointer transition-colors ${likedArticles[1] ? 'text-rose-500' : 'hover:text-white'}`}
                    >
                      <Heart className="w-3.5 h-3.5" fill={likedArticles[1] ? 'currentColor' : 'none'} />
                      <span className="text-[10px]">{likedArticles[1] ? '143' : '142'}</span>
                    </button>
                    <button 
                      type="button"
                      onClick={() => toggleBookmark(1)} 
                      className={`cursor-pointer transition-colors ${bookmarkedArticles[1] ? 'text-amber-400' : 'hover:text-white'}`}
                    >
                      <Bookmark className="w-3.5 h-3.5" fill={bookmarkedArticles[1] ? 'currentColor' : 'none'} />
                    </button>
                  </div>
                </div>

                {/* Article Card 2 / Row 2 */}
                <div className="p-3.5 rounded-2xl bg-neutral-900/60 border border-white/5 space-y-2">
                  <div className="flex items-center justify-between text-[10px] text-neutral-400">
                    <span className="text-emerald-400 font-medium">Deployment</span>
                    <span>Store Release</span>
                  </div>
                  <h5 className="text-sm font-semibold text-white leading-snug">
                    Deployment on Play Store and App Store
                  </h5>
                  <p className="text-neutral-400 text-[11px] line-clamp-2">
                    Production CI/CD pipelines, release management, and app deployment on Google Play and Apple App Store.
                  </p>
                </div>
              </div>
            )}

            {/* SCREEN 2: iTask To Do List */}
            {activeTab === 'tasks' && (
              <div className="space-y-3 animate-fadeIn">
                <div className="flex items-center justify-between pt-1">
                  <div>
                    <span className="text-[10px] text-neutral-400 uppercase tracking-widest font-mono">iTask</span>
                    <h4 className="text-base font-bold text-white tracking-tight">Daily Tasks</h4>
                  </div>
                  <span className="text-[10px] px-2 py-0.5 rounded-full bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 font-mono">
                    Firebase DB
                  </span>
                </div>

                {/* Task items list */}
                <div className="space-y-2">
                  {tasks.map(task => (
                    <div
                      key={task.id}
                      onClick={() => toggleTask(task.id)}
                      className="flex items-start gap-2.5 p-2.5 rounded-xl bg-neutral-900/80 border border-white/5 hover:border-white/20 transition-all cursor-pointer group"
                    >
                      <button type="button" className="mt-0.5 text-neutral-400 group-hover:text-blue-400 transition-colors">
                        {task.done ? (
                          <CheckCircle2 className="w-4 h-4 text-blue-500 fill-blue-500/20" />
                        ) : (
                          <Circle className="w-4 h-4" />
                        )}
                      </button>
                      <div className="flex-1 min-w-0">
                        <p className={`text-[11px] font-medium leading-snug transition-all ${
                          task.done ? 'line-through text-neutral-500' : 'text-neutral-200'
                        }`}>
                          {task.title}
                        </p>
                        <span className="text-[9px] text-neutral-500 font-mono">{task.priority}</span>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Add task quick form */}
                <form onSubmit={addTask} className="flex items-center gap-1.5 pt-1">
                  <input
                    type="text"
                    value={newTaskInput}
                    onChange={(e) => setNewTaskInput(e.target.value)}
                    placeholder="Add task to Hive storage..."
                    className="flex-1 bg-neutral-900 border border-white/10 rounded-lg px-2.5 py-1.5 text-[11px] text-white placeholder-neutral-500 focus:outline-none focus:border-blue-500"
                  />
                  <button
                    type="submit"
                    className="p-1.5 bg-blue-600 hover:bg-blue-500 text-white rounded-lg transition-colors cursor-pointer"
                  >
                    <Plus className="w-3.5 h-3.5" />
                  </button>
                </form>
              </div>
            )}

            {/* SCREEN 3: Connect WebChat */}
            {activeTab === 'chat' && (
              <div className="space-y-3 flex flex-col h-full animate-fadeIn">
                <div className="flex items-center justify-between pt-1 border-b border-white/10 pb-2">
                  <div className="flex items-center gap-2">
                    <div className="w-7 h-7 rounded-full bg-gradient-to-tr from-blue-600 to-indigo-600 flex items-center justify-center font-bold text-[10px]">
                      S
                    </div>
                    <div>
                      <h4 className="text-xs font-semibold text-white">Sameens Mobile Team</h4>
                      <div className="flex items-center gap-1 text-[9px] text-emerald-400">
                        <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
                        <span>Socket.IO Live</span>
                      </div>
                    </div>
                  </div>
                  <span className="text-[9px] font-mono text-neutral-500">Node v20</span>
                </div>

                {/* Chat feed */}
                <div className="space-y-2 py-1 max-h-[220px] overflow-y-auto">
                  {messages.map(msg => (
                    <div 
                      key={msg.id} 
                      className={`flex flex-col ${msg.isMe ? 'items-end' : 'items-start'}`}
                    >
                      <div className={`max-w-[82%] px-3 py-2 rounded-2xl text-[11px] leading-relaxed ${
                        msg.isMe 
                          ? 'bg-blue-600 text-white rounded-br-sm' 
                          : 'bg-neutral-800 text-neutral-200 rounded-bl-sm border border-white/5'
                      }`}>
                        {msg.text}
                      </div>
                      <span className="text-[8px] text-neutral-500 mt-0.5 px-1">{msg.time}</span>
                    </div>
                  ))}
                </div>

                {/* Send chat message */}
                <form onSubmit={sendChatMessage} className="flex items-center gap-1.5 mt-auto pt-2">
                  <input
                    type="text"
                    value={chatInput}
                    onChange={(e) => setChatInput(e.target.value)}
                    placeholder="Type WebSocket event..."
                    className="flex-1 bg-neutral-900 border border-white/10 rounded-full px-3 py-1.5 text-[11px] text-white placeholder-neutral-500 focus:outline-none focus:border-blue-500"
                  />
                  <button
                    type="submit"
                    className="p-1.5 bg-blue-600 hover:bg-blue-500 text-white rounded-full transition-colors cursor-pointer"
                  >
                    <Send className="w-3 h-3" />
                  </button>
                </form>
              </div>
            )}

            {/* SCREEN 4: Flutter Widgets Matrix */}
            {activeTab === 'widgets' && (
              <div className="space-y-3.5 animate-fadeIn">
                <div className="flex items-center justify-between pt-1">
                  <div>
                    <span className="text-[10px] text-neutral-400 uppercase tracking-widest font-mono">CustomPainter</span>
                    <h4 className="text-base font-bold text-white tracking-tight">Widget Lab</h4>
                  </div>
                  <Layers className="w-4 h-4 text-blue-400" />
                </div>

                {/* Custom painter canvas simulation */}
                <div className="p-3 rounded-2xl bg-gradient-to-br from-neutral-900 to-neutral-950 border border-white/10 space-y-2.5">
                  <div className="flex items-center justify-between text-[10px] text-neutral-400">
                    <span>Dynamic Arc Painter</span>
                    <span className="font-mono text-blue-400">{sliderValue}%</span>
                  </div>
                  
                  {/* Visual gauge rendering */}
                  <div className="h-16 flex items-center justify-center relative">
                    <svg className="w-24 h-16" viewBox="0 0 100 60">
                      <path
                        d="M 10 50 A 40 40 0 0 1 90 50"
                        fill="none"
                        stroke="#27272a"
                        strokeWidth="8"
                        strokeLinecap="round"
                      />
                      <path
                        d="M 10 50 A 40 40 0 0 1 90 50"
                        fill="none"
                        stroke="url(#blueGrad)"
                        strokeWidth="8"
                        strokeDasharray="126"
                        strokeDashoffset={126 - (126 * sliderValue) / 100}
                        strokeLinecap="round"
                        className="transition-all duration-300"
                      />
                      <defs>
                        <linearGradient id="blueGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                          <stop offset="0%" stopColor="#2997ff" />
                          <stop offset="100%" stopColor="#bf5af2" />
                        </linearGradient>
                      </defs>
                    </svg>
                    <div className="absolute top-7 text-center">
                      <span className="text-xs font-bold text-white font-mono">{sliderValue} FPS</span>
                    </div>
                  </div>

                  <input
                    type="range"
                    min="10"
                    max="120"
                    value={sliderValue}
                    onChange={(e) => setSliderValue(Number(e.target.value))}
                    className="w-full h-1 bg-neutral-800 rounded-lg appearance-none cursor-pointer accent-blue-500"
                  />
                </div>

                {/* Pattern selector */}
                <div className="space-y-1.5">
                  <span className="text-[10px] text-neutral-400">Pattern Selector:</span>
                  <div className="grid grid-cols-4 gap-1 text-[10px] text-center">
                    {['BLoC', 'Provider', 'GoRouter', 'GetIt'].map((pattern) => (
                      <button
                        key={pattern}
                        type="button"
                        onClick={() => setActiveChip(pattern)}
                        className={`py-1 rounded-lg border transition-all cursor-pointer truncate ${
                          activeChip === pattern
                            ? 'bg-white/10 border-blue-500/50 text-blue-400 font-semibold'
                            : 'border-white/5 bg-neutral-900/50 text-neutral-400 hover:text-white'
                        }`}
                      >
                        {pattern}
                      </button>
                    ))}
                  </div>
                </div>
              </div>
            )}
          </div>

          {/* iOS Bottom Home Bar */}
          <div className="relative z-30 pb-2 flex justify-center">
            <div className="w-32 h-1 bg-white/40 rounded-full"></div>
          </div>
        </div>
      </div>

      {/* Interactive Helper Tip */}
      <p className="mt-4 text-xs text-neutral-500 text-center flex items-center gap-1.5">
        <Sparkles className="w-3.5 h-3.5 text-blue-400" />
        <span>Interactive mockup: Tap screens, add tasks, or send messages</span>
      </p>
    </div>
  );
};
