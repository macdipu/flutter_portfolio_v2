import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// Navigation sections
enum NavigationSection {
  hero,
  about,
  experience,
  portfolio,
  services,
  techStack,
  blog,
  contact,
  resume
}

// Scroll state
class ScrollState extends Equatable {
  final NavigationSection currentSection;
  final bool isSidebarOpen;
  
  const ScrollState({
    required this.currentSection,
    this.isSidebarOpen = false,
  });
  
  ScrollState copyWith({
    NavigationSection? currentSection,
    bool? isSidebarOpen,
  }) {
    return ScrollState(
      currentSection: currentSection ?? this.currentSection,
      isSidebarOpen: isSidebarOpen ?? this.isSidebarOpen,
    );
  }
  
  @override
  List<Object> get props => [currentSection, isSidebarOpen];
}

// Scroll cubit
class ScrollCubit extends Cubit<ScrollState> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  
  ScrollCubit() : super(const ScrollState(currentSection: NavigationSection.hero)) {
    // Listen to scroll position changes
    itemPositionsListener.itemPositions.addListener(_onPositionChange);
  }
  
  void _onPositionChange() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;
    
    // Get the first visible item
    final firstIndex = positions.first.index;
    final section = NavigationSection.values[firstIndex];
    
    if (section != state.currentSection) {
      emit(state.copyWith(currentSection: section));
    }
  }
  
  void scrollToSection(NavigationSection section) {
    final index = NavigationSection.values.indexOf(section);
    itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
    
    emit(state.copyWith(
      currentSection: section,
      isSidebarOpen: false,
    ));
  }
  
  void toggleSidebar() {
    emit(state.copyWith(isSidebarOpen: !state.isSidebarOpen));
  }
  
  void closeSidebar() {
    if (state.isSidebarOpen) {
      emit(state.copyWith(isSidebarOpen: false));
    }
  }
  
  @override
  Future<void> close() {
    itemPositionsListener.itemPositions.removeListener(_onPositionChange);
    return super.close();
  }
}