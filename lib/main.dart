import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/responsive/responsive_framework.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/intro/intro_gate.dart';
import 'features/portfolio/presentation/pages/portfolio_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final mode = await ThemeCubit.load();
  runApp(MyApp(initialMode: mode));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initialMode = ThemeMode.dark});

  final ThemeMode initialMode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(initialMode),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) => MaterialApp(
          title: 'Md. Asad Chowdhury Dipu: Forward Deployed Engineer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.themeMode,
          themeAnimationDuration: const Duration(milliseconds: 240),
          builder: (context, child) =>
              ResponsiveScope(child: IntroGate(child: child!)),
          home: const PortfolioPage(),
        ),
      ),
    );
  }
}
