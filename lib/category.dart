import 'package:flutter/cupertino.dart';
import 'package:unitconverter/unit.dart';

class Category {
  final String name;
  final List<Unit> units;
  final ColorSwatch color;
  final String icon;

  const Category({
    @required this.name,
    @required this.units,
    @required this.color,
    @required this.icon,
  })  : assert(name != null),
        assert(units != null),
        assert(color != null),
        assert(icon != null);
}
