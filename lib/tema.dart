import 'package:flutter/material.dart';

//função simples para mudar a cor do app
ThemeData criacaoTema() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F7B6C)),
    scaffoldBackgroundColor: const Color(0xFFF4F7F6),
    useMaterial3: true,
  );
}
