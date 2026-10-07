export interface Project {
  id: string;
  title: string;
  tagline: string;
  category: 'Mobile' | 'Website' | 'Android';
  badgeType: string;
  badges?: string[];
  description: string;
  longDescription: string;
  highlights: string[];
  technologies: string[];
  metrics?: { label: string; value: string }[];
  projectUrl: string;
  actionLabel: string;
  actionType: 'website' | 'playstore' | 'github';
  playStoreUrl?: string;
  githubUrl?: string;
  iconName: string;
  featured: boolean;
  codeSnippet?: {
    filename: string;
    code: string;
  };
}

export interface SkillCategory {
  title: string;
  subtitle: string;
  items: {
    name: string;
    level: string;
    experience: string;
    description: string;
  }[];
}

export interface ExperienceItem {
  period: string;
  role: string;
  company: string;
  companyUrl?: string;
  location: string;
  type: string;
  summary: string;
  bullets: string[];
  technologies: string[];
}

export interface ArticleItem {
  title: string;
  platform: string;
  readTime: string;
  summary: string;
  url: string;
  topics: string[];
}
