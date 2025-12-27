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
      keyAccomplishments: _getKeyAccomplishments(),
      experiences: _getExperienceGroups(),
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

  List<ExperienceGroup> _getExperienceGroups() {
    return [
      ExperienceGroup(
        company: 'Polygon Technology',
        logoUrl:
            'https://media.licdn.com/dms/image/v2/D560BAQEqKBLaCHxhEA/company-logo_200_200/company-logo_200_200/0/1691577235644/polygontechxyz_logo?e=1766016000&v=beta&t=wDSNYO6aOPpHFkq2rUbs1IvB5SOYRzK2BvG3o7MrT7g',
        roles: const [
          ExperienceModel(
            position: 'Software Engineer III',
            period: 'July 2025 - Present',
            description:
            'Promoted to Software Engineer III. Contributing to cutting-edge blockchain and technology solutions in a collaborative engineering environment.',
          ),
          ExperienceModel(
            position: 'Software Engineer II',
            period: 'Sep 2024 - June 2025',
            description:
                'Promoted to Software Engineer II. Contributing to cutting-edge blockchain and technology solutions in a collaborative engineering environment.',
          ),
          ExperienceModel(
            position: 'Software Engineer I',
            period: 'Sep 2023 - Oct 2024',
            description:
                'Worked on scalable solutions within the Polygon ecosystem. Collaborated with cross-functional teams to build high-quality features.',
          ),
        ],
      ),
      ExperienceGroup(
        company: 'Chowdhury eLab',
        logoUrl:
            'https://media.licdn.com/dms/image/v2/D560BAQFibK2WK_nyzA/company-logo_100_100/company-logo_100_100/0/1702666475953/chowdhury_elab_logo?e=1766016000&v=beta&t=ZQM_59OqYls6M6VUlhhKm3zTwWrVH63ITFvlfISElhA',
        roles: const [
          ExperienceModel(
            position: 'Founder & Developer',
            period: 'May 2020 - Present',
            description:
                'Founded Chowdhury eLab and published multiple mobile apps on Google Play. Led full app lifecycle including design, development, testing, and deployment.',
          ),
        ],
      ),
      ExperienceGroup(
        company: 'Palki Motors Limited',
        logoUrl:
            'https://media.licdn.com/dms/image/v2/D560BAQEM5DcgpE1eeA/company-logo_200_200/company-logo_200_200/0/1664963823045/palkimotors_logo?e=1766016000&v=beta&t=-TjpRKT6ie5q9OVHmAwRMvsOnZxLZH-se6v6LAUjghs',
        roles: const [
          ExperienceModel(
            position: 'Software Engineer I',
            period: 'Aug 2023 - Sep 2023',
            description:
                'Developed software systems and contributed to digital transformation initiatives in the automotive domain.',
          ),
          ExperienceModel(
            position: 'IoT System Developer',
            period: 'May 2023 - Jul 2023',
            description:
                'Built and tested IoT solutions to enhance smart vehicle capabilities, integrating hardware with cloud-based systems.',
          ),
        ],
      ),
      ExperienceGroup(
        company: 'East West University Robotics Club',
        logoUrl:
            'https://media.licdn.com/dms/image/v2/C510BAQENncUmrD8khQ/company-logo_100_100/company-logo_100_100/0/1631432166987?e=1766016000&v=beta&t=7vQ145JdU2i9mPrtB0tTNoWVz2lStxThR5pJP2RnG_U',
        roles: const [
          ExperienceModel(
            position: 'President',
            period: 'Aug 2021 - Apr 2023',
            description:
                'Led the university robotics club, organized national-level tech events and workshops. Promoted innovation and technical skill development.',
          ),
          ExperienceModel(
            position: 'Training Instructor',
            period: 'Feb 2021 - Feb 2022',
            description:
                'Provided robotics training to junior members. Helped design workshop content, mentored new members, and coordinated sessions.',
          ),
        ],
      ),
      ExperienceGroup(
        company: 'East West University Telecommunications Club',
        logoUrl:
            'https://media.licdn.com/dms/image/v2/D560BAQE3Ig16zmdTbQ/company-logo_200_200/company-logo_200_200/0/1667837153058?e=1766016000&v=beta&t=Kli2EduqgQfGn1ghG8or0JN9svDBg5pQMcdO190bRVg',
        roles: const [
          ExperienceModel(
            position: 'Executive Member',
            period: 'Dec 2020 - Apr 2021',
            description:
                'Contributed to club operations, including organizing seminars and networking events focused on telecommunications technologies.',
          ),
        ],
      ),
    ];
  }

  List<EducationModel> _getEducations() {
    return [
      const EducationModel(
        institution: 'East West University',
        degree: 'B.Sc. in Computer Science & Engineering (CSE)',
        period: 'Jan 2019 - Mar 2023',
        description:
            'Focused on software development, data structures, algorithms, and robotics. Actively participated in Robotics and Telecom clubs.',
        logoUrl:
            'https://media.licdn.com/dms/image/v2/C510BAQH2cytqbI1UmQ/company-logo_200_200/company-logo_200_200/0/1630606663213/ewubd_logo?e=1766016000&v=beta&t=eGkGnTRspA65pkS99NGdm4axxmC5yafQwTc2hrBk_PA',
      ),
      const EducationModel(
        institution: 'Engineering University School & College',
        degree: 'H.S.C. in Science',
        period: '2016 - 2018',
        description:
            'Completed Higher Secondary education with a focus on Physics, Chemistry, and Mathematics.',
        logoUrl:
            'https://media.licdn.com/dms/image/v2/C560BAQEoAguxZkmliA/company-logo_200_200/company-logo_200_200/0/1676649091271?e=1766016000&v=beta&t=IoXQEcsyzbzRITIq5ttFTd2pjf1WzIOhblHlI1EN8gg',
      ),
      const EducationModel(
        institution: 'A.K. High School & College',
        degree: 'S.S.C. in Science',
        period: '2011 - 2016',
        description:
            'Completed secondary education with a focus on general science and mathematics.',
        logoUrl:
            'https://media.licdn.com/dms/image/v2/C560BAQFinT-wyRnjng/company-logo_200_200/company-logo_200_200/0/1630646597668?e=1766016000&v=beta&t=5DDhQBHPyuQSai2ZtVQ7Y6Wkc8V55PSU0jb7C1zxhKU',
      ),
    ];
  }

  List<ProjectModel> _getProjects() {
    return [
      // Professional Projects
      const ProjectModel(
        category: 'Mobile',
        title: 'Shell Agami App',
        role: 'Developer at Polygon Technology',
        description:
            'Developed and maintained a consumer-facing mobile app with e-commerce functionality, product guides, MotoGP campaigns, geolocation-based mechanic/shop finder, and product authenticity verification.',
        technologies: ['Flutter', 'BLoC', 'REST API'],
        screenshots: [
          'https://play-lh.googleusercontent.com/qNFTKTGpMYFD1vyB7ilBMsFOd9pUjDHsU8BwszQnNuAFbWYlLPmZeuWqErMzfZ-gpA=w2560-h1440-rw',
          'https://play-lh.googleusercontent.com/hTuxlpIUqTV1nrd2MBbw9XldzWs3E56y3_9AfIcSqxzPXA02sPlWhjK6IC0pJPw4vQ=w2560-h1440-rw',
          'https://play-lh.googleusercontent.com/QbEX2WZn1qd1XC9Il-MwL2skoLEXu0jAX89qtkZtRHtZREdH-HaZ2m9H_8DGtU6faQ=w2560-h1440-rw'
        ],
        appUrl:
            'https://play.google.com/store/apps/details?id=com.shell.agami&pcampaignid=web_share',
        sourceCodeUrl: '',
        challenge: '',
      ),
      const ProjectModel(
        category: 'Mobile',
        title: 'Shell Consumer App',
        role: 'Developer at Polygon Technology',
        description:
            'Developed and maintained a consumer-facing mobile app with e-commerce functionality, product guides, MotoGP campaigns, geolocation-based mechanic/shop finder, and product authenticity verification.',
        technologies: ['Flutter', 'BLoC', 'REST API'],
        screenshots: [
          'https://play-lh.googleusercontent.com/pS0NM82Eucvil55Sk_pIBJSuOduZQTmh3Z2lFMtqQlJi7g-6TaPHma3KrOa9BGA3E2Gi=w2560-h1440-rw',
          'https://play-lh.googleusercontent.com/rqefnXiCFOZXStLW5qwAXlC6-dQaX9RSO-yR90hzzg4zw8_TJbmz7i82Ib920T8b91g=w2560-h1440-rw',
          'https://play-lh.googleusercontent.com/rmZ594BAWCFn8lp6uEjMjFGuB2ntdYrD66ELMwW6VFnMTCdbmsFoir7x8uKfKdLiww0=w2560-h1440-rw'
        ],
        appUrl:
            'https://play.google.com/store/apps/details?id=com.shell.consumer.shell_consumer&pcampaignid=web_share',
        sourceCodeUrl: '',
        challenge: '',
      ),
      const ProjectModel(
        category: 'Mobile',
        title: 'Shamadhan Pay - User App',
        role: 'Developer at Polygon Technology',
        description:
            'Built a mobile app and merchant web portal for a Payment Service Provider (PSP) MVP, focusing on secure and inclusive digital payments, designed for regulatory compliance and scalability.',
        technologies: ['Flutter', 'GetX', 'REST API'],
        screenshots: [
          'https://shamadhan.com.bd/wp-content/uploads/2025/12/app.png'
        ],
        appUrl: 'https://shamadhan.com.bd/',
        sourceCodeUrl: '',
        challenge: '',
      ),
      const ProjectModel(
        category: 'Web',
        title: 'Shamadhan Pay - Merchant Portal',
        role: 'Developer at Polygon Technology',
        description:
            ' Developed a web portal for merchants to manage transactions, view analytics, and handle customer interactions, enhancing the digital payment ecosystem.',
        technologies: ['Flutter', 'Flutter Web', 'GetX', 'REST API'],
        screenshots: [
          'https://images.pexels.com/photos/7578926/pexels-photo-7578926.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/7579830/pexels-photo-7579830.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: '',
        challenge: '',
      ),
      const ProjectModel(
        category: 'Mobile',
        title: 'Agave',
        role: 'Developer at Polygon Technology',
        description:
            'Created a marketplace app for Japanese users to buy and sell household plants, featuring localized UX and full e-commerce functionality.',
        technologies: ['Flutter', 'BLoC', 'REST API'],
        screenshots: [
          'https://polygontechnology.io/wp-content/uploads/2025/08/Agave.webp',
        ],
        appUrl: '',
        sourceCodeUrl: '',
        challenge: '',
      ),
      // Personal Apps (Published)
      const ProjectModel(
        category: 'Mobile',
        title: 'BMI & BMR Calculator',
        role: 'Independent Developer',
        description:
            'A health-focused app for calculating BMI and BMR with a clean interface. Originally developed in Java and later migrated to Flutter.',
        technologies: ['Android', 'Java', 'Flutter', 'BLoC'],
        screenshots: [
          'https://play-lh.googleusercontent.com/4tW_1Uqjdyxu-qhviCfys_RnLZP-872A3A-LkqgXcnizMlW7cJT77HyK_EZEZLrxXP0=w2560-h1440-rw',
          'https://play-lh.googleusercontent.com/EA-TBb6YxeHqjhyos1kBUE4wsRw5GwpHxPGfzv9YgXXByQT4nUlaQ5WqO5jWXJYcgx2D=w2560-h1440-rw',
          'https://play-lh.googleusercontent.com/DLD-aUKFEZFGiSYWZCoWCRMZp_3fVMij106Y7luKyZibHHDXDvbzsApUFMEaim4-1Ds=w2560-h1440-rw'
        ],
        appUrl:
            'https://play.google.com/store/apps/details?id=com.chowdhuryelab.bmiandbmrcalculator',
        sourceCodeUrl: '',
        challenge: '',
      ),

      const ProjectModel(
        category: 'Mobile',
        title: 'CGPA Calculator',
        role: 'Independent Developer',
        description:
        'An academic tool for GPA/CGPA calculations, supporting both predefined and customizable grading systems.',
        technologies: ['Flutter'],
        screenshots: [
          'https://play-lh.googleusercontent.com/7DkY7ksLnYOq4xSuqWAZ47HzzHuYOcZo7ZzV9YjzKHRnkkZ8-6ba4sdm35t3Fu4X89M=w2560-h1440-rw',
          'https://play-lh.googleusercontent.com/6yp617LYNCjkaISGmdl02xMc6_IANLM-l4YsDkGQH1F6TWEefJqGb7Q5tpMJfpUikaI=w2560-h1440-rw',
          'https://play-lh.googleusercontent.com/M3rwsN2bhXKt6Z1yyqEItpYCEF2X177r1Uve2oebx4G34Tow3yf5ucEh0nlLxD5OyRM=w2560-h1440-rw'
        ],
        appUrl: 'https://play.google.com/store/apps/details?id=com.chowdhuryelab.cgpacalculator',
        sourceCodeUrl: '',
        challenge: '',
      ),

      const ProjectModel(
        category: 'Mobile',
        title: 'QrXpert',
        role: 'Independent Developer',
        description:
        'A QR code scanner & generator app with fast scanning and export features.',
        technologies: ['Flutter'],
        screenshots: [
          'https://play-lh.googleusercontent.com/0CPsnGiyR9gq4sbY373UBSCW-zyJpg45S3PJrybsK4q4fUuhyCnd4xCEwmDw3j20vX4fBLw4Xs0BjuEY1JDnIAs=w2560-h1440-rw',
        ],
        appUrl: 'https://play.google.com/store/apps/details?id=com.chowdhuryelab.qrxpert',
        sourceCodeUrl: '',
        challenge: '',
      ),

      const ProjectModel(
        category: 'Mobile',
        title: 'Money Track',
        role: 'Independent Developer',
        description:
        'A personal finance tracker to record expenses and incomes with intuitive UX.',
        technologies: ['Flutter'],
        screenshots: [
          'https://play-lh.googleusercontent.com/1eDpRs1c1J0dTKmq4Xh6p4xgC_dZ8I9kCny6sXs3MLWl6-zhrEtPgIX5zeVhA5H-9SIxDnvii0OE9q_YpAfQ=w2560-h1440-rw',
        ],
        appUrl: 'https://play.google.com/store/apps/details?id=com.chowdhuryelab.moneytrack',
        sourceCodeUrl: '',
        challenge: '',
      ),

      const ProjectModel(
        category: 'Mobile',
        title: 'Weight Tracker',
        role: 'Independent Developer',
        description:
        'An app to track weight over time with charts and progress insights.',
        technologies: ['Flutter'],
        screenshots: [
'https://play-lh.googleusercontent.com/PKDE_y0bhpmcnBNCn8FaQecGvLu5JrZg7PR9P3WVrFPFnfL_6DtTa7JDQR4rdQrcmDiCTxinNvZyoJzItIJE=w2560-h1440-rw',
          'https://play-lh.googleusercontent.com/5WCyC5htloE4CJhynChige0rzRtSAxSkunmwjEqF2v6_7Lf_fcSVWrOKnBpdD8ol-Hsg3VREqXXTEXvu_Iier6U=w2560-h1440-rw',
          'https://play-lh.googleusercontent.com/_6NIvfBolO8iM6GOqOZAHLW-egt2zeG4IDMgkfDfTgP8pOz4sxUBlDloAzoRwj4sq6pvW9n6yMRxs4cccjsQ=w2560-h1440-rw'

        ],
        appUrl: 'https://play.google.com/store/apps/details?id=com.chowdhuryelab.weighttracker',
        sourceCodeUrl: '',
        challenge: '',
      ),

      const ProjectModel(
        category: 'Mobile',
        title: 'FlashFy',
        role: 'Independent Developer',
        description:
        'A utility app (details based on Play Store listing).',
        technologies: ['Flutter'],
        screenshots: [
          'https://play-lh.googleusercontent.com/d-bj_BvhKTkTKTrxm5bl4xu_yLHBdFP4XO18nCywqqGlTDalZXkstWm5UUJAD6CXuN8=w2560-h1440-rw',
        ],
        appUrl: 'https://play.google.com/store/apps/details?id=com.chowdhuryelab.flashfy',
        sourceCodeUrl: '',
        challenge: '',
      ),

      const ProjectModel(
        category: 'Mobile',
        title: 'Flutter Portfolio Landing Page',
        role: 'Independent Developer',
        description:
            'A responsive Flutter web portfolio landing page with MVVM and BLoC state management.',
        technologies: ['Flutter', 'Dart', 'MVVM', 'BLoC', 'Medium API'],
        screenshots: [
          'https://images.pexels.com/photos/5391486/pexels-photo-5391486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/4482732/pexels-photo-4482732.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: 'https://github.com/flutter-portfolio-v2',
        challenge: '',
      ),

      const ProjectModel(
        category: 'Mobile',
        title: 'TripMeter - Bike Mileage & Maintenance Tracker',
        role: 'Independent Developer',
        description:
        'A motorcycle tracking app for mileage, fuel logs, and service history, with real-time sync, offline mode, and Supabase backend.',
        technologies: ['Flutter', 'GetX', 'Supabase'],
        screenshots: [
          'https://images.pexels.com/photos/7578926/pexels-photo-7578926.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/7579830/pexels-photo-7579830.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: 'https://github.com/TripMeter',
        challenge: '',
      ),

      const ProjectModel(
        category: 'Mobile',
        title: 'Greeneries E-Gardening',
        role: 'Independent Developer',
        description:
            'An e-commerce platform for buying/selling plants, with features for plant care vlogs and tips.',
        technologies: ['Android', 'Java'],
        screenshots: [
          'https://images.pexels.com/photos/6408282/pexels-photo-6408282.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl:
            'https://github.com/Greeneries-E-Gardening-Android-Java-Application',
        challenge: '',
      ),

      const ProjectModel(
        category: 'Full System',
        title: 'My 2nd Home - Django Web Application',
        role: 'Independent Developer',
        description:
            'An online rental platform connecting students and professionals with homeowners for global flat rentals.',
        technologies: ['Django', 'Python', 'HTML/CSS'],
        screenshots: [
          'https://images.pexels.com/photos/7578926/pexels-photo-7578926.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/7579830/pexels-photo-7579830.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: 'https://github.com/my_2nd-home-django',
        challenge: '',
      ),
      const ProjectModel(
        category: 'Full System',
        title: 'Todo App (Django + Flutter)',
        role: 'Independent Developer',
        description:
            'A full-stack task management app with Django backend APIs and Flutter frontend for CRUD operations.',
        technologies: ['Flutter', 'Dart', 'Django', 'Python', 'REST API'],
        screenshots: [
          'https://images.pexels.com/photos/7578926/pexels-photo-7578926.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/7579830/pexels-photo-7579830.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: 'https://github.com/todo-django-flutter',
        challenge: '',
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
      github: 'https://github.com/macdipu',
      twitter: 'https://x.com/dipu093',
      calendlyLink: 'https://calendly.com/macdipu',
    );
  }

  List<String> _getKeyAccomplishments() {
    return [
      '100+ UI Screens Designed',
      '3+ Years Flutter Experience',
      'Open Source Contributor',
      'Developed 10+ Production-Ready Apps',
    ];
  }
}
