import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'category_route.dart';

void main() {
  runApp(UnitConverter());
}

class UnitConverter extends StatelessWidget{
  const UnitConverter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.green[500],
          displayColor: Colors.green[600],
        ),
        primaryColor: Colors.green[100],
        primaryColorDark: Colors.green[50],
      ),
      home: CategoryRoute(),
    );
  }
}