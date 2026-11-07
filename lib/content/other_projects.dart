/// Smaller, older and experimental work, listed as plain rows.
///
/// Descriptions follow each repository's own README or description.
library;

class OtherProject {
  const OtherProject({
    required this.title,
    required this.summary,
    required this.tags,
    required this.url,
  });

  final String title;
  final String summary;
  final List<String> tags;
  final String url;
}

const otherProjects = <OtherProject>[
  OtherProject(
    title: 'universal_document_viewer',
    summary: 'A Flutter package that opens PDF, Word, Excel, CSV, PowerPoint '
        'and plain text with one widget or one controller API.',
    tags: ['Flutter', 'Dart', 'pub.dev'],
    url: 'https://github.com/macdipu/universal_document_viewer',
  ),
  OtherProject(
    title: 'JamSync',
    summary: 'Plays the same audio on several phones, tablets and computers '
        'over a local network, in sync, with one host in control.',
    tags: ['Flutter', 'UDP multicast', 'HTTP streaming'],
    url: 'https://github.com/macdipu/jamsync',
  ),
  OtherProject(
    title: 'SpeedLoop',
    summary: 'GPS speedometer and trip analysis with background trip '
        'recording, OpenStreetMap routes, a dashcam overlay and GPX '
        'import and export.',
    tags: ['Flutter', 'Clean Architecture', 'GPS'],
    url: 'https://github.com/macdipu/SpeedLoop',
  ),
  OtherProject(
    title: 'FCM Tools',
    summary: 'Validates Firebase service accounts and device tokens and sends '
        'test push notifications. Credentials are never stored.',
    tags: ['FastAPI', 'Next.js', 'Docker'],
    url: 'https://github.com/macdipu/fcm_tools',
  ),
  OtherProject(
    title: 'Flutter Clean Architecture (GetX)',
    summary: 'A Flutter template with Clean Architecture, a feature generator '
        'and build-time config through --dart-define-from-file.',
    tags: ['Flutter', 'GetX', 'Template'],
    url: 'https://github.com/macdipu/Flutter-Clean-Architecture-Getx',
  ),
  OtherProject(
    title: 'Agentic Development Kit',
    summary: '34 specialist skills, delivery workflows and a local Python '
        'harness that coordinates software work with explicit evidence and '
        'approval gates.',
    tags: ['Python', 'AI agents', 'Workflows'],
    url: 'https://github.com/macdipu/agentic-development-kit',
  ),
  OtherProject(
    title: 'Todo app, Django and Flutter',
    summary: 'A full-stack task manager: Django backend APIs and a Flutter '
        'frontend for create, read, update and delete.',
    tags: ['Flutter', 'Django', 'REST API'],
    url: 'https://github.com/macdipu/todo-django-flutter',
  ),
  OtherProject(
    title: 'My 2nd Home',
    summary: 'An online rental platform that connects students and office '
        'workers with homeowners to rent flats.',
    tags: ['Django', 'Python'],
    url: 'https://github.com/macdipu/my_2nd_home-django',
  ),
  OtherProject(
    title: 'Greeneries',
    summary: 'An Android app for buying indoor and outdoor plants and getting '
        'help with planting, for plant lovers and sellers.',
    tags: ['Android', 'Java'],
    url:
        'https://github.com/macdipu/Greeneries-E-Gardening-Android-Java-Application',
  ),
  OtherProject(
    title: 'Water level controller',
    summary: 'A microcontroller-based device that switches a water pump on and '
        'off automatically, so it never overflows or runs dry.',
    tags: ['C++', 'Microcontroller', 'IoT'],
    url:
        'https://github.com/macdipu/microcontroller-based-water-level-controller-in-domestic',
  ),
];
