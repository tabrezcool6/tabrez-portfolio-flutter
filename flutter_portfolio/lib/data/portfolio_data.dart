// Mirror of src/data/portfolioData.ts and src/types/portfolio.ts in the React app.
// Keep both files in sync when content changes.

class Metric {
  final String label;
  final String value;
  const Metric(this.label, this.value);
}

class CodeSnippetRef {
  final String filename;
  final String code;
  const CodeSnippetRef(this.filename, this.code);
}

class Project {
  final String id;
  final String title;
  final String tagline;
  final String category; // 'Mobile' | 'Website' | 'Android'
  final String badgeType;
  final List<String>? badges;
  final String description;
  final String longDescription;
  final List<String> highlights;
  final List<String> technologies;
  final List<Metric>? metrics;
  final String projectUrl;
  final String actionLabel;
  final String actionType; // 'website' | 'playstore' | 'github'
  final String? playStoreUrl;
  final String? githubUrl;
  final String iconName;
  final bool featured;
  final CodeSnippetRef? codeSnippet;

  const Project({
    required this.id,
    required this.title,
    required this.tagline,
    required this.category,
    required this.badgeType,
    this.badges,
    required this.description,
    required this.longDescription,
    required this.highlights,
    required this.technologies,
    this.metrics,
    required this.projectUrl,
    required this.actionLabel,
    required this.actionType,
    this.playStoreUrl,
    this.githubUrl,
    required this.iconName,
    required this.featured,
    this.codeSnippet,
  });
}

class SkillItem {
  final String name;
  final String level;
  final String experience;
  final String description;
  const SkillItem(this.name, this.level, this.experience, this.description);
}

class SkillCategory {
  final String title;
  final String subtitle;
  final List<SkillItem> items;
  const SkillCategory({required this.title, required this.subtitle, required this.items});
}

class ExperienceItem {
  final String period;
  final String role;
  final String company;
  final String? companyUrl;
  final String location;
  final String type;
  final String summary;
  final List<String> bullets;
  final List<String> technologies;

  const ExperienceItem({
    required this.period,
    required this.role,
    required this.company,
    this.companyUrl,
    required this.location,
    required this.type,
    required this.summary,
    required this.bullets,
    required this.technologies,
  });
}

class ArticleItem {
  final String title;
  final String platform;
  final String readTime;
  final String summary;
  final String url;
  final List<String> topics;

  const ArticleItem({
    required this.title,
    required this.platform,
    required this.readTime,
    required this.summary,
    required this.url,
    required this.topics,
  });
}

class StatItem {
  final String label;
  final String value;
  final String subtext;
  const StatItem(this.label, this.value, this.subtext);
}

class PersonalInfo {
  static const name = 'Syed Tabrez Pasha S';
  static const preferredName = 'Tabrez Pasha';
  static const username = 'tabrezcool6';
  static const title = 'Flutter Developer & Mobile Application Engineer';
  static const currentCompany = 'Rokkun Bengaluru';
  static const location = 'Bengaluru, Karnataka, India';
  static const email = 'dev.tabrez6@gmail.com';
  static const github = 'https://github.com/tabrezcool6';
  static const linkedin = 'https://www.linkedin.com/in/syed-tabrez-pasha-s/';
  static const medium = 'https://medium.com/@tabrezcool6';
  static const bioShort =
      'Flutter Developer at Rokkun Bengaluru passionate about building clean, high-performance cross-platform mobile experiences with uncompromising architecture.';
  static const bioExtended =
      'Curious, passionate, and dedicated mobile application engineer with a deep foundation in Flutter, Dart, Clean Architecture, and S.O.L.I.D principles. Experienced in engineering robust offline-first applications, reactive state management (BLoC & Provider), real-time WebSockets, and seamless RESTful APIs. Currently expanding with Firebase Functions, Google Play Services, Appscripts, and seamless payment gateways.';
}

