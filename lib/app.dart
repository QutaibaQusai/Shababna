import 'package:flutter/material.dart';

class ShababnaApp extends StatelessWidget {
  const ShababnaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shababna',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Shababna'),
        ),
      ),
    );
  }
}
