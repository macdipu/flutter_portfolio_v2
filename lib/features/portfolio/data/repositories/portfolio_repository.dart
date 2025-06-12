import '../models/blog_post_model.dart';
import '../models/profile_model.dart';
import '../services/medium_service.dart';

class PortfolioRepository {
  final MediumService _mediumService;

  PortfolioRepository({MediumService? mediumService})
      : _mediumService = mediumService ?? MediumService();

  Future<ProfileModel> getProfileData() async {
    return ProfileModel(
      name: 'Md. Asad Chowdhury Dipu',
      title: 'Flutter Developer | Mobile & Web App Specialist',
      introduction:
          'Passionate Flutter developer with expertise in creating beautiful, performant cross-platform applications. Specializing in elegant UI design and robust architecture.',
      about:
          'My journey into Flutter development began three years ago when I was searching for a framework that would allow me to build beautiful apps for both iOS and Android with a single codebase. What started as curiosity quickly turned into passion as I discovered Flutter\'s powerful capabilities and elegant design patterns. Since then, I\'ve worked on numerous projects, from simple utility apps to complex enterprise solutions, always striving to create exceptional user experiences and maintainable codebases.',
      avatarUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDko2K-54q8zwK4TMEPKz4GNAvFFYqr_TLOkXAYVl5oXUG9i0YUycZCpUF&s=10',
      experiences: _getExperiences(),
      educations: _getEducations(),
      projects: _getProjects(),
      services: _getServices(),
      techStacks: _getTechStacks(),
      contactInfo: _getContactInfo(),
      resumeUrl: 'assets/resume.pdf',
    );
  }

  Future<List<BlogPostModel>> getBlogPosts() async {
    return await _mediumService.fetchBlogPosts();
  }

