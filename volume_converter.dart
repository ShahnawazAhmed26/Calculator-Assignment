import 'package:flutter/material.dart';

class VolumeConverter extends StatefulWidget {
  @override
  _VolumeConverterState createState() => _VolumeConverterState();
}

class _VolumeConverterState extends State<VolumeConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedVolume = '';
  String _selectedFromUnit = 'Liters';
  String _selectedToUnit = 'Milliliters';

  final List<String> _units = [
    'Liters',
    'Milliliters',
    'Cubic meters',
    'Cubic centimeters',
    'Gallons',
    'Fluid ounces',
    'Pints',
    'Quarts',
  ];

  void _convertVolume() {
    final double? value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _convertedVolume = 'Invalid input';
      });
      return;
    }

    double convertedValue;

    // Convert to liters first
    switch (_selectedFromUnit) {
      case 'Liters':
        convertedValue = value;
        break;
      case 'Milliliters':
        convertedValue = value / 1000;
        break;
      case 'Cubic meters':
        convertedValue = value * 1000;
        break;
      case 'Cubic centimeters':
        convertedValue = value / 1000;
        break;
      case 'Gallons':
        convertedValue = value * 3.78541;
        break;
      case 'Fluid ounces':
        convertedValue = value / 33.814;
        break;
      case 'Pints':
        convertedValue = value * 0.473176;
        break;
      case 'Quarts':
        convertedValue = value * 0.946353;
        break;
      default:
        convertedValue = value; // Same unit
    }

    // Convert from liters to the selected unit
    switch (_selectedToUnit) {
      case 'Liters':
        break;
      case 'Milliliters':
        convertedValue *= 1000;
        break;
      case 'Cubic meters':
        convertedValue /= 1000;
        break;
      case 'Cubic centimeters':
        convertedValue *= 1000;
        break;
      case 'Gallons':
        convertedValue /= 3.78541;
        break;
      case 'Fluid ounces':
        convertedValue *= 33.814;
        break;
      case 'Pints':
        convertedValue /= 0.473176;
        break;
      case 'Quarts':
        convertedValue /= 0.946353;
        break;
    }

    setState(() {
      _convertedVolume = convertedValue.toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volume Converter"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('Enter volume:'),
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
        hintText: 'Volume',
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
      onPressed: _convertVolume,
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
      'Converted Volume: $_convertedVolume $_selectedToUnit',
      style: TextStyle(fontSize: 18, color: Colors.white),
    );
  }
}
