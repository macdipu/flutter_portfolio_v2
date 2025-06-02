import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/portfolio/presentation/pages/portfolio_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences for theme
  final sharedPreferences = await SharedPreferences.getInstance();
  final isDarkMode = sharedPreferences.getBool('isDarkMode') ?? false;

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(isDarkMode)..initialize(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Developer Portfolio',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            builder: (context, child) {
              return ResponsiveBuilder(
                builder: (context, deviceType, constraints) {
                  return MediaQuery(
                    data: MediaQuery.of(context),
                    child: child!,
                  );
                },
              );
            },
            home: const PortfolioPage(),
          );
        },
      ),
    );
  }
}
