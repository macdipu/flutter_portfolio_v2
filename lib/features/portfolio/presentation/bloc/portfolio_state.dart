part of 'portfolio_bloc.dart';

class PortfolioState extends Equatable {
  final bool isLoading;
  final ProfileModel? profile;
  final List<BlogPostModel> blogPosts;
  final String? error;
  final bool isContactFormSubmitting;
  final bool isContactFormSubmitted;
  final String? contactFormStatus;
  final String selectedCategory;
  final List<TechStackModel> filteredTechStacks;
  final int visibleBlogPostCount;

  const PortfolioState({
    this.isLoading = false,
    this.profile,
    this.blogPosts = const [],
    this.error,
    this.isContactFormSubmitting = false,
    this.isContactFormSubmitted = false,
    this.contactFormStatus,
    this.selectedCategory = 'All',
    this.filteredTechStacks = const [],
    this.visibleBlogPostCount = 6,
  });

  PortfolioState copyWith({
    bool? isLoading,
    ProfileModel? profile,
    List<BlogPostModel>? blogPosts,
    String? error,
    bool? isContactFormSubmitting,
    bool? isContactFormSubmitted,
    String? contactFormStatus,
    String? selectedCategory,
    List<TechStackModel>? filteredTechStacks,
    int? visibleBlogPostCount,
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
      selectedCategory: selectedCategory ?? this.selectedCategory,
      filteredTechStacks: filteredTechStacks ?? this.filteredTechStacks,
      visibleBlogPostCount: visibleBlogPostCount ?? this.visibleBlogPostCount,
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
        selectedCategory,
        filteredTechStacks,
        visibleBlogPostCount,
      ];
}
