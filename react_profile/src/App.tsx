/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React from 'react';
import { Navbar } from './components/Navbar';
import { Hero } from './components/Hero';
import { BentoGrid } from './components/BentoGrid';
import { ProjectShowcase } from './components/ProjectShowcase';
import { CodeInspector } from './components/CodeInspector';
import { CompareMatrix } from './components/CompareMatrix';
import { ExperienceTimeline } from './components/ExperienceTimeline';
import { ContactSection } from './components/ContactSection';
import { Footer } from './components/Footer';

export default function App() {
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
    <div className="min-h-screen bg-black text-[#f5f5f7] flex flex-col font-sans selection:bg-blue-600 selection:text-white">
      {/* Apple Frosted Navbar */}
      <Navbar onOpenContact={scrollToContact} />

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
