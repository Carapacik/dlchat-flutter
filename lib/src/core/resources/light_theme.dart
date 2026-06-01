import 'package:dlchat/src/core/constant/generated/fonts.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: AppColors.bgPrimary,
  brightness: Brightness.light,
  fontFamily: FontFamily.inter,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.black,
    onPrimary: AppColors.white,
    secondary: AppColors.white,
    onSecondary: AppColors.white,
    error: AppColors.white,
    onError: AppColors.white,
    surface: AppColors.white,
    onSurface: AppColors.black,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.iconMainChat1),
  appBarTheme: const AppBarThemeData(
    elevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.bgPrimary,
    surfaceTintColor: AppColors.bgPrimary,
    systemOverlayStyle: SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
    titleTextStyle: TextStyle(color: AppColors.textPrimary),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.bgSecondary,
    selectedIconTheme: IconThemeData(color: AppColors.iconMain1),
    unselectedIconTheme: IconThemeData(color: AppColors.iconPrimary),
    selectedItemColor: AppColors.iconMain1,
    unselectedItemColor: AppColors.iconPrimary,
  ),
  drawerTheme: const DrawerThemeData(
    shape: RoundedRectangleBorder(),
    backgroundColor: AppColors.white,
    surfaceTintColor: AppColors.white,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppColors.textPrimary),
    displayMedium: TextStyle(color: AppColors.textPrimary),
    displaySmall: TextStyle(color: AppColors.textPrimary),
    headlineLarge: TextStyle(color: AppColors.textPrimary),
    headlineMedium: TextStyle(color: AppColors.textPrimary),
    headlineSmall: TextStyle(color: AppColors.textPrimary),
    titleLarge: TextStyle(color: AppColors.textPrimary),
    titleMedium: TextStyle(color: AppColors.textPrimary),
    titleSmall: TextStyle(color: AppColors.textPrimary),
    bodyLarge: TextStyle(color: AppColors.textPrimary),
    bodyMedium: TextStyle(color: AppColors.textPrimary),
    bodySmall: TextStyle(color: AppColors.textPrimary),
    labelLarge: TextStyle(color: AppColors.textPrimary),
    labelMedium: TextStyle(color: AppColors.textPrimary),
    labelSmall: TextStyle(color: AppColors.textPrimary),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColors.textPrimary,
    disabledColor: AppColors.iconSecondary,
    focusColor: AppColors.textSecondary,
    hoverColor: AppColors.iconSecondary,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(16)),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
      textStyle: const WidgetStatePropertyAll(AppTypography.bodyMedium),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all<double>(0),
      padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(16)),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
      textStyle: const WidgetStatePropertyAll(AppTypography.bodyMedium),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.iconSecondary;
        }
        return AppColors.white;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        return Colors.transparent;
      }),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(16)),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
      textStyle: const WidgetStatePropertyAll(AppTypography.bodyMedium),
      foregroundColor: const WidgetStatePropertyAll(AppColors.textPrimary),
      backgroundColor: const WidgetStatePropertyAll(AppColors.iconSecondary),
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(allowEnterRouteSnapshotting: false),
    },
  ),
  inputDecorationTheme: const InputDecorationThemeData(
    alignLabelWithHint: true,
    isDense: true,
    outlineBorder: BorderSide.none,
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  // iconTheme: const IconThemeData(color: AppColors.iconPrimaryInverse),
  // cardTheme: const CardTheme(
  //   color: AppColors.baseBgPrimary,
  //   surfaceTintColor: AppColors.baseBgSecondary,
  // ),
  // bottomSheetTheme: const BottomSheetThemeData(
  //   backgroundColor: AppColors.baseBgPrimary,
  // ),
);
