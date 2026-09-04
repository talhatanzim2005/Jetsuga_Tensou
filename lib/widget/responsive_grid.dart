import 'package:flutter/material.dart';
import 'package:hackathon/front_end/responsive.dart';

class AppGridItem extends StatelessWidget {
  const AppGridItem({
    super.key,
    required this.child,
    this.mobileCols = 4,
    this.tabletCols = 8,
    this.desktopCols = 12,
  });

  final Widget child;
  final int mobileCols;
  final int tabletCols;
  final int desktopCols;

  int getSpan(BuildContext context) {
    final type = AppResponsive.getDeviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return mobileCols.clamp(1, 4);
      case DeviceType.tablet:
        return tabletCols.clamp(1, 8);
      case DeviceType.desktop:
        return desktopCols.clamp(1, 12);
    }
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class AppResponsiveGrid extends StatelessWidget {
  const AppResponsiveGrid({super.key, required this.children, this.runSpacing});

  final List<AppGridItem> children;
  final double? runSpacing;

  @override
  Widget build(BuildContext context) {
    final double gutter = AppResponsive.getGutter(context);
    final int totalCols = AppResponsive.getColumnCount(context);
    final double spacing = runSpacing ?? gutter;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        final double singleColWidth =
            (totalWidth - (gutter * (totalCols - 1))) / totalCols;

        return Wrap(
          spacing: gutter,
          runSpacing: spacing,
          children: children.map((item) {
            final int span = item.getSpan(context);
            final double itemWidth =
                (span * singleColWidth) + ((span - 1) * gutter);

            return SizedBox(
              width: itemWidth.clamp(0.0, totalWidth),
              child: item.child,
            );
          }).toList(),
        );
      },
    );
  }
}
