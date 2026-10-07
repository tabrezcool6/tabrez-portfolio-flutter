import React, { useState } from 'react';
import { Copy, Check, Send, Github, Linkedin, MessageSquare, Clock, MapPin } from 'lucide-react';
import { PERSONAL_INFO } from '../data/portfolioData';

// Display labels for the "Project / Inquiry Scope" <select> values.
const SCOPE_LABELS: Record<string, string> = {
  'Mobile App (Flutter)': 'Mobile App Development (Flutter)',
  'Freelance Opportunity': 'Freelance Opportunity',
  'Architecture & State Audit': 'Architecture & BLoC/Clean Arch Audit',
  'Full-time Engineering Role': 'Full-time Engineering Opportunity',
  'Technical Consulting': 'Technical Consulting / Mentorship',
  'Other': 'Other Collaboration',
};

// mailto: link to PERSONAL_INFO.email with the form's details as subject + body.
const buildMailtoLink = (form: { name: string; email: string; projectType: string; message: string }) => {
  const scope = SCOPE_LABELS[form.projectType] ?? form.projectType;
  const subject = `Portfolio Inquiry: ${scope} — ${form.name.trim()}`;
  const body = [
    `Name: ${form.name.trim()}`,
    `Email: ${form.email.trim()}`,
    `Project / Inquiry Scope: ${scope}`,
    '',
    'Message:',
    form.message.trim(),
  ].join('\n');
  return `mailto:${PERSONAL_INFO.email}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
};

export const ContactSection: React.FC = () => {
  const [copiedEmail, setCopiedEmail] = useState<string | null>(null);
  
  // Interactive form state
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    projectType: 'Mobile App (Flutter)',
    message: '',
  });
  const [formStatus, setFormStatus] = useState<'idle' | 'submitting' | 'success' | 'error'>('idle');
  const [errorMessage, setErrorMessage] = useState('');
  const [photoAvailable, setPhotoAvailable] = useState(true);

  const copyEmailToClipboard = (email: string) => {
    navigator.clipboard.writeText(email);
    setCopiedEmail(email);
    setTimeout(() => setCopiedEmail(null), 2500);
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.name.trim() || !formData.email.trim() || !formData.message.trim()) {
      setFormStatus('error');
      setErrorMessage('Please fill in your name, email, and message.');
      return;
    }

    // Open the visitor's mail app with everything they entered, addressed to Tabrez.
    // Done synchronously in the submit handler so browsers treat it as a user action.
    window.location.href = buildMailtoLink(formData);

    setFormStatus('submitting');
    setTimeout(() => {
      setFormStatus('success');
      setFormData({
        name: '',
        email: '',
        projectType: 'Mobile App (Flutter)',
        message: '',
      });
      setErrorMessage('');
    }, 800);
  };

  return (
    <section id="contact" className="py-20 sm:py-28 relative border-t border-white/10">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        
        {/* Section Header */}
        <div className="max-w-3xl space-y-3">
          <p className="text-xs font-mono uppercase tracking-widest text-blue-400">
            Get in Touch
          </p>
          <h2 className="text-3xl sm:text-5xl font-bold tracking-tight text-white leading-tight text-balance">
            Connect with Tabrez. <br />
            <span className="text-neutral-400">Let's build something remarkable.</span>
          </h2>
          <p className="text-sm sm:text-base text-neutral-400 leading-relaxed text-balance">
            Whether you need a Senior Flutter Engineer, an architectural consultation, or a high-performance 
            mobile app engineered from the ground up, I'm just a message away.
          </p>
        </div>

        {/* 2-Column Apple Layout */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-10">
          
          {/* Left Column: Direct Communication Channels (5 cols) */}
          <div className="lg:col-span-5 space-y-6">

            {/* Profile Card (public/assets/images/profile.png); the whole card hides if the photo is missing */}
            {photoAvailable && (
              <div className="rounded-3xl bg-[#121214] border border-white/10 p-6 sm:p-7 flex items-center gap-5 hover:border-white/20 transition-all">
                <img
                  src="/assets/images/profile.png"
                  alt={PERSONAL_INFO.name}
                  onError={() => setPhotoAvailable(false)}
                  className="w-24 h-24 sm:w-28 sm:h-28 rounded-full object-cover border border-white/15 shadow-lg shadow-black/50 shrink-0"
                />
                <div className="min-w-0 space-y-1">
                  <h3 className="text-lg font-bold text-white tracking-tight">{PERSONAL_INFO.name}</h3>
                  <p className="text-xs text-neutral-400">{PERSONAL_INFO.title}</p>
                  <p className="pt-1 text-xs font-mono text-emerald-400 flex items-center gap-1.5">
                    <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
                    Available for projects
                  </p>
                </div>
              </div>
            )}

            {/* Primary Email Card */}
            <div className="rounded-3xl bg-[#121214] border border-white/10 p-6 sm:p-7 space-y-4 hover:border-white/20 transition-all">
              <div className="flex items-center justify-between">
                <span className="text-xs font-mono text-neutral-400">Primary Channel</span>
                <span className="text-xs font-mono text-emerald-400 flex items-center gap-1">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
                  Quick Reply
                </span>
              </div>

              <div className="space-y-1">
                <h3 className="text-lg font-bold text-white tracking-tight">Direct Inquiries</h3>
                <p className="text-xs text-neutral-400">
                  Tap to copy address or open in your default mail client.
                </p>
              </div>

              {/* Primary Email */}
              <div className="p-3.5 rounded-2xl bg-neutral-900 border border-white/5 flex items-center justify-between gap-3">
                <div className="min-w-0">
                  <span className="text-[10px] uppercase font-mono text-neutral-500">Email Address</span>
                  <p className="text-xs sm:text-sm font-semibold text-white truncate font-mono">
                    {PERSONAL_INFO.email}
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => copyEmailToClipboard(PERSONAL_INFO.email)}
                  className="p-2 rounded-xl bg-white/5 hover:bg-white/10 text-neutral-300 hover:text-white transition-colors cursor-pointer border border-white/10 shrink-0"
                  title="Copy email"
                >
                  {copiedEmail === PERSONAL_INFO.email ? (
                    <Check className="w-4 h-4 text-emerald-400" />
                  ) : (
                    <Copy className="w-4 h-4" />
                  )}
                </button>
              </div>

              {copiedEmail && (
                <p className="text-xs text-emerald-400 font-mono flex items-center gap-1.5 animate-fadeIn">
                  <Check className="w-3.5 h-3.5" />
                  <span>Email address copied to clipboard</span>
                </p>
              )}
            </div>

            {/* Quick Details Card */}
            <div className="rounded-3xl bg-[#121214] border border-white/10 p-6 space-y-4">
              <div className="flex items-center gap-3 text-xs text-neutral-300">
                <MapPin className="w-4 h-4 text-blue-400 shrink-0" />
                <span>{PERSONAL_INFO.location}</span>
              </div>
              <div className="flex items-center gap-3 text-xs text-neutral-300">
                <Clock className="w-4 h-4 text-emerald-400 shrink-0" />
                <span>IST (UTC+5:30) · High availability</span>
              </div>
            </div>

            {/* Social Channels */}
            <div className="grid grid-cols-3 gap-3">
              <a
                href={PERSONAL_INFO.github}
                target="_blank"
                rel="noreferrer"
                className="p-4 rounded-2xl bg-[#121214] border border-white/10 hover:border-white/20 text-center transition-all group"
              >
                <Github className="w-5 h-5 mx-auto text-neutral-400 group-hover:text-white transition-colors" />
                <span className="block text-xs font-semibold text-neutral-300 mt-2">GitHub</span>
                <span className="text-[10px] text-neutral-500 font-mono">tabrezcool6</span>
              </a>

              <a
                href={PERSONAL_INFO.linkedin}
                target="_blank"
                rel="noreferrer"
                className="p-4 rounded-2xl bg-[#121214] border border-white/10 hover:border-white/20 text-center transition-all group"
              >
                <Linkedin className="w-4 h-4 mx-auto text-neutral-400 group-hover:text-blue-400 transition-colors" />
                <span className="block text-xs font-semibold text-neutral-300 mt-2">LinkedIn</span>
                <span className="text-[10px] text-neutral-500 font-mono">syed-tabrez-pasha-s</span>
              </a>

              <a
                href={PERSONAL_INFO.medium || "https://medium.com/@tabrezcool6"}
                target="_blank"
                rel="noreferrer"
                className="p-4 rounded-2xl bg-[#121214] border border-white/10 hover:border-white/20 text-center transition-all group"
              >
                <MessageSquare className="w-4 h-4 mx-auto text-neutral-400 group-hover:text-emerald-400 transition-colors" />
                <span className="block text-xs font-semibold text-neutral-300 mt-2">Medium</span>
                <span className="text-[10px] text-neutral-500 font-mono">tabrezcool6</span>
              </a>
            </div>

          </div>

          {/* Right Column: Interactive Consultation & Message Form (7 cols) */}
          <div className="lg:col-span-7">
            <div className="rounded-3xl bg-[#121214] border border-white/10 p-6 sm:p-9 space-y-6">
              <div>
                <h3 className="text-xl sm:text-2xl font-bold text-white tracking-tight">
                  Send a Message
                </h3>
                <p className="text-xs sm:text-sm text-neutral-400 mt-1">
                  Have an opportunity or architecture question? Drop the details below.
                </p>
              </div>

              {formStatus === 'success' ? (
                <div className="p-8 rounded-2xl bg-emerald-500/10 border border-emerald-500/20 text-center space-y-4 animate-fadeIn">
                  <div className="w-12 h-12 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center mx-auto">
                    <Check className="w-6 h-6" />
                  </div>
                  <div>
                    <h4 className="text-lg font-bold text-white">Message Dispatched!</h4>
                    <p className="text-xs text-neutral-300 mt-1 max-w-sm mx-auto">
                      Thank you for reaching out. Tabrez will review your message and reply via email shortly.
                    </p>
                  </div>
                  <button
                    type="button"
                    onClick={() => setFormStatus('idle')}
                    className="px-5 py-2 rounded-full bg-white text-black font-semibold text-xs hover:bg-neutral-200 transition-colors cursor-pointer"
                  >
                    Send Another Note
                  </button>
                </div>
              ) : (
                <form onSubmit={handleSubmit} className="space-y-4">
                  {formStatus === 'error' && (
                    <div className="p-3 rounded-xl bg-rose-500/10 border border-rose-500/20 text-xs text-rose-300">
                      {errorMessage}
                    </div>
                  )}

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div className="space-y-1.5">
                      <label htmlFor="contact-name" className="text-xs font-medium text-neutral-300">Your Name</label>
                      <input
                        id="contact-name"
                        type="text"
                        value={formData.name}
                        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                        placeholder="Enter your name"
                        className="w-full bg-neutral-900 border border-white/10 rounded-xl px-3.5 py-2.5 text-xs sm:text-sm text-white placeholder-neutral-500 focus:outline-none focus:border-blue-500 transition-colors"
                      />
                    </div>

                    <div className="space-y-1.5">
                      <label htmlFor="contact-email" className="text-xs font-medium text-neutral-300">Email Address</label>
                      <input
                        id="contact-email"
                        type="email"
                        value={formData.email}
                        onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                        placeholder="Enter your email"
                        className="w-full bg-neutral-900 border border-white/10 rounded-xl px-3.5 py-2.5 text-xs sm:text-sm text-white placeholder-neutral-500 focus:outline-none focus:border-blue-500 transition-colors"
                      />
                    </div>
                  </div>

                  <div className="space-y-1.5">
                    <label htmlFor="contact-scope" className="text-xs font-medium text-neutral-300">Project / Inquiry Scope</label>
                    <select
                      id="contact-scope"
                      value={formData.projectType}
                      onChange={(e) => setFormData({ ...formData, projectType: e.target.value })}
                      className="w-full bg-neutral-900 border border-white/10 rounded-xl px-3.5 py-2.5 text-xs sm:text-sm text-white focus:outline-none focus:border-blue-500 transition-colors"
                    >
                      <option value="Mobile App (Flutter)">Mobile App Development (Flutter)</option>
                      <option value="Freelance Opportunity">Freelance Opportunity</option>
                      <option value="Architecture & State Audit">Architecture & BLoC/Clean Arch Audit</option>
                      <option value="Full-time Engineering Role">Full-time Engineering Opportunity</option>
                      <option value="Technical Consulting">Technical Consulting / Mentorship</option>
                      <option value="Other">Other Collaboration</option>
                    </select>
                  </div>

                  <div className="space-y-1.5">
                    <label htmlFor="contact-message" className="text-xs font-medium text-neutral-300">Message</label>
                    <textarea
                      id="contact-message"
                      rows={4}
                      value={formData.message}
                      onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                      placeholder="Share details about your application, timelines, or engineering challenge..."
                      className="w-full bg-neutral-900 border border-white/10 rounded-xl px-3.5 py-2.5 text-xs sm:text-sm text-white placeholder-neutral-500 focus:outline-none focus:border-blue-500 transition-colors resize-none"
                    />
                  </div>

                  <div className="flex flex-col sm:flex-row items-center justify-between gap-4 pt-2">
                    <p className="text-[11px] text-neutral-500">
                      Replies typically dispatched within 24 hours.
                    </p>

                    <button
                      type="submit"
                      disabled={formStatus === 'submitting'}
                      className="w-full sm:w-auto px-6 py-3 rounded-full bg-blue-600 hover:bg-blue-500 text-white font-medium text-xs sm:text-sm transition-all shadow-lg shadow-blue-600/20 active:scale-95 cursor-pointer disabled:opacity-50 flex items-center justify-center gap-2"
                    >
                      {formStatus === 'submitting' ? (
                        <span>Transmitting...</span>
                      ) : (
                        <>
                          <span>Transmit Message</span>
                          <Send className="w-3.5 h-3.5" />
                        </>
                      )}
                    </button>
                  </div>
                </form>
              )}
            </div>
          </div>

        </div>

      </div>
    </section>
  );
};
