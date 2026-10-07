import React, { useEffect, useRef } from 'react';
import '../simple-portfolio.css';

/**
 * Simple portfolio view — a port of simpler_portfolio/
 * (https://github.com/tabrezcool6/tabrezcool6.github.io): same markup, styles
 * (src/simple-portfolio.css, scoped under .sp) and interactions (script.js).
 * Images live in public/simple/.
 */

// Destination WhatsApp number for the contact form, digits only incl. country code.
const WHATSAPP_NUMBER = '919945989643';

interface SimplePortfolioProps {
  onSwitchView: () => void;
}

export const SimplePortfolio: React.FC<SimplePortfolioProps> = ({ onSwitchView }) => {
  const rootRef = useRef<HTMLDivElement>(null);
  const year = new Date().getFullYear();

  // Interactions from script.js, scoped to this view and removed on unmount.
  useEffect(() => {
    const root = rootRef.current;
    if (!root) return;

    const navBar = root.querySelector<HTMLElement>('#navBar');
    const menu = root.querySelector<HTMLElement>('#menu');
    const mobileBtn = root.querySelector<HTMLElement>('#mobileMenuBtn');
    const progress = root.querySelector<HTMLElement>('#scrollProgress');
    const links = Array.from(root.querySelectorAll<HTMLAnchorElement>('.menu li a'));
    const sections = Array.from(root.querySelectorAll<HTMLElement>('section[id]'));

    // ----- Mobile menu -----
    const toggleMenu = () => {
      menu?.classList.toggle('show');
      mobileBtn?.classList.toggle('open');
    };
    const closeMenu = () => {
      menu?.classList.remove('show');
      mobileBtn?.classList.remove('open');
    };
    mobileBtn?.addEventListener('click', toggleMenu);
    links.forEach((a) => a.addEventListener('click', closeMenu));

    // ----- Scroll: nav background + progress bar + active link -----
    const onScroll = () => {
      const y = window.scrollY || window.pageYOffset;
      navBar?.classList.toggle('scrolled', y > 30);

      if (progress) {
        const h = document.documentElement.scrollHeight - window.innerHeight;
        progress.style.width = (h > 0 ? (y / h) * 100 : 0) + '%';
      }

      let current = sections.length ? sections[0].id : '';
      const offset = window.innerHeight * 0.35;
      sections.forEach((sec) => {
        if (y + offset >= sec.offsetTop) current = sec.id;
      });
      links.forEach((a) => a.classList.toggle('active', a.getAttribute('href') === '#' + current));
    };
    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('resize', onScroll);
    onScroll();

    // ----- Reveal on scroll, skill bars, count-up stats -----
    const frames = new Set<number>();
    const countUp = (node: HTMLElement, target: number) => {
      if (!target || target < 0) {
        node.textContent = String(target || 0);
        return;
      }
      const duration = 1200;
      const start = performance.now();
      const tick = (now: number) => {
        const p = Math.min((now - start) / duration, 1);
        const eased = 1 - Math.pow(1 - p, 3);
        node.textContent = String(Math.round(eased * target));
        if (p < 1) frames.add(requestAnimationFrame(tick));
      };
      frames.add(requestAnimationFrame(tick));
    };
    const runEffects = (el: Element) => {
      el.querySelectorAll<HTMLElement>('.line span[data-width]').forEach((bar) => {
        bar.style.width = bar.getAttribute('data-width') || '0';
      });
      el.querySelectorAll<HTMLElement>('.stat-num[data-count]').forEach((num) => {
        countUp(num, parseInt(num.getAttribute('data-count') || '0', 10));
      });
    };

    const revealEls = root.querySelectorAll<HTMLElement>('.reveal');
    let io: IntersectionObserver | null = null;
    if ('IntersectionObserver' in window) {
      io = new IntersectionObserver(
        (entries, obs) => {
          entries.forEach((entry, i) => {
            if (entry.isIntersecting) {
              const target = entry.target as HTMLElement;
              // small stagger for siblings entering together
              target.style.transitionDelay = Math.min(i * 60, 240) + 'ms';
              target.classList.add('in');
              runEffects(target);
              obs.unobserve(target);
            }
          });
        },
        { threshold: 0.15, rootMargin: '0px 0px -8% 0px' },
      );
      revealEls.forEach((el) => io!.observe(el));
    } else {
      revealEls.forEach((el) => {
        el.classList.add('in');
        runEffects(el);
      });
    }

    return () => {
      mobileBtn?.removeEventListener('click', toggleMenu);
      links.forEach((a) => a.removeEventListener('click', closeMenu));
      window.removeEventListener('scroll', onScroll);
      window.removeEventListener('resize', onScroll);
      io?.disconnect();
      frames.forEach((f) => cancelAnimationFrame(f));
    };
  }, []);

  // ----- Contact form → WhatsApp -----
  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const field = (id: string) =>
      ((e.currentTarget.elements.namedItem(id) as HTMLInputElement | HTMLTextAreaElement | null)?.value || '').trim();
    const name = field('cfName');
    const email = field('cfEmail');
    const subject = field('cfSubject');
    const message = field('cfMessage');
    if (!name || !email || !subject || !message) return;

    const text =
      "Hello Syed, I'd like to get in touch.\n\n" +
      '*Name:* ' + name + '\n' +
      '*Email:* ' + email + '\n' +
      '*Subject:* ' + subject + '\n' +
      '*Message:*' + message;

    window.open('https://wa.me/' + WHATSAPP_NUMBER + '?text=' + encodeURIComponent(text), '_blank', 'noopener');
  };

  return (
    <div ref={rootRef} className="sp">
      {/* Scroll progress bar */}
      <div className="scroll-progress" id="scrollProgress"></div>

      {/* Navigation */}
      <header className="navBar" id="navBar">
        <div className="max-width nav-inner">
          <a className="logo" href="#homePage"
            >Tabrez<span>.<span className="tld">in</span></span></a
          >

          <nav>
            <ul className="menu" id="menu">
              <li className="nav-btn"><a href="#homePage" className="active">Home</a></li>
              <li className="nav-btn"><a href="#about">About</a></li>
              <li className="nav-btn"><a href="#carrer">Career</a></li>
              <li className="nav-btn"><a href="#education">Qualification</a></li>
              <li className="nav-btn"><a href="#skills">Skills</a></li>
              <li className="nav-btn"><a href="#projects">Projects</a></li>
              <li className="nav-btn"><a href="#contact">Contact</a></li>
            </ul>
          </nav>

          <div className="nav-actions">
            <button
              type="button"
              className="view-switch"
              onClick={onSwitchView}
              aria-label="Switch to developer view"
            >
              <i className="fa-solid fa-code"></i> Developer view
            </button>
            <button
              className="mobile-menu-btn"
              id="mobileMenuBtn"
              aria-label="Toggle menu"
            >
              <i className="fa-solid fa-bars"></i>
            </button>
          </div>
        </div>
      </header>

      {/* Hero / Home */}
      <section className="homePage" id="homePage">
        <div className="hero-glow"></div>
        <div className="social-rail">
          <a
            href="https://linkedin.com/in/syed-tabrez-pasha-s-295b8a114/"
            target="_blank"
            rel="noopener"
            aria-label="LinkedIn"
            ><i className="fa-brands fa-linkedin-in"></i
          ></a>
          <a
            href="https://github.com/tabrezcool6"
            target="_blank"
            rel="noopener"
            aria-label="GitHub"
            ><i className="fa-brands fa-github"></i
          ></a>
          <a
            href="https://twitter.com/tabrezcool6"
            target="_blank"
            rel="noopener"
            aria-label="Twitter"
            ><i className="fa-brands fa-x-twitter"></i
          ></a>
          <a
            href="https://facebook.com/syed.tabrez.3382/"
            target="_blank"
            rel="noopener"
            aria-label="Facebook"
            ><i className="fa-brands fa-facebook-f"></i
          ></a>
          <span className="rail-line"></span>
        </div>

        <div className="max-width hero-inner">
          <div className="home-content">
            <div className="text-1 reveal">Hello, my name is</div>
            <h1 className="text-2 reveal">Syed Tabrez Pasha S</h1>
            <div className="text-3 reveal">
              I'm a <span>Senior Flutter Engineer</span>
            </div>
            <p className="hero-sub reveal">
              Founder &amp; Lead Engineer at{' '}
              <a href="https://sameens.com" target="_blank" rel="noopener"
                >Sameens</a
              >. Currently working at Rokkun Systems on{' '}
              <a href="https://gorentify.com" target="_blank" rel="noopener"
                >Rentify</a
              >, a Dubai-based platform modernizing property rentals. I build
              performant mobile and web experiences with Flutter,
              Backed-Integration and Clean UI/UX.
            </p>
            <div className="hero-cta reveal">
              <a href="#projects" className="btn btn-primary">View my work</a>
              <a href="#contact" className="btn btn-ghost">Get in touch</a>
            </div>
          </div>

          <div className="hero-photo reveal">
            <div className="photo-ring"></div>
            <img src="/simple/syed-profile-pic.png" alt="Syed Tabrez Pasha S" />
            {/* <img src="/simple/My_Picture.png" alt="Syed Tabrez Pasha S" /> */}
          </div>
        </div>

        <a href="#about" className="scroll-hint" aria-label="Scroll down">
          <span></span>
        </a>
      </section>

      {/* About */}
      <section className="about" id="about">
        <div className="max-width">
          <h2 className="title reveal" data-sub="who I am">About me</h2>
          <div className="about-content">
            <div className="column left reveal">
              <img
                src="/simple/syed-seconday-pic.png"
                alt="Syed Tabrez portrait"
              />
              {/* <img src="/simple/circle_suit_4.png" alt="Syed Tabrez portrait" /> */}
            </div>
            <div className="column right">
              <div className="text reveal">
                I'm Syed Tabrez Pasha S and I'm a Flutter Developer.
              </div>
              <p className="reveal">
                I live in Bengaluru. I completed my Bachelor of Engineering
                (Electronics and Communication) from Sambhram Institute of
                Technology. I started coding in early 2019 and got a hang of it.
                From then I didn't stop. Initially, I started with Android
                Development (Java) and created many projects out of which{' '}
                <a
                  href="https://play.google.com/store/apps/details?id=com.xsar.handwriter"
                  target="_blank"
                  rel="noopener"
                  >Handwriter: handwriting app</a
                >{' '}
                is one. Over the time, my interest kept increasing in the
                development field and to explore further I started Web
                Development. Apart from coding, I mostly like to cook and eat,
                watch series, travel &amp; read and write and listen to good
                music.
              </p>
              <div className="about-stats reveal">
                <div className="stat">
                  <span className="stat-num" data-count="5">0</span><span>+</span>
                  <small>Years coding</small>
                </div>
                <div className="stat">
                  <span className="stat-num" data-count="10">0</span><span>+</span>
                  <small>Featured projects</small>
                </div>
                <div className="stat">
                  <span className="stat-num" data-count="15">0</span><span>+</span>
                  <small>Years in business</small>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Career */}
      <section className="carrer" id="carrer">
        <div className="max-width">
          <h2 className="title reveal" data-sub="where I work">Career</h2>

          <div className="timeline">
            <div className="tl-item reveal">
              <div className="tl-dot"></div>
              <div className="tl-card">
                <div className="tl-head">
                  <a className="text-1" href="https://" target="_blank" rel="noopener"
                    >Flutter Engineer — Rokkun Systems</a
                  >
                  <span className="tl-date">Jan 2026 – Present</span>
                </div>
                <div className="tl-place">Bengaluru, India · Full-time</div>
                <p className="text-3">
                  Leading mobile application development for Rentify, a
                  Dubai-based fintech platform modernizing rental payments and
                  property management. I own the app end-to-end — from planning
                  and design through development to deployment on the App Store
                  and Google Play.<br />The app lets tenants pay rent monthly with
                  secure digital transactions and earn rewards redeemable across
                  200+ partner brands, while landlords receive rent upfront
                  through banking partners. Recognized as "Startup of the Year" at
                  the Finance Middle East Awards 2025.
                </p>
                <div className="tl-tags">
                  <span>Flutter</span><span>Mobile Architecture</span
                  ><span>UI/UX Design</span><span>API Integration</span
                  ><span>State Management</span><span>CI/CD &amp; Deployment</span
                  ><span>Team Leadership</span>
                </div>
              </div>
            </div>

            <div className="tl-item reveal">
              <div className="tl-dot"></div>
              <div className="tl-card">
                <div className="tl-head">
                  <a
                    className="text-1"
                    href="https://sameens.com"
                    target="_blank"
                    rel="noopener"
                    >Founder &amp; Lead Engineer — Sameens</a
                  >
                  <span className="tl-date">Oct 2023 – Present</span>
                </div>
                <div className="tl-place">Bengaluru, Karnataka</div>
                <p className="text-3">
                  Founded and built Sameens, an online store for bags and
                  accessories, as two Flutter apps: a customer storefront for
                  Android, iOS and web from a single codebase, and a Flutter Web
                  admin dashboard for products, orders, transactions, customers,
                  notifications and analytics. Built the full purchase flow —
                  catalogue, cart, Razorpay checkout, order tracking and PDF
                  invoices — with one shared invoice renderer so the admin and
                  customer always see the identical document. Customers get an
                  order confirmation email through Brevo. The dashboard also has
                  an internal chatbot powered by Gemini 3.7 Flash and a feedback
                  system where admins and managers can raise requirements, bugs
                  and enhancement requests.<br /><strong>Tech stack:</strong>{' '}
                  Flutter, Dart, Firebase (Firestore), Google Apps Script backend,
                  Razorpay, Brevo, Gemini 3.7 Flash, flutter_bloc, get_it,
                  fpdart.<br /><strong>Approach:</strong>{' '}
                  Both apps follow the same clean architecture, with BLoC for
                  state, dependency injection and typed error handling. Payment
                  secrets and all privileged writes live on the Apps Script
                  backend, never in the client. A three-tier role model (super
                  admin / admin / manager) is enforced both in the UI and on the
                  server. Dev, staging and prod build flavors each point to their
                  own Firebase project and backend, with a visible banner on
                  non-prod builds. Deployments run through GitHub Actions CI/CD
                  pipelines that authenticate with Google service accounts. Backed
                  by 300+ unit, bloc and widget tests, including layout tests
                  across screen sizes and text scales, and nine architecture and
                  operations guides.
                </p>
                <div className="tl-tags">
                  <span>Flutter</span><span>Dart</span><span>Firebase</span
                  ><span>Google Apps Script</span><span>Razorpay</span
                  ><span>Clean Architecture</span><span>BLoC</span
                  ><span>GitHub Actions</span><span>Gemini AI</span
                  ><span>Brevo</span><span>Testing</span>
                </div>
              </div>
            </div>

            <div className="tl-item reveal">
              <div className="tl-dot"></div>
              <div className="tl-card">
                <div className="tl-head">
                  <a
                    className="text-1"
                    href="https://intertecsystems.com"
                    target="_blank"
                    rel="noopener"
                    >Flutter Developer — Intertec Systems</a
                  >
                  <span className="tl-date">July 2025 – Dec 2025</span>
                </div>
                <div className="tl-place">Dubai, UAE · Remote</div>
                <p className="text-3">
                  Senior Flutter Developer on an enterprise application for Nama
                  Water Services (NWS), an Oman Government entity (formerly
                  OWWSC). Contributed across the full development lifecycle — from
                  requirement analysis and BRD/CR implementation to testing,
                  deployment and production support.<br />Collaborated with
                  cross-functional teams to deliver feature modules, managed
                  source control on Microsoft Azure, conducted code reviews, wrote
                  unit tests, and mentored junior developers within an Agile/Scrum
                  workflow.
                </p>
                <div className="tl-tags">
                  <span>Flutter</span><span>Enterprise Applications</span
                  ><span>Azure DevOps</span><span>Agile / Scrum</span
                  ><span>Jira</span><span>Unit Testing</span
                  ><span>Code Review</span><span>Mentoring</span>
                </div>
              </div>
            </div>

            <div className="tl-item reveal">
              <div className="tl-dot"></div>
              <div className="tl-card">
                <div className="tl-head">
                  <a
                    className="text-1"
                    href="https://ibuild.in"
                    target="_blank"
                    rel="noopener"
                    >Flutter Developer — iBuild Software Solutions</a
                  >
                  <span className="tl-date">Jul 2022 – Jun 2025</span>
                </div>
                <div className="tl-place">Bengaluru, Karnataka · Full-time</div>
                <p className="text-3">
                  Successfully integrated ERP systems into mobile applications.
                  The app contains features like updating attendance, real-time
                  location tracking, admin access, background tasks, getting
                  attendance details, etc.<br />Developed an integrated system,
                  known as the Intranet System, which facilitates real-time
                  communication among users within a closed network using
                  Socket.IO.
                </p>
                <div className="tl-tags">
                  <span>Flutter</span><span>Software Development</span
                  ><span>Project Management</span><span>API Integration</span
                  ><span>State Management</span><span>Teamwork</span>
                </div>
              </div>
            </div>

            <div className="tl-item reveal">
              <div className="tl-dot"></div>
              <div className="tl-card">
                <div className="tl-head">
                  <a
                    className="text-1"
                    href="https://sameens.com"
                    target="_blank"
                    rel="noopener"
                    >Sales Associate — Sameer Collections</a
                  >
                  <span className="tl-date">Jan 2010 – Present</span>
                </div>
                <div className="tl-place">Bengaluru, Karnataka · Part-time</div>
                <p className="text-3">
                  Accumulated over fifteen years of experience in sales at a
                  retail establishment operated by my family. This business
                  specializes in the retail sale of men's clothing, school bags,
                  travel bags, women's handbags, clutches, men's accessories, and
                  handlooms.
                </p>
                <div className="tl-tags">
                  <span>Sales</span><span>Sales Management</span
                  ><span>Sales Operations</span><span>Direct Sales</span
                  ><span>Retail Sales</span>
                </div>
              </div>
            </div>

            <div className="tl-item reveal">
              <div className="tl-dot"></div>
              <div className="tl-card">
                <div className="tl-head">
                  <a
                    className="text-1"
                    href="https://thecompanycheck.com/company/madvistara-private-limited/U72900KA2022PTC159416"
                    target="_blank"
                    rel="noopener"
                    >Flutter Developer — Madvistara Software Solutions</a
                  >
                  <span className="tl-date">Jan 2022 – Jun 2022</span>
                </div>
                <div className="tl-place">Bengaluru, Karnataka · Full-time</div>
                <p className="text-3">
                  Built and integrated mobile app features with cloud services and
                  REST APIs, focusing on data persistence and reliable API
                  communication.
                </p>
                <div className="tl-tags">
                  <span>Firebase</span><span>Postman API</span><span>Flutter</span
                  ><span>API Integration</span><span>Database</span>
                </div>
              </div>
            </div>

            <div className="tl-item reveal">
              <div className="tl-dot"></div>
              <div className="tl-card">
                <div className="tl-head">
                  <a
                    className="text-1"
                    href="https://linkedin.com/company/reformx/posts/?feedView=all"
                    target="_blank"
                    rel="noopener"
                    >Front End Developer Trainee — REFORMX</a
                  >
                  <span className="tl-date">Sep 2021 – Jan 2022</span>
                </div>
                <div className="tl-place">Bengaluru, Karnataka · Internship</div>
                <p className="text-3">
                  Successfully completed an internship and gained hands-on
                  experience in developing websites using HTML, CSS, Bootstrap and
                  JavaScript. Completed 3–4 projects based on this.
                </p>
                <div className="tl-tags">
                  <span>Bootstrap</span><span>HTML5</span
                  ><span>Front-End Development</span><span>JavaScript</span
                  ><span>CSS</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Qualification */}
      <section className="education" id="education">
        <div className="max-width">
          <h2 className="title reveal" data-sub="what I studied">Qualification</h2>

          <div className="education-content">
            <div className="column reveal">
              <div className="edu_heading">
                <i className="fa-solid fa-graduation-cap"></i> Education
              </div>
              <div className="education-content2">
                <div className="edu1">
                  <div className="edu-row">
                    <div>
                      <div className="text-1">Bachelor of Engineering (ECE)</div>
                      <div className="text-2">Sambhram Institute of Technology</div>
                    </div>
                    <div className="inner-row">
                      <div className="text-3">2016–2021</div>
                      <div className="text-4">6.3 CGPA</div>
                    </div>
                  </div>
                </div>

                <div className="edu1">
                  <div className="edu-row">
                    <div>
                      <div className="text-1">
                        Pre University College (Science, PCME)
                      </div>
                      <div className="text-2">Mahesh PU College</div>
                    </div>
                    <div className="inner-row">
                      <div className="text-3">2014–2016</div>
                      <div className="text-4">76.58%</div>
                    </div>
                  </div>
                </div>

                <div className="edu1">
                  <div className="edu-row">
                    <div>
                      <div className="text-1">
                        Secondary School Leaving Certificate
                      </div>
                      <div className="text-2">Kiran High School</div>
                    </div>
                    <div className="inner-row">
                      <div className="text-3">2002–2014</div>
                      <div className="text-4">88.64%</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div className="column reveal">
              <div className="edu_heading">
                <i className="fa-solid fa-briefcase"></i> Internship &amp; Experience
              </div>
              <div className="education-content2">
                <div className="edu1">
                  <div className="edu-row">
                    <div>
                      <div className="text-1">Front End Development Trainee</div>
                      <div className="text-2">ReformX Consulting Private Limited</div>
                    </div>
                    <div className="text-3">2021</div>
                  </div>
                </div>

                <div className="edu1">
                  <div className="edu-row">
                    <div>
                      <div className="text-1">Internet of Things (IoT)</div>
                      <div className="text-2">ExpertsHub</div>
                    </div>
                    <div className="text-3">2019</div>
                  </div>
                </div>

                <div className="edu1">
                  <div className="edu-row">
                    <div>
                      <div className="text-1">
                        Field Technician — Computing &amp; Peripherals
                      </div>
                      <div className="text-2">Rooman Technologies (PMKVY)</div>
                    </div>
                    <div className="text-3">2018</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Skills */}
      <section className="skills" id="skills">
        <div className="max-width">
          <h2 className="title reveal" data-sub="what I know">My Skills</h2>
          <div className="skills-content">
            <div className="columns reveal">
              <div className="bars">
                <div className="info"><span>Flutter</span><span>90%</span></div>
                <div className="line"><span data-width="90%"></span></div>
              </div>
              <div className="bars">
                <div className="info"><span>PHP, SQL</span><span>60%</span></div>
                <div className="line"><span data-width="60%"></span></div>
              </div>
              <div className="bars">
                <div className="info"><span>HTML, CSS, JS</span><span>70%</span></div>
                <div className="line"><span data-width="70%"></span></div>
              </div>
              <div className="bars">
                <div className="info"><span>Node.JS</span><span>80%</span></div>
                <div className="line"><span data-width="80%"></span></div>
              </div>
            </div>

            <div className="columns reveal">
              <div className="bars">
                <div className="info"><span>Java</span><span>70%</span></div>
                <div className="line"><span data-width="70%"></span></div>
              </div>
              <div className="bars">
                <div className="info"><span>Android</span><span>60%</span></div>
                <div className="line"><span data-width="60%"></span></div>
              </div>
              <div className="bars">
                <div className="info"><span>XML</span><span>80%</span></div>
                <div className="line"><span data-width="80%"></span></div>
              </div>
              <div className="bars">
                <div className="info"><span>Git</span><span>80%</span></div>
                <div className="line"><span data-width="80%"></span></div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Projects */}
      <section className="projects" id="projects">
        <div className="max-width">
          <h2 className="title reveal" data-sub="what I made">My Projects</h2>
          <div className="projects-content">
            <a
              className="card reveal"
              href="https://sameens.com"
              target="_blank"
              rel="noopener"
            >
              <div className="box">
                <div className="card-img">
                  <img src="/simple/sameens-logo.png" alt="Sameen Collections" />
                </div>
                <h3>Sameens - Store<span>Website</span></h3>
                <p>
                  A mobile and web e-commerce app built using Flutter and App
                  scripts backend, delivering a seamless shopping experience.
                </p>
                <span className="card-link"
                  >Visit site <i className="fa-solid fa-arrow-right"></i
                ></span>
              </div>
            </a>

            <a
              className="card reveal"
              href="https://staging-admin.sameens.com"
              target="_blank"
              rel="noopener"
            >
              <div className="box">
                <div className="card-img">
                  <img
                    src="/simple/sameens-logo.png"
                    alt="Sameens Admin Dashboard"
                  />
                </div>
                <h3>Sameens - Dashboard (Staging)<span>Website</span></h3>
                <p>
                  An admin dashboard for managing products, orders, transactions,
                  customers and analytics, with role-based access. Built with
                  Flutter Web, Firebase and a Google Apps Script backend.
                </p>
                <span className="card-link"
                  >Visit site <i className="fa-solid fa-arrow-right"></i
                ></span>
              </div>
            </a>

            <a
              className="card reveal"
              href="https://play.google.com/store/apps/details?id=com.rentify.rentifyApp&hl=en_IN"
              target="_blank"
              rel="noopener"
            >
              <div className="box">
                <div className="card-img">
                  <img src="/simple/rentify-logo.png" alt="Rentify" />
                </div>
                <h3>Rentify <span>Mobile</span></h3>
                <p>
                  A rental marketplace app that connects tenants and owners,
                  making it easy to list, browse and rent properties.
                </p>
                <span className="card-link"
                  >View on Play Store <i className="fa-solid fa-arrow-right"></i
                ></span>
              </div>
            </a>

            <a
              className="card reveal"
              href="https://play.google.com/store/apps/details?id=com.diamwaterproject&hl=en_IN"
              target="_blank"
              rel="noopener"
            >
              <div className="box">
                <div className="card-img">
                  <img src="/simple/nama-logo.png" alt="Nama Water" />
                </div>
                <h3>Nama Water <span>Mobile</span></h3>
                <p>
                  A water services app that lets customers manage their accounts,
                  view bills and handle water-related requests on the go.
                </p>
                <span className="card-link"
                  >View on Play Store <i className="fa-solid fa-arrow-right"></i
                ></span>
              </div>
            </a>
            <a
              className="card reveal"
              href="https://play.google.com/store/apps/details?id=com.xsar.handwriter"
              target="_blank"
              rel="noopener"
            >
              <div className="box">
                <div className="card-img">
                  <img src="/simple/project1.png" alt="Handwriter" />
                </div>
                <h3>Handwriter <span>Android</span></h3>
                <p>
                  A font-converter app that turns camera or gallery images into
                  text files. Built with Java, XML, Firebase, Photoshop and Adobe
                  XD.
                </p>
                <span className="card-link"
                  >View on Play Store <i className="fa-solid fa-arrow-right"></i
                ></span>
              </div>
            </a>

            <a
              className="card reveal"
              href="https://github.com/tabrezcool6/iTask-ToDoListApp"
              target="_blank"
              rel="noopener"
            >
              <div className="box">
                <div className="card-img">
                  <img src="/simple/project2.png" alt="iTask" />
                </div>
                <h3>iTask — To Do List <span>Android</span></h3>
                <p>
                  An Android app to plan daily tasks, with user login/logout and
                  tasks stored in a realtime Firebase database.
                </p>
                <span className="card-link"
                  >View on GitHub <i className="fa-solid fa-arrow-right"></i
                ></span>
              </div>
            </a>

            <a
              className="card reveal"
              href="https://github.com/tabrezcool6/Connect--A-Web-Chat-API"
              target="_blank"
              rel="noopener"
            >
              <div className="box">
                <div className="card-img">
                  <img src="/simple/project3.png" alt="Connect" />
                </div>
                <h3>Connect — Web Chat API <span>Website</span></h3>
                <p>
                  A real-time chat API built with JavaScript, Node server and
                  Socket.IO, enabling users to communicate through accessible web
                  interfaces.
                </p>
                <span className="card-link"
                  >View on GitHub <i className="fa-solid fa-arrow-right"></i
                ></span>
              </div>
            </a>
          </div>
        </div>
      </section>

      {/* Contact */}
      <section className="contact" id="contact">
        <div className="max-width">
          <h2 className="title reveal" data-sub="get in touch">Contact Me</h2>
          <div className="contact-content">
            <div className="column left reveal">
              <div className="text">Get in touch</div>
              <p>
                If you need to know more details about me or have any questions,
                please feel free to drop me a message. I'll get back to you as
                soon as I can.
              </p>
              <div className="icons">
                <div className="row">
                  <i className="fa-solid fa-user"></i>
                  <div className="info">
                    <div className="head">Name</div>
                    <div className="sub-title">Syed Tabrez Pasha S</div>
                  </div>
                </div>
                <div className="row">
                  <i className="fa-solid fa-location-dot"></i>
                  <div className="info">
                    <div className="head">Address</div>
                    <div className="sub-title">Bangalore, Karnataka</div>
                  </div>
                </div>
                <div className="row">
                  <i className="fa-solid fa-envelope"></i>
                  <div className="info">
                    <div className="head">E-mail</div>
                    <div className="sub-title">dev.tabrez6@gmail.com</div>
                  </div>
                </div>
              </div>
            </div>

            <div className="column right reveal">
              <div className="text">Message me</div>
              <form id="contactForm" onSubmit={handleSubmit}>
                <div className="fields">
                  <div className="field name">
                    <input
                      id="cfName"
                      type="text"
                      placeholder="Enter your name"
                      required
                    />
                  </div>
                  <div className="field email">
                    <input
                      id="cfEmail"
                      type="email"
                      placeholder="Enter your e-mail"
                      required
                    />
                  </div>
                </div>
                <div className="field">
                  <input
                    id="cfSubject"
                    type="text"
                    placeholder="Subject"
                    required
                  />
                </div>
                <div className="field textarea">
                  <textarea
                    id="cfMessage"
                    cols={30}
                    rows={6}
                    placeholder="Describe project..."
                    required
                  ></textarea>
                </div>
                <div className="button">
                  <button type="submit">
                    Send message <i className="fa-solid fa-paper-plane"></i>
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="footer">
        <div className="max-width footer-inner">
          <a className="logo" href="#homePage"
            >Tabrez<span>.<span className="tld">in</span></span></a
          >
          <div className="footer-social">
            <a
              href="https://linkedin.com/in/syed-tabrez-pasha-s-295b8a114/"
              target="_blank"
              rel="noopener"
              aria-label="LinkedIn"
              ><i className="fa-brands fa-linkedin-in"></i
            ></a>
            <a
              href="https://github.com/tabrezcool6"
              target="_blank"
              rel="noopener"
              aria-label="GitHub"
              ><i className="fa-brands fa-github"></i
            ></a>
            <a
              href="https://twitter.com/tabrezcool6"
              target="_blank"
              rel="noopener"
              aria-label="Twitter"
              ><i className="fa-brands fa-x-twitter"></i
            ></a>
            <a
              href="https://facebook.com/syed.tabrez.3382/"
              target="_blank"
              rel="noopener"
              aria-label="Facebook"
              ><i className="fa-brands fa-facebook-f"></i
            ></a>
          </div>
          <p>
            © {year} Syed Tabrez Pasha S. All Rights Reserved.
          </p>
        </div>
      </footer>


    </div>
  );
};
