import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A node in the network topology graphic, representing a router,
/// switch, server, or endpoint device.
class TopologyNode {
  final Offset relativePosition; // 0..1 normalized within canvas
  final String label;
  final IconData icon;

  const TopologyNode({
    required this.relativePosition,
    required this.label,
    required this.icon,
  });
}

/// Decorative interactive network topology diagram: nodes connected by
/// animated "data pulse" lines, used in the hero/about background to
/// reinforce the networking theme explicitly (separate from the more
/// generic ParticleBackground).
class NetworkTopologyPainter extends StatefulWidget {
  final List<TopologyNode> nodes;
  final List<List<int>> edges; // pairs of node indices to connect

  const NetworkTopologyPainter({
    super.key,
    required this.nodes,
    required this.edges,
  });

  /// A sensible default topology resembling a small enterprise network:
  /// core router -> switches -> endpoints.
  factory NetworkTopologyPainter.defaultTopology() {
    const nodes = [
      TopologyNode(
          relativePosition: Offset(0.5, 0.12),
          label: 'Core Router',
          icon: Icons.router),
      TopologyNode(
          relativePosition: Offset(0.25, 0.42),
          label: 'Switch A',
          icon: Icons.hub),
      TopologyNode(
          relativePosition: Offset(0.75, 0.42),
          label: 'Switch B',
          icon: Icons.hub),
      TopologyNode(
          relativePosition: Offset(0.12, 0.78),
          label: 'Server',
          icon: Icons.dns),
      TopologyNode(
          relativePosition: Offset(0.38, 0.85),
          label: 'Workstation',
          icon: Icons.computer),
      TopologyNode(
          relativePosition: Offset(0.62, 0.85),
          label: 'Firewall',
          icon: Icons.security),
      TopologyNode(
          relativePosition: Offset(0.88, 0.78),
          label: 'Cloud',
          icon: Icons.cloud),
    ];
    const edges = [
      [0, 1],
      [0, 2],
      [1, 3],
      [1, 4],
      [2, 5],
      [2, 6],
    ];
    return const NetworkTopologyPainter(nodes: nodes, edges: edges);
  }

  @override
  State<NetworkTopologyPainter> createState() => _NetworkTopologyPainterState();
}

class _NetworkTopologyPainterState extends State<NetworkTopologyPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            return Stack(
              children: [
                CustomPaint(
                  size: size,
                  painter: _TopologyLinePainter(
                    nodes: widget.nodes,
                    edges: widget.edges,
                    pulseT: _controller.value,
                  ),
                ),
                for (final node in widget.nodes)
                  Positioned(
                    left: node.relativePosition.dx * size.width - 22,
                    top: node.relativePosition.dy * size.height - 22,
                    child: _NodeIcon(node: node),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _NodeIcon extends StatelessWidget {
  final TopologyNode node;
  const _NodeIcon({required this.node});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: node.label,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.bgMid.withOpacity(0.7),
          border: Border.all(
              color: AppColors.cyberBlue.withOpacity(0.6), width: 1.4),
          boxShadow: AppColors.glow(AppColors.cyberBlue, blur: 16),
        ),
        child: Icon(node.icon, color: AppColors.cyberBlue, size: 20),
      ),
    );
  }
}

class _TopologyLinePainter extends CustomPainter {
  final List<TopologyNode> nodes;
  final List<List<int>> edges;
  final double pulseT;

  _TopologyLinePainter({
    required this.nodes,
    required this.edges,
    required this.pulseT,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.cyberBlue.withOpacity(0.25)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final pulsePaint = Paint()
      ..color = AppColors.cyberGreen.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    for (final edge in edges) {
      final a = nodes[edge[0]].relativePosition.scale(size.width, size.height);
      final b = nodes[edge[1]].relativePosition.scale(size.width, size.height);
      canvas.drawLine(a, b, linePaint);

      // Animated pulse dot traveling along the edge
      final t = (pulseT + edge[0] * 0.13) % 1.0;
      final pulsePos = Offset.lerp(a, b, t)!;
      canvas.drawCircle(pulsePos, 3.2, pulsePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TopologyLinePainter oldDelegate) =>
      oldDelegate.pulseT != pulseT;
}
