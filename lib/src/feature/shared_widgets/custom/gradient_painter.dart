import 'dart:ui';

import 'package:flutter/material.dart';

class DesktopGradientPainter() extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(rect);

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomLeft,
        colors: [Color(0x1AD7C9DC), Color(0xB2F5E7FA), Color(0xFFCCE3F8)],
        stops: [0.1, 0.4, 1],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ChatGradientPainter() extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, PlatformDispatcher.instance.views.first.physicalSize.height);
    canvas.clipRect(rect);

    final paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xff35DBFF).withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    canvas.drawCircle(Offset(size.width * 0.066667, size.height * 1.208674), size.width * 0.6746667, paint0Fill);

    final paint1Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xffE6889E).withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    canvas.drawCircle(Offset(size.width * 1.215061, size.height * 1.288674), size.width * 0.9137280, paint1Fill);

    final paint2Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xffAE9FD9).withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    canvas.drawCircle(Offset(size.width * 0.5066667, size.height * 0.7090909), size.width * 0.4746667, paint2Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RateGradientPainter() extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, -216.623, size.width, PlatformDispatcher.instance.views.first.physicalSize.height);
    canvas.clipRect(rect);

    final paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xff35DBFF).withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    canvas.drawCircle(Offset(size.width * -0.2, size.height * -0.3), size.width * 0.9, paint0Fill);

    final paint1Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xffE6889E).withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    canvas.drawCircle(Offset(size.width * 1.5, size.height * -0.2), size.width * 0.9, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CustomClipperWithFullScreen() extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(
      0,
      -PlatformDispatcher.instance.views.first.padding.top,
      size.width,
      PlatformDispatcher.instance.views.first.physicalSize.height,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

class const ChatGradient({required final List<Widget> children, final bool isLargeOrLarger = false, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        CustomPaint(size: size, painter: isLargeOrLarger ? DesktopGradientPainter() : ChatGradientPainter()),
        ...children,
      ],
    );
  }
}

class const RateGradient({required final List<Widget> children, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        CustomPaint(size: size, painter: RateGradientPainter()),
        ...children,
      ],
    );
  }
}