  List<ExperienceModel> _getExperiences() {
    return [
      const ExperienceModel(
        company: 'Tech Innovations',
        position: 'Senior Flutter Developer',
        period: 'Jan 2022 - Present',
        description:
            'Leading Flutter development team in creating cutting-edge mobile applications. Implementing MVVM architecture and BLoC pattern for state management. Mentoring junior developers and establishing best practices.',
        logoUrl:
            'https://images.pexels.com/photos/4348404/pexels-photo-4348404.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      ),
      const ExperienceModel(
        company: 'Mobile Masters',
        position: 'Flutter Developer',
        period: 'Mar 2020 - Dec 2021',
        description:
            'Developed and maintained multiple Flutter applications for various clients. Implemented complex UI designs and integrated RESTful APIs. Collaborated with design and backend teams to ensure seamless user experiences.',
        logoUrl:
            'https://images.pexels.com/photos/5473298/pexels-photo-5473298.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      ),
      const ExperienceModel(
        company: 'FreelanceHub',
        position: 'Mobile App Developer',
        period: 'Jun 2018 - Feb 2020',
        description:
            'Created custom mobile applications for small to medium businesses. Utilized React Native before transitioning to Flutter. Managed entire project lifecycle from requirements gathering to app store submission.',
        logoUrl:
            'https://images.pexels.com/photos/3277808/pexels-photo-3277808.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      ),
    ];
  }

  List<EducationModel> _getEducations() {
    return [
      const EducationModel(
        institution: 'University of Technology',
        degree: 'Master of Computer Science',
        period: '2016 - 2018',
        description:
            'Specialized in Mobile Computing and User Interface Design. Thesis on Cross-Platform Mobile Development Frameworks.',
        logoUrl:
            'https://images.pexels.com/photos/159490/yale-university-landscape-universities-schools-159490.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      ),
      const EducationModel(
        institution: 'College of Engineering',
        degree: 'Bachelor of Computer Engineering',
        period: '2012 - 2016',
        description:
            'Core curriculum covering software development, algorithms, data structures, and computer networks. Participated in mobile app development club.',
        logoUrl:
            'https://images.pexels.com/photos/159490/yale-university-landscape-universities-schools-159490.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      ),
    ];
  }

  List<ProjectModel> _getProjects() {
    return [
      const ProjectModel(
        category: 'Full System',
        title: 'FitTracker Pro',
        role: 'Lead Developer',
        description:
            'A comprehensive fitness tracking application with personalized workout plans, nutrition tracking, and progress visualization.',
        technologies: [
          'Flutter',
          'Firebase',
          'Provider',
          'REST API',
          'Google Maps API'
        ],
        screenshots: [
          'https://images.pexels.com/photos/5391486/pexels-photo-5391486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/4482732/pexels-photo-4482732.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: 'https://play.google.com/store',
        sourceCodeUrl: 'https://github.com',
        challenge:
            'Implementing complex animations while maintaining performance. Solved by using custom painter and optimized rendering techniques.',
      ),
      const ProjectModel(
        category: 'Mobile',
        title: 'ShopEase',
        role: 'Solo Developer',
        description:
            'E-commerce application with features like product search, categorization, cart management, payment integration, and order tracking.',
        technologies: [
          'Flutter',
          'BLoC',
          'Firebase',
          'Stripe API',
          'Cloud Functions'
        ],
        screenshots: [
          'https://images.pexels.com/photos/230544/pexels-photo-230544.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/6214476/pexels-photo-6214476.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: 'https://play.google.com/store',
        sourceCodeUrl: 'https://github.com',
        challenge:
            'Managing complex state across multiple screens. Implemented BLoC pattern with stream-based architecture for reactive state management.',
      ),
      const ProjectModel(
        category: 'Backend',
        title: 'WeatherNow',
        role: 'Frontend Developer',
        description:
            'Real-time weather forecasting app with beautiful visualizations, location-based forecasts, and severe weather alerts.',
        technologies: [
          'Flutter',
          'GetX',
          'OpenWeatherMap API',
          'Animations',
          'Geolocation'
        ],
        screenshots: [
          'https://images.pexels.com/photos/2422588/pexels-photo-2422588.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/1118873/pexels-photo-1118873.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: 'https://play.google.com/store',
        sourceCodeUrl: 'https://github.com',
        challenge:
            'Creating smooth transitions between weather states. Used custom animations and staggered animations to achieve fluid UI transitions.',
      ),
      const ProjectModel(
        category: 'Others',
        title: 'TaskMaster',
        role: 'Team Lead',
        description:
            'Advanced task management application with features like project organization, time tracking, team collaboration, and detailed reporting.',
        technologies: ['Flutter', 'Firebase', 'BLoC', 'Cloud Firestore', 'FCM'],
        screenshots: [
          'https://images.pexels.com/photos/6408282/pexels-photo-6408282.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: 'https://play.google.com/store',
        sourceCodeUrl: 'https://github.com',
        challenge:
            'Implementing real-time synchronization across devices. Used Firebase Cloud Firestore with optimistic UI updates for responsive user experience.',
      ),
      const ProjectModel(
        category: 'Mobile',
        title: 'MedConnect',
        role: 'Mobile Developer',
        description:
            'Healthcare application connecting patients with doctors for virtual consultations, appointment scheduling, and medication tracking.',
        technologies: [
          'Flutter',
          'Provider',
          'WebRTC',
          'HIPAA Compliance',
          'Secure Storage'
        ],
        screenshots: [
          'https://images.pexels.com/photos/7578926/pexels-photo-7578926.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/7579830/pexels-photo-7579830.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: 'https://play.google.com/store',
        sourceCodeUrl: 'https://github.com',
        challenge:
            'Ensuring data security and compliance with healthcare regulations. Implemented end-to-end encryption and secure local storage solutions.',
      ),
    ];
  }

  List<ServiceModel> _getServices() {
    return [
      const ServiceModel(
        title: 'Cross-platform Mobile App Development',
        description:
            'Build your application once and deploy it across iOS, Android, and web platforms, saving time and resources while maintaining native-like performance.',
        iconUrl: 'https://img.icons8.com/color/96/null/flutter.png',
      ),
      const ServiceModel(
        title: 'UI/UX Implementation with Flutter',
        description:
            'Transform your design concepts into beautiful, responsive user interfaces with smooth animations and attention to detail that delights users.',
        iconUrl: 'https://img.icons8.com/color/96/null/design--v1.png',
      ),
      const ServiceModel(
        title: 'Backend Integration',
        description:
            'Connect your app to Firebase, REST/GraphQL APIs, and other backend services to create full-featured applications with real-time data synchronization.',
        iconUrl: 'https://img.icons8.com/color/96/null/api-settings.png',
      ),
      const ServiceModel(
        title: 'App Deployment and Publishing',
        description:
            'Navigate the app store submission process confidently with expert guidance on optimization, compliance, and best practices for successful publishing.',
        iconUrl: 'https://img.icons8.com/color/96/null/google-play.png',
      ),
      const ServiceModel(
        title: 'Consulting and Mentoring',
        description:
            'Benefit from expert advice on Flutter development best practices, architecture decisions, performance optimization, and team training.',
        iconUrl: 'https://img.icons8.com/color/96/null/training.png',
      ),
    ];
  }

  List<TechStackModel> _getTechStacks() {
    return [
      // Frameworks
      const TechStackModel(
        name: 'Flutter',
        category: 'Frameworks',
        iconUrl: 'https://img.icons8.com/color/96/null/flutter.png',
      ),
      const TechStackModel(
        name: 'React Native',
        category: 'Frameworks',
        iconUrl: 'https://img.icons8.com/color/96/null/react-native.png',
      ),

      // Programming Languages
      const TechStackModel(
        name: 'Dart',
        category: 'Programming Languages',
        iconUrl: 'https://img.icons8.com/color/96/null/dart.png',
      ),
      const TechStackModel(
        name: 'JavaScript',
        category: 'Programming Languages',
        iconUrl: 'https://img.icons8.com/color/96/null/javascript.png',
      ),
      const TechStackModel(
        name: 'TypeScript',
        category: 'Programming Languages',
        iconUrl: 'https://img.icons8.com/color/96/null/typescript.png',
      ),

      // UI & Design
      const TechStackModel(
        name: 'Material Design',
        category: 'UI & Design',
        iconUrl: 'https://img.icons8.com/color/96/null/material-ui.png',
      ),
      const TechStackModel(
        name: 'Cupertino',
        category: 'UI & Design',
        iconUrl: 'https://img.icons8.com/color/96/null/ios-logo.png',
      ),
      const TechStackModel(
        name: 'Figma',
        category: 'UI & Design',
        iconUrl: 'https://img.icons8.com/color/96/null/figma.png',
      ),

      // Dev Tools & Productivity
      const TechStackModel(
        name: 'Git',
        category: 'Dev Tools & Productivity',
        iconUrl: 'https://img.icons8.com/color/96/null/git.png',
      ),
      const TechStackModel(
        name: 'VS Code',
        category: 'Dev Tools & Productivity',
        iconUrl:
            'https://img.icons8.com/color/96/null/visual-studio-code-2019.png',
      ),
      const TechStackModel(
        name: 'Android Studio',
        category: 'Dev Tools & Productivity',
        iconUrl: 'https://img.icons8.com/color/96/null/android-studio--v3.png',
      ),

      // Other Technologies
      const TechStackModel(
        name: 'Firebase',
        category: 'Other Technologies',
        iconUrl: 'https://img.icons8.com/color/96/null/firebase.png',
      ),
      const TechStackModel(
        name: 'RESTful APIs',
        category: 'Other Technologies',
        iconUrl: 'https://img.icons8.com/color/96/null/api-settings.png',
      ),
      const TechStackModel(
        name: 'GraphQL',
        category: 'Other Technologies',
        iconUrl: 'https://img.icons8.com/color/96/null/graphql.png',
      ),
    ];
  }

  ContactInfoModel _getContactInfo() {
    return const ContactInfoModel(
      email: 'c.dipu0@gmail.com',
      linkedIn: 'https://www.linkedin.com/in/md-asad-chowdhury-dipu/',
      github: 'https://github.com/dipu0',
      twitter: 'https://x.com/dipu093',
      calendlyLink: 'https://calendly.com/macdipu',
    );
  }
}
