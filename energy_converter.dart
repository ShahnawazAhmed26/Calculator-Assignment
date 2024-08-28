import 'package:flutter/material.dart';

class EnergyConverter extends StatefulWidget {
  @override
  _EnergyConverterState createState() => _EnergyConverterState();
}

class _EnergyConverterState extends State<EnergyConverter> {
  String _fromUnit = 'Joules';
  String _toUnit = 'Kilojoules';
  double _inputValue = 0.0;
  String _result = '';

  final Map<String, double> _conversionRates = {
    'Joules': 1.0,
    'Kilojoules': 1000.0,
    'Calories': 4.184,
    'Kilocalories': 4184.0,
    'Watt-hours': 3600.0,
    'BTUs': 1055.06,
    'eV': 1.60218e-19,
    'Electron Watts': 1.60218e-19,  // Approximation
    'Thermal Calories': 4.184,      // Same as Calories for simplicity
    'Food Calories': 4184.0,        // Same as Kilocalories
    'Foot-pounds': 1.35582,         // Conversion factor for energy
    'Kilowatt-hours': 3600000.0,    // Conversion factor for energy
  };

  void _convertEnergy() {
    double fromRate = _conversionRates[_fromUnit]!;
    double toRate = _conversionRates[_toUnit]!;
    double convertedValue = (_inputValue * fromRate) / toRate;

    setState(() {
      _result = 'Converted value: $convertedValue $_toUnit';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Converter', style: TextStyle(color: Colors.white)),
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
      onPressed: _convertEnergy,
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
