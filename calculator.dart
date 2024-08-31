import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'conversion_selector.dart'; // Import the conversions selector screen
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expressions/expressions.dart';


class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String display = '0';
  String expression = '';
  List<String> history = []; // Initialize history as an empty list

  final List<String> _buttonLabels = [
    'AC', '+/-', '%', '⌫',
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    '0', '.', '=', '+'
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenSize = MediaQuery.of(context).size;
    final buttonSize = screenSize.width / 4; // Calculate button size based on screen width

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "CALCULATOR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: CachedNetworkImage(
                imageUrl: 'https://imgtr.ee/images/2024/08/31/a30eba82aec52b735ec6360a0d8730a4.png',
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer when pressed
              },
            );
          },
        ),
        actions: [
          IconButton(
            key: ValueKey('history'),
            icon: CachedNetworkImage(
              imageUrl: 'https://imgtr.ee/images/2024/08/31/5bf8f37eaf4259844428731b2f80ae47.png',
              width: 24,
              height: 24,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            onPressed: () {
              showHistory();
            },
          ),
          IconButton(
            icon: CachedNetworkImage(
              imageUrl: 'https://imgtr.ee/images/2024/08/31/640305d68702aa1036b8787ecca5ae6d.png',
              width: 24,
              height: 24,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConversionsSelector()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Center(
                child: Text(
                  "Calculator Modes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text(
                "Standard",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.yellow),
              title: Text(
                "Rate Us",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: _rateUs,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          // Display area
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text(
              display,
              style: TextStyle(
                color: Colors.white,
                fontSize: _getFontSize(display),
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Calculator buttons
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of buttons per row
                crossAxisSpacing: 2, // Adjust spacing between buttons
                mainAxisSpacing: 2, // Adjust spacing between rows
                childAspectRatio: 1.0, // Ensures buttons are square
              ),
              itemCount: _buttonLabels.length,
              itemBuilder: (context, index) {
                final button = _buttonLabels[index];
                final isOperator = ['/', '*', '-', '+', '=', '⌫'].contains(button);
                return SizedBox(
                  width: buttonSize,
                  height: buttonSize,
                  child: ElevatedButton(
                    onPressed: () {
                      calculation(button);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOperator ? Colors.yellow : Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(0), // Remove additional padding
                    ),
                    child: Center(
                      child: Text(
                        button,
                        style: TextStyle(
                          fontSize: 20, // Adjust font size as needed
                          color: isOperator ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[800],
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        title: Text(
                          history[index],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        trailing: Icon(Icons.history, color: Colors.yellow),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the bottom sheet
                          setState(() {
                            final parts = history[index].split(' = ');
                            if (parts.length == 2) {
                              display = parts[1];
                              expression = parts[1].replaceAll('x', '*').replaceAll('/', '/');
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Button color
                      ),
                      onPressed: () {
                        setState(() {
                          history.clear(); // Clear the history
                        });
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                      child: Text(
                        'Clear All History',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow, // Button color
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _getFontSize(String text) {
    if (text.length > 15) return 40; // Smaller font size for longer text
    if (text.length > 10) return 50; // Medium font size
    return 60; // Larger font size for shorter text
  }

  void calculation(String buttonText) {
  setState(() {
    if (buttonText == null) {
      print('Error: buttonText is null');
      return;
    }

    print('Button Pressed: $buttonText');
    print('Current Display: $display');
    print('Current Expression: $expression');

    if (buttonText == 'AC') {
      display = '0';
      expression = '';
    } else if (buttonText == '+/-') {
      // Toggle the sign of the display value
      if (display != '0') {
        if (display.startsWith('-')) {
          display = display.substring(1);
        } else {
          display = '-' + display;
        }
        expression = display;
      }
    } else if (buttonText == '%') {
      // Calculate percentage based on the current expression
      if (display.isNotEmpty) {
        try {
          double currentValue = double.tryParse(display) ?? 0;
          if (expression.isNotEmpty) {
            final parsedExpression = Expression.parse(expression.replaceAll('x', '*').replaceAll('÷', '/'));
            final evaluator = const ExpressionEvaluator();
            final result = evaluator.eval(parsedExpression, {});
            display = (result * currentValue / 100).toString();
          } else {
            display = (currentValue / 100).toString();
          }
          expression = display;
        } catch (e) {
          display = 'Error';
        }
      }
    } else if (buttonText == '=') {
      // Evaluate the expression
      if (expression.isNotEmpty) {
        try {
          final parsedExpression = Expression.parse(expression.replaceAll('x', '*').replaceAll('÷', '/'));
          final evaluator = const ExpressionEvaluator();
          final result = evaluator.eval(parsedExpression, {});
          display = result.toString();
          history.add('$expression = $display'); // Add to history
          expression = ''; // Clear the expression after evaluation
        } catch (e) {
          display = 'Error';
        }
      }
    } else if (buttonText == '⌫') {
      // Handle backspace
      if (display.length > 1) {
        display = display.substring(0, display.length - 1);
      } else {
        display = '0';
      }
      expression = display;
    } else {
      // Append the button text to the display and expression
      if (display == '0' && buttonText != '.') {
        display = buttonText;
      } else {
        display += buttonText;
      }
      expression += buttonText;
    }

    print('Updated Display: $display');
    print('Updated Expression: $expression');
  });
}

  void _rateUs() async {
    const url = 'https://play.google.com/store/apps/details?id=com.example.app'; // Update with your app's URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