const List<Project> projects = [
  Project(
    id: 'sameens-app',
    title: 'Sameens App',
    tagline: 'Customer Mobile E-Commerce Application',
    category: 'Mobile',
    badgeType: 'Mobile',
    badges: ['Android', 'iOS'],
    description:
        'A mobile e-commerce shopping app built using Flutter with smooth catalogue browsing, Razorpay payments, and live order tracking.',
    longDescription:
        'Sameens App is the native customer mobile retail experience developed for Sameens. Built from a clean Flutter codebase with BLoC state management, it provides instant category search, cart calculations, secure Razorpay checkout, live tracking, and digital invoice integration.',
    highlights: [
      'Native cross-platform mobile shopping experience built in Flutter',
      'Integrated Razorpay mobile payment gateway with seamless checkout flows',
      'Real-time cart calculation, automated order synchronization, and order tracking',
      'Engineered with Clean Architecture and BLoC for predictable offline-tolerant state',
    ],
    technologies: ['Flutter', 'Dart', 'BLoC', 'Razorpay', 'Firebase', 'Clean Architecture'],
    metrics: [
      Metric('Platform', 'Mobile App'),
      Metric('Architecture', 'Clean & BLoC'),
      Metric('Payments', 'Razorpay'),
    ],
    projectUrl: 'https://play.google.com/store/apps/details?id=com.sameens.store',
    actionLabel: 'View on Play Store',
    actionType: 'playstore',
    iconName: 'ShoppingBag',
    featured: true,
  ),
  Project(
    id: 'sameens-store',
    title: 'Sameens - Store',
    tagline: 'Web E-Commerce Application & Storefront',
    category: 'Website',
    badgeType: 'Website',
    badges: ['Website'],
    description:
        'A web e-commerce app built using Flutter and App scripts backend, delivering a seamless shopping experience.',
    longDescription:
        'Sameens Store is a modern retail and commerce application developed for Sameen Collections. Engineered with Flutter and Flutter Web, it connects to a Google Apps Script cloud backend for managing products, cart synchronization, customer orders, and checkout workflows across desktop and mobile devices.',
    highlights: [
      'Cross-platform responsive Flutter and Flutter Web storefront architecture',
      'Integrated Google Apps Script backend pipeline for automated catalog sync',
      'Real-time cart calculation and seamless order processing experience',
      'Optimized image caching and smooth product catalog scrolling',
    ],
    technologies: ['Flutter', 'Flutter Web', 'Google Apps Script', 'E-Commerce', 'REST API', 'Responsive UI'],
    metrics: [
      Metric('Platform', 'Flutter Web'),
      Metric('Backend', 'App Scripts'),
      Metric('Domain', 'Retail & Store'),
    ],
    projectUrl: 'https://sameens.com',
    actionLabel: 'Visit site',
    actionType: 'website',
    iconName: 'ShoppingBag',
    featured: true,
  ),
  Project(
    id: 'sameens-dashboard',
    title: 'Sameens - Dashboard (Staging)',
    tagline: 'Admin Dashboard with Role-Based Access Control',
    category: 'Website',
    badgeType: 'Website',
    description:
        'An admin dashboard for managing products, orders, transactions, customers and analytics, with role-based access. Built with Flutter Web, Firebase and a Google Apps Script backend.',
    longDescription:
        'An enterprise back-office management console for Sameens operations. Provides store managers and admins with role-based controls over product inventory, incoming customer orders, transaction auditing, customer profiles, and analytical revenue charts.',
    highlights: [
      'Role-based access control (RBAC) powered by Firebase Authentication and custom claims',
      'Real-time sales, order, and inventory synchronization with Google Apps Script backend',
      'Interactive analytical reporting dashboards and transactional logs',
      'High-density data tables with sorting, search filtering, and batch updates',
    ],
    technologies: ['Flutter Web', 'Firebase', 'Google Apps Script', 'Analytics', 'Role-Based Access', 'Data Tables'],
    metrics: [
      Metric('Framework', 'Flutter Web'),
      Metric('Auth & DB', 'Firebase'),
      Metric('Environment', 'Staging Admin'),
    ],
    projectUrl: 'https://staging-admin.sameens.com',
    actionLabel: 'Visit site',
    actionType: 'website',
    iconName: 'LayoutDashboard',
    featured: true,
  ),
  Project(
    id: 'rentify',
    title: 'Rentify',
    tagline: 'Rental Marketplace for Tenants & Property Owners',
    category: 'Mobile',
    badgeType: 'Mobile',
    badges: ['Android', 'iOS'],
    description:
        'A rental marketplace app that connects tenants and owners, making it easy to list, browse and rent properties.',
    longDescription:
        'Rentify is a production rental marketplace application published on the Google Play Store. It bridges property owners and prospective tenants with location-aware property discovery, interactive listings, amenity filters, inquiry messaging, and verified property portfolios.',
    highlights: [
      'Live production mobile app published on Google Play Store',
      'Dual-role workflow for property owners (listings & photos) and tenants (search & booking)',
      'Geographical property search with interactive location filters',
      'Responsive Flutter UI optimized for fluid scrolling and quick property filtering',
    ],
    technologies: ['Flutter', 'Dart', 'Google Play Store', 'Marketplace', 'Maps & Location', 'State Management'],
    metrics: [
      Metric('Distribution', 'Google Play'),
      Metric('Ecosystem', 'Tenants & Owners'),
      Metric('Type', 'Production App'),
    ],
    projectUrl: 'https://play.google.com/store/apps/details?id=com.rentify.rentifyApp&hl=en_IN',
    actionLabel: 'View on Play Store',
    actionType: 'playstore',
    iconName: 'Home',
    featured: true,
  ),
  Project(
    id: 'nama-water',
    title: 'Nama Water',
    tagline: 'Water Services & Utility Account Management App',
    category: 'Mobile',
    badgeType: 'Mobile',
    badges: ['Android', 'iOS'],
    description:
        'A water services app that lets customers manage their accounts, view bills and handle water-related requests on the go.',
    longDescription:
        'Published on Google Play Store, Nama Water provides a customer utility portal on mobile. Consumers can track their water consumption, inspect and download bills, initiate service requests, receive outage notifications, and manage municipal accounts on the go.',
    highlights: [
      'Live utility mobile client serving active customers on Google Play Store',
      'Account management with billing records, meter reading history, and online payments',
      'Service ticket dispatch and real-time status tracking for maintenance requests',
      'Robust API integration with municipal ERP backend systems',
    ],
    technologies: ['Flutter', 'Dart', 'Google Play Store', 'Utility Billing', 'REST APIs', 'ERP Integration'],
    metrics: [
      Metric('Distribution', 'Google Play'),
      Metric('Domain', 'Utilities & Water'),
      Metric('Scale', 'Customer Portal'),
    ],
    projectUrl: 'https://play.google.com/store/apps/details?id=com.diamwaterproject&hl=en_IN',
    actionLabel: 'View on Play Store',
    actionType: 'playstore',
    iconName: 'Droplets',
    featured: true,
  ),
  Project(
    id: 'handwriter',
    title: 'Handwriter',
    tagline: 'Font-Converter Android Application (Camera to Text)',
    category: 'Android',
    badgeType: 'Android',
    description:
        'A font-converter app that turns camera or gallery images into text files. Built with Java, XML, Firebase, Photoshop and Adobe XD.',
    longDescription:
        'Published on Google Play Store, Handwriter is a specialized native Android utility application. It converts handwritten and printed documents captured via the device camera or picked from the gallery into digital text files, leveraging OCR pipelines, native Android SDK, and Firebase.',
    highlights: [
      'Published on Google Play Store with thousands of active Android users',
      'Built with native Android (Java), custom XML layouts, and camera hardware bindings',
      'Integrated Firebase backend for cloud sync and user preferences',
      'Custom image preprocessing and font rendering pipeline',
    ],
    technologies: ['Java', 'Native Android SDK', 'XML', 'Firebase', 'Photoshop', 'Adobe XD'],
    metrics: [
      Metric('Distribution', 'Google Play'),
      Metric('Platform', 'Native Android'),
      Metric('Engine', 'Java & XML'),
    ],
    projectUrl: 'https://play.google.com/store/apps/details?id=com.xsar.handwriter',
    actionLabel: 'View on Play Store',
    actionType: 'playstore',
    iconName: 'FileText',
    featured: true,
  ),
  Project(
    id: 'itask-todolist',
    title: 'iTask',
    tagline: 'Daily Task Planner with Firebase Realtime Database',
    category: 'Android',
    badgeType: 'Android',
    description:
        'An Android app to plan daily tasks, with user login/logout and tasks stored in a realtime Firebase database.',
    longDescription:
        'iTask is a native Android productivity application engineered in Java. Features full user registration, login authentication, and real-time synchronization with Firebase Realtime Database. Users can schedule daily goals, track completion status, and access tasks across devices.',
    highlights: [
      'Native Android application built with Java and Material Design components',
      'User authentication with login/logout states and user profile header',
      'Real-time task synchronization backed by Firebase Realtime Database',
      'Open-source repository available on GitHub with complete source code',
    ],
    technologies: ['Java', 'Android SDK', 'Firebase Realtime Database', 'Material Design', 'XML'],
    metrics: [
      Metric('Platform', 'Native Android'),
      Metric('Database', 'Firebase Realtime'),
      Metric('Source', 'GitHub Open Source'),
    ],
    projectUrl: 'https://github.com/tabrezcool6/iTask-ToDoListApp',
    actionLabel: 'View on GitHub',
    actionType: 'github',
    iconName: 'CheckCircle2',
    featured: false,
  ),
];

