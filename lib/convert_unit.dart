import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unitconverter/api.dart';
import 'package:unitconverter/category.dart';
import 'package:unitconverter/unit.dart';

const _padding = EdgeInsets.all(16.0);

class ConvertUnit extends StatefulWidget {
  final Category category;

  const ConvertUnit({
    @required this.category,
  }) : assert(category != null);

  @override
  _ConvertUnitState createState() => _ConvertUnitState();
}

class _ConvertUnitState extends State<ConvertUnit> {
  List<DropdownMenuItem> _units;
  double _input;
  String _output = '';
  Unit _fromUnit, _toUnit;
  bool _inputError = false, _conversionError = false;
  final _inputKey = GlobalKey(debugLabel: 'inputText');

  @override
  void initState() {
    super.initState();
    _buildDropDownMenuItems();
    _defaultValues();
  }

  @override
  void didUpdateWidget(ConvertUnit old) {
    super.didUpdateWidget(old);
    if (old.category != widget.category) {
      _buildDropDownMenuItems();
      _defaultValues();
    }
  }

  void _buildDropDownMenuItems() {
    var _tempUnits = <DropdownMenuItem>[];

    for (var unit in widget.category.units)
      _tempUnits.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          ),
        ),
      ));

    setState(() {
      _units = _tempUnits;
    });
  }

  void _defaultValues() {
    setState(() {
      _fromUnit = widget.category.units[0];
      _toUnit = widget.category.units[1];
    });

    if (_input != null) _computeOutput();
  }

  Unit _getUnit(String unitName) {
    return widget.category.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }

  void _updateFromUnit(dynamic unitName) {
    setState(() {
      _fromUnit = _getUnit(unitName);
    });

    if (_input != null) _computeOutput();
  }

  void _updateToUnit(dynamic unitName) {
    setState(() {
      _toUnit = _getUnit(unitName);
    });

    if (_input != null) _computeOutput();
  }

  void _updateInput(String newInput) {
    if (newInput == null || newInput.isEmpty) {
      setState(() {
        _output = '';
      });
    } else {
      try {
        double temp = double.parse(newInput);
        _inputError = false;
        _input = temp;
        _computeOutput();
      } on Exception catch (e) {
        print('$e');
        _inputError = true;
      }
    }
  }

  Future<void> _computeOutput() async {
    if (widget.category.name == apiCategory['name']) {
      final api = Api();
      final conversion = await api.getConversion(apiCategory['route'],
          _input.toString(), _fromUnit.name, _toUnit.name);

      if (conversion == null) {
        setState(() {
          _conversionError = true;
        });
      } else {
        setState(() {
          _conversionError = false;
          _output = _formatOutput(conversion);
        });
      }
    } else {
      setState(() {
        _output =
            _formatOutput(_input * (_toUnit.conversion / _fromUnit.conversion));
      });
    }
  }

  String _formatOutput(double output) {
    String outputNum = output.toString();
    int length = outputNum.length - 1;

    if (outputNum.contains('.')) {
      while (outputNum[length] == '0') --length;

      if (outputNum[length] == '.') --length;
    }

    return outputNum.substring(0, length + 1);
  }

  Widget _buildDropDown(String _currentUnit, ValueChanged<dynamic> _onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                value: _currentUnit,
                items: _units,
                onChanged: _onChanged,
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
      ),
    );
  }

  void swapUnits() {
    var temp = _fromUnit;
    setState(() {
      _fromUnit = _toUnit;
      _toUnit = temp;
    });

    _computeOutput();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.category.units == null ||
        (widget.category.name == apiCategory['name'] && _conversionError)) {
      return SingleChildScrollView(
        child: Container(
          padding: _padding,
          margin: _padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: widget.category.color['error'],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                size: 180.0,
                color: Colors.white,
              ),
              Text(
                "Oh no! We are unable to connect right now!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final input = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: _inputKey,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.black),
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.headline4,
              labelText: 'Input',
              errorText: _inputError ? 'Invalid number entered!!' : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: _updateInput,
          ),
          _buildDropDown(_fromUnit.name, _updateFromUnit),
        ],
      ),
    );

    final arrows = RotatedBox(
        quarterTurns: 1,
        child: RawMaterialButton(
          onPressed: swapUnits,
          elevation: 5.0,
          fillColor: Colors.grey[50],
          child: Icon(
            Icons.compare_arrows,
            size: 35.0,
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ));

    final output = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.headline4,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            child: Text(
              _output,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.black),
            ),
          ),
          _buildDropDown(_toUnit.name, _updateToUnit),
        ],
      ),
    );

    final converter = Column(
      children: [
        input,
        arrows,
        output,
      ],
    );

    return Padding(
      padding: _padding,
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.portrait) {
            return SingleChildScrollView(
              child: converter,
            );
          } else {
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  child: converter,
                  width: 450.0,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
