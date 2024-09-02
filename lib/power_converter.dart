import 'package:flutter/material.dart';

class PowerConverter extends StatefulWidget {
  @override
  _PowerConverterState createState() => _PowerConverterState();
}

class _PowerConverterState extends State<PowerConverter> {
  String _fromUnit = 'Watts';
  String _toUnit = 'Kilowatts';
  double _inputValue = 0.0;
  String _result = '';

  final Map<String, double> _conversionRates = {
    'Watts': 1.0,
    'Kilowatts': 1000.0,
    'Megawatts': 1e6,
    'Horsepower': 745.7,
    'Foot-pounds/minute': 0.0226,
    'BTUs/minute': 17.5843,
  };

  void _convertPower() {
    double fromRate = _conversionRates[_fromUnit]!;
    double toRate = _conversionRates[_toUnit]!;
    double convertedValue = (_inputValue * fromRate) / toRate;

    setState(() {
      _result = 'Conversion Result:\n\n'
                '${convertedValue.toStringAsPrecision(6)} $_toUnit\n\n'
                ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Power Converter', style: TextStyle(color: Colors.white)),
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
      onPressed: _convertPower,
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
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
      height: MediaQuery.of(context).size.height * 0.2, // 20% of screen height
      child: Card(
        color: Colors.grey[850],
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: 
           Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                _result.isEmpty ? 'Result will be displayed here' : _result,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  
}
}