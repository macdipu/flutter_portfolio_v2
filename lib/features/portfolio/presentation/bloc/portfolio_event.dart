part of 'portfolio_bloc.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object> get props => [];
}

class LoadPortfolioData extends PortfolioEvent {}

class LoadBlogPosts extends PortfolioEvent {}

class SubmitContactForm extends PortfolioEvent {
  final String name;
  final String email;
  final String message;

  const SubmitContactForm({
    required this.name,
    required this.email,
    required this.message,
  });

  @override
  List<Object> get props => [name, email, message];
}

class UpdateTechStackCategory extends PortfolioEvent {
  final String category;

  const UpdateTechStackCategory(this.category);

  @override
  List<Object> get props => [category];
}

class UpdateProjectCategory extends PortfolioEvent {
  final String category;
  const UpdateProjectCategory(this.category);
}
