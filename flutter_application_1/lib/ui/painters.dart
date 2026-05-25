part of '../main.dart';


class FlagScenePainter extends CustomPainter {
  const FlagScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint skyPaint = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[Color(0xFF79CAF5), Color(0xFFC9EFFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);

    canvas.drawRect(rect, skyPaint);

    final Paint sunPaint = Paint()..color = const Color(0xFFFFEE9D);
    canvas.drawCircle(
      Offset(size.width * 0.83, size.height * 0.2),
      size.width * 0.08,
      sunPaint,
    );

    _drawCloud(canvas, Offset(size.width * 0.16, size.height * 0.22), 18);
    _drawCloud(canvas, Offset(size.width * 0.78, size.height * 0.32), 14);

    final Path hillPath = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.56,
        size.width * 0.38,
        size.height * 0.72,
      )
      ..quadraticBezierTo(
        size.width * 0.62,
        size.height * 0.88,
        size.width,
        size.height * 0.58,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final Paint hillPaint = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[Color(0xFFE6F7E7), Color(0xFFB9DEBD)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);

    canvas.drawPath(hillPath, hillPaint);

    final Paint polePaint = Paint()..color = const Color(0xFF7B4A2D);
    final Rect pole = Rect.fromLTWH(
      size.width * 0.28,
      size.height * 0.18,
      size.width * 0.015,
      size.height * 0.58,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(pole, const Radius.circular(8)),
      polePaint,
    );

    final double flagLeft = size.width * 0.294;
    final double flagTop = size.height * 0.24;
    final double flagWidth = size.width * 0.4;
    final double flagHeight = size.height * 0.28;
    final double wave = flagWidth * 0.08;

    final Path flagPath = Path()
      ..moveTo(flagLeft, flagTop)
      ..quadraticBezierTo(
        flagLeft + flagWidth * 0.22,
        flagTop - wave,
        flagLeft + flagWidth * 0.52,
        flagTop + wave * 0.12,
      )
      ..quadraticBezierTo(
        flagLeft + flagWidth * 0.84,
        flagTop + wave,
        flagLeft + flagWidth,
        flagTop - wave * 0.06,
      )
      ..lineTo(flagLeft + flagWidth, flagTop + flagHeight)
      ..quadraticBezierTo(
        flagLeft + flagWidth * 0.84,
        flagTop + flagHeight + wave,
        flagLeft + flagWidth * 0.52,
        flagTop + flagHeight - wave * 0.05,
      )
      ..quadraticBezierTo(
        flagLeft + flagWidth * 0.22,
        flagTop + flagHeight - wave,
        flagLeft,
        flagTop + flagHeight,
      )
      ..close();

    canvas.save();
    canvas.clipPath(flagPath);

    canvas.drawRect(
      Rect.fromLTWH(flagLeft, flagTop, flagWidth, flagHeight / 3),
      Paint()..color = const Color(0xFF1C1C1C),
    );
    canvas.drawRect(
      Rect.fromLTWH(
        flagLeft,
        flagTop + flagHeight / 3,
        flagWidth,
        flagHeight / 3,
      ),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        flagLeft,
        flagTop + (flagHeight / 3) * 2,
        flagWidth,
        flagHeight / 3,
      ),
      Paint()..color = const Color(0xFF13924A),
    );

    canvas.restore();

    final Path triangle = Path()
      ..moveTo(flagLeft, flagTop)
      ..lineTo(flagLeft + flagWidth * 0.34, flagTop + flagHeight / 2)
      ..lineTo(flagLeft, flagTop + flagHeight)
      ..close();
    canvas.drawPath(triangle, Paint()..color = const Color(0xFFD94037));

    canvas.drawPath(
      flagPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xFF143B2F).withValues(alpha: 0.15),
    );
  }

  void _drawCloud(Canvas canvas, Offset center, double radius) {
    final Paint paint = Paint()..color = Colors.white.withValues(alpha: 0.92);
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(
      Offset(center.dx + radius * 0.7, center.dy + 4),
      radius * 0.78,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.7, center.dy + 4),
      radius * 0.68,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

