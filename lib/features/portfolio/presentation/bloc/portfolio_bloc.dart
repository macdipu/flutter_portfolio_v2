import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/profile_model.dart';
import '../../data/models/blog_post_model.dart';
import '../../data/repositories/portfolio_repository.dart';

// Portfolio events
abstract class PortfolioEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPortfolioData extends PortfolioEvent {}

class LoadBlogPosts extends PortfolioEvent {}

class SubmitContactForm extends PortfolioEvent {
  final String name;
  final String email;
  final String message;
  
  SubmitContactForm({
    required this.name,
    required this.email,
    required this.message,
  });
  
  @override
  List<Object> get props => [name, email, message];
}

// Portfolio state
class PortfolioState extends Equatable {
  final bool isLoading;
  final ProfileModel? profile;
  final List<BlogPostModel> blogPosts;
  final String? error;
  final bool isContactFormSubmitting;
  final bool isContactFormSubmitted;
  final String? contactFormError;
  
  const PortfolioState({
    this.isLoading = false,
    this.profile,
    this.blogPosts = const [],
    this.error,
    this.isContactFormSubmitting = false,
    this.isContactFormSubmitted = false,
    this.contactFormError,
  });
  
  PortfolioState copyWith({
    bool? isLoading,
    ProfileModel? profile,
    List<BlogPostModel>? blogPosts,
    String? error,
    bool? isContactFormSubmitting,
    bool? isContactFormSubmitted,
    String? contactFormError,
  }) {
    return PortfolioState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      blogPosts: blogPosts ?? this.blogPosts,
      error: error,
      isContactFormSubmitting: isContactFormSubmitting ?? this.isContactFormSubmitting,
      isContactFormSubmitted: isContactFormSubmitted ?? this.isContactFormSubmitted,
      contactFormError: contactFormError,
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
    contactFormError
  ];
}

// Portfolio BLoC
class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final PortfolioRepository _repository;
  
  PortfolioBloc({PortfolioRepository? repository}) 
    : _repository = repository ?? PortfolioRepository(),
      super(const PortfolioState()) {
    on<LoadPortfolioData>(_onLoadPortfolioData);
    on<LoadBlogPosts>(_onLoadBlogPosts);
    on<SubmitContactForm>(_onSubmitContactForm);
  }
  
  Future<void> _onLoadPortfolioData(
    LoadPortfolioData event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final profile = await _repository.getProfileData();
      emit(state.copyWith(
        isLoading: false,
        profile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load profile data: ${e.toString()}',
      ));
    }
  }
  
  Future<void> _onLoadBlogPosts(
    LoadBlogPosts event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final blogPosts = await _repository.getBlogPosts();
      emit(state.copyWith(
        isLoading: false,
        blogPosts: blogPosts,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load blog posts: ${e.toString()}',
      ));
    }
  }
  
  Future<void> _onSubmitContactForm(
    SubmitContactForm event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(
      isContactFormSubmitting: true,
      isContactFormSubmitted: false,
      contactFormError: null,
    ));
    
    // In a real app, this would submit the form to a backend
    // For now, we'll simulate a delay and success
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulating success (in a real app, we'd check the response)
    emit(state.copyWith(
      isContactFormSubmitting: false,
      isContactFormSubmitted: true,
    ));
  }
}