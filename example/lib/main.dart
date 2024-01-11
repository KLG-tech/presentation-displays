import 'package:flutter/material.dart';
import 'package:presentation_displays_example/presentation/secondary_screen.dart';
import 'presentation/display_manager_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const DisplayManagerScreen());
    case 'presentation':
      return MaterialPageRoute(builder: (_) => const SecondaryScreen());
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

void mainProgram() {
  runApp(const MyApp());
}

void secondaryProgram() {
  runApp(const MySecondApp());
}

class MySecondApp extends StatelessWidget {
  const MySecondApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      onGenerateRoute: generateRoute,
      initialRoute: 'presentation',
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      onGenerateRoute: generateRoute,
      initialRoute: '/',
    );
  }
}



