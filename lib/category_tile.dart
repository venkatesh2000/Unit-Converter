import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unitconverter/category.dart';

const _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);

class CategoryTile extends StatelessWidget {
  final Category category;
  final ValueChanged<Category> onTap;
  static const _padding = EdgeInsets.all(16.0);

  const CategoryTile({
    @required this.category,
    @required this.onTap,
  })  : assert(category != null),
        assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _rowHeight,
      padding: _padding,
      child: InkWell(
          highlightColor: category.color['highlight'],
          splashColor: category.color['splash'],
          borderRadius: _borderRadius,
          onTap: () => onTap(category),
          child: Padding(
            padding: _padding,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: _padding,
                  child: Image.asset(category.icon),
                ),
                Center(
                  child: Text(
                    category.name,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
