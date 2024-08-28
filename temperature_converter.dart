import 'package:flutter/material.dart';

class TemperatureConverter extends StatefulWidget {
  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedTemperature = '';
  String _selectedFromUnit = 'Celsius';
  String _selectedToUnit = 'Fahrenheit';

  final List<String> _units = [
    'Celsius',
    'Fahrenheit',
    'Kelvin',
  ];

  void _convertTemperature() {
    final double? value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _convertedTemperature = 'Invalid input';
      });
      return;
    }

    double convertedValue;

    // Convert to Celsius first
    switch (_selectedFromUnit) {
      case 'Celsius':
        convertedValue = value;
        break;
      case 'Fahrenheit':
        convertedValue = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        convertedValue = value - 273.15;
        break;
      default:
        convertedValue = value; // Same unit
    }

    // Convert from Celsius to the selected unit
    switch (_selectedToUnit) {
      case 'Celsius':
        break;
      case 'Fahrenheit':
        convertedValue = convertedValue * 9 / 5 + 32;
        break;
      case 'Kelvin':
        convertedValue += 273.15;
        break;
    }

    setState(() {
      _convertedTemperature = convertedValue.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temperature Converter"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('Enter temperature:'),
            SizedBox(height: 10),
            _buildInputField(),
            SizedBox(height: 20),
            _buildCustomDropdown('From:', _selectedFromUnit, (value) {
              setState(() {
                _selectedFromUnit = value!;
              });
            }),
            SizedBox(height: 20),
            _buildCustomDropdown('To:', _selectedToUnit, (value) {
              setState(() {
                _selectedToUnit = value!;
              });
            }),
            SizedBox(height: 20),
            _buildConvertButton(),
            SizedBox(height: 20),
            _buildResultText(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }

  Widget _buildInputField() {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Temperature',
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildCustomDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(label),
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
            items: _units.map((unit) {
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

  Widget _buildConvertButton() {
    return ElevatedButton(
      onPressed: _convertTemperature,
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

  Widget _buildResultText() {
    return Text(
      'Converted Temperature: $_convertedTemperature $_selectedToUnit',
      style: TextStyle(fontSize: 18, color: Colors.white),
    );
  }
}
