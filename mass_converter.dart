import 'package:flutter/material.dart';

class MassConverter extends StatefulWidget {
  @override
  _MassConverterState createState() => _MassConverterState();
}

class _MassConverterState extends State<MassConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedMass = '';
  String _selectedFromUnit = 'Kilograms';
  String _selectedToUnit = 'Grams';

  final List<String> _units = [
    'Kilograms',
    'Grams',
    'Pounds',
    'Ounces',
    'Tons',
    'Stones',
  ];

  void _convertMass() {
    final double? value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _convertedMass = 'Invalid input';
      });
      return;
    }

    double convertedValue;

    // Convert to kilograms first
    switch (_selectedFromUnit) {
      case 'Kilograms':
        convertedValue = value;
        break;
      case 'Grams':
        convertedValue = value / 1000;
        break;
      case 'Pounds':
        convertedValue = value * 0.453592;
        break;
      case 'Ounces':
        convertedValue = value * 0.0283495;
        break;
      case 'Tons':
        convertedValue = value * 907.185;
        break;
      case 'Stones':
        convertedValue = value * 6.35029;
        break;
      default:
        convertedValue = value; // Same unit
    }

    // Convert from kilograms to the selected unit
    switch (_selectedToUnit) {
      case 'Kilograms':
        break;
      case 'Grams':
        convertedValue *= 1000;
        break;
      case 'Pounds':
        convertedValue /= 0.453592;
        break;
      case 'Ounces':
        convertedValue /= 0.0283495;
        break;
      case 'Tons':
        convertedValue /= 907.185;
        break;
      case 'Stones':
        convertedValue /= 6.35029;
        break;
    }

    setState(() {
      _convertedMass = convertedValue.toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mass Converter"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('Enter mass:'),
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
        hintText: 'Mass',
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
      onPressed: _convertMass,
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
      'Converted Mass: $_convertedMass $_selectedToUnit',
      style: TextStyle(fontSize: 18, color: Colors.white),
    );
  }
}
