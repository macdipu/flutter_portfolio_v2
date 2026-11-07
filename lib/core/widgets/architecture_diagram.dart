import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// One box in a diagram.
class DiagramNode {
  const DiagramNode(
    this.title,
    this.sub, {
    this.flex = 1,
    this.emphasis = false,
  });

  final String title;
  final String sub;
  final int flex;
  final bool emphasis;
}

/// A row of boxes. [muted] rows (data stores) are drawn quieter.
class DiagramRow {
  const DiagramRow(this.nodes, {this.muted = false});

  final List<DiagramNode> nodes;
  final bool muted;
}

/// System diagrams, each taken from the project's own documentation.
abstract class Diagrams {
  /// FlexWork: README architecture summary.
  static const flexwork = <DiagramRow>[
    DiagramRow([
      DiagramNode('Worker app', 'Flutter, mobile'),
      DiagramNode('Employer app', 'Flutter, mobile'),
      DiagramNode('Admin panel', 'Next.js, web'),
    ]),
    DiagramRow([
      DiagramNode('API gateway', 'Spring Cloud Gateway, one entry point',
          emphasis: true),
    ]),
    DiagramRow([
      DiagramNode(
        'Spring Boot',
        'auth, user, job, application, shift, attendance, wallet, rating, '
            'referral, learning, employer',
        flex: 5,
      ),
      DiagramNode('Django', 'admin', flex: 2),
      DiagramNode('Node.js', 'notifications, chat', flex: 3),
      DiagramNode('FastAPI', 'AI', flex: 2),
    ]),
    DiagramRow([
      DiagramNode('PostgreSQL', 'per-service schemas'),
      DiagramNode('Redis', 'cache'),
      DiagramNode('MinIO', 'files'),
      DiagramNode('Kafka', 'optional'),
    ], muted: true),
  ];

  /// BuildingOS: docs/ARCHITECTURE.md monorepo layout.
  static const buildingOs = <DiagramRow>[
    DiagramRow([
      DiagramNode('User app', 'Flutter, GetX'),
      DiagramNode('Back-office web', 'web app'),
    ]),
    DiagramRow([
      DiagramNode('API gateway', 'one entry point', emphasis: true),
    ]),
    DiagramRow([
      DiagramNode('auth', 'OTP, JWT'),
      DiagramNode('building', 'service'),
      DiagramNode('subscription', 'plans, fees'),
      DiagramNode('back-office', 'support, audit'),
    ]),
    DiagramRow([
      DiagramNode('OpenAPI', 'HTTP contracts'),
      DiagramNode('Kafka', 'event schemas'),
      DiagramNode('PostgreSQL', 'one database per service'),
    ], muted: true),
  ];

  static List<DiagramRow> byKey(String key) =>
      key == 'buildingos' ? buildingOs : flexwork;
}

/// Draws [rows] as boxes joined by arrows.
///
/// Laid out at a fixed 640px width and scaled to fit, so it stays legible
/// inside any device frame and cannot overflow in any font.
class ArchitectureDiagram extends StatelessWidget {
  const ArchitectureDiagram({super.key, required this.rows});

  final List<DiagramRow> rows;

  static const _w = 640.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ColoredBox(
      color: c.paper,
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _w,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i > 0) const _Gap(),
                  _RowView(row: rows[i]),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RowView extends StatelessWidget {
  const _RowView({required this.row});

  final DiagramRow row;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < row.nodes.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(
              flex: row.nodes[i].flex,
              child: _NodeView(node: row.nodes[i], muted: row.muted),
            ),
          ],
        ],
      ),
    );
  }
}

class _NodeView extends StatelessWidget {
  const _NodeView({required this.node, required this.muted});

  final DiagramNode node;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: node.emphasis ? c.signal.withValues(alpha: 0.14) : c.surface,
        borderRadius: BorderRadius.circular(Radii.sm),
        border: Border.all(color: node.emphasis ? c.signal : c.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            node.title,
            style: AppType.ui14(context).copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: muted ? c.muted : c.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            node.sub,
            style:
                AppType.caption(context).copyWith(fontSize: 11.5, height: 1.3),
          ),
        ],
      ),
    );
  }
}

class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child:
            Icon(Icons.arrow_downward, size: 16, color: context.colors.signal),
      );
}
