import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:unitconverter/category.dart';
import 'package:unitconverter/unit.dart';
import 'package:unitconverter/api.dart';

class CategoryRoute extends StatefulWidget {
  const CategoryRoute();

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  Category _defaultCategory, _currentCategory;
  List<Category> _categories;
  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];
  static const _icons = <String>[
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/volume.png',
    'assets/icons/mass.png',
    'assets/icons/time.png',
    'assets/icons/digital_storage.png',
    'assets/icons/power.png',
    'assets/icons/currency.png',
  ];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _retrieveLocalCategories();
    await _retrieveApiCategories();
  }

  Future<void> _retrieveLocalCategories() async {
    final json = DefaultAssetBundle.of(context)
        .loadString('assets/data/categories.json');
    final data = JsonDecoder().convert(await json);
    var index = 0;

    if (data is! Map) return null;

    data.keys().forEach((key) {
      List<Unit> units =
          data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();
      final _category = Category(
        name: key,
        units: units,
        color: _baseColors[index],
        icon: _icons[index],
      );

      setState(() {
        if (index == 0) _defaultCategory = _category;
        _categories.add(_category);
      });
    });
  }

  Future<void> _retrieveApiCategories() async {
    final _category = Category(
      name: apiCategory['name'],
      units: [],
      color: _baseColors.last,
      icon: _icons.last,
    );
    setState(() {
      _categories.add(_category);
    });

    final api = Api();
    String category = apiCategory['route'];
    final jsonUnits = await api.getUnits(category);

    if (jsonUnits != null) {
      List<Unit> units =
          jsonUnits.map<Unit>((dynamic data) => Unit.fromJson(data)).toList();
      setState(() {
        final _category = Category(
          name: apiCategory['name'],
          units: units,
          color: _baseColors.last,
          icon: _icons.last,
        );
        _categories.removeLast();
        _categories.add(_category);
      });
    }
  }

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {}
}