import 'package:flutter/material.dart';
import 'package:not_defteri/view/kay%C4%B1tlar_sayfasi.dart';

void main() {
  runApp(AnaUygulama());
}

class AnaUygulama extends StatelessWidget {
  const AnaUygulama({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: KayitlarSayfasi());
  }
}
