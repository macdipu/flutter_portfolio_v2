import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  ScrollCubit()
      : super(const ScrollState(currentSection: NavigationSection.hero)) {
    itemPositionsListener.itemPositions.addListener(_onPositionChange);
  }

  void _onPositionChange() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final visibleItems = positions
        .where((pos) => pos.itemTrailingEdge >= 0 && pos.itemLeadingEdge <= 1)
        .toList();

    if (visibleItems.isEmpty) return;

    visibleItems.sort((a, b) {
      final aCenter = (a.itemLeadingEdge + a.itemTrailingEdge) / 2;
      final bCenter = (b.itemLeadingEdge + b.itemTrailingEdge) / 2;
      return (aCenter - 0.5).abs().compareTo((bCenter - 0.5).abs());
    });

    final mostCenteredIndex = visibleItems.first.index;

    if (mostCenteredIndex >= 0 &&
        mostCenteredIndex < NavigationSection.values.length) {
      final newSection = NavigationSection.values[mostCenteredIndex];
      if (newSection != state.currentSection) {
        emit(state.copyWith(currentSection: newSection));
      }
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