const List<SkillCategory> skillCategories = [
  SkillCategory(
    title: 'Mobile & Frameworks',
    subtitle: 'Core application runtimes and UI engines',
    items: [
      SkillItem('Flutter', 'Expert', 'Production', 'Cross-platform reactive UI, widget composition, memory optimization, custom painters'),
      SkillItem('Dart', 'Expert', 'Production', 'Strong typing, async streams, null-safety, isolates, extension methods'),
      SkillItem('Native Android (Java)', 'Advanced', 'Native', 'Activity lifecycles, SQLite, Intents, XML layouts, Android SDK'),
      SkillItem('Web Development (HTML, CSS, JS)', 'Advanced', 'Applied', 'Semantic HTML, responsive CSS layouts, vanilla JavaScript, DOM APIs, and cross-browser web pages'),
    ],
  ),
  SkillCategory(
    title: 'State & Architecture',
    subtitle: 'Scalable data flow and software boundaries',
    items: [
      SkillItem('BLoC Pattern', 'Expert', 'Production', 'Event-driven unidirectional state streams, bloc_test verification'),
      SkillItem('Provider', 'Advanced', 'Production', 'Dependency tree scoping, ChangeNotifier, clean reactive bindings'),
      SkillItem('Clean Architecture', 'Expert', 'Production', 'Strict separation of Presentation, Domain, and Data layers'),
      SkillItem('GoRouter', 'Expert', 'Production', 'Declarative routing, deep linking, nested navigation, redirect auth guards, and state-driven transitions'),
      SkillItem('S.O.L.I.D Principles', 'Expert', 'Guiding Rule', 'Interface segregation, dependency inversion, testability'),
      SkillItem('GetIt (Service Locator)', 'Advanced', 'Production', 'Decoupled dependency injection, lazy singletons, factory registration'),
    ],
  ),
  SkillCategory(
    title: 'Data & Offline Persistence',
    subtitle: 'High-efficiency local and cloud data stores',
    items: [
      SkillItem('Hive NoSQL', 'Expert', 'Production', 'Lightweight binary key-value store, instant initialization, zero native dependencies'),
      SkillItem('SQFLite / SQLite', 'Advanced', 'Production', 'Relational data modeling, transactional queries, migration scripting'),
      SkillItem('Firebase & Firestore', 'Advanced', 'Production', 'Realtime database, Authentication, Cloud Storage, Security Rules'),
      SkillItem('Supabase', 'Intermediate', 'Applied', 'PostgreSQL backend, row-level security, auth token handling'),
      SkillItem('SharedPreferences', 'Expert', 'Production', 'Key-value config persistence, user preferences, session caching'),
      SkillItem('Localization (EN & AR)', 'Expert', 'Production', 'English and Arabic localization with RTL layouts, ARB / intl message catalogs, and locale-aware formatting'),
    ],
  ),
  SkillCategory(
    title: 'Backend, Networking & Cloud',
    subtitle: 'APIs, real-time protocols, and serverless infrastructure',
    items: [
      SkillItem('Google Apps Script', 'Expert', 'Production', 'Serverless backend logic, automated catalog sync, shared PDF invoice generation, and REST endpoints'),
      SkillItem('REST APIs & Postman', 'Expert', 'Production', 'Contract inspection, Dio / http clients, interceptors, retry policies'),
      SkillItem('Socket.IO & WebSockets', 'Advanced', 'Applied', 'Bidirectional low-latency messaging, reconnect protocols, heartbeat checks'),
      SkillItem('Node.js & Express', 'Intermediate', 'Applied', 'Lightweight microservices, event emitters, JSON API endpoints'),
      SkillItem('Firebase Functions', 'Advanced', 'Production', 'Serverless backend logic, Firestore triggers, background tasks, push notifications'),
      SkillItem('Google Play Services', 'Advanced', 'Production', 'Play Integrity, Google Sign-In, In-App Updates, Location & Maps SDK'),
    ],
  ),
  SkillCategory(
    title: 'Payment Providers',
    subtitle: 'Fintech integrations, secure checkouts, and transaction gateways',
    items: [
      SkillItem('Razorpay', 'Expert', 'Production', 'Full checkout integration, webhooks, signature verification, payment intents, and automated order reconciliation'),
      SkillItem('TotalPay', 'Advanced', 'Production', 'Payment gateway integration, multi-currency processing, and secure transaction workflows'),
      SkillItem('Paymob', 'Advanced', 'Production', 'MENA regional payment gateway, cards, digital wallets, and transaction validation callbacks'),
      SkillItem('UrbanLedger EPP', 'Advanced', 'Production', 'Digital ledger accounting, merchant transaction tracking, cashflow settlement, and balance reconciliation'),
      SkillItem('Slice EPP', 'Advanced', 'Production', 'Card payments, credit checkout workflows, installment split transactions, and merchant SDK bindings'),
    ],
  ),
  SkillCategory(
    title: 'Deployments & Releases',
    subtitle: 'App store releases, automated pipelines, and testing distributions',
    items: [
      SkillItem('Google Play Store', 'Expert', 'Production', 'AAB app bundles, keystore signing, internal/closed/production rollout tracks, and store compliance'),
      SkillItem('Apple App Store', 'Expert', 'Production', 'TestFlight beta distribution, App Store Connect submissions, certificates, and provisioning profiles'),
      SkillItem('GitHub Actions', 'Advanced', 'CI/CD', 'Automated CI/CD build pipelines, test suites, Google service account authentication, and release automation'),
      SkillItem('Firebase App Distribution', 'Advanced', 'Internal QA', 'Rapid tester group distribution, release notes automation, crash telemetry, and QA validation cycles'),
      SkillItem('Website Hosting (Firebase & GoDaddy)', 'Advanced', 'Production', 'Firebase Hosting deploys, custom domains and DNS via GoDaddy, SSL setup, and third-party hosting services'),
    ],
  ),
  SkillCategory(
    title: 'AI & Dev Tools',
    subtitle: 'AI assistants, agentic IDEs, and model integrations',
    items: [
      SkillItem('Claude', 'Advanced', 'Daily Driver', 'AI pair programming for code reviews, refactors, test generation, and architecture discussions'),
      SkillItem('Antigravity', 'Advanced', 'Daily Driver', 'Agent-first IDE for planning and executing multi-step coding tasks across the codebase'),
      SkillItem('Cursor', 'Advanced', 'Daily Driver', 'AI-native code editor with codebase-aware chat, inline edits, and multi-file refactors'),
      SkillItem('Windsurf', 'Advanced', 'Applied', 'Agentic IDE with context-aware code generation and iterative, multi-file edit flows'),
      SkillItem('Gemini 3.7 Flash', 'Advanced', 'Production', 'Low-latency chatbot model integration, prompt design, and API wiring for in-app AI assistants'),
    ],
  ),
];

