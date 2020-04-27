import 'package:flutter/material.dart';
import 'category_route.dart';

void main() {
  runApp(UnitConverter());
}

class UnitConverter extends StatelessWidget {
  const UnitConverter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      color: Colors.black,
      theme: ThemeData(
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.grey[600],
            ),
        primaryColor: Colors.grey[500],
        textSelectionHandleColor: Colors.green[500],
      ),
      home: CategoryRoute(),
    );
  }
}
