import 'package:chrono_calc/angle_converter.dart';
import 'package:chrono_calc/bmi_converter.dart';
import 'package:chrono_calc/data_converter.dart';
import 'package:chrono_calc/discount_calculator.dart';
import 'package:chrono_calc/distance_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Import your converter screens
import 'finance_converter.dart';
import 'mass_converter.dart';
import 'numeral_system_converter.dart';
import 'power_converter.dart';
import 'pressure_converter.dart';
import 'speed_converter.dart';
import 'temperature_converter.dart';
import 'area_converter.dart';
import 'volume_converter.dart';
import 'energy_converter.dart';
import 'time_converter.dart';

class ConverterSelectionScreen extends StatelessWidget {
  const ConverterSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFFFFD600); // Bright yellow

    final List<Map<String, dynamic>> converters = [
      {"name": "Area", "icon": Icons.crop_square, "page":  AreaConverter()},
      {"name": "Angle", "icon": Icons.crop_square, "page":  AngleConverter()},
      {"name": "Data", "icon": Icons.crop_square, "page":  DataConverter()},
      {"name": "Discount", "icon": Icons.crop_square, "page":  DiscountCalculator()},
      {"name": "Distance", "icon": Icons.crop_square, "page":  DistanceConverter()},
      {"name": "Energy", "icon": Icons.crop_square, "page":  EnergyConverter()},
      {"name": "Finance", "icon": Icons.crop_square, "page":  FinanceConverter()},

      {"name": "BMI", "icon": Icons.crop_square, "page":  BMICalculator()},

      {"name": "Volume", "icon": Icons.invert_colors, "page":  VolumeConverter()},
      {"name": "Mass", "icon": Icons.scale, "page":  MassConverter()},
      {"name": "Temperature", "icon": Icons.thermostat, "page":  TemperatureConverter()},
      {"name": "Speed", "icon": Icons.speed, "page":  SpeedConverter()},
      {"name": "Power", "icon": Icons.flash_on, "page": PowerConverter() },
      {"name": "Pressure", "icon": Icons.compress, "page":  PressureConverter()},
      {"name": "Energy", "icon": Icons.bolt, "page":  EnergyConverter()},
      {"name": "Time", "icon": Icons.access_time, "page":  TimeConverter()},
      {"name": "Numeral System", "icon": Icons.code, "page":  NumeralSystemConverter()},
      {"name": "Finance", "icon": Icons.attach_money, "page":  FinanceConverter()},
    ];

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
          title: Text(
            "Converters",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: accentColor,
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: converters.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 22,
              crossAxisSpacing: 22,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final converter = converters[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => converter["page"]));
                },
                child: AnimatedContainer(
                  duration: 300.ms,
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: accentColor.withOpacity(0.25), width: 2),
                    // Glassmorphism effect
                    backgroundBlendMode: BlendMode.overlay,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.25),
                              blurRadius: 18,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(converter["icon"], size: 44, color: accentColor),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        converter["name"],
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.7,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              );
            },
          ),
        ),
      ),
    );
  }
}