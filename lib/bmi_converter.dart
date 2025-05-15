import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _bmiResult = '';
  String _category = '';
  String _gender = 'Male';
  String _unit = 'Metric';
  final List<String> _bmiHistory = [];
  String _targetWeightMessage = '';

  void _calculateBMI() {
    final double? weight = double.tryParse(_weightController.text);
    final double? height = double.tryParse(_heightController.text);
    final int age = int.tryParse(_ageController.text) ?? 18;

    if (weight == null || height == null || height <= 0 || weight <= 0 || age < 0) {
      setState(() {
        _bmiResult = 'Invalid input';
        _category = '';
        _targetWeightMessage = '';
      });
      return;
    }

    double bmi;
    if (_unit == 'Metric') {
      double heightInMeters = height / 100;
      bmi = weight / (heightInMeters * heightInMeters);
    } else {
      bmi = (weight / (height * height)) * 703;
    }

    _bmiResult = bmi.toStringAsFixed(2);
    _determineBMICategory(bmi, age);
    _updateTargetWeight(height, age);
    _updateBMIHistory();
  }

  void _determineBMICategory(double bmi, int age) {
    if (age < 18) {
      if (bmi < 14.0) {
        _category = 'Underweight';
      } else if (bmi >= 14.0 && bmi < 22.0) {
        _category = 'Normal weight';
      } else if (bmi >= 22.0 && bmi < 24.0) {
        _category = 'Overweight';
      } else {
        _category = 'Obesity';
      }
    } else {
      if (bmi < 18.5) {
        _category = 'Underweight';
      } else if (bmi < 24.9) {
        _category = 'Normal weight';
      } else if (bmi < 29.9) {
        _category = 'Overweight';
      } else {
        _category = 'Obesity';
      }
    }
  }

  void _updateTargetWeight(double height, int age) {
    double heightInMeters = height / 100;
    double targetWeightLow = 18.5 * (heightInMeters * heightInMeters);
    double targetWeightHigh = 24.9 * (heightInMeters * heightInMeters);

    setState(() {
      if (age < 18) {
        _targetWeightMessage =
            'Recommended weight (child): ${targetWeightLow.toStringAsFixed(2)} kg - ${targetWeightHigh.toStringAsFixed(2)} kg';
      } else {
        _targetWeightMessage =
            'Recommended weight: ${targetWeightLow.toStringAsFixed(2)} kg - ${targetWeightHigh.toStringAsFixed(2)} kg';
      }
    });
  }

  void _updateBMIHistory() {
    setState(() {
      _bmiHistory.clear();
      _bmiHistory.add('BMI: $_bmiResult ($_category) for $_gender, Age: ${_ageController.text}');
    });
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
          title: const Text('BMI Calculator', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          elevation: 8,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGenderIcons(accentColor),
              SizedBox(height: screenHeight * 0.02),
              _buildTitle('Weight (${_unit == 'Metric' ? 'kg' : 'lbs'}):', accentColor),
              SizedBox(height: 8),
              _buildInputField(_weightController, accentColor, Icons.monitor_weight, 'Enter weight'),
              SizedBox(height: screenHeight * 0.02),
              _buildTitle('Height (${_unit == 'Metric' ? 'cm' : 'inches'}):', accentColor),
              SizedBox(height: 8),
              _buildInputField(_heightController, accentColor, Icons.height, 'Enter height'),
              SizedBox(height: screenHeight * 0.02),
              _buildTitle('Age:', accentColor),
              SizedBox(height: 8),
              _buildInputField(_ageController, accentColor, Icons.cake, 'Enter age'),
              SizedBox(height: screenHeight * 0.02),
              _buildUnitToggle(accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildConvertButton(accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildResultCard(accentColor),
              SizedBox(height: screenHeight * 0.02),
              _buildBMIHistory(accentColor),
              SizedBox(height: screenHeight * 0.02),
              _buildTargetWeight(accentColor),
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

  Widget _buildInputField(TextEditingController controller, Color accentColor, IconData icon, String hint) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white.withOpacity(0.07),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            prefixIcon: Icon(icon, color: accentColor),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderIcons(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _gender = 'Male';
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.boy,
                  color: _gender == 'Male' ? accentColor : Colors.white,
                  size: 60,
                ),
                const SizedBox(height: 8),
                Text(
                  'Male',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _gender = 'Female';
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.girl,
                  color: _gender == 'Female' ? accentColor : Colors.white,
                  size: 60,
                ),
                const SizedBox(height: 8),
                Text(
                  'Female',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitToggle(Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTitle('Unit:', accentColor),
        Card(
          color: Colors.white.withOpacity(0.07),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: DropdownButton<String>(
              value: _unit,
              onChanged: (value) {
                setState(() {
                  _unit = value!;
                  _weightController.clear();
                  _heightController.clear();
                  _ageController.clear();
                  _bmiResult = '';
                  _category = '';
                  _targetWeightMessage = '';
                  _bmiHistory.clear();
                });
              },
              items: ['Metric', 'Imperial'].map((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              dropdownColor: Colors.grey[900],
              underline: const SizedBox(),
              icon: Icon(Icons.arrow_drop_down, color: accentColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConvertButton(Color accentColor) {
    return ElevatedButton(
      onPressed: _calculateBMI,
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
      child: const Text('Calculate BMI', style: TextStyle(color: Colors.black)),
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
            _bmiResult.isEmpty || _bmiResult == 'Invalid input'
                ? 'BMI Result'
                : 'BMI: $_bmiResult\nCategory: $_category',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.052,
              color: _bmiResult == 'Invalid input' ? Colors.red : accentColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ).animate().fade(duration: 400.ms),
    );
  }

  Widget _buildBMIHistory(Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('BMI History:', accentColor),
        ..._bmiHistory.map((entry) {
          return Text(entry, style: const TextStyle(color: Colors.white));
        }).toList(),
      ],
    );
  }

  Widget _buildTargetWeight(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        _targetWeightMessage,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}