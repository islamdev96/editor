import 'package:editor/page/spash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Editor());
}

class Editor extends StatelessWidget {
  const Editor ({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
     
          
      theme: ThemeData(
        primaryColor: Colors.brown,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amberAccent),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black
        )
      ),
      home: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}