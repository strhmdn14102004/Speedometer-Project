
import "package:flutter/material.dart";
import "package:weather_sasat/helper/navigator.dart";


class AppColors {
  static Brightness brightness() {
    if (Navigators.navigatorState.currentContext != null) {
      return MediaQuery.of(Navigators.navigatorState.currentContext!).platformBrightness;
    }

    return Brightness.light;
  }

  static Brightness brightnessInverse() {
    if (darkMode()) {
      return Brightness.light;
    } else {
      return Brightness.dark;
    }
  }

  static bool darkMode() {
    return brightness() == Brightness.dark;
  }

  static Color primary() {
    if (darkMode()) {
      return Color.fromARGB(255, 255, 29, 29);
    } else {
      return Colors.green;
    }
  }

  static Color onPrimary() {
    if (darkMode()) {
      return darkColorScheme.onPrimary;
    } else {
      return lightColorScheme.onPrimary;
    }
  }

  static Color primaryContainer() {
    if (darkMode()) {
      return darkColorScheme.primaryContainer;
    } else {
      return lightColorScheme.primaryContainer;
    }
  }

  static Color onPrimaryContainer() {
    if (darkMode()) {
      return darkColorScheme.onPrimaryContainer;
    } else {
      return lightColorScheme.onPrimaryContainer;
    }
  }

  static Color secondary() {
    if (darkMode()) {
      return Color.fromARGB(255, 255, 255, 255);
    } else {
      return Color.fromARGB(255, 255, 0, 0);
    }
  }

  static Color onSecondary() {
    if (darkMode()) {
      return darkColorScheme.onSecondary;
    } else {
      return lightColorScheme.onSecondary;
    }
  }

  static Color secondaryContainer() {
    if (darkMode()) {
      return darkColorScheme.secondaryContainer;
    } else {
      return lightColorScheme.secondaryContainer;
    }
  }

  static Color onSecondaryContainer() {
    if (darkMode()) {
      return darkColorScheme.onSecondaryContainer;
    } else {
      return lightColorScheme.onSecondaryContainer;
    }
  }

  static Color tertiary() {
    if (darkMode()) {
      return darkColorScheme.tertiary;
    } else {
      return lightColorScheme.tertiary;
    }
  }

  static Color onTertiary() {
    if (darkMode()) {
      return darkColorScheme.onTertiary;
    } else {
      return lightColorScheme.onTertiary;
    }
  }

  static Color tertiaryContainer() {
    if (darkMode()) {
      return darkColorScheme.tertiaryContainer;
    } else {
      return lightColorScheme.tertiaryContainer;
    }
  }

  static Color onTertiaryContainer() {
    if (darkMode()) {
      return darkColorScheme.onTertiaryContainer;
    } else {
      return lightColorScheme.onTertiaryContainer;
    }
  }

  static Color error() {
    if (darkMode()) {
      return darkColorScheme.error;
    } else {
      return lightColorScheme.error;
    }
  }

  static Color errorContainer() {
    if (darkMode()) {
      return darkColorScheme.errorContainer;
    } else {
      return lightColorScheme.errorContainer;
    }
  }

  static Color onError() {
    if (darkMode()) {
      return darkColorScheme.onError;
    } else {
      return lightColorScheme.onError;
    }
  }

  static Color onErrorContainer() {
    if (darkMode()) {
      return darkColorScheme.onErrorContainer;
    } else {
      return lightColorScheme.onErrorContainer;
    }
  }

  static Color background() {
    if (darkMode()) {
      return darkColorScheme.background;
    } else {
      return lightColorScheme.background;
    }
  }

  static Color onBackground() {
    if (darkMode()) {
      return darkColorScheme.onBackground;
    } else {
      return lightColorScheme.onBackground;
    }
  }

  static Color surface() {
    if (darkMode()) {
      return darkColorScheme.surface;
    } else {
      return lightColorScheme.surface;
    }
  }

  static Color onSurface() {
    if (darkMode()) {
      return darkColorScheme.onSurface;
    } else {
      return lightColorScheme.onSurface;
    }
  }

  static Color surfaceVariant() {
    if (darkMode()) {
      return darkColorScheme.surfaceVariant;
    } else {
      return lightColorScheme.surfaceVariant;
    }
  }

