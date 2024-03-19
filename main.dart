import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false, // Remove debug label from AppBar
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => CalculateScreen()),
        GetPage(name: '/info', page: () => InfoScreen()),
      ],
    );
  }
}

class CalculateScreen extends StatelessWidget {
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black), // Add border decoration
          borderRadius: BorderRadius.circular(20),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('BMI Calculator'),
            backgroundColor: const Color(0xFFE53935),
            centerTitle: true,
            toolbarHeight: 25,
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: TextField(
                          controller: heightController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Height (cm)'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: TextField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Weight (kg)'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    double height = double.tryParse(heightController.text) ?? 0;
                    double weight = double.tryParse(weightController.text) ?? 0;
                    double bmi = weight / ((height / 100) * (height / 100));
                    Get.toNamed('/info', arguments: bmi);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red), // Set button background color to red
                  ),
                  child: const Text('Calculate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double bmi = Get.arguments ?? 0;
    String category = _getCategory(bmi);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black), // Add border decoration
          borderRadius: BorderRadius.circular(20),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('BMI Information'),
            backgroundColor: const Color(0xFFE53935),
            centerTitle: true,
            toolbarHeight: 25,
          ),
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your BMI: ${bmi.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                Text(
                  'Category: $category',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                BMIWidget(bmi: bmi),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi >= 24.9 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }
}

class BMIWidget extends StatelessWidget {
  final double bmi;

  const BMIWidget({required this.bmi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: BMIMeterPainter(bmi: bmi),
      ),
    );
  }
}

class BMIMeterPainter extends CustomPainter {
  final double bmi;

  BMIMeterPainter({required this.bmi});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = _getColor()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = min(centerX, centerY);

    canvas.drawCircle(Offset(centerX, centerY), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Color _getColor() {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return Colors.green;
    } else if (bmi >= 24.9 && bmi < 29.9) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
