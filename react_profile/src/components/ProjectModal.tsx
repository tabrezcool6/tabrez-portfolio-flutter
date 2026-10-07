import React, { useEffect } from 'react';
import { X, Github, Check, Copy, Terminal, Smartphone, Globe, ExternalLink, ArrowUpRight } from 'lucide-react';
import { Project } from '../types/portfolio';

interface ProjectModalProps {
  project: Project | null;
  onClose: () => void;
}

export const ProjectModal: React.FC<ProjectModalProps> = ({ project, onClose }) => {
  const [copiedCode, setCopiedCode] = React.useState(false);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    if (project) {
      document.body.style.overflow = 'hidden';
      window.addEventListener('keydown', handleKeyDown);
    }
    return () => {
      document.body.style.overflow = '';
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [project, onClose]);

  if (!project) return null;

  const copySnippet = () => {
    if (project.codeSnippet) {
      navigator.clipboard.writeText(project.codeSnippet.code);
      setCopiedCode(true);
      setTimeout(() => setCopiedCode(false), 2000);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-6 md:p-10 bg-black/80 backdrop-blur-xl animate-fadeIn">
      {/* Background click to close */}
      <div className="absolute inset-0" onClick={onClose} />

      {/* Modal Card */}
      <div className="relative w-full max-w-3xl max-h-[90vh] overflow-y-auto bg-[#18181b] border border-white/15 rounded-3xl p-6 sm:p-8 shadow-2xl z-10 space-y-6">
        
        {/* Header Bar */}
        <div className="flex items-start justify-between gap-4 border-b border-white/10 pb-5">
          <div className="space-y-1">
            <div className="flex items-center gap-2 text-xs text-neutral-400">
              <span>{project.category}</span>
              <span aria-hidden="true">·</span>
              <span className="font-mono text-blue-400">Architecture Verified</span>
            </div>
            <h3 className="text-2xl sm:text-3xl font-bold text-white tracking-tight">
              {project.title}
            </h3>
            <p className="text-neutral-400 text-sm">
              {project.tagline}
            </p>
          </div>

          <button
            type="button"
            onClick={onClose}
            className="p-2 rounded-full bg-white/10 hover:bg-white/20 text-neutral-300 hover:text-white transition-colors cursor-pointer"
            aria-label="Close modal"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Narrative & Technical Deep Dive */}
        <div className="space-y-4">
          <h4 className="text-sm font-semibold uppercase tracking-wider text-neutral-300 font-mono">
            System Overview
          </h4>
          <p className="text-neutral-300 text-sm sm:text-base leading-relaxed">
            {project.longDescription}
          </p>
        </div>

        {/* Technical Highlights */}
        <div className="space-y-3">
          <h4 className="text-sm font-semibold uppercase tracking-wider text-neutral-300 font-mono">
            Engineering Highlights
          </h4>
          <ul className="space-y-2">
            {project.highlights.map((highlight, index) => (
              <li key={index} className="flex items-start gap-2.5 text-xs sm:text-sm text-neutral-300">
                <span className="text-blue-400 font-bold mt-0.5">·</span>
                <span>{highlight}</span>
              </li>
            ))}
          </ul>
        </div>

        {/* Architecture Specs & Tabular Numerals */}
        {project.metrics && (
          <div className="space-y-3 pt-2">
            <h4 className="text-sm font-semibold uppercase tracking-wider text-neutral-300 font-mono">
              Key Metrics & Patterns
            </h4>
            <div className="grid grid-cols-3 gap-3 p-4 rounded-2xl bg-neutral-900/80 border border-white/5">
              {project.metrics.map((m, i) => (
                <div key={i} className="text-center sm:text-left">
                  <div className="text-base sm:text-lg font-bold text-white font-mono tabular-nums">
                    {m.value}
                  </div>
                  <div className="text-xs text-neutral-400">
                    {m.label}
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Technologies List */}
        <div className="space-y-2 pt-2">
          <h4 className="text-sm font-semibold uppercase tracking-wider text-neutral-300 font-mono">
            Tech Stack
          </h4>
          <div className="flex flex-wrap items-center gap-x-3 gap-y-1.5 text-xs sm:text-sm text-neutral-300">
            {project.technologies.map((tech, idx) => (
              <React.Fragment key={tech}>
                <span className="font-medium text-white">{tech}</span>
                {idx < project.technologies.length - 1 && (
                  <span className="text-neutral-600" aria-hidden="true">·</span>
                )}
              </React.Fragment>
            ))}
          </div>
        </div>

        {/* Code Snippet Inspector */}
        {project.codeSnippet && (
          <div className="space-y-2 pt-2">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2 text-xs font-mono text-neutral-400">
                <Terminal className="w-3.5 h-3.5 text-blue-400" />
                <span>{project.codeSnippet.filename}</span>
              </div>
              <button
                type="button"
                onClick={copySnippet}
                className="flex items-center gap-1 text-xs text-neutral-400 hover:text-white transition-colors cursor-pointer"
              >
                {copiedCode ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
                <span>{copiedCode ? 'Copied' : 'Copy Code'}</span>
              </button>
            </div>
            <pre className="p-4 rounded-xl bg-black border border-white/10 text-xs font-mono text-neutral-200 overflow-x-auto leading-relaxed">
              <code>{project.codeSnippet.code}</code>
            </pre>
          </div>
        )}

        {/* Action Buttons */}
        <div className="pt-6 border-t border-white/10 flex flex-wrap items-center justify-between gap-3">
          <div className="flex flex-wrap items-center gap-3">
            <a
              href={project.projectUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-2 px-5 py-2.5 rounded-full bg-white text-black font-semibold text-xs sm:text-sm hover:bg-neutral-200 transition-colors shadow-sm cursor-pointer"
            >
              {project.actionType === 'playstore' && <Smartphone className="w-4 h-4 text-emerald-600" />}
              {project.actionType === 'website' && <Globe className="w-4 h-4 text-blue-600" />}
              {project.actionType === 'github' && <Github className="w-4 h-4 text-neutral-800" />}
              <span>{project.actionLabel}</span>
              <ArrowUpRight className="w-4 h-4" />
            </a>

            {project.playStoreUrl && (
              <a
                href={project.playStoreUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 px-5 py-2.5 rounded-full bg-white text-black font-semibold text-xs sm:text-sm hover:bg-neutral-200 transition-colors shadow-sm cursor-pointer"
              >
                <Smartphone className="w-4 h-4 text-emerald-600" />
                <span>View on Play Store</span>
                <ArrowUpRight className="w-4 h-4" />
              </a>
            )}
          </div>

          <button
            type="button"
            onClick={onClose}
            className="px-5 py-2.5 rounded-full bg-neutral-800 hover:bg-neutral-700 text-neutral-300 hover:text-white text-xs sm:text-sm font-medium transition-colors cursor-pointer"
          >
            Close Overview
          </button>
        </div>

      </div>
    </div>
  );
};
