import 'package:flutter/material.dart';

class BMICalculator extends StatefulWidget {
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
      double heightInMeters = height / 100; // Convert cm to meters
      bmi = weight / (heightInMeters * heightInMeters);
    } else { // Imperial
      bmi = (weight / (height * height)) * 703; // Conversion for lbs and inches
    }

    _bmiResult = bmi.toStringAsFixed(2);
    _determineBMICategory(bmi, age); // Pass age here
    _updateTargetWeight(height, age); // Corrected method call
    _updateBMIHistory();
  }

  void _determineBMICategory(double bmi, int age) {
    if (age < 18) {
      // Use hypothetical BMI thresholds for children (adjust these values based on actual data)
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
      // Adult categories remain unchanged
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
    double heightInMeters = height / 100; // Convert cm to meters
    double targetWeightLow = 18.5 * (heightInMeters * heightInMeters);
    double targetWeightHigh = 24.9 * (heightInMeters * heightInMeters);

    setState(() {
      if (age < 18) {
        _targetWeightMessage =
            'Recommended weight range (for children): ${targetWeightLow.toStringAsFixed(2)} kg - ${targetWeightHigh.toStringAsFixed(2)} kg';
      } else {
        _targetWeightMessage =
            'Recommended weight range: ${targetWeightLow.toStringAsFixed(2)} kg - ${targetWeightHigh.toStringAsFixed(2)} kg';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGenderIcons(),
                  SizedBox(height: 20),
                  _buildTitle('Weight (${_unit == 'Metric' ? 'kg' : 'lbs'}):'),
                  _buildInputField(_weightController),
                  SizedBox(height: 20),
                  _buildTitle('Height (${_unit == 'Metric' ? 'cm' : 'inches'}):'),
                  _buildInputField(_heightController),
                  SizedBox(height: 20),
                  _buildTitle('Age:'),
                  _buildInputField(_ageController), // Add age input field
                  SizedBox(height: 20),
                  _buildUnitToggle(),
                  SizedBox(height: 20),
                  _buildConvertButton(),
                  SizedBox(height: 20),
                  _buildResultText(),
                  SizedBox(height: 20),
                  _buildBMIHistory(),
                  SizedBox(height: 20),
                  _buildTargetWeight(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTargetWeight() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        _targetWeightMessage,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildGenderIcons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                    color: _gender == 'Male' ? Colors.yellow : Colors.white,
                    size: 60,
                  ),
                  SizedBox(height: 8),
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
                    color: _gender == 'Female' ? Colors.yellow : Colors.white,
                    size: 60,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Female',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        )
        ]
        );
            }
          

  Widget _buildInputField(TextEditingController controller) {
    return TextField(
      controller: controller,
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
    );
  }

  Widget _buildUnitToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTitle('Unit:'),
        DropdownButton<String>(
          value: _unit,
          onChanged: (value) {
            setState(() {
              _unit = value!;
              _weightController.clear();
              _heightController.clear();
              _ageController.clear(); // Clear age input on unit change
              _bmiResult = '';
              _category = '';
              _targetWeightMessage = '';
              _bmiHistory.clear();
            });
          },
          items: ['Metric', 'Imperial'].map((String unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(unit, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          dropdownColor: Colors.grey[900],
        ),
      ],
    );
  }

  Widget _buildConvertButton() {
    return ElevatedButton(
      onPressed: _calculateBMI,
      child: Text('Calculate BMI'),
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
    return Center(
      child: Card(
        color: Colors.grey[850],
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.038),
          child: Text(
            'BMI: $_bmiResult\nCategory: $_category',
            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBMIHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('BMI History:'),
        ..._bmiHistory.map((entry) {
          return Text(entry, style: TextStyle(color: Colors.white));
        }).toList(),
      ],
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }
}

