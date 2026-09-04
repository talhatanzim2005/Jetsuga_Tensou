import 'package:flutter/material.dart';
import 'package:hackathon/front_end/theme.dart';

/// Screen device breakpoint types
enum DeviceType { mobile, tablet, desktop }

/// Responsive Layout Utility enforcing 12 / 8 / 4 Column Grids
abstract class AppResponsive {
  static const double mobileMax = 599.0;
  static const double tabletMax = 1023.0;

  static DeviceType getDeviceType(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    if (width < 600.0) {
      return DeviceType.mobile;
    } else if (width <= 1023.0) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  static int getColumnCount(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return 4;
      case DeviceType.tablet:
        return 8;
      case DeviceType.desktop:
        return 12;
    }
  }

  static double getGutter(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return AppSpacing.sm;
      case DeviceType.tablet:
        return AppSpacing.md;
      case DeviceType.desktop:
        return AppSpacing.lg;
    }
  }

  static double getMargin(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return AppSpacing.sm;
      case DeviceType.tablet:
        return AppSpacing.lg;
      case DeviceType.desktop:
        return AppSpacing.xxl;
    }
  }
}
