import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/blog_post_model.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/portfolio_repository.dart';

part 'portfolio_event.dart';
part 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final PortfolioRepository _repository;

  PortfolioBloc({PortfolioRepository? repository})
      : _repository = repository ?? PortfolioRepository(),
        super(const PortfolioState()) {
    on<LoadPortfolioData>(_onLoadPortfolioData);
    on<LoadBlogPosts>(_onLoadBlogPosts);
    on<SubmitContactForm>(_onSubmitContactForm);
    on<UpdateTechStackCategory>(_onUpdateTechStackCategory);
    on<UpdateProjectCategory>(_onUpdateProjectCategory);
  }

  Future<void> _onLoadPortfolioData(
      LoadPortfolioData event, Emitter<PortfolioState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final profile = await _repository.getProfileData();
      emit(state.copyWith(
        isLoading: false,
        profile: profile,
        selectedTechStacksCategory: 'All',
        filteredTechStacks: profile.techStacks,
        selectedProjectCategory: ProjectCategory.all,
        filteredProjects: profile.projects,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load portfolio data: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadBlogPosts(
      LoadBlogPosts event, Emitter<PortfolioState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final blogPosts = await _repository.getBlogPosts();
      emit(state.copyWith(
        isLoading: false,
        blogPosts: blogPosts,
        visibleBlogPostCount: 2, // Default to 2 posts
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load blog posts: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSubmitContactForm(
      SubmitContactForm event, Emitter<PortfolioState> emit) async {
    emit(state.copyWith(
      isContactFormSubmitting: true,
      isContactFormSubmitted: false,
      contactFormStatus: null,
    ));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(
      isContactFormSubmitting: false,
      isContactFormSubmitted: true,
    ));
  }

  void _onUpdateTechStackCategory(
      UpdateTechStackCategory event, Emitter<PortfolioState> emit) {
    if (state.profile == null) return;
    final filteredTechStacks = event.category == 'All'
        ? state.profile!.techStacks
        : state.profile!.techStacks
            .where((tech) => tech.category == event.category)
            .toList();
    emit(state.copyWith(
      selectedTechStacksCategory: event.category,
      filteredTechStacks: filteredTechStacks,
    ));
  }

  void _onUpdateProjectCategory(
      UpdateProjectCategory event, Emitter<PortfolioState> emit) {
    final filtered = event.category == ProjectCategory.all
        ? state.profile!.projects
        : state.profile!.projects
            .where((p) => p.category == event.category)
            .toList();
    emit(state.copyWith(
      selectedProjectCategory: event.category,
      filteredProjects: filtered,
    ));
  }
}
