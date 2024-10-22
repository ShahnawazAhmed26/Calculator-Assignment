import 'package:flutter/material.dart';

class NumeralSystemConverter extends StatefulWidget {
  @override
  _NumeralSystemConverterState createState() => _NumeralSystemConverterState();
}

class _NumeralSystemConverterState extends State<NumeralSystemConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedValue = '';
  String _selectedFromSystem = 'Binary';
  String _selectedToSystem = 'Decimal';

  final List<String> _systems = ['Binary', 'Decimal', 'Hexadecimal'];

  void _convertNumeral() {
    final String input = _controller.text;

    int decimalValue;

    try {
      switch (_selectedFromSystem) {
        case 'Binary':
          decimalValue = int.parse(input, radix: 2);
          break;
        case 'Decimal':
          decimalValue = int.parse(input);
          break;
        case 'Hexadecimal':
          decimalValue = int.parse(input, radix: 16);
          break;
        default:
          decimalValue = int.parse(input);
      }

      switch (_selectedToSystem) {
        case 'Binary':
          _convertedValue = decimalValue.toRadixString(2);
          break;
        case 'Decimal':
          _convertedValue = decimalValue.toString();
          break;
        case 'Hexadecimal':
          _convertedValue = decimalValue.toRadixString(16).toUpperCase();
          break;
      }

      setState(() {
        _convertedValue = _convertedValue;
      });
    } catch (e) {
      setState(() {
        _convertedValue = 'Invalid input';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildConverter(context, 'Numeral System Converter', _convertNumeral, _systems, _selectedFromSystem, (value) {
      setState(() {
        _selectedFromSystem = value!;
      });
    });
  }
}

// This is the helper function used by multiple converters
Widget _buildConverter(BuildContext context, String title, Function convert, List<String> units, String selectedUnit, ValueChanged<String?> onChanged) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      backgroundColor: Colors.black,
    ),
    backgroundColor: Colors.black,
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Enter value:'),
          TextField(
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter value',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[850],
              border: InputBorder.none,
            ),
          ),
          SizedBox(height: 20),
          Text('From:'),
          DropdownButton<String>(
            value: selectedUnit,
            onChanged: onChanged,
            items: units.map((unit) {
              return DropdownMenuItem(
                value: unit,
                child: Text(unit),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: () => convert(), child: Text('Convert')),
          SizedBox(height: 20),
          Text('Converted Value:', style: TextStyle(fontSize: 20, color: Colors.white)),
        ],
      ),
    ),
  );
}

// Then, the rest of your converters like this one:

