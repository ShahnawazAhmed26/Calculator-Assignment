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
    'Carats',
    'Milligrams',
    'Centigrams',
    'Decigrams',
    'Grams',
    'Dekagrams',
    'Hectograms',
    'Kilograms',
    'Metric Tons',
    'Ounces',
    'Pounds',
    'Stones',
    'Short Tons',
    'Long Tons',
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
      case 'Carats':
        convertedValue = value * 0.0002;
        break;
      case 'Milligrams':
        convertedValue = value / 1e6;
        break;
      case 'Centigrams':
        convertedValue = value / 100000;
        break;
      case 'Decigrams':
        convertedValue = value / 10000;
        break;
      case 'Grams':
        convertedValue = value / 1000;
        break;
      case 'Dekagrams':
        convertedValue = value / 100;
        break;
      case 'Hectograms':
        convertedValue = value / 10;
        break;
      case 'Kilograms':
        convertedValue = value;
        break;
      case 'Metric Tons':
        convertedValue = value * 1000;
        break;
      case 'Ounces':
        convertedValue = value * 0.028349523125;
        break;
      case 'Pounds':
        convertedValue = value * 0.45359237;
        break;
      case 'Stones':
        convertedValue = value * 6.35029318;
        break;
      case 'Short Tons':
        convertedValue = value * 907.18474;
        break;
      case 'Long Tons':
        convertedValue = value * 1016.0469088;
        break;
      default:
        convertedValue = value; // Same unit
    }

    // Convert from kilograms to the selected unit
    switch (_selectedToUnit) {
      case 'Carats':
        convertedValue /= 0.0002;
        break;
      case 'Milligrams':
        convertedValue *= 1e6;
        break;
      case 'Centigrams':
        convertedValue *= 100000;
        break;
      case 'Decigrams':
        convertedValue *= 10000;
        break;
      case 'Grams':
        convertedValue *= 1000;
        break;
      case 'Dekagrams':
        convertedValue *= 100;
        break;
      case 'Hectograms':
        convertedValue *= 10;
        break;
      case 'Kilograms':
        break;
      case 'Metric Tons':
        convertedValue /= 1000;
        break;
      case 'Ounces':
        convertedValue /= 0.028349523125;
        break;
      case 'Pounds':
        convertedValue /= 0.45359237;
        break;
      case 'Stones':
        convertedValue /= 6.35029318;
        break;
      case 'Short Tons':
        convertedValue /= 907.18474;
        break;
      case 'Long Tons':
        convertedValue /= 1016.0469088;
        break;
    }

    setState(() {
      _convertedMass = convertedValue.toStringAsFixed(10); // Scientific precision
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
