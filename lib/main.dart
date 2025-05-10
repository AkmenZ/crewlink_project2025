import 'package:crewlink/firebase_options.dart';
import 'package:crewlink/router.dart';
import 'package:crewlink/widgets/loading_overlay.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load .env
  await dotenv.load(fileName: ".env");

  // initialize firebase
  try {
    // attempt initialization
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow;
    }
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CrewLink',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurpleAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.deepPurpleAccent,
          circularTrackColor: Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
      builder: (context, child) {
        // wrapps all pages with loading overlay
        return LoadingOverlay(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
