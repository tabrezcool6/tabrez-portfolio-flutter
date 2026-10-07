import React from 'react';
import { ArrowUpRight } from 'lucide-react';
import { EXPERIENCE, ARTICLES } from '../data/portfolioData';

const MONTHS = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];

// Parses "Jul 2022" / "July 2025" / "Present" into a month index (year * 12 + month).
const toMonthIndex = (value: string): number | null => {
  const text = value.trim();
  if (/^present$/i.test(text)) {
    const now = new Date();
    return now.getFullYear() * 12 + now.getMonth();
  }
  const [month, year] = text.split(/\s+/);
  const m = MONTHS.indexOf(month?.slice(0, 3).toLowerCase());
  const y = Number(year);
  return m < 0 || !y ? null : y * 12 + m;
};

// "Jul 2022 – Jun 2025" → "3 years". Both the start and end months are counted.
const formatDuration = (period: string): string | null => {
  const [from, to] = period.split(/[–-]/);
  if (!from || !to) return null;
  const start = toMonthIndex(from);
  const end = toMonthIndex(to);
  if (start === null || end === null || end < start) return null;
  const total = end - start + 1;
  const years = Math.floor(total / 12);
  const months = total % 12;
  const parts = [];
  if (years) parts.push(`${years} ${years === 1 ? 'year' : 'years'}`);
  if (months) parts.push(`${months} ${months === 1 ? 'month' : 'months'}`);
  return parts.join(', ');
};

export const ExperienceTimeline: React.FC = () => {
  return (
    <section id="experience" className="py-20 sm:py-28 relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        
        {/* Section Header */}
        <div className="max-w-3xl space-y-3">
          <p className="text-xs font-mono uppercase tracking-widest text-blue-400">
            Professional Trajectory
          </p>
          <h2 className="text-3xl sm:text-5xl font-bold tracking-tight text-white leading-tight text-balance">
            The Journey. <br />
            <span className="text-neutral-400">From native Android to Flutter at scale.</span>
          </h2>
          <p className="text-sm sm:text-base text-neutral-400 leading-relaxed text-balance">
            Real engineering impact delivered in high-velocity teams, open-source communities, and technical publications.
          </p>
        </div>

        {/* Experience Blocks */}
        <div className="space-y-8">
          {EXPERIENCE.map((item, index) => (
            <div
              key={index}
              className="rounded-3xl bg-[#121214] border border-white/10 p-6 sm:p-8 hover:border-white/20 transition-all space-y-5"
            >
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-white/5 pb-4">
                <div>
                  <div className="flex items-center gap-2 flex-wrap">
                    <span className="text-xl font-bold text-white tracking-tight">{item.role}</span>
                    <span className="text-neutral-400 font-normal">at</span>
                    {item.companyUrl ? (
                      <a
                        href={item.companyUrl}
                        target="_blank"
                        rel="noreferrer"
                        className="text-xl font-bold text-blue-400 hover:text-blue-300 transition-colors inline-flex items-center gap-1 group/company hover:underline underline-offset-4 decoration-blue-400/40"
                        title={`Visit ${item.company}`}
                      >
                        <span>{item.company}</span>
                        <ArrowUpRight className="w-4 h-4 text-blue-400/80 group-hover/company:text-blue-300 group-hover/company:translate-x-0.5 group-hover/company:-translate-y-0.5 transition-transform" />
                      </a>
                    ) : (
                      <span className="text-xl font-bold text-blue-400">{item.company}</span>
                    )}
                  </div>
                  <div className="flex items-center gap-2 text-xs text-neutral-400 mt-1">
                    <span>{item.location}</span>
                    <span aria-hidden="true">·</span>
                    <span>{item.type}</span>
                  </div>
                </div>

                <div className="text-xs font-mono text-neutral-400 sm:text-right">
                  <span className="px-3 py-1 rounded-full bg-white/5 border border-white/10 text-neutral-300">
                    {item.period}
                  </span>
                  {formatDuration(item.period) && (
                    <div className="mt-2 px-[13px] text-[11px] text-neutral-500">
                      {formatDuration(item.period)}
                    </div>
                  )}
                </div>
              </div>

              <p className="text-sm text-neutral-300 leading-relaxed">
                {item.summary}
              </p>

              {/* Bullet points */}
              <ul className="space-y-2.5">
                {item.bullets.map((bullet, bIdx) => (
                  <li key={bIdx} className="flex items-start gap-2.5 text-xs sm:text-sm text-neutral-400">
                    <span className="text-blue-400 font-bold mt-0.5">·</span>
                    <span>{bullet}</span>
                  </li>
                ))}
              </ul>

              {/* Technologies unboxed list */}
              <div className="pt-3 border-t border-white/5 flex flex-wrap items-center gap-x-2 gap-y-1 text-xs text-neutral-400">
                <span className="text-neutral-500 font-mono">Toolkit:</span>
                {item.technologies.map((t, idx) => (
                  <React.Fragment key={t}>
                    <span className="text-neutral-300">{t}</span>
                    {idx < item.technologies.length - 1 && (
                      <span className="text-neutral-600" aria-hidden="true">·</span>
                    )}
                  </React.Fragment>
                ))}
              </div>
            </div>
          ))}
        </div>

        {/* Published Articles on Medium */}
        <div className="space-y-6 pt-8 border-t border-white/10">
          <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4">
            <div>
              <p className="text-xs font-mono uppercase tracking-widest text-emerald-400">
                Technical Writing
              </p>
              <h3 className="text-2xl sm:text-3xl font-bold text-white tracking-tight mt-1">
                Published on Medium
              </h3>
            </div>
            <a
              href="https://medium.com/@tabrezcool6"
              target="_blank"
              rel="noreferrer"
              className="text-xs font-semibold text-blue-400 hover:text-blue-300 transition-colors inline-flex items-center gap-1"
            >
              <span>Follow on Medium</span>
              <ArrowUpRight className="w-3.5 h-3.5" />
            </a>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {ARTICLES.map((art, idx) => (
              <a
                key={idx}
                href={art.url}
                target="_blank"
                rel="noreferrer"
                className="rounded-3xl bg-[#121214] border border-white/10 p-6 sm:p-7 flex flex-col justify-between hover:border-white/25 transition-all group hover:-translate-y-1"
              >
                <div className="space-y-3">
                  <div className="flex items-center justify-between text-xs text-neutral-400">
                    <span className="font-mono text-emerald-400 font-medium">{art.platform}</span>
                    <span aria-hidden="true">·</span>
                    <span>{art.readTime}</span>
                  </div>

                  <h4 className="text-lg font-bold text-white group-hover:text-blue-400 transition-colors leading-snug">
                    {art.title}
                  </h4>

                  <p className="text-xs sm:text-sm text-neutral-400 leading-relaxed">
                    {art.summary}
                  </p>
                </div>

                <div className="pt-5 border-t border-white/5 mt-5 flex items-center justify-between text-xs text-neutral-400">
                  <div className="flex items-center gap-2">
                    {art.topics.map((t, i) => (
                      <span key={i} className="text-neutral-500 font-mono text-[10px]">
                        #{t}
                      </span>
                    ))}
                  </div>
                  <span className="text-blue-400 font-medium inline-flex items-center gap-1 group-hover:translate-x-0.5 transition-transform">
                    Read Article <ArrowUpRight className="w-3 h-3" />
                  </span>
                </div>
              </a>
            ))}
          </div>
        </div>

      </div>
    </section>
  );
};
