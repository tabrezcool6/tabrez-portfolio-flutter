import React, { useState, useEffect } from 'react';
import { Menu, X, ArrowUpRight, Github, Linkedin, Mail, LayoutTemplate } from 'lucide-react';
import { PERSONAL_INFO } from '../data/portfolioData';

interface NavbarProps {
  onOpenContact: () => void;
  /** Switches the page to the simple (non-technical) portfolio view. */
  onSwitchView: () => void;
}

export const Navbar: React.FC<NavbarProps> = ({ onOpenContact, onSwitchView }) => {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 20);
    };
    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const navLinks = [
    { label: 'Overview', href: '#overview' },
    { label: 'Engineering', href: '#engineering' },
    { label: 'Projects', href: '#projects' },
    { label: 'Architecture', href: '#architecture' },
    { label: 'Experience', href: '#experience' },
    { label: 'Contact', href: '#contact' },
  ];

  const handleNavClick = (e: React.MouseEvent<HTMLAnchorElement>, href: string) => {
    e.preventDefault();
    setMobileMenuOpen(false);
    const target = document.querySelector(href);
    if (target) {
      target.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <>
      <header
        className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
          scrolled || mobileMenuOpen
            ? 'bg-black/85 backdrop-blur-xl border-b border-white/10 shadow-lg shadow-black/40'
            : 'bg-black/40 backdrop-blur-md border-b border-white/5'
        }`}
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-12 flex items-center justify-between">
          
          {/* Zone 1: Brand Wordmark (Single text element) */}
          <a
            href="#overview"
            onClick={(e) => handleNavClick(e, '#overview')}
            className="text-sm font-semibold tracking-tight text-white hover:text-neutral-300 transition-colors whitespace-nowrap"
          >
            Tabrez<span className="text-blue-600">.in</span>
          </a>

          {/* Zone 2: 4-6 text navigation links */}
          <nav className="hidden md:flex items-center gap-7 text-xs font-medium text-neutral-400">
            {navLinks.map((link) => (
              <a
                key={link.label}
                href={link.href}
                onClick={(e) => handleNavClick(e, link.href)}
                className="hover:text-white transition-colors duration-150 py-1"
              >
                {link.label}
              </a>
            ))}
          </nav>

          {/* Zone 3: 1-2 primary actions */}
          <div className="flex items-center gap-3">
            {/* Switch to the simple portfolio view */}
            <button
              type="button"
              onClick={onSwitchView}
              className="hidden sm:inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium rounded-full border border-white/15 text-neutral-300 hover:text-white hover:border-white/30 transition-colors whitespace-nowrap cursor-pointer"
              title="Switch to a simple, non-technical portfolio"
            >
              <LayoutTemplate className="w-3.5 h-3.5" />
              <span>Simple view</span>
            </button>

            <button
              type="button"
              onClick={onOpenContact}
              className={`hidden sm:inline-flex items-center gap-1 px-3.5 py-1.5 text-xs font-medium rounded-full transition-all duration-300 whitespace-nowrap cursor-pointer ${
                scrolled
                  ? 'bg-blue-600 hover:bg-blue-500 text-white shadow-md shadow-blue-600/30 font-medium'
                  : 'text-black bg-white hover:bg-neutral-200 shadow-sm'
              }`}
            >
              <span>Get in Touch</span>
              <ArrowUpRight className="w-3 h-3" />
            </button>

            {/* Mobile Menu Toggle Button */}
            <button
              type="button"
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="md:hidden p-1.5 text-neutral-400 hover:text-white transition-colors cursor-pointer"
              aria-label={mobileMenuOpen ? 'Close menu' : 'Open menu'}
            >
              {mobileMenuOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
            </button>
          </div>
        </div>
      </header>

      {/* Apple-style Full-screen Mobile Menu */}
      {mobileMenuOpen && (
        <div className="fixed inset-0 top-12 z-40 bg-black/95 backdrop-blur-2xl md:hidden flex flex-col justify-between p-6 animate-fadeIn">
          <div className="space-y-5 pt-4">
            <p className="text-[11px] font-mono uppercase tracking-widest text-neutral-500">
              Navigation
            </p>
            <div className="flex flex-col space-y-4">
              {navLinks.map((link) => (
                <a
                  key={link.label}
                  href={link.href}
                  onClick={(e) => handleNavClick(e, link.href)}
                  className="text-2xl font-semibold text-neutral-200 hover:text-white transition-colors tracking-tight"
                >
                  {link.label}
                </a>
              ))}
            </div>
          </div>

          <div className="pt-6 border-t border-white/10 space-y-4">
            <div className="flex items-center justify-between text-xs text-neutral-400">
              <span>{PERSONAL_INFO.location}</span>
              <span className="font-mono text-emerald-400">Available for projects</span>
            </div>

            <div className="flex items-center gap-3 pt-2">
              <button
                type="button"
                onClick={() => {
                  setMobileMenuOpen(false);
                  onOpenContact();
                }}
                className="flex-1 py-3 bg-white text-black font-semibold text-center rounded-xl text-sm transition-transform active:scale-[0.98]"
              >
                Connect with Tabrez
              </button>
            </div>

            <button
              type="button"
              onClick={() => {
                setMobileMenuOpen(false);
                onSwitchView();
              }}
              className="w-full py-3 inline-flex items-center justify-center gap-2 rounded-xl border border-white/15 text-neutral-200 hover:text-white text-sm font-medium transition-colors"
            >
              <LayoutTemplate className="w-4 h-4" />
              Switch to simple view
            </button>

            <div className="flex items-center justify-center gap-6 pt-2 text-neutral-400">
              <a
                href={PERSONAL_INFO.github}
                target="_blank"
                rel="noreferrer"
                className="hover:text-white transition-colors p-2"
                aria-label="GitHub"
              >
                <Github className="w-5 h-5" />
              </a>
              <a
                href={PERSONAL_INFO.linkedin}
                target="_blank"
                rel="noreferrer"
                className="hover:text-white transition-colors p-2"
                aria-label="LinkedIn"
              >
                <Linkedin className="w-5 h-5" />
              </a>
              <a
                href={`mailto:${PERSONAL_INFO.email}`}
                className="hover:text-white transition-colors p-2"
                aria-label="Email"
              >
                <Mail className="w-5 h-5" />
              </a>
            </div>
          </div>
        </div>
      )}
    </>
  );
};
