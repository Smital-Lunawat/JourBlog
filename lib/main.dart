import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Mapping.dart';
import 'Authentication.dart';

void main() async {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  binding.renderView.automaticSystemUiAdjustment = false;
  await Firebase.initializeApp();
  runApp(BlogApp());
}

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Jour Blog",
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}
