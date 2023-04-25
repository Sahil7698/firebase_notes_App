import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_note_app/view/screens/add_note.dart';
import 'package:firebase_note_app/view/screens/home_page.dart';
import 'package:firebase_note_app/view/screens/note_page.dart';
import 'package:firebase_note_app/view/screens/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const SplashScreen(),
      routes: {
        //'/': (context) => const SplashScreen(),
        'login_page': (context) => const HomePage(),
        'registration_page': (context) => const RegistrationPage(),
        'note_page': (context) => const NotePage(),
        'add_note_page': (context) => const AddNotePage(),
      },
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage("assets/images/note.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "Note App",
              style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 35),
            ),
          ],
        ),
      ),
    );
  }
}
