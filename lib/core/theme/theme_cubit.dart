import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme state
class ThemeState extends Equatable {
  final ThemeMode themeMode;
  
  const ThemeState({required this.themeMode});
  
  @override
  List<Object> get props => [themeMode];
}

// Theme cubit
class ThemeCubit extends Cubit<ThemeState> {
  final bool initialDarkMode;
  
  ThemeCubit(this.initialDarkMode) 
    : super(ThemeState(themeMode: ThemeMode.light));
  
  Future<void> initialize() async {
    emit(ThemeState(themeMode: initialDarkMode ? ThemeMode.dark : ThemeMode.light));
  }
  
  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    
    // Save theme preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newMode == ThemeMode.dark);
    
    emit(ThemeState(themeMode: newMode));
  }
}