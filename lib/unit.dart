import 'package:flutter/cupertino.dart';

class Unit {
  final String name;
  final double conversion;

  const Unit({
    @required this.name,
    @required this.conversion,
  })  : assert(name != null),
        assert(conversion != null);

  Unit.fromJson(Map json)
      : assert(json['name'] != null),
        assert(json['conversion'] != null),
        name = json['name'],
        conversion = json['conversion'].toDouble();
}
