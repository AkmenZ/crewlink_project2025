import 'package:crewlink/firebase_options.dart';
import 'package:crewlink/pages/auth_page.dart';
import 'package:crewlink/pages/home_page.dart';
import 'package:crewlink/pages/loading_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return MaterialApp(
      title: 'CrewLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurpleAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // listen to auth state changes
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // if credentials are loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          }
          // if instance holds credential, navigate to home page
          if (snapshot.hasData) {
            return const HomePage();
          }
          // otherwise navigate to auth page
          return const AuthPage();
        },
      ),
    );
  }
}
