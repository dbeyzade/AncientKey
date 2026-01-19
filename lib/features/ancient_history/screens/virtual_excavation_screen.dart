import 'package:flutter/material.dart';

class VirtualExcavationScreen extends StatelessWidget {
  const VirtualExcavationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('virtual excavation')),
      body: const Center(child: Text('Geliştirme devam ediyor...')),
    );
  }
}
