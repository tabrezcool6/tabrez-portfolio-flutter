import React from 'react';
import { 
  Layers, 
  Database, 
  Wifi, 
  ShieldCheck, 
  Cloud 
} from 'lucide-react';

export const BentoGrid: React.FC = () => {
  return (
    <section id="engineering" className="py-20 sm:py-28 relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        
        {/* Section Header */}
        <div className="max-w-3xl space-y-3">
          <p className="text-xs font-mono uppercase tracking-widest text-blue-400">
            Core Architecture
          </p>
          <h2 className="text-3xl sm:text-5xl font-bold tracking-tight text-white leading-tight text-balance">
            Engineered from the core. <br />
            <span className="text-neutral-400">Built to withstand scale.</span>
          </h2>
          <p className="text-base sm:text-lg text-neutral-400 leading-relaxed text-balance">
            Every Flutter application is built atop strict separation of concerns, deterministic 
            state streams, and offline-first reliability.
          </p>
        </div>

        {/* Apple-style Bento Layout */}
        <div className="grid grid-cols-1 md:grid-cols-12 gap-6">
          
          {/* Bento Card 1: Clean Architecture & BLoC Engine (Span 7 cols) */}
          <div className="md:col-span-7 rounded-3xl bg-[#121214] border border-white/10 p-6 sm:p-8 flex flex-col justify-between hover:border-white/20 transition-all group relative overflow-hidden">
            <div className="space-y-4 relative z-10">
              <div className="flex items-center justify-between">
                <div className="w-10 h-10 rounded-2xl bg-blue-600/10 border border-blue-500/20 flex items-center justify-center text-blue-400">
                  <Layers className="w-5 h-5" />
                </div>
                <span className="text-xs font-mono text-neutral-400">Layered Separation</span>
              </div>

              <div>
                <h3 className="text-xl sm:text-2xl font-bold text-white tracking-tight">
                  Clean Architecture & BLoC State
                </h3>
                <p className="text-neutral-400 text-sm mt-2 leading-relaxed">
                  Decoupled Presentation, Domain, and Data boundaries. Unidirectional event-to-state 
                  pipelines eliminate side effects and guarantee predictable UI rendering.
                </p>
              </div>

              {/* Architectural Layer Diagram */}
              <div className="pt-4 space-y-2.5">
                <div className="p-3 rounded-xl bg-neutral-900/90 border border-white/10 flex items-center justify-between">
                  <div>
                    <span className="text-xs font-semibold text-white">Presentation Layer</span>
                    <p className="text-[11px] text-neutral-400">Flutter Widgets · BlocBuilder · Page Routers</p>
                  </div>
                  <span className="text-[10px] font-mono text-blue-400">UI / Events</span>
                </div>

                <div className="p-3 rounded-xl bg-neutral-900/90 border border-blue-500/30 flex items-center justify-between">
                  <div>
                    <span className="text-xs font-semibold text-white">Domain Layer</span>
                    <p className="text-[11px] text-neutral-400">UseCases · Entities · Repository Contracts</p>
                  </div>
                  <span className="text-[10px] font-mono text-emerald-400">Pure Business Logic</span>
                </div>

                <div className="p-3 rounded-xl bg-neutral-900/90 border border-white/10 flex items-center justify-between">
                  <div>
                    <span className="text-xs font-semibold text-white">Data Layer</span>
                    <p className="text-[11px] text-neutral-400">Models · Remote DataSources · Local Cache</p>
                  </div>
                  <span className="text-[10px] font-mono text-purple-400">APIs & Hive/SQFLite</span>
                </div>
              </div>
            </div>

            <div className="pt-6 border-t border-white/5 mt-6 flex items-center gap-3 text-xs text-neutral-400">
              <span>S.O.L.I.D Compliance</span>
              <span aria-hidden="true">·</span>
              <span>Dependency Inversion</span>
              <span aria-hidden="true">·</span>
              <span>GetIt Service Locator</span>
            </div>
          </div>

          {/* Bento Card 2: Offline Persistence Engine (Span 5 cols) */}
          <div className="md:col-span-5 rounded-3xl bg-[#121214] border border-white/10 p-6 sm:p-8 flex flex-col justify-between hover:border-white/20 transition-all group">
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div className="w-10 h-10 rounded-2xl bg-amber-500/10 border border-amber-500/20 flex items-center justify-center text-amber-400">
                  <Database className="w-5 h-5" />
                </div>
                <span className="text-xs font-mono text-neutral-400">&lt;2ms Reads</span>
              </div>

              <div>
                <h3 className="text-xl sm:text-2xl font-bold text-white tracking-tight">
                  Offline-First Persistence
                </h3>
                <p className="text-neutral-400 text-sm mt-2 leading-relaxed">
                  Fast, resilient local storage architecture. Applications work effortlessly offline, 
                  instantaneously reading from local binary stores and syncing when network resumes.
                </p>
              </div>

              {/* Cache Hierarchy Metrics */}
              <div className="space-y-3 pt-3">
                <div className="flex items-center justify-between p-3 rounded-xl bg-neutral-900/80 border border-white/5">
                  <span className="text-xs font-medium text-neutral-200">Hive NoSQL Box</span>
                  <span className="text-xs font-mono text-amber-400">Key-Value &lt;1ms</span>
                </div>
                <div className="flex items-center justify-between p-3 rounded-xl bg-neutral-900/80 border border-white/5">
                  <span className="text-xs font-medium text-neutral-200">SQFLite Relational</span>
                  <span className="text-xs font-mono text-blue-400">ACID Transactions</span>
                </div>
                <div className="flex items-center justify-between p-3 rounded-xl bg-neutral-900/80 border border-white/5">
                  <span className="text-xs font-medium text-neutral-200">SharedPreferences</span>
                  <span className="text-xs font-mono text-purple-400">Config & Tokens</span>
                </div>
              </div>
            </div>

            <div className="pt-6 border-t border-white/5 mt-6 flex items-center gap-3 text-xs text-neutral-400">
              <span>Zero Native Overhead</span>
              <span aria-hidden="true">·</span>
              <span>Encrypted Boxes</span>
            </div>
          </div>

          {/* Bento Card 3: Realtime & Event Streaming (Span 4 cols) */}
          <div className="md:col-span-4 rounded-3xl bg-[#121214] border border-white/10 p-6 sm:p-8 flex flex-col justify-between hover:border-white/20 transition-all">
            <div className="space-y-4">
              <div className="w-10 h-10 rounded-2xl bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400">
                <Wifi className="w-5 h-5" />
              </div>

              <div>
                <h3 className="text-lg sm:text-xl font-bold text-white tracking-tight">
                  Realtime Sockets & APIs
                </h3>
                <p className="text-neutral-400 text-xs sm:text-sm mt-2 leading-relaxed">
                  Persistent bidirectional WebSocket connections with Socket.IO and Node.js. 
                  Resilient reconnect hooks and heartbeat telemetry.
                </p>
              </div>

              <div className="p-3 rounded-xl bg-neutral-900/90 border border-white/5 font-mono text-[11px] text-neutral-300 space-y-1">
                <div className="text-neutral-500">{"// Socket Channel Sync"}</div>
                <div className="text-emerald-400">socket.on('stream:sync')</div>
                <div className="text-neutral-400">ping: &lt;45ms · jitter: 2ms</div>
              </div>
            </div>

            <div className="pt-6 border-t border-white/5 mt-4 text-xs text-neutral-500">
              WebSockets · Postman Verified · RESTful Contracts
            </div>
          </div>

          {/* Bento Card 4: Automated Testing & Verification (Span 4 cols) */}
          <div className="md:col-span-4 rounded-3xl bg-[#121214] border border-white/10 p-6 sm:p-8 flex flex-col justify-between hover:border-white/20 transition-all">
            <div className="space-y-4">
              <div className="w-10 h-10 rounded-2xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center text-purple-400">
                <ShieldCheck className="w-5 h-5" />
              </div>

              <div>
                <h3 className="text-lg sm:text-xl font-bold text-white tracking-tight">
                  TDD & Test Automation
                </h3>
                <p className="text-neutral-400 text-xs sm:text-sm mt-2 leading-relaxed">
                  Author of technical testing masterclasses on Medium. Exhaustive Widget tests, 
                  Integration flows, and unit verification before production rollout.
                </p>
              </div>

              <div className="p-3 rounded-xl bg-neutral-900/90 border border-white/5 font-mono text-[11px] text-neutral-300 space-y-1">
                <div className="text-emerald-400">✓ testWidgets('Pumps Counter')</div>
                <div className="text-emerald-400">✓ integrationTest('Auth Flow')</div>
                <div className="text-emerald-400">{"✓ blocTest('Emits Loading -> Loaded')"}</div>
              </div>
            </div>

            <div className="pt-6 border-t border-white/5 mt-4 text-xs text-neutral-500">
              Medium Published · Automated CI Pipeline
            </div>
          </div>

          {/* Bento Card 5: Cloud & Infrastructure (Span 4 cols) */}
          <div className="md:col-span-4 rounded-3xl bg-[#121214] border border-white/10 p-6 sm:p-8 flex flex-col justify-between hover:border-white/20 transition-all">
            <div className="space-y-4">
              <div className="w-10 h-10 rounded-2xl bg-cyan-500/10 border border-cyan-500/20 flex items-center justify-center text-cyan-400">
                <Cloud className="w-5 h-5" />
              </div>

              <div>
                <h3 className="text-lg sm:text-xl font-bold text-white tracking-tight">
                  Cloud & Infrastructure
                </h3>
                <p className="text-neutral-400 text-xs sm:text-sm mt-2 leading-relaxed">
                  Actively engineering with Firebase Functions, Google Play Services, 
                  and resilient cloud-connected mobile architectures.
                </p>
              </div>

              <div className="space-y-2">
                <div className="flex items-center justify-between text-xs p-2 rounded-lg bg-neutral-900/60 border border-white/5">
                  <span className="text-neutral-300 font-medium">Appscripts (Google Apps Script)</span>
                  <span className="text-[10px] font-mono text-cyan-400">Serverless Automation</span>
                </div>
                <div className="flex items-center justify-between text-xs p-2 rounded-lg bg-neutral-900/60 border border-white/5">
                  <span className="text-neutral-300 font-medium">Firebase Functions</span>
                  <span className="text-[10px] font-mono text-cyan-400">Serverless Backend</span>
                </div>
                <div className="flex items-center justify-between text-xs p-2 rounded-lg bg-neutral-900/60 border border-white/5">
                  <span className="text-neutral-300 font-medium">Google Play Services</span>
                  <span className="text-[10px] font-mono text-cyan-400">Auth · Maps · Billing</span>
                </div>
              </div>
            </div>

            <div className="pt-6 border-t border-white/5 mt-4 text-xs text-neutral-500">
              Cloud Ecosystem · Mobile Services
            </div>
          </div>

        </div>

      </div>
    </section>
  );
};
