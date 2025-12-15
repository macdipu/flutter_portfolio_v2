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
  final SiteConfigModel siteConfig;

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
    required this.siteConfig,
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
        siteConfig,
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
  });

  @override
  List<Object> get props => [
        category,
        title,
        role,
        description,
        technologies,
        screenshots,
        appUrl,
        sourceCodeUrl,
        challenge
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

class SiteConfigModel extends Equatable {
  final HeaderConfigModel header;
  final SidebarConfigModel sidebar;
  final CursorConfigModel cursor;
  final AnimationConfigModel animations;

  const SiteConfigModel({
    required this.header,
    required this.sidebar,
    required this.cursor,
    required this.animations,
  });

  @override
  List<Object> get props => [header, sidebar, cursor, animations];
}

class HeaderConfigModel extends Equatable {
  final String greeting;
  final List<String> heroNameLines;
  final List<String> roleLines;
  final String infoParagraph;
  final String primaryCtaLabel;
  final String secondaryCtaLabel;

  const HeaderConfigModel({
    required this.greeting,
    required this.heroNameLines,
    required this.roleLines,
    required this.infoParagraph,
    required this.primaryCtaLabel,
    required this.secondaryCtaLabel,
  });

  @override
  List<Object> get props => [
        greeting,
        heroNameLines,
        roleLines,
        infoParagraph,
        primaryCtaLabel,
        secondaryCtaLabel,
      ];
}

class SidebarConfigModel extends Equatable {
  final String salutation;
  final String tagline;
  final List<NavigationLinkConfig> navigationLinks;
  final List<SocialLinkConfig> socialLinks;

  const SidebarConfigModel({
    required this.salutation,
    required this.tagline,
    required this.navigationLinks,
    required this.socialLinks,
  });

  @override
  List<Object> get props => [salutation, tagline, navigationLinks, socialLinks];
}

class NavigationLinkConfig extends Equatable {
  final String sectionId;
  final String label;
  final String asciiLabel;

  const NavigationLinkConfig({
    required this.sectionId,
    required this.label,
    required this.asciiLabel,
  });

  @override
  List<Object> get props => [sectionId, label, asciiLabel];
}

class SocialLinkConfig extends Equatable {
  final String platform;
  final String url;

  const SocialLinkConfig({
    required this.platform,
    required this.url,
  });

  @override
  List<Object> get props => [platform, url];
}

class CursorConfigModel extends Equatable {
  final bool enabled;
  final double innerRadius;
  final double outerRadius;
  final double hoverScale;
  final Duration followDuration;

  const CursorConfigModel({
    required this.enabled,
    required this.innerRadius,
    required this.outerRadius,
    required this.hoverScale,
    required this.followDuration,
  });

  @override
  List<Object> get props => [
        enabled,
        innerRadius,
        outerRadius,
        hoverScale,
        followDuration,
      ];
}

class AnimationConfigModel extends Equatable {
  final bool enableAos;
  final Duration baseDelay;
  final double verticalOffset;

  const AnimationConfigModel({
    required this.enableAos,
    required this.baseDelay,
    required this.verticalOffset,
  });

  @override
  List<Object> get props => [enableAos, baseDelay, verticalOffset];
}
