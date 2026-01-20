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
        category: ProjectCategory.mobile,
        title: 'Shell Consumer App',
        role: 'Developer at Polygon Technology',
        description:
            'Developed and maintained a consumer-facing mobile app with e-commerce functionality, product guides, MotoGP campaigns, geolocation-based mechanic/shop finder, and product authenticity verification.',
        technologies: ['Flutter', 'BLoC', 'REST API'],
        screenshots: [
          'https://images.pexels.com/photos/230544/pexels-photo-230544.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/6214476/pexels-photo-6214476.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl:
            'https://play.google.com/store/apps/details?id=com.shell.consumer',
        sourceCodeUrl: '',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'Shamadhan Pay - User App',
        role: 'Developer at Polygon Technology',
        description:
            'Built a mobile app and merchant web portal for a Payment Service Provider (PSP) MVP, focusing on secure and inclusive digital payments, designed for regulatory compliance and scalability.',
        technologies: ['Flutter', 'GetX', 'REST API'],
        screenshots: [
          'https://images.pexels.com/photos/7578926/pexels-photo-7578926.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/7579830/pexels-photo-7579830.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: '',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.web,
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
        category: ProjectCategory.mobile,
        title: 'Agave',
        role: 'Developer at Polygon Technology',
        description:
            'Created a marketplace app for Japanese users to buy and sell household plants, featuring localized UX and full e-commerce functionality.',
        technologies: ['Flutter', 'BLoC', 'REST API'],
        screenshots: [
          'https://images.pexels.com/photos/5391486/pexels-photo-5391486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/4482732/pexels-photo-4482732.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: '',
        challenge: '',
      ),
      // Personal Apps (Published)
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'BMI & BMR Calculator',
        role: 'Independent Developer',
        description:
            'A health-focused app for calculating BMI and BMR with a clean interface. Originally developed in Java and later migrated to Flutter.',
        technologies: ['Android', 'Java', 'Flutter', 'BLoC'],
        screenshots: [
          'https://images.pexels.com/photos/6408282/pexels-photo-6408282.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl:
            'https://play.google.com/store/apps/details?id=com.chowdhuryelab.copacalculator',
        sourceCodeUrl: 'https://github.com/BMI-and-BMR-Calculator',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'CGPA Calculator',
        role: 'Independent Developer',
        description:
            'An academic tool for GPA/CGPA calculations, supporting both predefined and customizable grading systems.',
        technologies: ['Flutter'],
        screenshots: [
          'https://images.pexels.com/photos/2422588/pexels-photo-2422588.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/1118873/pexels-photo-1118873.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl:
            'https://play.google.com/store/apps/details?id=com.chowdhuryelab.copacalculater',
        sourceCodeUrl: '',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'FlashFy',
        role: 'Independent Developer',
        description:
            'A mobile application for [description not provided in PDF].',
        technologies: ['Flutter'],
        screenshots: [
          'https://images.pexels.com/photos/230544/pexels-photo-230544.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/6214476/pexels-photo-6214476.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: 'https://play.google.com/store/apps/details?id=com.flashfy',
        sourceCodeUrl: '',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'TripMeter - Bike Mileage & Maintenance Tracker',
        role: 'Independent Developer',
        description:
            'A motorcycle tracking app for mileage, fuel logs, and service history, with real-time sync, offline mode, and Supabase backend.',
        technologies: ['Flutter', 'GetX', 'SpringBoot'],
        screenshots: [
          'https://images.pexels.com/photos/7578926/pexels-photo-7578926.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/7579830/pexels-photo-7579830.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: 'https://github.com/TripMeter',
        challenge: '',
      ),
      // Other Projects
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'Address Book (Firebase)',
        role: 'Independent Developer',
        description:
            'A single-page Android app for contact management with Firebase for real-time data and image storage, offering full CRUD functionality.',
        technologies: ['Android', 'Java', 'Firebase', 'Camera/Gallery API'],
        screenshots: [
          'https://images.pexels.com/photos/5391486/pexels-photo-5391486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/4482732/pexels-photo-4482732.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl:
            'https://github.com/Address-Book-firebase-Android-Java-Application',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'Address Book (SQLite)',
        role: 'Independent Developer',
        description:
            'A single-page Android app for contact management using SQLite for local storage, with efficient CRUD operations.',
        technologies: ['Android', 'Java', 'SQLite', 'Camera/Gallery API'],
        screenshots: [
          'https://images.pexels.com/photos/6408282/pexels-photo-6408282.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl:
            'https://github.com/Address-Book-SQLite-Android-Java-Application',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.backend,
        title: 'AI Model for Predicting Price',
        role: 'Independent Developer',
        description:
            'An AI model for price prediction using machine learning techniques for data analysis and forecasting.',
        technologies: ['Python', 'Machine Learning'],
        screenshots: [
          'https://images.pexels.com/photos/2422588/pexels-photo-2422588.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/1118873/pexels-photo-1118873.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: 'https://github.com/AI-model-for-predicting-price',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.backend,
        title: 'AI Model of Fashion Project',
        role: 'Independent Developer',
        description:
            'An AI-based solution for fashion-related applications, processing and analyzing fashion data with machine learning.',
        technologies: ['Python', 'Machine Learning', 'Computer Vision'],
        screenshots: [
          'https://images.pexels.com/photos/230544/pexels-photo-230544.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/6214476/pexels-photo-6214476.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: 'https://github.com/AI-Model-of-Fashion-Project',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'BMI and BMR Calculator (Android)',
        role: 'Independent Developer',
        description:
            'An Android app for calculating BMI and BMR based on user inputs like weight, height, age, and gender.',
        technologies: ['Android', 'Java'],
        screenshots: [
          'https://images.pexels.com/photos/7578926/pexels-photo-7578926.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/7579830/pexels-photo-7579830.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl:
            'https://github.com/BMI-and-BMR-Calculator-Android-Java-Application',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.backend,
        title: 'Classification Problem of Supervised Learning with Iris Flower',
        role: 'Independent Developer',
        description:
            'A supervised learning model for classifying Iris flower species using the Iris dataset and machine learning algorithms.',
        technologies: ['Python', 'Scikit-learn', 'Machine Learning'],
        screenshots: [
          'https://images.pexels.com/photos/5391486/pexels-photo-5391486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/4482732/pexels-photo-4482732.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl:
            'https://github.com/Classification-Problem-of-Supervised-Learning-with-irish-flower',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'Contact Info (SharedPreferences)',
        role: 'Independent Developer',
        description:
            'A single-page Android app for storing user data and images using SharedPreferences with Base64 encoding.',
        technologies: ['Android', 'Java', 'SharedPreferences', 'Base64'],
        screenshots: [
          'https://images.pexels.com/photos/6408282/pexels-photo-6408282.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl:
            'https://github.com/Contact-Info-SharedPreferences-Android-Java-Application',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'E-Commerce Flutter App',
        role: 'Independent Developer',
        description:
            'A Flutter-based e-commerce app with Appium testing for a robust mobile shopping experience.',
        technologies: ['Flutter', 'Dart', 'Appium'],
        screenshots: [
          'https://images.pexels.com/photos/2422588/pexels-photo-2422588.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/1118873/pexels-photo-1118873.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: 'https://github.com/ecommerce-flutter-app',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'Event Management',
        role: 'Independent Developer',
        description:
            'An Android app for creating, tracking, and organizing events efficiently.',
        technologies: ['Android', 'Java'],
        screenshots: [
          'https://images.pexels.com/photos/230544/pexels-photo-230544.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/6214476/pexels-photo-6214476.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl:
            'https://github.com/Event-Management-Android-Java-Application',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'Flutter Clean Architecture BLoC',
        role: 'Independent Developer',
        description:
            'A Flutter app built with clean architecture and BLoC for scalable and maintainable state management.',
        technologies: ['Flutter', 'Dart', 'BLoC', 'Clean Architecture'],
        screenshots: [
          'https://images.pexels.com/photos/7578926/pexels-photo-7578926.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/7579830/pexels-photo-7579830.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: 'https://github.com/Flutter-Clean-Architecture-Bloc',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
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
        category: ProjectCategory.mobile,
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
        category: ProjectCategory.backend,
        title: 'Ice Cream Sell Number',
        role: 'Independent Developer',
        description:
            'Analyzed ice cream sales data to identify trends or predict sales using data science techniques.',
        technologies: ['Python', 'Data Analysis'],
        screenshots: [
          'https://images.pexels.com/photos/2422588/pexels-photo-2422588.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/1118873/pexels-photo-1118873.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: 'https://github.com/ice-cream-sell-number',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.others,
        title: 'Microcontroller-Based Water Level Controller',
        role: 'Independent Developer',
        description:
            'A smart device to automate water pump control, preventing overflow and conserving energy.',
        technologies: ['Microcontrollers', 'Arduino', 'C'],
        screenshots: [
          'https://images.pexels.com/photos/230544/pexels-photo-230544.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/6214476/pexels-photo-6214476.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl:
            'https://github.com/microcontroller-based-water-level-controller-in-domestic',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.fullSystem,
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
        category: ProjectCategory.mobile,
        title: 'Roadbuddy Capstone Project',
        role: 'Independent Developer',
        description:
            'A travel or navigation-based Android app developed as a capstone project for enhanced user experience.',
        technologies: ['Android', 'Java'],
        screenshots: [
          'https://images.pexels.com/photos/5391486/pexels-photo-5391486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/4482732/pexels-photo-4482732.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl:
            'https://github.com/Roadbuddy-Capstone-Project-Android-Java-Application',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'Simple Calculator',
        role: 'Independent Developer',
        description:
            'A calculator app with infix-to-postfix conversion for efficient arithmetic operations.',
        technologies: ['Android', 'Java'],
        screenshots: [
          'https://images.pexels.com/photos/6408282/pexels-photo-6408282.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl:
            'https://github.com/Simple-Calculator-Android-Java-Application',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'Simple Calculator Flutter App',
        role: 'Independent Developer',
        description:
            'A cross-platform calculator app for basic arithmetic operations.',
        technologies: ['Flutter', 'Dart'],
        screenshots: [
          'https://images.pexels.com/photos/2422588/pexels-photo-2422588.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/1118873/pexels-photo-1118873.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: 'https://github.com/simple_calculator-flutter-app',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'Stopwatch',
        role: 'Independent Developer',
        description:
            'A responsive stopwatch and timer app with background time tracking using Android services.',
        technologies: [
          'Android',
          'Java',
          'Service Class',
          'Broadcast Receiver'
        ],
        screenshots: [
          'https://images.pexels.com/photos/230544/pexels-photo-230544.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/6214476/pexels-photo-6214476.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl: 'https://github.com/Stopwatch-Android-Java-Application',
        challenge: '',
      ),
      const ProjectModel(
        category: ProjectCategory.fullSystem,
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
      const ProjectModel(
        category: ProjectCategory.mobile,
        title: 'Travel Reservation Management System',
        role: 'Independent Developer',
        description:
            'An Android app for managing travel reservations, streamlining booking and tracking processes.',
        technologies: ['Android', 'Java'],
        screenshots: [
          'https://images.pexels.com/photos/5391486/pexels-photo-5391486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'https://images.pexels.com/photos/4482732/pexels-photo-4482732.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ],
        appUrl: '',
        sourceCodeUrl:
            'https://github.com/Travel-Reservation-Management-System-Android-Java-Application',
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
