import 'package:flutter/material.dart';
import 'conversion_selector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expressions/expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  static const Color backgroundColor = Colors.black;
  static const Color buttonColor = Color(0xFF1E1E1E);
  static const Color operatorColor = Colors.yellow;
  static const Color textColor = Colors.white;

  String display = 'WELCOME !';
  String expression = '';
  List<String> history = [];
  bool isWelcomeDisplayed = true;

  final List<String> _buttonLabels = [
    'AC', '+/-', '%', '⌫',
    '7', '8', '9', '÷',
    '4', '5', '6', '×',
    '1', '2', '3', '-',
    '0', '.', '=', '+'
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonSize = screenSize.width / 4;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: Column(
        children: <Widget>[
          _buildDisplay(),
          _buildButtonGrid(buttonSize),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: const Text(
        "Pentaculator",
        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
      ),
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: Image.asset('assets/s.png', width: 24, height: 24),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: [
        IconButton(
          key: ValueKey('history'),
          icon: Image.asset('assets/h.png', width: 24, height: 24),
          onPressed: showHistory,
        ),
        IconButton(
          icon: Image.asset('assets/c.png', width: 24, height: 24),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConversionsSelector()),
            );
          },
        ),
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: backgroundColor),
            child: Center(
              child: Text(
                "Working On ...",
                style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            title: const Text("Standard", style: TextStyle(color: textColor, fontSize: 18)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.yellow),
            title: Text("Rate Us", style: TextStyle(color: textColor, fontSize: 18)),
            onTap: _rateUs,
          ),
        ],
      ),
    );
  }

  Container _buildDisplay() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Text(
        display,
        style: TextStyle(color: textColor, fontSize: _getFontSize(display)),
        textAlign: TextAlign.right,
      ),
    );
  }

  Expanded _buildButtonGrid(double buttonSize) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: _buttonLabels.length,
        itemBuilder: (context, index) {
          final button = _buttonLabels[index];
          final isOperator = ['÷', '×', '-', '+', '=', '⌫'].contains(button);
          return SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: ElevatedButton(
              onPressed: () => calculation(button),
              style: ElevatedButton.styleFrom(
                backgroundColor: isOperator ? operatorColor : buttonColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.all(0),
              ),
              child: Center(
                child: Text(
                  button,
                  style: TextStyle(fontSize: 20, color: isOperator ? Colors.black : textColor),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double _getFontSize(String text) {
    if (text.length > 15) return 40;
    if (text.length > 10) return 50;
    return 60;
  }

  void calculation(String buttonText) {
    setState(() {
      if (isWelcomeDisplayed) {
        display = ''; // Clear welcome message
        isWelcomeDisplayed = false; // Update the flag
      }

      if (display == 'Error') {
        if (buttonText == '⌫') {
          display = '0';
          expression = '';
        } else if (buttonText != 'AC') {
          display = buttonText;
          expression = buttonText;
        } else {
          display = '0';
          expression = '';
        }
        return;
      }

      switch (buttonText) {
        case 'AC':
          display = '0';
          expression = '';
          break;
        case '⌫':
          display = display.length > 1 ? display.substring(0, display.length - 1) : '0';
          expression = display;
          break;
        case '+/-':
          if (display != '0') {
            display = display.startsWith('-') ? display.substring(1) : '-' + display;
          }
          break;
        case '%':
          if (display.isNotEmpty) {
            display = (double.tryParse(display) ?? 0 / 100).toString();
          }
          break;
        case '=':
          _evaluateExpression();
          break;
        default:
          if (display == '0' && buttonText != '.') {
            display = buttonText;
          } else {
            display += buttonText;
          }
          expression += buttonText;
      }
    });
  }

  void _evaluateExpression() {
    if (expression.isNotEmpty) {
      try {
        final parsedExpression = Expression.parse(expression
            .replaceAll('×', '*')
            .replaceAll('÷', '/'));
        final evaluator = const ExpressionEvaluator();
        final result = evaluator.eval(parsedExpression, {});
        display = result.toString();
        history.add('$expression = $display'); // Save to history
        expression = '';
      } catch (e) {
        display = 'Error';
        expression = '';
      }
    }
  }

  void showHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: _buildHistoryList(),
        );
      },
    );
  }

  Widget _buildHistoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
              textAlign: TextAlign.center,
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
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                  trailing: Icon(Icons.history, color: operatorColor),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      final parts = history[index].split(' = ');
                      if (parts.length == 2) {
                        display = parts[1];
                        expression = parts[1].replaceAll('×', '*').replaceAll('÷', '/');
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
        _buildHistoryActions(),
      ],
    );
  }

  Widget _buildHistoryActions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (history.isNotEmpty)
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  history.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text('Clear All History', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: operatorColor),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ],
      ),
    );
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
