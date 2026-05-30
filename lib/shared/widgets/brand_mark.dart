import 'package:flutter/material.dart';
import 'package:saber_cristao/app/theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.size = 96,
    this.showBackground = true,
  });

  final double size;
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    final mark = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BrandMarkPainter(),
      ),
    );

    if (!showBackground) return mark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        gradient: const LinearGradient(
          colors: [AppTheme.darkBrown, AppTheme.primaryBrown],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: mark,
    );
  }
}

class _BrandMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final leftBook = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.16, h * 0.28, w * 0.34, h * 0.46),
      Radius.circular(w * 0.06),
    );
    final rightBook = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.50, h * 0.28, w * 0.34, h * 0.46),
      Radius.circular(w * 0.06),
    );

    final bookBorder = Paint()
      ..color = AppTheme.textDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.018;
    final leftFill = Paint()..color = AppTheme.parchment;
    final rightFill = Paint()..color = AppTheme.cream;
    final linePaint = Paint()
      ..color = const Color(0xFFB79A7A)
      ..strokeWidth = w * 0.01
      ..strokeCap = StrokeCap.round;
    final spinePaint = Paint()
      ..color = AppTheme.secondaryBrown
      ..strokeWidth = w * 0.02;

    canvas.drawRRect(leftBook, leftFill);
    canvas.drawRRect(rightBook, rightFill);
    canvas.drawRRect(leftBook, bookBorder);
    canvas.drawRRect(rightBook, bookBorder);
    canvas.drawLine(Offset(w * 0.50, h * 0.30), Offset(w * 0.50, h * 0.72), spinePaint);

    for (var i = 0; i < 5; i++) {
      final y = h * (0.38 + (i * 0.08));
      canvas.drawLine(Offset(w * 0.21, y), Offset(w * 0.44, y), linePaint);
      canvas.drawLine(Offset(w * 0.56, y), Offset(w * 0.79, y), linePaint);
    }

    final ring = Paint()
      ..color = AppTheme.softGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08;
    final ringCenter = Offset(w * 0.50, h * 0.50);
    final ringRadius = w * 0.18;
    canvas.drawCircle(ringCenter, ringRadius, ring);

    final handle = Paint()
      ..color = AppTheme.softGold
      ..strokeWidth = w * 0.095
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.62, h * 0.62), Offset(w * 0.74, h * 0.74), handle);

    final ribbon = Paint()..color = AppTheme.gold;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.48, h * 0.69, w * 0.04, h * 0.10),
        Radius.circular(w * 0.01),
      ),
      ribbon,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
