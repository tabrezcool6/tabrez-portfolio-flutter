import 'package:flutter/material.dart';

import 'core/theme/apple_theme.dart';
import 'presentation/views/portfolio_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TabrezPortfolioApp());
}

class TabrezPortfolioApp extends StatelessWidget {
  const TabrezPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syed Tabrez - Portfolio',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppleTheme.darkTheme,
      theme: AppleTheme.darkTheme,
      home: const PortfolioShell(),
    );
  }
}
