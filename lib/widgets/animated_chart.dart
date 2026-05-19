import 'package:flutter/material.dart';

class AnimatedChart extends StatefulWidget {
  final List<double> income;
  final List<double> expense;
  const AnimatedChart({super.key, required this.income, required this.expense});

  @override
  State<AnimatedChart> createState() => _AnimatedChartState();
}

class _AnimatedChartState extends State<AnimatedChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 160),
          painter: _ChartPainter(widget.income, widget.expense, _ctrl.value),
        );
      },
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> income;
  final List<double> expense;
  final double t;
  _ChartPainter(this.income, this.expense, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paintInc = Paint()
      ..color = Colors.green.withAlpha((0.8 * 255).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final paintExp = Paint()
      ..color = Colors.red.withAlpha((0.8 * 255).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final maxVal = [0.0, ...income, ...expense].reduce((a, b) => a > b ? a : b);
    if (maxVal <= 0) return;

    final step = size.width / (income.length - 1).clamp(1, double.infinity);
    Path pInc = Path();
    Path pExp = Path();
    for (int i = 0; i < income.length; i++) {
      final dx = step * i;
      final dyInc = size.height - (income[i] / maxVal) * size.height * t;
      final dyExp = size.height - (expense[i] / maxVal) * size.height * t;
      if (i == 0) {
        pInc.moveTo(dx, dyInc);
        pExp.moveTo(dx, dyExp);
      } else {
        pInc.lineTo(dx, dyInc);
        pExp.lineTo(dx, dyExp);
      }
    }
    canvas.drawPath(pInc, paintInc);
    canvas.drawPath(pExp, paintExp);
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) =>
      old.t != t || old.income != income || old.expense != expense;
}
