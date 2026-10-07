import React from 'react';
import { ArrowUp } from 'lucide-react';
import { PERSONAL_INFO } from '../data/portfolioData';

export const Footer: React.FC = () => {
  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <footer className="bg-[#050505] border-t border-white/10 text-neutral-400 text-xs py-14 sm:py-16">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-10">
        
        {/* Footnote / Disclaimer section like Apple */}
        <div className="space-y-3 pb-8 border-b border-white/5 text-[11px] text-neutral-500 leading-relaxed">
          <p>
            1. 120 FPS performance targets are profiled on 120Hz ProMotion displays with zero frame jitter 
            using Flutter's DevTools performance overlay and Skia/Impeller graphics pipelines.
          </p>
          <p>
            2. Architectural references and test coverage adhere to Clean Architecture, S.O.L.I.D principles, 
            and automated test pyramids as detailed in Syed's published technical articles on Medium.
          </p>
          <p>
            3. All trademarks, device silhouettes, and product references belong to their respective owners. 
            Portfolio engineered with Apple human interface design principles.
          </p>
        </div>

        {/* Directory Columns */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div className="space-y-3">
            <h4 className="text-white font-semibold tracking-tight text-xs">Navigation</h4>
            <ul className="space-y-2">
              <li><a href="#overview" className="hover:text-white transition-colors">Overview</a></li>
              <li><a href="#engineering" className="hover:text-white transition-colors">Core Specs</a></li>
              <li><a href="#projects" className="hover:text-white transition-colors">Featured Works</a></li>
              <li><a href="#architecture" className="hover:text-white transition-colors">Code Engine</a></li>
              <li><a href="#experience" className="hover:text-white transition-colors">Trajectory</a></li>
            </ul>
          </div>

          <div className="space-y-3">
            <h4 className="text-white font-semibold tracking-tight text-xs">Featured Projects</h4>
            <ul className="space-y-2">
              <li><a href="https://play.google.com/store/apps/details?id=com.sameens.store" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">Sameens App</a></li>
              <li><a href="https://sameens.com" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">Sameens Store</a></li>
              <li><a href="https://staging-admin.sameens.com" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">Sameens Dashboard</a></li>
              <li><a href="https://play.google.com/store/apps/details?id=com.xsar.handwriter" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">Handwriter Android</a></li>
              <li><a href="https://github.com/tabrezcool6/iTask-ToDoListApp" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">iTask</a></li>
            </ul>
          </div>

          <div className="space-y-3">
            <h4 className="text-white font-semibold tracking-tight text-xs">Articles & Insights</h4>
            <ul className="space-y-2">
              <li><a href="https://medium.com/@tabrezcool6/how-to-pick-image-from-camera-and-gallery-flutter-2023-2faa1d104eee" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">Pick Image from Camera & Gallery</a></li>
              <li><a href="https://medium.com/@tabrezcool6/unit-tests-for-an-api-in-flutter-2025-e8f162ec9f46" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">Unit Tests for an API in Flutter</a></li>
              <li><a href="https://medium.com/@tabrezcool6/widget-tests-for-a-counter-class-in-flutter-2025-c8c919d7ca88" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">Widget Tests for a Counter Class</a></li>
              <li><a href="https://medium.com/@tabrezcool6/integration-tests-for-a-login-page-in-flutter-2025-9e09f8049181" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">Integration Tests for a Login Page</a></li>
              <li><a href="https://medium.com/@tabrezcool6" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">Medium Articles Hub</a></li>
            </ul>
          </div>

          <div className="space-y-3">
            <h4 className="text-white font-semibold tracking-tight text-xs">Direct Connect</h4>
            <ul className="space-y-2">
              <li><a href={`mailto:${PERSONAL_INFO.email}`} className="hover:text-white transition-colors">Mail: {PERSONAL_INFO.email}</a></li>
              <li><a href={PERSONAL_INFO.linkedin} target="_blank" rel="noreferrer" className="hover:text-white transition-colors">LinkedIn: syed-tabrez-pasha-s</a></li>
              <li className="text-neutral-500 font-mono text-[11px] pt-1">{PERSONAL_INFO.location}</li>
            </ul>
          </div>
        </div>

        {/* Bottom Line Bar */}
        <div className="pt-8 border-t border-white/5 flex flex-col sm:flex-row items-center justify-between gap-4 text-neutral-500">
          <div className="flex flex-wrap items-center gap-2 text-center sm:text-left">
            <span>Copyright © {new Date().getFullYear()} {PERSONAL_INFO.name}.</span>
            <span aria-hidden="true" className="hidden sm:inline">·</span>
            <span>All rights reserved.</span>
          </div>

          <button
            type="button"
            onClick={scrollToTop}
            className="flex items-center gap-1.5 text-neutral-400 hover:text-white transition-colors cursor-pointer text-xs"
          >
            <span>Back to top</span>
            <ArrowUp className="w-3.5 h-3.5" />
          </button>
        </div>

      </div>
    </footer>
  );
};
