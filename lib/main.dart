import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'コンクリートお絵かき',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'コンクリートお絵かき'),
    );
  }
}

class MyHomePage extends HookWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // 描画ポイントを保存するためのState
    final points = useState<List<Offset>>([]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          // ドラッグ時に点を追加
          points.value = [...points.value, details.localPosition];
        },
        onPanStart: (details) {
          // 描き始めの点を追加
          points.value = [...points.value, details.localPosition];
        },
        child: CustomPaint(
          painter: DrawingPainter(points: points.value),
          size: Size.infinite,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // クリアボタン
          points.value = [];
        },
        tooltip: 'Clear',
        child: const Icon(Icons.clear),
      ),
    );
  }
}

// カスタムペインターの実装
class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
