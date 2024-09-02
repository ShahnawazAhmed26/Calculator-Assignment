import 'package:flutter/material.dart';

class PressureConverter extends StatefulWidget {
  @override
  _PressureConverterState createState() => _PressureConverterState();
}

class _PressureConverterState extends State<PressureConverter> {
  String _fromUnit = 'Pascal';
  String _toUnit = 'Bar';
  double _inputValue = 0.0;
  String _result = '';

  final Map<String, double> _conversionRates = {
    'Pascal': 1.0,
    'Bar': 1e5,
    'Atmosphere': 101325.0,
    'Torr': 133.322,
    'Pound per Square Inch (PSI)': 6894.76,
    'Kilopascal': 1e3,
    'Millimeter of Mercury (mmHg)': 133.322,
    'Inch of Mercury (inHg)': 3386.39,
    'Kilogram per Square Meter': 9.80665,
  };

  void _convertPressure() {
    double fromRate = _conversionRates[_fromUnit]!;
    double toRate = _conversionRates[_toUnit]!;
    double convertedValue = (_inputValue * fromRate) / toRate;

    setState(() {
      _result = 'Conversion Result:\n\n ${convertedValue.toStringAsPrecision(6)} $_toUnit\n\n';
            
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pressure Converter', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitle('From:'),
              SizedBox(height: 10),
              _buildCustomDropdown(_fromUnit, (value) {
                setState(() {
                  _fromUnit = value!;
                });
              }),
              SizedBox(height: 20),
              _buildInputField(),
              SizedBox(height: 20),
              _buildTitle('To:'),
              SizedBox(height: 10),
              _buildCustomDropdown(_toUnit, (value) {
                setState(() {
                  _toUnit = value!;
                });
              }),
              SizedBox(height: 20),
              _buildConvertButton(),
              SizedBox(height: 20),
              _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInputField() {
    return TextField(
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Enter value',
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _inputValue = double.tryParse(value) ?? 0.0;
        });
      },
    );
  }

  Widget _buildCustomDropdown(String value, ValueChanged<String?> onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down, color: Colors.yellow),
        dropdownColor: Colors.grey[900],
        underline: SizedBox(),
        style: TextStyle(color: Colors.white, fontSize: 16),
        items: _conversionRates.keys.map((unit) {
          return DropdownMenuItem(
            value: unit,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(unit),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConvertButton() {
    return ElevatedButton(
      onPressed: _convertPressure,
      child: Text('Convert'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        padding: EdgeInsets.symmetric(vertical: 20),
        textStyle: TextStyle(fontSize: 20),
        minimumSize: Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Center(
      child: Card(
        color: Colors.grey[850],
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _result,
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
