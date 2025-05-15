import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TimeConverter extends StatefulWidget {
  @override
  _TimeConverterState createState() => _TimeConverterState();
}

class _TimeConverterState extends State<TimeConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedTime = '';
  String _selectedFromUnit = 'Seconds';
  String _selectedToUnit = 'Minutes';

  final List<String> _units = [
    'Seconds',
    'Minutes',
    'Hours',
    'Days',
    'Weeks',
    'Years',
    'Milliseconds',
    'Microseconds',
  ];

  void _convertTime() {
    final double? value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _convertedTime = 'Invalid input';
      });
      return;
    }

    double convertedValue;

    switch (_selectedFromUnit) {
      case 'Seconds':
        convertedValue = _convertFromSeconds(value);
        break;
      case 'Minutes':
        convertedValue = _convertFromMinutes(value);
        break;
      case 'Hours':
        convertedValue = _convertFromHours(value);
        break;
      case 'Days':
        convertedValue = _convertFromDays(value);
        break;
      case 'Weeks':
        convertedValue = _convertFromWeeks(value);
        break;
      case 'Years':
        convertedValue = _convertFromYears(value);
        break;
      case 'Milliseconds':
        convertedValue = _convertFromMilliseconds(value);
        break;
      case 'Microseconds':
        convertedValue = _convertFromMicroseconds(value);
        break;
      default:
        convertedValue = value; // Same unit
    }

    setState(() {
      _convertedTime = convertedValue.toStringAsFixed(6);
    });
  }

  double _convertFromSeconds(double value) {
    switch (_selectedToUnit) {
      case 'Minutes': return value / 60;
      case 'Hours': return value / 3600;
      case 'Days': return value / 86400;
      case 'Weeks': return value / 604800;
      case 'Years': return value / 31536000;
      case 'Milliseconds': return value * 1000;
      case 'Microseconds': return value * 1000000;
      default: return value;
    }
  }

  double _convertFromMinutes(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 60;
      case 'Hours': return value / 60;
      case 'Days': return value / 1440;
      case 'Weeks': return value / 10080;
      case 'Years': return value / 525600;
      case 'Milliseconds': return value * 60000;
      case 'Microseconds': return value * 60000000;
      default: return value;
    }
  }

  double _convertFromHours(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 3600;
      case 'Minutes': return value * 60;
      case 'Days': return value / 24;
      case 'Weeks': return value / 168;
      case 'Years': return value / 8760;
      case 'Milliseconds': return value * 3600000;
      case 'Microseconds': return value * 3600000000;
      default: return value;
    }
  }

  double _convertFromDays(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 86400;
      case 'Minutes': return value * 1440;
      case 'Hours': return value * 24;
      case 'Weeks': return value / 7;
      case 'Years': return value / 365;
      case 'Milliseconds': return value * 86400000;
      case 'Microseconds': return value * 86400000000;
      default: return value;
    }
  }

  double _convertFromWeeks(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 604800;
      case 'Minutes': return value * 10080;
      case 'Hours': return value * 168;
      case 'Days': return value * 7;
      case 'Years': return value / 52.1429;
      case 'Milliseconds': return value * 604800000;
      case 'Microseconds': return value * 604800000000;
      default: return value;
    }
  }

  double _convertFromYears(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 31536000;
      case 'Minutes': return value * 525600;
      case 'Hours': return value * 8760;
      case 'Days': return value * 365;
      case 'Weeks': return value * 52.1429;
      case 'Milliseconds': return value * 31536000000;
      case 'Microseconds': return value * 31536000000000;
      default: return value;
    }
  }

  double _convertFromMilliseconds(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value / 1000;
      case 'Minutes': return value / 60000;
      case 'Hours': return value / 3600000;
      case 'Days': return value / 86400000;
      case 'Weeks': return value / 604800000;
      case 'Years': return value / 31536000000;
      case 'Microseconds': return value * 1000;
      default: return value;
    }
  }

  double _convertFromMicroseconds(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value / 1000000;
      case 'Minutes': return value / 60000000;
      case 'Hours': return value / 3600000000;
      case 'Days': return value / 86400000000;
      case 'Weeks': return value / 604800000000;
      case 'Years': return value / 31536000000000;
      case 'Milliseconds': return value / 1000;
      default: return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFFFFD600);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Color(0xFF222222)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Time Converter", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          elevation: 8,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitle('Enter time:', accentColor),
              SizedBox(height: screenHeight * 0.02),
              _buildInputField(accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildCustomDropdown('From:', _selectedFromUnit, (value) {
                setState(() {
                  _selectedFromUnit = value!;
                });
              }, accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildCustomDropdown('To:', _selectedToUnit, (value) {
                setState(() {
                  _selectedToUnit = value!;
                });
              }, accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildConvertButton(accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildResultCard(accentColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String text, Color accentColor) {
    return Text(
      text,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.052,
        color: accentColor,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildInputField(Color accentColor) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white.withOpacity(0.07),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Time',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            prefixIcon: Icon(Icons.access_time, color: accentColor),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDropdown(String label, String value, ValueChanged<String?> onChanged, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(label, accentColor),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white.withOpacity(0.07),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: MediaQuery.of(context).size.height * 0.01),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: accentColor),
              dropdownColor: Colors.grey[900],
              underline: const SizedBox(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  fontWeight: FontWeight.w600),
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
        ),
      ],
    );
  }

  Widget _buildConvertButton(Color accentColor) {
    return ElevatedButton(
      onPressed: _convertTime,
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.022),
        textStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.052,
            fontWeight: FontWeight.bold),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        shadowColor: accentColor.withOpacity(0.3),
      ),
      child: const Text('Convert', style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildResultCard(Color accentColor) {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.09),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.045),
          child: Text(
            _convertedTime.isEmpty || _convertedTime == 'Invalid input'
                ? 'Converted Time'
                : '$_convertedTime $_selectedToUnit',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.052,
              color: _convertedTime == 'Invalid input' ? Colors.red : accentColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ).animate().fade(duration: 400.ms),
    );
  }
}