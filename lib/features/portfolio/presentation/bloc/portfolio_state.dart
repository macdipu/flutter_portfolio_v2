part of 'portfolio_bloc.dart';

class PortfolioState extends Equatable {
  final bool isLoading;
  final ProfileModel? profile;
  final List<BlogPostModel> blogPosts;
  final String? error;
  final bool isContactFormSubmitting;
  final bool isContactFormSubmitted;
  final String? contactFormStatus;
  final TechStackCategory selectedTechStacksCategory;
  final List<TechStackModel> filteredTechStacks;
  final int visibleBlogPostCount;
  final ProjectCategory? selectedProjectCategory;
  final List<ProjectModel> filteredProjects;

  const PortfolioState({
    this.isLoading = false,
    this.profile,
    this.blogPosts = const [],
    this.error,
    this.isContactFormSubmitting = false,
    this.isContactFormSubmitted = false,
    this.contactFormStatus,
    this.selectedTechStacksCategory = TechStackCategory.all,
    this.filteredTechStacks = const [],
    this.visibleBlogPostCount = 6,
    this.selectedProjectCategory,
    this.filteredProjects = const [],
  });

  PortfolioState copyWith({
    bool? isLoading,
    ProfileModel? profile,
    List<BlogPostModel>? blogPosts,
    String? error,
    bool? isContactFormSubmitting,
    bool? isContactFormSubmitted,
    String? contactFormStatus,
    TechStackCategory? selectedTechStacksCategory,
    List<TechStackModel>? filteredTechStacks,
    int? visibleBlogPostCount,
    ProjectCategory? selectedProjectCategory,
    List<ProjectModel>? filteredProjects,
  }) {
    return PortfolioState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      blogPosts: blogPosts ?? this.blogPosts,
      error: error ?? this.error,
      isContactFormSubmitting:
          isContactFormSubmitting ?? this.isContactFormSubmitting,
      isContactFormSubmitted:
          isContactFormSubmitted ?? this.isContactFormSubmitted,
      contactFormStatus: contactFormStatus ?? this.contactFormStatus,
      selectedTechStacksCategory:
          selectedTechStacksCategory ?? this.selectedTechStacksCategory,
      filteredTechStacks: filteredTechStacks ?? this.filteredTechStacks,
      visibleBlogPostCount: visibleBlogPostCount ?? this.visibleBlogPostCount,
      selectedProjectCategory:
          selectedProjectCategory ?? this.selectedProjectCategory,
      filteredProjects: filteredProjects ?? this.filteredProjects,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        profile,
        blogPosts,
        error,
        isContactFormSubmitting,
        isContactFormSubmitted,
        contactFormStatus,
        selectedTechStacksCategory,
        filteredTechStacks,
        visibleBlogPostCount,
        selectedProjectCategory,
        filteredProjects,
      ];
}
