import 'package:dlchat/src/core/constant/generated/fonts.gen.dart';
import 'package:flutter/material.dart';

abstract final class AppTypography() {
  static const bodyRegular = TextStyle(
    fontFamily: FontFamily.inter,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  );

  static const bodyMedium = TextStyle(
    fontFamily: FontFamily.inter,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
  );

  static const bodySemibold = TextStyle(
    fontFamily: FontFamily.inter,
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.02,
  );

  static const bodyRegular2 = TextStyle(
    fontFamily: FontFamily.inter,
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
  );

  static const bodyMediumBulleted = TextStyle(
    fontFamily: FontFamily.inter,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.17,
  );

  static const bodyPay = TextStyle(
    fontFamily: FontFamily.inter,
    fontSize: 8,
    height: 1.1,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  );

  static const bodySettingsRegularHeader = TextStyle(
    fontFamily: FontFamily.inter,
    fontSize: 14,
    height: 1,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  static const bodySettingsMedium = TextStyle(
    fontFamily: FontFamily.inter,
    fontSize: 14,
    height: 16 / 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
  );

  static const bodySettingsRegularText = TextStyle(
    fontFamily: FontFamily.inter,
    fontSize: 14,
    height: 16 / 14,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.01,
  );

  static const headerMedium = TextStyle(
    fontFamily: FontFamily.sFNSExpanded,
    fontSize: 24,
    height: 28 / 24,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
  );

  static const headerSemibold = TextStyle(
    fontFamily: FontFamily.sFNSExpanded,
    fontSize: 32,
    height: 1,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
  );
}
