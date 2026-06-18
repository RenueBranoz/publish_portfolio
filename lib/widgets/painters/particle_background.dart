import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/pointer_provider.dart';

/// A single particle with position, velocity, and radius.
class _Particle {
  Offset position;
  Offset velocity;
  double radius;
  double opacity;

  _Particle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.opacity,
  });
}

/// Animated particle field used as the hero/global background.
/// Upgraded for high-visibility nodes, thick global network lines, and crash protection.
class ParticleBackground extends ConsumerStatefulWidget {
  final int particleCount;
  final double maxConnectionDistance;
  final bool isDark;

  const ParticleBackground({
    super.key,
    this.particleCount = 75,
    this.maxConnectionDistance = 150,
    this.isDark = true,
  });

  @override
  ConsumerState<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends ConsumerState<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _rand = Random();
  Size _lastSize = Size.zero;

  // Interactive Radar System variables
  Offset _clickRipplePosition = const Offset(-500, -500);
  double _rippleRadius = 0.0;
  double _rippleOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(days: 1))
          ..addListener(_tick)
          ..repeat();
  }

  void _ensureParticles(Size size) {
    if (_particles.isNotEmpty && _lastSize == size) return;
    _lastSize = size;
    _particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(_Particle(
        position: Offset(
            _rand.nextDouble() * size.width, _rand.nextDouble() * size.height),
        velocity: Offset((_rand.nextDouble() - 0.5) * 0.45,
            (_rand.nextDouble() - 0.5) * 0.45),
        radius: 3.5 + _rand.nextDouble() * 3.0,
        opacity: 0.4 + _rand.nextDouble() * 0.5,
      ));
    }
  }

  void _tick() {
    if (_lastSize == Size.zero) return;

    if (_rippleOpacity > 0.0) {
      _rippleRadius += 6.5;
      _rippleOpacity -= 0.015;
      if (_rippleOpacity < 0.0) _rippleOpacity = 0.0;
    }

    for (final p in _particles) {
      p.position += p.velocity;
      if (p.position.dx < 0 || p.position.dx > _lastSize.width)
        p.velocity = Offset(-p.velocity.dx, p.velocity.dy);
      if (p.position.dy < 0 || p.position.dy > _lastSize.height)
        p.velocity = Offset(p.velocity.dx, -p.velocity.dy);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mousePos = ref.watch(pointerPositionProvider);

    // FIX: If the mouse position is null (initial load), drop a safe off-screen fallback point
    final safeMousePos = mousePos ?? const Offset(-1000, -1000);

    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _clickRipplePosition = details.localPosition;
          _rippleRadius = 0.0;
          _rippleOpacity = 0.65;
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _ensureParticles(size);
          return CustomPaint(
            size: size,
            painter: _ParticlePainter(
              particles: _particles,
              maxConnectionDistance: widget.maxConnectionDistance,
              isDark: widget.isDark,
              mousePosition: safeMousePos, // Pass crash-proofed variable
              ripplePos: _clickRipplePosition,
              rippleRadius: _rippleRadius,
              rippleOpacity: _rippleOpacity,
            ),
          );
        },
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double maxConnectionDistance;
  final bool isDark;
  final Offset mousePosition;
  final Offset ripplePos;
  final double rippleRadius;
  final double rippleOpacity;

  _ParticlePainter({
    required this.particles,
    required this.maxConnectionDistance,
    required this.isDark,
    required this.mousePosition,
    required this.ripplePos,
    required this.rippleRadius,
    required this.rippleOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Color dotColor = isDark ? AppColors.cyberBlue : AppColors.cyberPurple;
    final Color lineColor =
        isDark ? AppColors.cyberBlue : AppColors.cyberPurple;

    canvas.drawRect(Offset.zero & size,
        Paint()..color = isDark ? AppColors.bgDarkest : AppColors.bgLight);

    // CRT Display Terminal Scanlines
    final scanlinePaint = Paint()
      ..color = AppColors.textWhite.withOpacity(isDark ? 0.015 : 0.03)
      ..strokeWidth = 1.0;
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanlinePaint);
    }

    final linePaint = Paint()..style = PaintingStyle.stroke;

    // 1. Draw Network Mesh Interconnection Arrays
    for (int i = 0; i < particles.length; i++) {
      final posA = particles[i].position;

      final mouseDistance = (mousePosition - posA).distance;
      if (mouseDistance < 190) {
        linePaint.strokeWidth = 2.0;
        linePaint.color = AppColors.cyberGreen.withOpacity(
            (1.0 - (mouseDistance / 190)) * (isDark ? 0.55 : 0.35));
        canvas.drawLine(mousePosition, posA, linePaint);
      }

      double rippleBonusFade = 0.0;
      if (rippleOpacity > 0.0) {
        final distToRipple = (posA - ripplePos).distance;
        if ((distToRipple - rippleRadius).abs() < 40) {
          rippleBonusFade = (1.0 - ((distToRipple - rippleRadius).abs() / 40)) *
              rippleOpacity;
        }
      }

      for (int j = i + 1; j < particles.length; j++) {
        final posB = particles[j].position;
        final dist = (posA - posB).distance;
        if (dist < maxConnectionDistance) {
          final fade = 1 - (dist / maxConnectionDistance);
          linePaint.strokeWidth = rippleBonusFade > 0 ? 2.4 : 1.8;

          linePaint.color = rippleBonusFade > 0
              ? AppColors.cyberGreen.withOpacity(rippleBonusFade)
              : lineColor.withOpacity(fade * 0.30);

          canvas.drawLine(posA, posB, linePaint);
        }
      }
    }

    // Render Radar Discovery Scan Ring Frame
    if (rippleOpacity > 0.0) {
      canvas.drawCircle(
        ripplePos,
        rippleRadius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0
          ..color = AppColors.cyberGreen.withOpacity(rippleOpacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }

    // 2. High-Visibility Glowing Circle Node Map
    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      final mouseDistance = (mousePosition - p.position).distance;
      final bool isNearCursor = mouseDistance < 130;

      final double distToRipple = (p.position - ripplePos).distance;
      final bool isHitByRipple =
          rippleOpacity > 0.0 && (distToRipple - rippleRadius).abs() < 40;

      double computedRadius = isNearCursor ? (p.radius * 1.5) : p.radius;
      if (isHitByRipple) computedRadius *= 1.3;

      dotPaint.color = isHitByRipple
          ? AppColors.cyberGreen.withOpacity(0.9)
          : isNearCursor
              ? AppColors.cyberGreen.withOpacity(isDark ? 0.85 : 0.6)
              : dotColor.withOpacity(p.opacity * 0.7);

      canvas.drawCircle(
        p.position,
        computedRadius + 3,
        Paint()
          ..color = dotPaint.color.withOpacity(0.22)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      canvas.drawCircle(p.position, computedRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
