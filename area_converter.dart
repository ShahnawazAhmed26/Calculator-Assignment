import 'package:flutter/material.dart';

class AreaConverter extends StatefulWidget {
  @override
  _AreaConverterState createState() => _AreaConverterState();
}

class _AreaConverterState extends State<AreaConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedArea = '';
  String _selectedFromUnit = 'Square meters';
  String _selectedToUnit = 'Square feet';

  final List<String> _units = [
    'Square meters',
    'Square feet',
    'Square yards',
    'Acres',
    'Hectares',
    'Square kilometers',
    'Square miles',
  ];

  void _convertArea() {
    final double? value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _convertedArea = 'Invalid input';
      });
      return;
    }

    double convertedValue = value;

    // Convert from the selected unit to square meters (base unit)
    switch (_selectedFromUnit) {
      case 'Square meters':
        convertedValue = value;
        break;
      case 'Square feet':
        convertedValue = value * 0.092903;
        break;
      case 'Square yards':
        convertedValue = value * 0.836127;
        break;
      case 'Acres':
        convertedValue = value * 4046.86;
        break;
      case 'Hectares':
        convertedValue = value * 10000;
        break;
      case 'Square kilometers':
        convertedValue = value * 1e6;
        break;
      case 'Square miles':
        convertedValue = value * 2.59e6;
        break;
    }

    // Convert from square meters (base unit) to the selected target unit
    switch (_selectedToUnit) {
      case 'Square meters':
        break;
      case 'Square feet':
        convertedValue *= 10.764;
        break;
      case 'Square yards':
        convertedValue *= 1.19599;
        break;
      case 'Acres':
        convertedValue /= 4046.86;
        break;
      case 'Hectares':
        convertedValue /= 10000;
        break;
      case 'Square kilometers':
        convertedValue /= 1e6;
        break;
      case 'Square miles':
        convertedValue /= 2.59e6;
        break;
    }

    setState(() {
      _convertedArea = convertedValue.toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Area Converter" , style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('Enter area:'),
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
        hintText: 'Area',
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
      onPressed: _convertArea,
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
      'Converted Area: $_convertedArea $_selectedToUnit',
      style: TextStyle(fontSize: 18, color: Colors.white),
    );
  }
}
