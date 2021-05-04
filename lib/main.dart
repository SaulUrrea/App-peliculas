import 'package:flutter/material.dart';
import 'package:flutter_peliculas_app/src/pages/detalle_page.dart';
import 'package:flutter_peliculas_app/src/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas App',
      initialRoute: 'home',
      routes: {
        'home': (context) => HomePage(),
        'detalle': (context) => PeliculaDetalle(),
      },
    );
  }
}
