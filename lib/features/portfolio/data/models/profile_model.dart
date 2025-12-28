import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String name;
  final String title;
  final String introduction;
  final String about;
  final String avatarUrl;
  final List<String> keyAccomplishments;
  final List<ExperienceGroup> experiences;
  final List<EducationModel> educations;
  final List<ProjectModel> projects;
  final List<ServiceModel> services;
  final List<TechStackModel> techStacks;
  final ContactInfoModel contactInfo;
  final String resumeUrl;

  const ProfileModel({
    required this.name,
    required this.title,
    required this.introduction,
    required this.about,
    required this.avatarUrl,
    required this.keyAccomplishments,
    required this.experiences,
    required this.educations,
    required this.projects,
    required this.services,
    required this.techStacks,
    required this.contactInfo,
    required this.resumeUrl,
  });

  @override
  List<Object> get props => [
        name,
        title,
        introduction,
        about,
        avatarUrl,
        keyAccomplishments,
        experiences,
        educations,
        projects,
        services,
        techStacks,
        contactInfo,
        resumeUrl,
      ];
}

class ExperienceModel extends Equatable {
  final String position;
  final String period;
  final String description;

  const ExperienceModel({
    required this.position,
    required this.period,
    required this.description,
  });

  @override
  List<Object> get props => [position, period, description];
}

class ExperienceGroup {
  final String company;
  final String logoUrl;
  final List<ExperienceModel> roles;

  ExperienceGroup({
    required this.company,
    required this.logoUrl,
    required this.roles,
  });
}

class EducationModel extends Equatable {
  final String institution;
  final String degree;
  final String period;
  final String description;
  final String logoUrl;

  const EducationModel({
    required this.institution,
    required this.degree,
    required this.period,
    required this.description,
    required this.logoUrl,
  });

  @override
  List<Object> get props => [institution, degree, period, description, logoUrl];
}

class ProjectModel extends Equatable {
  final String category;
  final String title;
  final String role;
  final String description;
  final List<String> technologies;
  final List<String> screenshots;
  final String appUrl;
  final String sourceCodeUrl;
  final String challenge;
  final String? appIconUrl;

  const ProjectModel({
    required this.category,
    required this.title,
    required this.role,
    required this.description,
    required this.technologies,
    required this.screenshots,
    required this.appUrl,
    required this.sourceCodeUrl,
    required this.challenge,
    this.appIconUrl,
  });

  @override
  List<Object?> get props => [
        category,
        title,
        role,
        description,
        technologies,
        screenshots,
        appUrl,
        sourceCodeUrl,
        challenge,
        appIconUrl
      ];
}

class ServiceModel extends Equatable {
  final String title;
  final String description;
  final String iconUrl;

  const ServiceModel({
    required this.title,
    required this.description,
    required this.iconUrl,
  });

  @override
  List<Object> get props => [title, description, iconUrl];
}

class TechStackModel extends Equatable {
  final String name;
  final String category;
  final String iconUrl;

  const TechStackModel({
    required this.name,
    required this.category,
    required this.iconUrl,
  });

  @override
  List<Object> get props => [name, category, iconUrl];
}

class ContactInfoModel extends Equatable {
  final String email;
  final String linkedIn;
  final String github;
  final String twitter;
  final String calendlyLink;

  const ContactInfoModel({
    required this.email,
    required this.linkedIn,
    required this.github,
    required this.twitter,
    required this.calendlyLink,
  });

  @override
  List<Object> get props => [email, linkedIn, github, twitter, calendlyLink];
}
