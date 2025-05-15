import 'package:flutter/material.dart';

class CalculatorLogo extends StatelessWidget {
  const CalculatorLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF232526), Color(0xFF414345)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFFFD600),
          width: 2.5,
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Calculator body
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.10),
                  width: 1.5,
                ),
              ),
            ),
            // Display
            Positioned(
              top: 10,
              child: Container(
                width: 18,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Center(
                  child: Text(
                    '0',
                    style: TextStyle(
                      color: const Color(0xFFFFD600),
                      fontWeight: FontWeight.bold,
                      fontSize: 7,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
            // Buttons row
            Positioned(
              bottom: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 4.5,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
            // Accent button
            Positioned(
              bottom: 3,
              right: 8,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD600),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}