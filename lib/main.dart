import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sara Flower',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: FlowerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FlowerScreen extends StatefulWidget {
  @override
  _FlowerScreenState createState() => _FlowerScreenState();
}

class _FlowerScreenState extends State<FlowerScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              size: Size(400, 600),
              painter: FlowerPainter(_animation.value),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _animationController.reset();
          _animationController.forward();
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class FlowerPainter extends CustomPainter {
  final double animationValue;

  FlowerPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 40);
    
    // Draw flower petals
    if (animationValue > 0.2) {
      _drawFlowerPetals(canvas, center, (animationValue - 0.2) / 0.8);
    }
    
    // Draw flower center
    if (animationValue > 0.6) {
      _drawFlowerCenter(canvas, center, (animationValue - 0.6) / 0.4);
    }
    
    // Draw letters
    if (animationValue > 0.8) {
      _drawLetters(canvas, size, (animationValue - 0.8) / 0.2);
    }
  }

  void _drawFlowerPetals(Canvas canvas, Offset center, double progress) {
    final paint = Paint()
      ..color = Color(0xFFFFA216)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final totalPetals = (16 * progress).round();
    
    for (int i = 0; i < totalPetals; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      
      for (int j = 0; j < 18; j++) {
        final radius = 150.0 - j * 6;
        
        // First arc
        final rect1 = Rect.fromCircle(center: Offset.zero, radius: radius);
        canvas.drawArc(rect1, 0, math.pi / 2, false, paint);
        
        // Second arc
        canvas.translate(0, -radius);
        final rect2 = Rect.fromCircle(center: Offset.zero, radius: radius);
        canvas.drawArc(rect2, math.pi / 2, math.pi / 2, false, paint);
        canvas.translate(0, radius);
      }
      
      // Rotate for next petal
      canvas.rotate(24 * math.pi / 180);
      canvas.restore();
    }
  }

  void _drawFlowerCenter(Canvas canvas, Offset center, double progress) {
    final paint = Paint()
      ..color = Color(0xFF884513)
      ..style = PaintingStyle.fill;

    final goldenAngle = 137.508 * math.pi / 180;
    final totalSeeds = (140 * progress).round();

    for (int i = 0; i < totalSeeds; i++) {
      final r = 4 * math.sqrt(i.toDouble());
      final theta = i * goldenAngle;
      final x = r * math.cos(theta);
      final y = r * math.sin(theta);
      
      canvas.drawCircle(
        Offset(center.dx + x, center.dy + y),
        2.0,
        paint,
      );
    }
  }

  void _drawLetters(Canvas canvas, Size size, double progress) {
    if (progress == 0) return;
    
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final baseY = size.height - 150;
    final spacing = 60.0;
    
    // Draw S
    _drawS(canvas, size.width / 2 - spacing * 1.5, baseY, paint, progress);
    // Draw A
    _drawA(canvas, size.width / 2 - spacing * 0.5, baseY, paint, progress);
    // Draw R
    _drawR(canvas, size.width / 2 + spacing * 0.5, baseY, paint, progress);
    // Draw A
    _drawA(canvas, size.width / 2 + spacing * 1.5, baseY, paint, progress);
  }

  void _drawS(Canvas canvas, double x, double y, Paint paint, double progress) {
    final points = [
      Offset(x, y), Offset(x + 5, y), Offset(x + 10, y), Offset(x + 15, y),
      Offset(x, y - 5), Offset(x, y - 10), Offset(x, y - 15),
      Offset(x + 5, y - 15), Offset(x + 10, y - 15), Offset(x + 15, y - 15),
      Offset(x + 20, y - 20), Offset(x + 20, y - 25),
      Offset(x, y - 30), Offset(x + 5, y - 30), Offset(x + 10, y - 30), Offset(x + 15, y - 30)
    ];
    
    final visiblePoints = (points.length * progress).round();
    for (int i = 0; i < visiblePoints; i++) {
      canvas.drawCircle(points[i], 3, paint);
    }
  }

  void _drawA(Canvas canvas, double x, double y, Paint paint, double progress) {
    final points = [
      Offset(x - 6, y), Offset(x - 12, y), Offset(x - 18, y),
      Offset(x, y - 6), Offset(x, y - 12), Offset(x, y - 18), Offset(x, y - 24), Offset(x, y - 30),
      Offset(x - 24, y - 6), Offset(x - 24, y - 12), Offset(x - 24, y - 18), Offset(x - 24, y - 24), Offset(x - 24, y - 30),
      Offset(x - 6, y - 18), Offset(x - 12, y - 18), Offset(x - 18, y - 18)
    ];
    
    final visiblePoints = (points.length * progress).round();
    for (int i = 0; i < visiblePoints; i++) {
      canvas.drawCircle(points[i], 3, paint);
    }
  }

  void _drawR(Canvas canvas, double x, double y, Paint paint, double progress) {
    final points = [
      Offset(x, y), Offset(x, y + 6), Offset(x, y + 12), Offset(x, y + 18), Offset(x, y + 24), Offset(x, y + 30),
      Offset(x + 6, y + 30), Offset(x + 12, y + 30), Offset(x + 18, y + 20), Offset(x + 18, y + 25),
      Offset(x + 12, y + 15), Offset(x + 6, y + 15), Offset(x + 6, y + 10), Offset(x + 12, y + 6), Offset(x + 18, y + 2)
    ];
    
    final visiblePoints = (points.length * progress).round();
    for (int i = 0; i < visiblePoints; i++) {
      canvas.drawCircle(points[i], 3, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}