const List<ExperienceItem> experience = [
  ExperienceItem(
    period: 'Jan 2026 – Present',
    role: 'Flutter Engineer',
    company: 'Rokkun Systems',
    companyUrl: 'https://rokkun.io',
    location: 'Bengaluru, India',
    type: 'Full-time / In-office',
    summary:
        'Leading mobile application development for Rentify, a Dubai-based fintech platform modernizing rental payments and property management.',
    bullets: [
      'Own the Rentify app end-to-end — from planning and design through development to deployment on the App Store and Google Play.',
      'Enables tenants to pay rent monthly with secure digital transactions and earn rewards across 200+ partner brands, while landlords receive rent upfront through banking partners.',
      'Rentify recognized as "Startup of the Year" at the Finance Middle East Awards 2025.',
      'Enforcing Clean Architecture, responsive slivers, zero frame drops, and robust API integration.',
    ],
    technologies: ['Flutter', 'Mobile Architecture', 'UI/UX Design', 'API Integration', 'State Management', 'CI/CD & Deployment', 'Team Leadership'],
  ),
  ExperienceItem(
    period: 'Oct 2023 – Present',
    role: 'Founder & Lead Engineer',
    company: 'Sameens',
    companyUrl: 'https://sameens.com',
    location: 'Bengaluru, Karnataka',
    type: 'Self-Employed / Venture',
    summary:
        'Founded and built Sameens, an online store for bags and accessories, engineered as two synchronized Flutter applications.',
    bullets: [
      'Engineered customer storefront for Android, iOS, and Web from a single codebase, paired with a Flutter Web admin dashboard for inventory, orders, transactions, and analytics.',
      'Engineered full purchase flow — catalogue, cart, Razorpay checkout, live order tracking, and shared PDF invoice renderer.',
      'Integrated Google Apps Script backend, Brevo email triggers, and internal Gemini AI chatbot for management inquiries.',
      'Three-tier role model (super admin / admin / manager) backed by 300+ unit, BLoC, and widget tests across screen sizes.',
    ],
    technologies: ['Flutter', 'Dart', 'Firebase (Firestore)', 'Google Apps Script', 'Razorpay', 'Clean Architecture', 'BLoC', 'GitHub Actions', 'Gemini AI', 'Brevo'],
  ),
  ExperienceItem(
    period: 'July 2025 – Dec 2025',
    role: 'Senior Flutter Developer',
    company: 'Intertec Systems',
    companyUrl: 'https://intertecsystems.com',
    location: 'Dubai, UAE · Remote',
    type: 'Full-time / Remote',
    summary:
        'Senior Flutter Developer on an enterprise application for Nama Water Services (NWS), an Oman Government entity (formerly OWWSC).',
    bullets: [
      'Contributed across full development lifecycle — requirement analysis, BRD/CR implementation, testing, deployment, and production support.',
      'Collaborated with cross-functional enterprise teams to deliver feature modules for water utility billing and account management.',
      'Managed source control on Microsoft Azure DevOps, conducted code reviews, wrote unit tests, and mentored junior developers within Agile/Scrum workflow.',
    ],
    technologies: ['Flutter', 'Enterprise Applications', 'Azure DevOps', 'Agile / Scrum', 'Jira', 'Unit Testing', 'Code Review', 'Mentoring'],
  ),
  ExperienceItem(
    period: 'Jul 2022 – Jun 2025',
    role: 'Flutter Developer',
    company: 'iBuild Software Solutions',
    companyUrl: 'https://ibuild.in',
    location: 'Bengaluru, Karnataka',
    type: 'Full-time / In-office',
    summary:
        'Successfully integrated ERP systems into mobile applications with attendance updates, real-time location tracking, admin access, background tasks, and attendance reporting. Developed an Intranet System facilitating real-time closed-network communication using Socket.IO.',
    bullets: [
      'Successfully integrated ERP systems into mobile applications with features like attendance tracking, live location monitoring, admin access, and automated background tasks.',
      'Developed an integrated Intranet System facilitating real-time communication among users within a closed network using Socket.IO.',
      'Collaborated closely across teams to deliver robust state management, responsive UI widgets, and stable API integrations.',
    ],
    technologies: ['Flutter', 'Software Development', 'Project Management', 'API Integration', 'State Management', 'Socket.IO', 'ERP Systems'],
  ),
  ExperienceItem(
    period: 'Jan 2022 – Jun 2022',
    role: 'Flutter Developer',
    company: 'Madvistara Software Solutions',
    companyUrl: 'https://thecompanycheck.com/company/madvistara-private-limited/U72900KA2022PTC159416',
    location: 'Bengaluru, Karnataka',
    type: 'Full-time / In-office',
    summary:
        'Built and integrated mobile app features with cloud services and REST APIs, focusing on data persistence and reliable API communication.',
    bullets: [
      'Built and integrated mobile app features with cloud services and REST APIs, focusing on data persistence and reliable API communication.',
      'Designed and wired backend cloud storage and database sync utilizing Firebase services.',
      'Constructed, tested, and validated RESTful endpoint payloads using the Postman API suite.',
    ],
    technologies: ['Firebase', 'Postman API', 'Flutter', 'API Integration', 'Database', 'REST APIs'],
  ),
];

