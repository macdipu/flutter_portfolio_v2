/// All portfolio content. Static, verified facts only.
///
/// To add a project, append a [Project] to [projects]. A project needs real
/// preview graphics ([Shot]s); the showcase will not invent any.
library;

import 'package:flutter/material.dart' show IconData, Icons;

abstract class AppLinks {
  static const email = 'c.dipu0@gmail.com';
  static const site = 'https://masadcd.online';
  static const github = 'https://github.com/macdipu';
  static const linkedIn = 'https://www.linkedin.com/in/md-asad-chowdhury-dipu/';
  static const x = 'https://x.com/dipu093';
  static const calendly = 'https://calendly.com/macdipu';
  static const medium = 'https://medium.com/@c.dipu0';
  static const siteSource = 'https://github.com/macdipu/flutter_portfolio_v2';
}

abstract class Profile {
  static const name = 'Md. Asad Chowdhury Dipu';
  static const handle = 'MACDIPU';
  static const role = 'Forward Deployed Engineer';

  static const intro =
      'I turn complex problems into practical software solutions, '
      'building products across mobile, desktop, web and AI-powered systems.';

  static const about =
      'I am a software engineer focused on building and deploying '
      'real-world software solutions. My work spans mobile, desktop, '
      'web and backend engineering, with an interest in AI agents, '
      'LLM integrations and agentic workflows. Since 2020, I have '
      'built and published independent apps on Google Play through '
      'Chowdhury eLab. Since 2023, I have been shipping production '
      'products at Polygon Technology, including consumer applications '
      'and a payments platform. Beyond client work, I build open-source '
      'tools, explore emerging AI technologies and turn ideas into '
      'working products.';

  static const avatar = 'assets/images/avatar.jpg';
}

/// What a project runs on. Drives the badge shown in the showcase.
enum Platform {
  mobile('Mobile', Icons.smartphone),
  desktop('Desktop', Icons.desktop_windows_outlined),
  web('Web', Icons.language),
  fullStack('Full stack', Icons.layers_outlined),
  cli('CLI', Icons.terminal);

