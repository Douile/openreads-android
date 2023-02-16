part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ChangeThemeEvent extends ThemeEvent {
  final ThemeMode themeMode;
  final bool showOutlines;
  final double cornerRadius;
  final Color primaryColor;
  final String? fontFamily;
  final bool readTabFirst;
  final bool useMaterialYou;
  final String? locale;

  const ChangeThemeEvent({
    required this.themeMode,
    required this.showOutlines,
    required this.cornerRadius,
    required this.primaryColor,
    required this.fontFamily,
    required this.readTabFirst,
    required this.useMaterialYou,
    required this.locale,
  });

  @override
  List<Object?> get props => [
        themeMode,
        showOutlines,
        cornerRadius,
        primaryColor,
        fontFamily,
        readTabFirst,
        useMaterialYou,
        locale,
      ];
}
