import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vize/ekle.dart';
import 'package:vize/homePage.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => homepage(),
    ),
    GoRoute(
      path: '/ekle',
      builder: (context, state) => LoginPage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'filmix',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