  const Platform(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// How a preview graphic is presented.
enum ShotKind { phone, desktop, browser, diagram }

class Shot {
  const Shot(this.asset, this.kind, this.caption);
  final String asset;
  final ShotKind kind;
  final String caption;
}

class ProjectLink {
  const ProjectLink(this.label, this.url);
  final String label;
  final String url;
}

class Project {
  const Project({
    required this.title,
    required this.role,
    required this.summary,
    required this.platforms,
    required this.tags,
    required this.links,
    required this.shots,
    this.note,
  });

  final String title;

  /// Your part in it, e.g. "Developer at Polygon Technology".
  final String role;
  final String summary;
  final List<Platform> platforms;
  final List<String> tags;
  final List<ProjectLink> links;
  final List<Shot> shots;

  /// Shown instead of links when there is nothing public to link to.
  final String? note;
}

/// Showcase projects, in display order. Every one has real preview graphics.
const projects = <Project>[
  Project(
    title: 'Distribution and product verification platform',
    role: 'Built and developed at Polygon Technology',
    summary: 'A distribution, e-commerce and product verification management '
        'system for engine oil brands. I built and developed it, and it ships '
        'as five apps: Shell Agami, Shell BD, Motul Bangladesh, ASTRO Connect '
        'and Reward Link.',
    platforms: [Platform.mobile],
    tags: ['Flutter', 'BLoC', 'REST API', 'Engine oil'],
    links: [
      ProjectLink('Shell Agami',
          'https://play.google.com/store/apps/details?id=com.shell.agami'),
      ProjectLink('Shell BD',
          'https://play.google.com/store/apps/details?id=com.shell.consumer.shell_consumer'),
      ProjectLink('Motul Bangladesh',
          'https://play.google.com/store/apps/details?id=com.motulbd.consumer'),
      ProjectLink('ASTRO Connect',
          'https://play.google.com/store/apps/details?id=com.astroconnectbd.customerapp'),
      ProjectLink('Reward Link',
          'https://play.google.com/store/apps/details?id=com.ulolrewardlink.reward_link'),
    ],
    shots: [
      Shot('assets/images/projects/shell-agami-home.webp', ShotKind.phone,
          'Shell Agami home screen'),
      Shot('assets/images/projects/shell-consumer-home.webp', ShotKind.phone,
          'Shell BD home screen'),
      Shot('assets/images/projects/motul-home.webp', ShotKind.phone,
          'Motul Bangladesh home screen'),
      Shot('assets/images/projects/astro-home.webp', ShotKind.phone,
          'ASTRO Connect home screen'),
      Shot('assets/images/projects/reward-home.webp', ShotKind.phone,
          'Reward Link home screen'),
    ],
  ),
  Project(
    title: 'Weight Tracker',
    role: 'Independent developer, Chowdhury eLab',
    summary:
        'Log weigh-ins, body measurements, meals, water, steps and sleep, with '
        'BMI, calorie targets and goal projections worked out on the device. '
        'Multiple profiles, reminders, backup and restore, and no account: '
        'your records stay in a local database.',
    platforms: [Platform.mobile],
    tags: ['Flutter', 'Drift', 'Health Connect', 'Offline-first'],
    links: [
      ProjectLink('Website', 'https://macdipu.github.io/weight_tracker/'),
      ProjectLink('Google Play',
          'https://play.google.com/store/apps/details?id=com.chowdhury_elab.weight_tracker'),
    ],
    shots: [
      Shot('assets/images/projects/wt-today.webp', ShotKind.phone,
          'Weight Tracker today screen'),
      Shot('assets/images/projects/wt-weight_trend.webp', ShotKind.phone,
          'Weight Tracker weight trend'),
      Shot('assets/images/projects/wt-insights.webp', ShotKind.phone,
          'Weight Tracker weekly insights'),
      Shot('assets/images/projects/wt-food.webp', ShotKind.phone,
          'Weight Tracker food log'),
      Shot('assets/images/projects/wt-share_progress.webp', ShotKind.phone,
          'Weight Tracker shareable progress card'),
    ],
  ),
  Project(
    title: 'Muslim Deen',
    role: 'Independent developer, Chowdhury eLab',
    summary: 'An offline-first Islamic companion for Android. Prayer times are '
        'calculated on the device with real azan alarms, alongside the Quran '
        'with audio, a live Qibla compass, a prayer tracker with missed-prayer '
        'counts, tasbih, duas and azkar, a Zakat calculator, a mosque finder '
        'and 15 home-screen widgets, in English and Bangla. No ads, no '
        'account.',
    platforms: [Platform.mobile],
    tags: ['Flutter', 'Offline-first', 'Home-screen widgets', 'Android'],
    links: [
      ProjectLink('Website', 'https://macdipu.github.io/muslim_deen/'),
      ProjectLink('Google Play',
          'https://play.google.com/store/apps/details?id=com.chowdhuryelab.muslimdeen'),
    ],
    shots: [
      Shot('assets/images/projects/md-01-home.jpg', ShotKind.phone,
          'Muslim Deen prayer times and daily progress'),
      Shot('assets/images/projects/md-02-collection.jpg', ShotKind.phone,
          'Muslim Deen feature collection'),
      Shot('assets/images/projects/md-03-quran.jpg', ShotKind.phone,
          'Muslim Deen Quran with translation'),
      Shot('assets/images/projects/md-04-tasbih.jpg', ShotKind.phone,
          'Muslim Deen tasbih counter'),
      Shot('assets/images/projects/md-05-daily-amal.jpg', ShotKind.phone,
          'Muslim Deen daily Amal checklist'),
    ],
  ),
  Project(
    title: 'FlexWork',
    role: 'Author, private repository',
    summary:
        'A mobile-first workforce marketplace for Bangladesh that connects '
        'businesses with flexible workers. A Flutter worker app (find jobs, '
        'apply, check in and out, get paid), a Flutter employer app (post '
        'jobs, manage candidates, pay workers) and a Next.js admin panel '
        'share one backend of 16 services behind a Spring Cloud Gateway.',
    platforms: [Platform.fullStack, Platform.mobile, Platform.web],
    tags: [
      'Flutter',
      'Spring Boot',
      'Next.js',
      'Django',
      'FastAPI',
      'Node.js',
      'PostgreSQL',
      'Docker',
    ],
    links: [],
    note: 'Private repository. The diagram is the system architecture.',
    shots: [
      Shot('flexwork', ShotKind.diagram, 'FlexWork system architecture'),
    ],
  ),
  Project(
    title: 'BuildingOS',
    role: 'Author, open source',
    summary: 'A platform monorepo: Spring Boot microservices (gateway, auth, '
        'building, subscription, back-office), a Flutter user app and a '
        'back-office web app, joined by OpenAPI and Kafka contracts. Clean '
        'Architecture is enforced by tests, and it is built with an agentic '
        'development kit: 34 skills, delivery workflows and a harness with '
        'evidence and approval gates.',
    platforms: [Platform.fullStack, Platform.mobile, Platform.web],
    tags: [
      'Spring Boot',
      'Flutter',
      'GetX',
      'Kafka',
      'PostgreSQL',
      'Clean Architecture',
      'AI agents',
    ],
    links: [
      ProjectLink('Source on GitHub', 'https://github.com/macdipu/BuildingOS'),
    ],
    shots: [
      Shot('buildingos', ShotKind.diagram, 'BuildingOS system architecture'),
    ],
  ),
  Project(
    title: 'OpenReader',
    role: 'Author, open source',
    summary:
        'A document reader built with Flutter. Browse, open, read, search and '
        'navigate the documents on your device, with no account and no '
        'server: nothing you open ever leaves it.',
    platforms: [Platform.desktop, Platform.mobile],
    tags: ['Flutter', 'Dart', 'Offline-first', 'Windows', 'Android'],
    links: [
      ProjectLink('Website', 'https://macdipu.github.io/OpenReader/'),
      ProjectLink('Source on GitHub', 'https://github.com/macdipu/OpenReader'),
    ],
    shots: [
      Shot('assets/images/projects/openreader-desktop.png', ShotKind.desktop,
          'OpenReader on Windows'),
      Shot('assets/images/projects/openreader-phone.png', ShotKind.phone,
          'OpenReader on Android'),
    ],
  ),
  Project(
    title: 'GitSwitch',
    role: 'Author, open source',
    summary:
        'Use several Git accounts (work, personal, clients) on one computer '
        'with normal clone URLs. GitSwitch picks the right SSH key and commit '
        'email for every clone, pull and push, with a terminal app and a '
        'desktop app for Windows, macOS and Linux.',
    platforms: [Platform.cli, Platform.desktop],
    tags: ['Go', 'SSH', 'Cross-platform'],
    links: [
      ProjectLink('Source on GitHub', 'https://github.com/macdipu/gitswitch'),
    ],
    shots: [
      Shot('assets/images/projects/gitswitch-accounts.png', ShotKind.browser,
          'GitSwitch accounts screen'),
    ],
  ),
  Project(
    title: 'BMI and BMR Calculator',
    role: 'Independent developer, Chowdhury eLab',
    summary: 'Calculates Body Mass Index and Basal Metabolic Rate from weight, '
        'height, age and gender, with a weight monitor, a BMI avatar, metric '
        'and imperial units, and offline use. It started as a Java app and '
        'was later migrated to Flutter. Published on Google Play with 50K+ '
        'downloads.',
    platforms: [Platform.mobile],
    tags: ['Flutter', 'BLoC', 'Java', 'Offline'],
    links: [
      ProjectLink('Google Play',
          'https://play.google.com/store/apps/details?id=com.chowdhuryelab.bmiandbmrcalculator'),
      ProjectLink('Original Java source',
          'https://github.com/macdipu/BMI_and_BMR_Calculator_Android_Java_Application'),
    ],
    shots: [
      Shot('assets/images/projects/bmi-input.webp', ShotKind.phone,
          'BMI and BMR Calculator input screen'),
      Shot('assets/images/projects/bmi-result-dark.webp', ShotKind.phone,
          'BMI and BMR Calculator result, dark theme'),
      Shot('assets/images/projects/bmi-result.webp', ShotKind.phone,
          'BMI and BMR Calculator result, light theme'),
    ],
  ),
];

class ProofFact {
  const ProofFact(this.headline, this.detail);
  final String headline;
  final String detail;
}

/// Facts shown under the hero. Each is stated elsewhere on the page.
const proofFacts = <ProofFact>[
  ProofFact('Software Engineer III',
      'At Polygon Technology, promoted twice since Sep 2023'),
  ProofFact('50K+ downloads on Google Play',
      'BMI and BMR Calculator, from Chowdhury eLab'),
  ProofFact(
      'Open source', 'OpenReader, GitSwitch and BuildingOS, public on GitHub'),
];

class Role {
  const Role(this.position, this.period, this.description);
  final String position;
  final String period;
  final String description;
}

class Employer {
  const Employer(this.name, this.roles, {this.shipped = const []});
  final String name;
  final List<Role> roles;

  /// Products shipped here, as plain sentences.
  final List<String> shipped;
}

const experience = <Employer>[
  Employer(
    'Polygon Technology',
    [
      Role(
        'Software Engineer III',
        'July 2025 to present',
        'Promoted to Software Engineer III. Contributing to blockchain and '
            'technology solutions in a collaborative engineering environment.',
      ),
      Role(
        'Software Engineer II',
        'Sep 2024 to June 2025',
        'Promoted to Software Engineer II.',
      ),
      Role(
        'Software Engineer I',
        'Sep 2023 to Oct 2024',
        'Worked on scalable solutions within the Polygon ecosystem with '
            'cross-functional teams.',
      ),
    ],
    shipped: [
      'Shamadhan Pay: a mobile app and a merchant web portal for a payment '
          'service provider MVP, built for secure, inclusive digital payments, '
          'regulatory compliance and scale (Flutter, Flutter Web, GetX, REST).',
      'Agave: a marketplace app for Japanese users to buy and sell household '
          'plants, with localized UX and full e-commerce (Flutter, BLoC, REST).',
    ],
  ),
  Employer('Chowdhury eLab', [
    Role(
      'Founder and developer',
      'May 2020 to present',
      'Founded Chowdhury eLab and published multiple mobile apps on Google '
          'Play. Led the full app lifecycle: design, development, testing and '
          'deployment.',
    ),
  ]),
  Employer('Palki Motors Limited', [
    Role(
      'Software Engineer I',
      'Aug 2023 to Sep 2023',
      'Developed software systems for digital transformation in the '
          'automotive domain.',
    ),
    Role(
      'IoT System Developer',
      'May 2023 to Jul 2023',
      'Built and tested IoT solutions for smart vehicles, integrating '
          'hardware with cloud systems.',
    ),
  ]),
  Employer('East West University Robotics Club', [
    Role(
      'President',
      'Aug 2021 to Apr 2023',
      'Led the club and organized national-level tech events and workshops.',
    ),
    Role(
      'Training instructor',
      'Feb 2021 to Feb 2022',
      'Trained junior members and helped design workshop content.',
    ),
  ]),
];

class SkillGroup {
  const SkillGroup(this.title, this.items);
  final String title;
  final List<String> items;
}

/// Two rows, used by both the scrolling strip and the About section.
const engineeringSkills = <String>[
  'Flutter',
  'Dart',
  'Kotlin',
  'Java',
  'Spring Boot',
  'PostgreSQL',
  'Redis',
  'Docker',
  'Kubernetes',
  'Kafka',
  'Clean Architecture',
  'Microservices',
];

const aiSkills = <String>[
  'AI Agents',
  'MCP',
  'RAG',
  'LLM Integration',
  'Agentic Workflows',
  'Multi-Agent Systems',
  'Context Engineering',
  'AI Orchestration',
  'OpenAI API',
  'LangGraph',
  'FDE',
];

/// Grouped for the About section. No ratings: they mean nothing.
const skills = <SkillGroup>[
  SkillGroup('Engineering', engineeringSkills),
  SkillGroup('AI and agentic engineering', aiSkills),
];

class Education {
  const Education(this.institution, this.degree, this.period);
  final String institution;
  final String degree;
  final String period;
}

const education = <Education>[
  Education('East West University', 'B.Sc. in Computer Science and Engineering',
      'Jan 2019 to Mar 2023'),
];
