import 'dart:ui' show FontVariation;

import 'package:flutter/material.dart';

/// Общая визуальная система рабочего пространства.
ThemeData forgeTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF008771),
        brightness: brightness,
      ).copyWith(
        surface: dark ? const Color(0xFF111916) : const Color(0xFFF7FAF7),
        surfaceContainerLow: dark ? const Color(0xFF19221E) : Colors.white,
        tertiaryContainer: dark
            ? const Color(0xFF4D3318)
            : const Color(0xFFFFE7C9),
        onTertiaryContainer: dark
            ? const Color(0xFFFFD9AB)
            : const Color(0xFF462A0B),
      );
  final base = ThemeData(colorScheme: scheme, useMaterial3: true);
  final text = base.textTheme;
  TextStyle? heading(TextStyle? style) => style?.copyWith(
    fontFamily: 'Manrope',
    fontVariations: const [FontVariation('wght', 720)],
    height: 1.18,
    letterSpacing: -0.35,
  );
  final panel = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(color: scheme.outlineVariant),
  );
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: scheme.outlineVariant),
  );
  return base.copyWith(
    textTheme: text.copyWith(
      headlineLarge: heading(text.headlineLarge),
      headlineMedium: heading(text.headlineMedium),
      titleLarge: heading(text.titleLarge),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: text.bodyMedium?.copyWith(height: 1.45),
      bodyLarge: text.bodyLarge?.copyWith(height: 1.45),
    ),
    appBarTheme: AppBarThemeData(
      centerTitle: false,
      backgroundColor: scheme.surface,
      scrolledUnderElevation: 0,
      titleTextStyle: heading(
        text.titleLarge,
      )?.copyWith(color: scheme.onSurface),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      elevation: 0,
      height: 68,
      labelTextStyle: WidgetStatePropertyAll(text.labelMedium),
      indicatorColor: scheme.primaryContainer,
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerLow,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: panel,
    ),
    dialogTheme: DialogThemeData(shape: panel),
    bottomSheetTheme: const BottomSheetThemeData(showDragHandle: true),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: scheme.surfaceContainerLow,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant),
  );
}
