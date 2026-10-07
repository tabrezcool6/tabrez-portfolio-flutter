import React from 'react';
import { ArrowDown, Sparkles, Code2, Layers, Cpu } from 'lucide-react';
import { PERSONAL_INFO, STATS } from '../data/portfolioData';
import { DeviceMockup } from './DeviceMockup';

interface HeroProps {
  onOpenContact: () => void;
  onExploreProjects: () => void;
}

export const Hero: React.FC<HeroProps> = ({ onOpenContact, onExploreProjects }) => {
  return (
    <section id="overview" className="relative pt-24 sm:pt-32 pb-16 sm:pb-24 overflow-hidden">
      {/* Subtle Apple-style Ambient Lighting */}
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] sm:w-[900px] h-[400px] sm:h-[550px] bg-gradient-to-b from-blue-600/15 via-indigo-600/10 to-transparent blur-[120px] pointer-events-none rounded-full" />
      
      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Main Keynote Text Hierarchy */}
        <div className="text-center max-w-4xl mx-auto space-y-4 sm:space-y-6">
          
          {/* Subtle Kicker */}
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/[0.06] border border-white/10 text-xs text-neutral-300 font-medium">
            <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
            <span>Flutter Engineer · Rokkun Bengaluru</span>
          </div>

          {/* Primary Display Headline with Apple Titanium Sheen */}
          <h1 className="text-4xl sm:text-6xl md:text-7xl font-bold tracking-tight text-white leading-[1.08] text-balance">
            Mobile Engineering. <br className="hidden sm:inline" />
            <span className="apple-titanium-gradient">Down to the pixel.</span>
          </h1>

          {/* Apple Sub-headline Prose */}
          <p className="text-lg sm:text-xl text-neutral-400 font-normal leading-relaxed max-w-2xl mx-auto text-balance">
            Hi, I'm <strong className="text-white font-medium">{PERSONAL_INFO.name}</strong>. I architect buttery, 
            high-refresh cross-platform mobile experiences with Flutter, Dart, Clean Architecture, 
            and Native Android.
          </p>

          {/* Primary Action Buttons */}
          <div className="flex flex-wrap items-center justify-center gap-3 sm:gap-4 pt-2">
            <button
              type="button"
              onClick={onExploreProjects}
              className="px-6 py-3 bg-blue-600 hover:bg-blue-500 text-white rounded-full font-medium text-sm transition-all shadow-lg shadow-blue-600/25 hover:shadow-blue-500/40 active:scale-95 cursor-pointer"
            >
              Explore Applications
            </button>
            <button
              type="button"
              onClick={onOpenContact}
              className="px-6 py-3 bg-neutral-900 hover:bg-neutral-800 text-neutral-200 hover:text-white rounded-full font-medium text-sm border border-white/10 hover:border-white/20 transition-all active:scale-95 cursor-pointer"
            >
              Connect with Tabrez
            </button>
          </div>
        </div>

        {/* Centerpiece: Interactive iPhone 16 Pro Device Mockup */}
        <div className="mt-12 sm:mt-16 flex justify-center">
          <DeviceMockup />
        </div>

        {/* Apple By-The-Numbers Spec Strip */}
        <div className="mt-16 sm:mt-24 pt-12 border-t border-white/10 grid grid-cols-2 md:grid-cols-4 gap-6 sm:gap-8">
          {STATS.map((stat, idx) => (
            <div key={idx} className="text-center md:text-left space-y-1">
              <div className="text-3xl sm:text-4xl font-extrabold text-white tracking-tight font-mono tabular-nums">
                {stat.value}
              </div>
              <div className="text-xs sm:text-sm font-semibold text-neutral-300">
                {stat.label}
              </div>
              <div className="text-xs text-neutral-500">
                {stat.subtext}
              </div>
            </div>
          ))}
        </div>

      </div>
    </section>
  );
};
