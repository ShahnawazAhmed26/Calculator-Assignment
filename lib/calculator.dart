import 'package:chrono_calc/Calcualtorlogo.dart';
import 'package:chrono_calc/conversion_selector.dart';
import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _ModernCalculatorState();
}

class _ModernCalculatorState extends State<Calculator> {
static const Color backgroundColor = Colors.black;
static const Color glassColor = Color(0xFF222222);
static const Color accentColor = Color(0xFFFFD600); // Bright yellow
static const Color operatorColor = Color(0xFF333333);
static const Color actionColor = Color(0xFF444444);
static const Color textColor = Colors.white;  

  bool isScientificMode = false;
  String display = '0';
  String preview = '';
  String lastValidResult = '0';
  final TextEditingController _displayController = TextEditingController();
  final List<String> operators = ['+', '-', '×', '÷', '^'];
  final List<String> history = [];
  double memory = 0;

  @override
  void initState() {
    super.initState();
    _displayController.text = display;
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final isPortrait = size.height > size.width;
  final buttonHeight = isPortrait ? size.height * 0.09 : size.height * 0.15;
  final buttonFont = isPortrait ? 22.0 : 18.0;

  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF232526), Color(0xFF414345)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
                  leading: const CalculatorLogo(), // <-- Add this line

        title: Text(
          'Chrono Calculator',
          style: GoogleFonts.poppins(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),

        actions: [
          
          IconButton(
            icon: Icon(Icons.history, color: accentColor),
            onPressed: _showHistory,
          ),
          IconButton(
            icon: Icon(Icons.store_mall_directory , color: accentColor,),
           onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ConverterSelectionScreen(),
    ),
  );
},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Use a fixed height for display
            SizedBox(
              height: isPortrait ? size.height * 0.18 : size.height * 0.25,
              child: _buildDisplay(),
            ),
            _buildPreviewDisplay(),
            const SizedBox(height: 10),
            // Use Flexible for the button grid
            Flexible(
              child: _buildButtonGrid(buttonHeight, buttonFont),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget _buildDisplay() {
  return Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    decoration: BoxDecoration(
      color: glassColor,
      borderRadius: BorderRadius.circular(32),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
      border: Border.all(color: accentColor.withOpacity(0.2), width: 1.5),
    ),
    child: SelectableText(
      display,
      style: GoogleFonts.jetBrainsMono(
        color: textColor,
        fontSize: _getDisplayFontSize(),
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.right,
      maxLines: 1,
      showCursor: true,
      cursorColor: accentColor,
      toolbarOptions: const ToolbarOptions(
        copy: true,
        selectAll: true,
      ),
    ),
  );
}

  Widget _buildPreviewDisplay() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 5),
      child: Text(
        preview,
        style: GoogleFonts.jetBrainsMono(
          color: accentColor.withOpacity(0.7),
          fontSize: 24,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  double _getDisplayFontSize() {
    if (display.length < 10) {
      return 54;
    } else if (display.length < 20) {
      return 38;
    } else {
      return 26;
    }
  }

  Widget _buildButtonGrid(double buttonHeight, double buttonFont) {
  final List<String> buttonLabels = [
    'MC', 'MR', 'M+', 'M-',
    '(', ')', 'AC', '⌫',
    '7', '8', '9', '÷',
    '4', '5', '6', '×',
    '1', '2', '3', '-',
    '0', '.', '=', '+'
  ];

  if (isScientificMode) {
    buttonLabels.addAll([
      'sin', 'cos', 'tan', 'ln', 'log', '√', '^', '!', 'π', 'e', 'exp', 'abs'
    ]);
  }

  int crossAxisCount = 4;
  int rowCount = (buttonLabels.length / crossAxisCount).ceil();

  return Center(
    child: SizedBox(
      width: 400, // max width for large screens
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: List.generate(buttonLabels.length, (index) {
          final button = buttonLabels[index];
          final isOperator = operators.contains(button);
          final isAction = [
            'AC', '⌫', '+/-', '%', 'MC', 'MR', 'M+', 'M-', '(', ')'
          ].contains(button);
          final isScientific = [
            'sin', 'cos', 'tan', 'ln', 'log', '√', '^', '!', 'π', 'e', 'exp', 'abs'
          ].contains(button);

          return SizedBox(
            height: buttonHeight,
            child: GestureDetector(
              onTap: () => _handleInput(button),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 90),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isScientific
                      ? accentColor.withOpacity(0.18)
                      : isOperator
                          ? operatorColor
                          : isAction
                              ? actionColor
                              : glassColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: isOperator || isScientific
                        ? accentColor.withOpacity(0.4)
                        : Colors.transparent,
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: Text(
                    button,
                    style: GoogleFonts.poppins(
                      fontSize: buttonFont,
                      color: isOperator || isScientific
                          ? accentColor
                          : textColor,
                      fontWeight: isOperator || isScientific
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ),
  );
}


  void _handleInput(String buttonText) {
    setState(() {
      switch (buttonText) {
        case 'AC':
          display = '0';
          preview = '';
          lastValidResult = '0';
          break;
        case '⌫':
          display = display.length > 1 ? display.substring(0, display.length - 1) : '0';
          break;
        case '+/-':
          display = display.startsWith('-') ? display.substring(1) : '-$display';
          break;
        case '=':
          String result = _evaluateExpression(display);
          preview = '';
          lastValidResult = result;
          history.add('$display = $result');
          display = result;
          break;
        case 'MC':
          memory = 0;
          break;
        case 'MR':
          display = memory.toString();
          break;
        case 'M+':
          memory += double.tryParse(display) ?? 0;
          break;
        case 'M-':
          memory -= double.tryParse(display) ?? 0;
          break;
        case '(':
        case ')':
          if (display == '0') {
            display = buttonText;
          } else {
            display += buttonText;
          }
          break;
        default:
          if (isScientificMode && [
            'sin', 'cos', 'tan', 'ln', 'log', '√', '^', '!', 'π', 'e', 'exp', 'abs'
          ].contains(buttonText)) {
            display = _handleScientificInput(buttonText, display);
          } else {
            if (display == '0' && !operators.contains(buttonText)) {
              display = buttonText;
            } else if (operators.contains(display[display.length - 1]) && operators.contains(buttonText)) {
              return;
            } else {
              display += buttonText;
            }
            if (!_isInvalidPreview(display)) {
              preview = _evaluatePreview(display);
            }
          }
      }
      _displayController.text = display;
    });
  }
String _handleScientificInput(String buttonText, String display) {
  switch (buttonText) {
    case 'sin':
    case 'cos':
    case 'tan':
    case 'ln':
    case 'log':
    case '√':
    case 'exp':
    case 'abs':
      if (display == '0') {
        return '$buttonText(';
      } else {
        return '$display$buttonText(';
      }
    case '^':
      return display == '0' ? '^' : '$display^';
    case '!':
      return display == '0' ? '!' : '$display!';
    case 'π':
      return display == '0' ? 'π' : '$display' + 'π';
    case 'e':
      return display == '0' ? 'e' : '$display' + 'e';
    default:
      return display;
  }
}

  int _factorial(int n) {
    if (n < 0) return 0;
    if (n == 0 || n == 1) return 1;
    return n * _factorial(n - 1);
  }

  bool _isInvalidPreview(String exp) {
    return exp.endsWith('.') || exp.endsWith('%') || operators.contains(exp[exp.length - 1]);
  }

  String _evaluatePreview(String exp) {
    exp = _normalizeExpression(exp);
    try {
      final expression = Expression.parse(exp);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expression, {});
      return result % 1 == 0 ? result.toStringAsFixed(0) : result.toString();
    } catch (e) {
      return '';
    }
  }

  String _evaluateExpression(String exp) {
    exp = _normalizeExpression(exp);
    try {
      final expression = Expression.parse(exp);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expression, {});
      return result % 1 == 0 ? result.toStringAsFixed(0) : result.toString();
    } catch (e) {
      return 'ERROR';
    }
  }

  String _normalizeExpression(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
    expression = expression.replaceAll('π', pi.toString());
    expression = expression.replaceAll('e', e.toString());
    return expression;
  }

  void _toggleScientificMode() {
    setState(() {
      isScientificMode = !isScientificMode;
    });
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: glassColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'History',
                  style: GoogleFonts.poppins(color: accentColor, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear, color: accentColor),
                  onPressed: () {
                    setState(() => history.clear());
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: history.isEmpty
                    ? Center(
                        child: Text(
                          'No history yet.',
                          style: GoogleFonts.poppins(color: textColor.withOpacity(0.6)),
                        ),
                      )
                    : ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              history[index],
                              style: GoogleFonts.jetBrainsMono(color: textColor),
                            ),
                            onTap: () {
                              setState(() {
                                display = history[index].split(' = ')[0];
                                preview = '';
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}