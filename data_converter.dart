import 'package:flutter/material.dart';

class DataConverter extends StatefulWidget {
  @override
  _DataConverterState createState() => _DataConverterState();
}

class _DataConverterState extends State<DataConverter> {
  String _fromUnit = 'Bits';
  String _toUnit = 'Bytes';
  double _inputValue = 0.0;
  String _result = '';

  final Map<String, double> _conversionRates = {
    'Bits': 1.0,
    'Bytes': 8.0,
    'Kilobits': 1000.0,
    'Kilobytes': 8000.0,
    'Megabits': 1e6,
    'Megabytes': 8e6,
    'Gigabits': 1e9,
    'Gigabytes': 8e9,
    'Terabits': 1e12,
    'Terabytes': 8e12,
    'Petabits': 1e15,
    'Petabytes': 8e15,
    'Exabits': 1e18,
    'Exabytes': 8e18,
    'Zettabits': 1e21,
    'Zettabytes': 8e21,
    'Yottabits': 1e24,
    'Yottabytes': 8e24,
    'Kibibits': 1024.0,
    'Kibibytes': 8192.0,
    'Mebibits': 1.048576e6,
    'Mebibytes': 8.388608e6,
    'Gibibits': 1.073741824e9,
    'Gibibytes': 8.589869056e9,
    'Tebibits': 1.099511627776e12,
    'Tebibytes': 8.796093022208e12,
    'Pebibits': 1.125899906842624e15,
    'Pebibytes': 9.007199254740992e15,
    'Exbibits': 1.152921504606846e18,
    'Exbibytes': 9.007199254740992e18,
    'Zebibits': 1.180591620017e21,
    'Zebibytes': 9.333430416136e21,
    'Yobibits': 1.2089258196146292e24,
    'Yobibytes': 9.444732965000004e24,
  };

  void _convertData() {
    double fromRate = _conversionRates[_fromUnit]!;
    double toRate = _conversionRates[_toUnit]!;
    double convertedValue = (_inputValue * fromRate) / toRate;

    setState(() {
      _result = 'Converted value: ${convertedValue.toStringAsFixed(4)} $_toUnit';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Converter', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCustomDropdown('From:', _fromUnit, (value) {
              setState(() {
                _fromUnit = value!;
              });
            }),
            SizedBox(height: 16),
            _buildInputField(),
            SizedBox(height: 16),
            _buildCustomDropdown('To:', _toUnit, (value) {
              setState(() {
                _toUnit = value!;
              });
            }),
            SizedBox(height: 20),
            _buildConvertButton(),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text(
                  _result,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        Container(
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
            items: _conversionRates.keys.toList().map((unit) {
              return DropdownMenuItem<String>(
                value: unit,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(unit),
                ),
              );
            }).toList(),
          ),
        ),
      ],
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

  Widget _buildConvertButton() {
    return ElevatedButton(
      onPressed: _convertData,
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
}
