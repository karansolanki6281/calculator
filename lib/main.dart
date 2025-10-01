import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _display = '0';
  String _equation = '';
  bool _shouldResetDisplay = false;

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _display = '0';
        _equation = '';
        _shouldResetDisplay = false;
      } else if (buttonText == '=') {
        try {
          _equation += _display;
          _display = _evaluateExpression(_equation);
          _equation = '';
          _shouldResetDisplay = true;
        } catch (e) {
          _display = 'Error';
          _equation = '';
          _shouldResetDisplay = true;
        }
      } else if (buttonText == '%') {
        try {
          double value = double.parse(_display);
          _display = (value / 100).toString();
          _shouldResetDisplay = true;
        } catch (e) {
          _display = 'Error';
        }
      } else if (['+', '-', '×', '÷'].contains(buttonText)) {
        _equation += _display + buttonText;
        _shouldResetDisplay = true;
      } else if (buttonText == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
      } else if (buttonText == '.') {
        if (!_display.contains('.')) {
          _display += '.';
        }
      } else {
        if (_shouldResetDisplay || _display == '0') {
          _display = buttonText;
          _shouldResetDisplay = false;
        } else {
          _display += buttonText;
        }
      }
    });
  }

  String _evaluateExpression(String expression) {
    try {
      // Replace symbols with operators
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      
      // Handle multiple operations by evaluating in order of precedence
      // First handle multiplication and division
      while (expression.contains('*') || expression.contains('/')) {
        // Find first * or /
        int mulIndex = expression.indexOf('*');
        int divIndex = expression.indexOf('/');
        
        if (mulIndex != -1 && (divIndex == -1 || mulIndex < divIndex)) {
          // Handle multiplication
          expression = _evaluateSingleOperation(expression, '*');
        } else if (divIndex != -1) {
          // Handle division
          expression = _evaluateSingleOperation(expression, '/');
        }
      }
      
      // Then handle addition and subtraction
      while (expression.contains('+') || (expression.contains('-') && expression.indexOf('-') > 0)) {
        // Find first + or - (but not at start for negative numbers)
        int addIndex = expression.indexOf('+');
        int subIndex = expression.indexOf('-', 1);
        
        if (addIndex != -1 && (subIndex == -1 || addIndex < subIndex)) {
          // Handle addition
          expression = _evaluateSingleOperation(expression, '+');
        } else if (subIndex != -1) {
          // Handle subtraction
          expression = _evaluateSingleOperation(expression, '-');
        }
      }
      
      return expression;
    } catch (e) {
      throw Exception('Invalid expression');
    }
  }

  String _evaluateSingleOperation(String expression, String operator) {
    int opIndex = expression.indexOf(operator);
    if (opIndex == -1) return expression;
    
    // Find left operand
    int leftStart = opIndex - 1;
    while (leftStart >= 0 && (expression[leftStart].contains(RegExp(r'[0-9.]')) || 
           (expression[leftStart] == '-' && leftStart == 0))) {
      leftStart--;
    }
    leftStart++;
    
    // Find right operand
    int rightEnd = opIndex + 1;
    while (rightEnd < expression.length && 
           (expression[rightEnd].contains(RegExp(r'[0-9.]')) || 
            (expression[rightEnd] == '-' && rightEnd == opIndex + 1))) {
      rightEnd++;
    }
    
    double left = double.parse(expression.substring(leftStart, opIndex));
    double right = double.parse(expression.substring(opIndex + 1, rightEnd));
    
    double result;
    switch (operator) {
      case '*':
        result = left * right;
        break;
      case '/':
        if (right == 0) throw Exception('Division by zero');
        result = left / right;
        break;
      case '+':
        result = left + right;
        break;
      case '-':
        result = left - right;
        break;
      default:
        throw Exception('Unknown operator');
    }
    
    return expression.substring(0, leftStart) + 
           result.toString() + 
           expression.substring(rightEnd);
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[800],
            foregroundColor: textColor ?? Colors.white,
            padding: EdgeInsets.all(30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.blue[200],
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _equation,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _display,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            
            // Buttons
            Row(
              children: [
                _buildButton('C', color: Colors.red[400]),
                _buildButton('⌫', color: Colors.orange[400]),
                _buildButton('%', color: Colors.orange[400]),
                _buildButton('÷', color: Colors.orange[400]),
              ],
            ),
            Row(
              children: [
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('×', color: Colors.orange[400]),
              ],
            ),
            Row(
              children: [
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('-', color: Colors.orange[400]),
              ],
            ),
            Row(
              children: [
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('+', color: Colors.orange[400]),
              ],
            ),
            Row(
              children: [
                _buildButton('0', color: Colors.grey[700]),
                _buildButton('.'),
                _buildButton('=', color: Colors.blue[400]),
                _buildButton('00', color: Colors.grey[800]), // Placeholder button to maintain 4-column layout
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