const List<ArticleItem> articles = [
  ArticleItem(
    title: 'How to Pick Image from Camera and Gallery — Flutter 2023',
    platform: 'Medium',
    readTime: '4 min read',
    summary:
        'A step-by-step masterclass on capturing and selecting images from device camera and gallery in Flutter with permissions, compression, and modern state integration.',
    url: 'https://medium.com/@tabrezcool6/how-to-pick-image-from-camera-and-gallery-flutter-2023-2faa1d104eee',
    topics: ['Flutter', 'Camera & Gallery', 'Image Picker', 'Cross-Platform'],
  ),
  ArticleItem(
    title: 'Unit Tests for an API in Flutter — 2025',
    platform: 'Medium',
    readTime: '4 min read',
    summary:
        'A comprehensive guide on writing resilient unit tests for HTTP REST APIs in Flutter using mocktail, verifying payload contracts, status codes, and error states.',
    url: 'https://medium.com/@tabrezcool6/unit-tests-for-an-api-in-flutter-2025-e8f162ec9f46',
    topics: ['Flutter', 'Unit Testing', 'REST API', 'Mocktail'],
  ),
  ArticleItem(
    title: 'Widget Tests for a Counter Class in Flutter — 2025',
    platform: 'Medium',
    readTime: '4 min read',
    summary:
        'A step-by-step masterclass on isolating and asserting UI behavior in Flutter using testWidgets, finder APIs, and widget tester pumps.',
    url: 'https://medium.com/@tabrezcool6/widget-tests-for-a-counter-class-in-flutter-2025-c8c919d7ca88',
    topics: ['Flutter', 'Widget Testing', 'TDD', 'Quality Engineering'],
  ),
  ArticleItem(
    title: 'Integration Tests for a Login Page in Flutter — 2025',
    platform: 'Medium',
    readTime: '5 min read',
    summary:
        'Architecting comprehensive end-to-end integration tests for authentication workflows, verifying real input interactions and network mocks.',
    url: 'https://medium.com/@tabrezcool6/integration-tests-for-a-login-page-in-flutter-2025-9e09f8049181',
    topics: ['Flutter', 'Integration Testing', 'Auth Flow', 'Automation'],
  ),
];

const List<StatItem> stats = [
  StatItem('Target Frame Rate', '120 FPS', 'ProMotion & High Refresh'),
  StatItem('Architecture', '100%', 'Clean Arch & S.O.L.I.D'),
  StatItem('State Isolation', 'Zero Jank', 'Predictable Event Streams'),
  StatItem('Production Engine', 'Sameens', 'Bengaluru Tech Hub'),
];