  static Color onSurfaceVariant() {
    if (darkMode()) {
      return darkColorScheme.onSurfaceVariant;
    } else {
      return lightColorScheme.onSurfaceVariant;
    }
  }

  static Color outline() {
    if (darkMode()) {
      return darkColorScheme.outline;
    } else {
      return lightColorScheme.outline;
    }
  }

  static Color onInverseSurface() {
    if (darkMode()) {
      return darkColorScheme.onInverseSurface;
    } else {
      return lightColorScheme.onInverseSurface;
    }
  }

  static Color inverseSurface() {
    if (darkMode()) {
      return darkColorScheme.inverseSurface;
    } else {
      return lightColorScheme.inverseSurface;
    }
  }

  static Color inversePrimary() {
    if (darkMode()) {
      return darkColorScheme.inversePrimary;
    } else {
      return lightColorScheme.inversePrimary;
    }
  }

  static Color shadow() {
    if (darkMode()) {
      return darkColorScheme.shadow;
    } else {
      return lightColorScheme.shadow;
    }
  }

  static Color surfaceTint() {
    if (darkMode()) {
      return darkColorScheme.surfaceTint;
    } else {
      return lightColorScheme.surfaceTint;
    }
  }

  static Color outlineVariant() {
    if (darkMode()) {
      return darkColorScheme.outlineVariant;
    } else {
      return lightColorScheme.outlineVariant;
    }
  }

  static Color scrim() {
    if (darkMode()) {
      return darkColorScheme.scrim;
    } else {
      return lightColorScheme.scrim;
    }
  }

  static Color success() {
    if (darkMode()) {
      return Colors.green.shade100;
    } else {
      return Colors.green.shade700;
    }
  }

  static Color onSuccess() {
    if (darkMode()) {
      return Colors.green.shade900;
    } else {
      return Colors.green.shade100;
    }
  }

  static Color successContainer() {
    if (darkMode()) {
      return Colors.green.shade700;
    } else {
      return Colors.green.shade100;
    }
  }

  static Color onSuccessContainer() {
    if (darkMode()) {
      return Colors.green.shade100;
    } else {
      return Colors.green.shade900;
    }
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF006E17),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF99F990),
    onPrimaryContainer: Color(0xFF002203),
    secondary: Color(0xFF626200),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE9E86A),
    onSecondaryContainer: Color(0xFF1D1D00),
    tertiary: Color(0xFF38656A),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFBCEBF0),
    onTertiaryContainer: Color(0xFF002022),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFCFDF6),
    onBackground: Color(0xFF1A1C19),
    surface: Color(0xFFFCFDF6),
    onSurface: Color(0xFF1A1C19),
    surfaceVariant: Color(0xFFDEE5D8),
    onSurfaceVariant: Color(0xFF424940),
    outline: Color(0xFF73796F),
    onInverseSurface: Color(0xFFF1F1EB),
    inverseSurface: Color(0xFF2F312D),
    inversePrimary: Color(0xFF7DDC77),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF006E17),
    outlineVariant: Color(0xFFC2C8BD),
    scrim: Color(0xFF000000),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF7DDC77),
    onPrimary: Color(0xFF003907),
    primaryContainer: Color(0xFF00530F),
    onPrimaryContainer: Color(0xFF99F990),
    secondary: Color(0xFFCCCC51),
    onSecondary: Color(0xFF323200),
    secondaryContainer: Color(0xFF494900),
    onSecondaryContainer: Color(0xFFE9E86A),
    tertiary: Color(0xFFA0CFD4),
    onTertiary: Color(0xFF00363B),
    tertiaryContainer: Color(0xFF1E4D52),
    onTertiaryContainer: Color(0xFFBCEBF0),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1A1C19),
    onBackground: Color(0xFFE2E3DD),
    surface: Color(0xFF1A1C19),
    onSurface: Color(0xFFE2E3DD),
    surfaceVariant: Color(0xFF424940),
    onSurfaceVariant: Color(0xFFC2C8BD),
    outline: Color(0xFF8C9388),
    onInverseSurface: Color(0xFF1A1C19),
    inverseSurface: Color(0xFFE2E3DD),
    inversePrimary: Color(0xFF006E17),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF7DDC77),
    outlineVariant: Color(0xFF424940),
    scrim: Color(0xFF000000),
  );
}
