import React, { useState } from 'react';
import { 
  Github, 
  ArrowUpRight, 
  Code2, 
  CheckCircle2, 
  MessageSquare, 
  Smartphone, 
  ShoppingBag,
  LayoutDashboard,
  Home,
  Droplets,
  FileText,
  ExternalLink,
  Globe
} from 'lucide-react';
import { PROJECTS } from '../data/portfolioData';
import { Project } from '../types/portfolio';
import { ProjectModal } from './ProjectModal';

export const ProjectShowcase: React.FC = () => {
  const [activeCategory, setActiveCategory] = useState<string>('All');
  const [selectedProject, setSelectedProject] = useState<Project | null>(null);

  // Filter tabs: All, Mobile, Website (Mobile tab includes both Mobile and Android projects)
  const categories = ['All', 'Mobile', 'Website'];

  const filteredProjects = activeCategory === 'All'
    ? PROJECTS
    : activeCategory === 'Mobile'
      ? PROJECTS.filter(
          (p) =>
            p.category === 'Mobile' ||
            p.category === 'Android' ||
            p.badges?.includes('Mobile') ||
            p.badges?.includes('Android')
        )
      : PROJECTS.filter(
          (p) => p.category === activeCategory || p.badges?.includes(activeCategory)
        );

  const getIcon = (name: string) => {
    switch (name) {
      case 'ShoppingBag': return <ShoppingBag className="w-5 h-5 text-amber-400" />;
      case 'LayoutDashboard': return <LayoutDashboard className="w-5 h-5 text-blue-400" />;
      case 'Home': return <Home className="w-5 h-5 text-emerald-400" />;
      case 'Droplets': return <Droplets className="w-5 h-5 text-cyan-400" />;
      case 'FileText': return <FileText className="w-5 h-5 text-rose-400" />;
      case 'CheckCircle2': return <CheckCircle2 className="w-5 h-5 text-emerald-400" />;
      case 'MessageSquare': return <MessageSquare className="w-5 h-5 text-purple-400" />;
      default: return <Code2 className="w-5 h-5 text-blue-400" />;
    }
  };

  const getActionIcon = (actionType: Project['actionType']) => {
    switch (actionType) {
      case 'playstore':
        return <Smartphone className="w-3.5 h-3.5 text-emerald-400" />;
      case 'website':
        return <Globe className="w-3.5 h-3.5 text-blue-400" />;
      case 'github':
        return <Github className="w-3.5 h-3.5 text-neutral-300" />;
      default:
        return <ExternalLink className="w-3.5 h-3.5 text-blue-400" />;
    }
  };

  return (
    <section id="projects" className="py-20 sm:py-28 relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        
        {/* Section Title */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-6">
          <div className="space-y-3 max-w-2xl">
            <p className="text-xs font-mono uppercase tracking-widest text-blue-400">
              Featured Work
            </p>
            <h2 className="text-3xl sm:text-5xl font-bold tracking-tight text-white leading-tight text-balance">
              The Product Lineup. <br />
              <span className="text-neutral-400">Engineered for production.</span>
            </h2>
            <p className="text-sm sm:text-base text-neutral-400 leading-relaxed text-balance">
              Explore open-source architectures, native integrations, and responsive Flutter applications.
            </p>
          </div>

          {/* Interactive Filter Tabs */}
          <div className="flex items-center gap-1 p-1 bg-neutral-900/90 border border-white/10 rounded-xl overflow-x-auto max-w-full">
            {categories.map((cat) => (
              <button
                key={cat}
                type="button"
                onClick={() => setActiveCategory(cat)}
                className={`px-3.5 py-1.5 text-xs font-medium rounded-lg transition-all whitespace-nowrap cursor-pointer ${
                  activeCategory === cat
                    ? 'bg-white text-black shadow-sm font-semibold'
                    : 'text-neutral-400 hover:text-white'
                }`}
              >
                {cat}
              </button>
            ))}
          </div>
        </div>

        {/* Project Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8">
          {filteredProjects.map((project) => (
            <div
              key={project.id}
              onClick={() => setSelectedProject(project)}
              className="rounded-3xl bg-[#121214] border border-white/10 p-6 sm:p-7 flex flex-col justify-between hover:border-white/25 transition-all duration-300 group hover:-translate-y-1 cursor-pointer"
            >
              {/* Card Top: Icon & Category Badge */}
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <div className="w-11 h-11 rounded-2xl bg-neutral-900 border border-white/10 flex items-center justify-center">
                    {getIcon(project.iconName)}
                  </div>
                  {project.badges ? (
                    <div className="flex items-center gap-1.5">
                      {project.badges.map((b) => (
                        <span
                          key={b}
                          className="inline-flex items-center px-2.5 py-0.5 rounded-full text-[11px] font-mono font-medium bg-white/5 border border-white/10 text-neutral-300"
                        >
                          {b}
                        </span>
                      ))}
                    </div>
                  ) : (
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-[11px] font-mono font-medium bg-white/5 border border-white/10 text-neutral-300">
                      {project.category}
                    </span>
                  )}
                </div>

                {/* Card Title & Tagline */}
                <div>
                  <h3 className="text-xl font-bold text-white tracking-tight group-hover:text-blue-400 transition-colors flex items-center justify-between">
                    <span>{project.title}</span>
                  </h3>
                  <p className="text-xs text-neutral-400 mt-1 font-medium">
                    {project.tagline}
                  </p>
                </div>

                {/* Description - Exact from tabrezcool6.github.io */}
                <p className="text-xs sm:text-sm text-neutral-300 leading-relaxed line-clamp-3">
                  {project.description}
                </p>

                {/* Metrics strip */}
                {project.metrics && (
                  <div className="grid grid-cols-3 gap-2 py-3 border-y border-white/5 text-center">
                    {project.metrics.map((m, idx) => (
                      <div key={idx}>
                        <div className="text-xs font-bold text-white font-mono tabular-nums">
                          {m.value}
                        </div>
                        <div className="text-[10px] text-neutral-500 truncate">
                          {m.label}
                        </div>
                      </div>
                    ))}
                  </div>
                )}

                {/* Technologies List */}
                <div className="flex flex-wrap items-center gap-x-2 gap-y-1 text-[11px] text-neutral-400 pt-1">
                  {project.technologies.slice(0, 4).map((tech, i) => (
                    <React.Fragment key={tech}>
                      <span className="text-neutral-300">{tech}</span>
                      {i < Math.min(project.technologies.length, 4) - 1 && (
                        <span className="text-neutral-600" aria-hidden="true">·</span>
                      )}
                    </React.Fragment>
                  ))}
                  {project.technologies.length > 4 && (
                    <span className="text-neutral-500 font-mono">+{project.technologies.length - 4}</span>
                  )}
                </div>
              </div>

              {/* Card Footer Actions - Matching tabrezcool6.github.io buttons */}
              <div className="pt-6 border-t border-white/5 mt-6 flex items-end justify-between gap-3">
                <button
                  type="button"
                  onClick={() => setSelectedProject(project)}
                  className="text-xs text-neutral-400 hover:text-white transition-colors cursor-pointer self-end pb-1 text-left"
                >
                  Architecture & Details
                </button>

                <div 
                  className={`flex ${project.playStoreUrl ? 'flex-col items-end gap-1.5' : 'items-center'}`}
                  onClick={(e) => e.stopPropagation()}
                >
                  <a
                    href={project.projectUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-white/10 hover:bg-white text-neutral-200 hover:text-black text-xs font-semibold transition-all cursor-pointer group/link shadow-sm"
                  >
                    {getActionIcon(project.actionType)}
                    <span>{project.actionLabel}</span>
                    <ArrowUpRight className="w-3 h-3 group-hover/link:translate-x-0.5 group-hover/link:-translate-y-0.5 transition-transform" />
                  </a>

                  {project.playStoreUrl && (
                    <a
                      href={project.playStoreUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-white/10 hover:bg-white text-neutral-200 hover:text-black text-xs font-semibold transition-all cursor-pointer group/link shadow-sm"
                    >
                      {getActionIcon('playstore')}
                      <span>View on Play Store</span>
                      <ArrowUpRight className="w-3 h-3 group-hover/link:translate-x-0.5 group-hover/link:-translate-y-0.5 transition-transform" />
                    </a>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>

      </div>

      {/* Modal Detail View */}
      <ProjectModal
        project={selectedProject}
        onClose={() => setSelectedProject(null)}
      />
    </section>
  );
};
