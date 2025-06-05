part of 'portfolio_bloc.dart';

class PortfolioState extends Equatable {
  final bool isLoading;
  final ProfileModel? profile;
  final List<BlogPostModel> blogPosts;
  final String? error;
  final bool isContactFormSubmitting;
  final bool isContactFormSubmitted;
  final String? contactFormError;
  final String selectedCategory;
  final List<TechStackModel> filteredTechStacks;

  const PortfolioState({
    this.isLoading = false,
    this.profile,
    this.blogPosts = const [],
    this.error,
    this.isContactFormSubmitting = false,
    this.isContactFormSubmitted = false,
    this.contactFormError,
    this.selectedCategory = 'All',
    this.filteredTechStacks = const [],
  });

  PortfolioState copyWith({
    bool? isLoading,
    ProfileModel? profile,
    List<BlogPostModel>? blogPosts,
    String? error,
    bool? isContactFormSubmitting,
    bool? isContactFormSubmitted,
    String? contactFormError,
    String? selectedCategory,
    List<TechStackModel>? filteredTechStacks,
  }) {
    return PortfolioState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      blogPosts: blogPosts ?? this.blogPosts,
      error: error ?? this.error,
      isContactFormSubmitting: isContactFormSubmitting ?? this.isContactFormSubmitting,
      isContactFormSubmitted: isContactFormSubmitted ?? this.isContactFormSubmitted,
      contactFormError: contactFormError ?? this.contactFormError,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      filteredTechStacks: filteredTechStacks ?? this.filteredTechStacks,
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
        contactFormError,
        selectedCategory,
        filteredTechStacks,
      ];
}