import 'package:chat/screen/AuthScreen.dart';
import 'package:chat/screen/chat_screen.dart';
import 'package:chat/screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      canvasColor: Colors.black54,
      primarySwatch: Colors.pink,
      backgroundColor: Colors.pink,
      accentColor: Colors.deepPurple,
      accentColorBrightness: Brightness.dark,
    ),
    home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (snapShot.hasData) {
            return ChatScreen();
          } else {
            return AuthScreen();
          }
        }),
  ));
}
