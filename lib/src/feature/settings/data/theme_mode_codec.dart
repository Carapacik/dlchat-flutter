import 'dart:convert';

import 'package:flutter/material.dart' show ThemeMode;

/// {@template theme_mode_codec}
/// Codec for [ThemeMode]
/// {@endtemplate}
final class const ThemeModeCodec() extends Codec<ThemeMode, String> {
  /// {@macro theme_mode_codec}
  this;

  @override
  Converter<String, ThemeMode> get decoder => const _ThemeModeDecoder();

  @override
  Converter<ThemeMode, String> get encoder => const _ThemeModeEncoder();
}

final class const _ThemeModeDecoder() extends Converter<String, ThemeMode> {
  @override
  ThemeMode convert(String input) => switch (input) {
    'ThemeMode.dark' => ThemeMode.dark,
    'ThemeMode.light' => ThemeMode.light,
    'ThemeMode.system' => ThemeMode.system,
    _ => throw ArgumentError.value(input, 'input', 'Cannot convert $input to $ThemeMode'),
  };
}

final class const _ThemeModeEncoder() extends Converter<ThemeMode, String> {
  @override
  String convert(ThemeMode input) => switch (input) {
    ThemeMode.dark => 'ThemeMode.dark',
    ThemeMode.light => 'ThemeMode.light',
    ThemeMode.system => 'ThemeMode.system',
  };
}
