import React, { useState } from 'react';
import { Check } from 'lucide-react';
import { SKILL_CATEGORIES } from '../data/portfolioData';

export const CompareMatrix: React.FC = () => {
  const [selectedCategoryIndex, setSelectedCategoryIndex] = useState(0);

  const activeCategory = SKILL_CATEGORIES[selectedCategoryIndex];

  return (
    <section className="py-20 sm:py-28 relative border-t border-white/10">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        
        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto space-y-3">
          <p className="text-xs font-mono uppercase tracking-widest text-blue-400">
            Compare Capabilities
          </p>
          <h2 className="text-3xl sm:text-5xl font-bold tracking-tight text-white leading-tight text-balance">
            Which technology fits your app? <br />
            <span className="text-neutral-400">Explore architectural depth.</span>
          </h2>
          <p className="text-sm sm:text-base text-neutral-400 leading-relaxed text-balance">
            Compare proficiencies, execution paradigms, and production applications across Tabrez's toolkit.
          </p>
        </div>

        {/* Category Selector Tabs */}
        <div className="flex flex-col items-center gap-4">
          <div className="inline-flex p-1 bg-neutral-900 border border-white/10 rounded-2xl overflow-x-auto max-w-full scrollbar-none">
            {SKILL_CATEGORIES.map((cat, idx) => (
              <button
                key={cat.title}
                type="button"
                onClick={() => setSelectedCategoryIndex(idx)}
                className={`px-4 py-2 text-xs font-medium rounded-xl transition-all cursor-pointer whitespace-nowrap ${
                  selectedCategoryIndex === idx
                    ? 'bg-white text-black font-semibold shadow-md'
                    : 'text-neutral-400 hover:text-white'
                }`}
              >
                {cat.title}
              </button>
            ))}
          </div>

          <p className="text-center text-xs font-mono text-neutral-400">
            {activeCategory.subtitle}
          </p>
        </div>

        {/* Comparative Spec Cards Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {activeCategory.items.map((item) => (
            <div
              key={item.name}
              className="rounded-3xl bg-[#121214] border border-white/10 p-6 flex flex-col justify-between hover:border-white/20 transition-all group"
            >
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <span className="text-[11px] font-mono text-neutral-400">
                    {item.experience}
                  </span>
                  <span className="text-[11px] font-mono text-blue-400 font-semibold">
                    {item.level}
                  </span>
                </div>

                <div>
                  <h3 className="text-lg font-bold text-white tracking-tight group-hover:text-blue-400 transition-colors">
                    {item.name}
                  </h3>
                  <p className="text-xs text-neutral-400 mt-2 leading-relaxed">
                    {item.description}
                  </p>
                </div>
              </div>

              <div className="pt-5 border-t border-white/5 mt-6 flex items-center gap-2 text-xs text-neutral-300">
                <Check className="w-4 h-4 text-emerald-400 shrink-0" />
                <span>Production Ready</span>
              </div>
            </div>
          ))}
        </div>

        {/* Apple Footer Note */}
        <div className="text-center text-xs text-neutral-500 pt-4">
          All engineering solutions follow strict S.O.L.I.D principles and unit/widget test verification.
        </div>

      </div>
    </section>
  );
};
