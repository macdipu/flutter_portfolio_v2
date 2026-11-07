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

  static const avatar = 'assets/images/avatar.png';
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
enum ShotKind { phone, desktop, browser, banner }

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
  });

  final String title;

  /// Your part in it, e.g. "Developer at Polygon Technology".
  final String role;
  final String summary;
  final List<Platform> platforms;
  final List<String> tags;
  final List<ProjectLink> links;
  final List<Shot> shots;
}

/// Showcase projects, in display order. Every one has real preview graphics.
const projects = <Project>[
  Project(
    title: 'Shell Agami and Shell Consumer',
    role: 'Developer at Polygon Technology',
    summary: 'Consumer mobile apps with e-commerce, product guides, MotoGP '
        'campaigns, a geolocation-based mechanic and shop finder, and product '
        'authenticity verification.',
    platforms: [Platform.mobile],
    tags: ['Flutter', 'BLoC', 'REST API'],
    links: [
      ProjectLink('Shell Consumer on Google Play',
          'https://play.google.com/store/apps/details?id=com.shell.consumer.shell_consumer'),
      ProjectLink('Shell Agami on Google Play',
          'https://play.google.com/store/apps/details?id=com.shell.agami'),
    ],
    shots: [
      Shot('assets/images/projects/shell-agami-home.webp', ShotKind.phone,
          'Shell Agami home screen'),
      Shot('assets/images/projects/shell-consumer-home.webp', ShotKind.phone,
          'Shell Consumer home screen'),
      Shot('assets/images/projects/shell-agami-scan.webp', ShotKind.phone,
          'Shell Agami product code scanner'),
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
    title: 'BMI & BMR Calculator',
    role: 'Independent developer, Chowdhury eLab',
    summary: 'Calculates Body Mass Index and Basal Metabolic Rate from weight, '
        'height, age and gender. First written in Java, later migrated to '
        'Flutter, and published on Google Play.',
    platforms: [Platform.mobile],
    tags: ['Flutter', 'BLoC', 'Java'],
    links: [
      ProjectLink('Google Play',
          'https://play.google.com/store/apps/details?id=com.chowdhuryelab.bmiandbmrcalculator'),
      ProjectLink('Original Java source',
          'https://github.com/macdipu/BMI_and_BMR_Calculator_Android_Java_Application'),
    ],
    shots: [
      Shot('assets/images/projects/bmi-1.webp', ShotKind.phone,
          'BMI & BMR Calculator input screen'),
      Shot('assets/images/projects/bmi-2.webp', ShotKind.phone,
          'BMI & BMR Calculator result'),
      Shot('assets/images/projects/bmi-3.webp', ShotKind.phone,
          'BMI & BMR Calculator result, dark'),
    ],
  ),
  Project(
    title: 'QrXpert',
    role: 'Independent developer, Chowdhury eLab',
    summary: 'A QR code scanner and generator with fast scanning and export, '
        'published on Google Play.',
    platforms: [Platform.mobile],
    tags: ['Flutter'],
    links: [
      ProjectLink('Google Play',
          'https://play.google.com/store/apps/details?id=com.chowdhuryelab.qrxpert'),
    ],
    shots: [
      Shot('assets/images/projects/qrxpert-banner.webp', ShotKind.banner,
          'QrXpert scanning and generating QR codes'),
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
  ProofFact(
      'On Google Play since 2020', 'Own apps published through Chowdhury eLab'),
  ProofFact('Open source', 'OpenReader and GitSwitch, public on GitHub'),
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

/// Grouped by what appears in the work above. No ratings: they mean nothing.
const skills = <SkillGroup>[
  SkillGroup('Apps', ['Flutter', 'Dart', 'Flutter Web', 'Android (Java)']),
  SkillGroup('Architecture', ['BLoC', 'GetX', 'Clean Architecture']),
  SkillGroup(
      'Backend and data', ['REST APIs', 'Firebase', 'Supabase', 'Django']),
  SkillGroup('Also used', ['Go', 'Python', 'Git', 'Figma']),
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
