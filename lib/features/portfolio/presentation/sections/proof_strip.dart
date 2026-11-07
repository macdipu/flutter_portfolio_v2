import 'package:flutter/material.dart';

import '../../../../content/portfolio_content.dart';
import '../../../../core/design/tokens.dart';
import '../../../../core/motion/reveal.dart';
import '../../../../core/widgets/ui.dart';

/// Three checkable facts under the hero. Each one is stated again, in full,
/// further down the page: this strip is a summary, not extra claims.
class ProofStrip extends StatelessWidget {
  const ProofStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final wide = MediaQuery.sizeOf(context).width >= 800;

    Widget fact(int i, ProofFact f) => Reveal(
          delay: Motion.stagger * i,
          child: Container(
            padding: const EdgeInsets.only(top: Space.m, bottom: Space.m),
            decoration:
                BoxDecoration(border: Border(top: BorderSide(color: c.line))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f.headline, style: AppType.h3(context)),
                const SizedBox(height: Space.xs),
                Text(f.detail, style: AppType.caption(context)),
              ],
            ),
          ),
        );

    return Padding(
      padding: EdgeInsets.only(top: fluid(context, 16, 32)),
      child: Frame(
        child: wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < proofFacts.length; i++) ...[
                    if (i > 0) const SizedBox(width: Space.xl),
                    Expanded(child: fact(i, proofFacts[i])),
                  ],
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < proofFacts.length; i++)
                    fact(i, proofFacts[i]),
                ],
              ),
      ),
    );
  }
}
