import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iosreminder/config/custom_theme.dart';
import 'package:iosreminder/screens/wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('There was an error'),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              StreamProvider<User?>(
                initialData: FirebaseAuth.instance.currentUser,
                create: (BuildContext context) =>
                    FirebaseAuth.instance.authStateChanges(),
              ),
              ChangeNotifierProvider(create: (context) => CustomTheme())
            ],
            child: Wrapper(),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
