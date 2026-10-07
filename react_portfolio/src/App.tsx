/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useEffect, useState } from 'react';
import { flushSync } from 'react-dom';
import { Navbar } from './components/Navbar';
import { Hero } from './components/Hero';
import { BentoGrid } from './components/BentoGrid';
import { ProjectShowcase } from './components/ProjectShowcase';
import { CodeInspector } from './components/CodeInspector';
import { CompareMatrix } from './components/CompareMatrix';
import { ExperienceTimeline } from './components/ExperienceTimeline';
import { ContactSection } from './components/ContactSection';
import { Footer } from './components/Footer';
import { SimplePortfolio } from './components/SimplePortfolio';

type View = 'apple' | 'simple';
const VIEW_STORAGE_KEY = 'portfolio-view';

// ?view=simple|developer wins (shareable links; the older ?view=apple still
// works); otherwise the visitor's last choice.
const readInitialView = (): View => {
  const fromUrl = new URLSearchParams(window.location.search).get('view');
  if (fromUrl === 'simple') return 'simple';
  if (fromUrl === 'developer' || fromUrl === 'apple') return 'apple';
  try {
    return localStorage.getItem(VIEW_STORAGE_KEY) === 'simple' ? 'simple' : 'apple';
  } catch {
    return 'apple';
  }
};

export default function App() {
  const [view, setView] = useState<View>(readInitialView);
  // Plain fade-in, only used where the View Transitions API is unavailable.
  const [fallbackFade, setFallbackFade] = useState(false);

  // The simple view's page-level styles (scrollbar, scroll padding) key off this class.
  useEffect(() => {
    document.documentElement.classList.toggle('sp-active', view === 'simple');
  }, [view]);

  const applyView = (next: View) => {
    setView(next);
    document.documentElement.classList.toggle('sp-active', next === 'simple');
    try {
      localStorage.setItem(VIEW_STORAGE_KEY, next);
    } catch {
      // storage unavailable (private mode) — the URL still carries the choice
    }
    const url = new URL(window.location.href);
    url.searchParams.set('view', next === 'simple' ? 'simple' : 'developer');
    url.hash = '';
    window.history.replaceState(null, '', url);
    window.scrollTo({ top: 0, behavior: 'instant' as ScrollBehavior });
  };

  // Apple-style "zoom-through": the current site shrinks, blurs and fades to
  // black, then the new one settles in from a slight zoom (see index.css).
  // The View Transitions API animates page snapshots, so fixed navbars stay put.
  const switchView = (next: View) => {
    const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    const doc = document as Document & { startViewTransition?: (update: () => void) => unknown };
    if (!reduceMotion && typeof doc.startViewTransition === 'function') {
      setFallbackFade(false);
      doc.startViewTransition(() => flushSync(() => applyView(next)));
    } else {
      setFallbackFade(!reduceMotion);
      applyView(next);
    }
  };

  if (view === 'simple') {
    return (
      <div key="simple" className={fallbackFade ? 'view-fade-in' : undefined}>
        <SimplePortfolio onSwitchView={() => switchView('apple')} />
      </div>
    );
  }

  const scrollToContact = () => {
    const contactElement = document.getElementById('contact');
    if (contactElement) {
      contactElement.scrollIntoView({ behavior: 'smooth' });
      setTimeout(() => {
        const input = document.getElementById('contact-name');
        if (input) input.focus();
      }, 500);
    }
  };

  const scrollToProjects = () => {
    const projectsElement = document.getElementById('projects');
    if (projectsElement) {
      projectsElement.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <div key="apple" className={`${fallbackFade ? 'view-fade-in ' : ''}min-h-screen bg-black text-[#f5f5f7] flex flex-col font-sans selection:bg-blue-600 selection:text-white`}>
      {/* Apple Frosted Navbar */}
      <Navbar onOpenContact={scrollToContact} onSwitchView={() => switchView('simple')} />

      {/* Main Content Area */}
      <main className="flex-1 w-full">
        {/* Apple Keynote Hero with Interactive iPhone 16 Pro */}
        <Hero 
          onOpenContact={scrollToContact}
          onExploreProjects={scrollToProjects}
        />

        {/* Apple M-Series Silicon Style Architecture Bento Grid */}
        <BentoGrid />

        {/* Featured Projects Lineup */}
        <ProjectShowcase />

        {/* Apple macOS Code Inspector */}
        <CodeInspector />

        {/* Apple Compare Models Style Capabilities Matrix */}
        <CompareMatrix />

        {/* Experience Trajectory & Medium Articles */}
        <ExperienceTimeline />

        {/* Apple Specialist Contact & Inquiry Desk */}
        <ContactSection />
      </main>

      {/* Apple Clean Footer */}
      <Footer />
    </div>
  );
}
