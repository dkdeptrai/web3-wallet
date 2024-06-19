import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  /// Soft color
  final Color softPurple;
  final Color softPink;
  final Color softOrange;
  final Color softYellow1;
  final Color softPurple2;
  final Color softGreen;
  final Color softBlue;
  final Color softRed;

  // Main
  final Color orange;
  final Color purple;
  final Color pink;
  final Color yellow;
  final Color purple1;
  final Color green;
  final Color blue;
  final Color red;

  // Background
  final Color bgPurple;
  final Color bgPink;
  final Color bgGrey1;
  final Color bgCard1;
  final Color bgGrey2;
  final Color bgCard2;
  final Color bgCardTransparent;
  final Color bgBlurModal;
  final Color bgScreen;

  // Text
  final Color title;
  final Color subTitle;
  final Color txtInactive;

  //

  const AppColors({
    required this.softPurple,
    required this.softPink,
    required this.softOrange,
    required this.softYellow1,
    required this.softPurple2,
    required this.softGreen,
    required this.softBlue,
    required this.softRed,
    required this.orange,
    required this.purple,
    required this.pink,
    required this.yellow,
    required this.purple1,
    required this.green,
    required this.blue,
    required this.red,
    required this.bgPurple,
    required this.bgPink,
    required this.bgGrey1,
    required this.bgCard1,
    required this.bgGrey2,
    required this.bgCard2,
    required this.bgCardTransparent,
    required this.bgBlurModal,
    required this.bgScreen,
    required this.title,
    required this.subTitle,
    required this.txtInactive,
  });

  factory AppColors.lightMode() {
    return const AppColors(
      softPurple: Color(0xFFEBECFF),
      softPink: Color(0xFFFFE4EF),
      softOrange: Color(0xFFFFEBE4),
      softYellow1: Color(0xFFFFE4C3),
      softPurple2: Color(0xFFE0E2FF),
      softGreen: Color(0xFFDEF5E9),
      softBlue: Color(0xFFDFF0FF),
      softRed: Color(0xFFFFDBDB),
      orange: Color(0xFFFFCC7E),
      purple: Color(0xFF9F9DF3),
      pink: Color(0xFFF04086),
      yellow: Color(0xFFF7931A),
      purple1: Color(0xFF767DFF),
      green: Color(0xFF5FC88F),
      blue: Color(0xFF66B6FF),
      red: Color(0xFFFF6464),
      bgPurple: Color(0xFF9F9DF3),
      bgPink: Color(0xFFFF9BB3),
      bgGrey1: Color(0xFFF3F5F6),
      bgCard1: Color(0xCCFFFFFF),
      bgGrey2: Color(0xFFF7F7FA),
      bgCard2: Color(0xFFFFFFFF),
      bgCardTransparent: Color(0x66FFFFFF),
      bgBlurModal: Color(0x99CDCEDB),
      bgScreen: Color(0xFFF3F5F6),
      title: Color(0xFF26273C),
      subTitle: Color(0xFF9395A4),
      txtInactive: Color(0xFFCED0DE),
    );
  }

  factory AppColors.darkMode() {
    return const AppColors(
      softPurple: Color(0xFFEBECFF),
      softPink: Color(0x33F04086),
      softOrange: Color(0x33F7931A),
      softYellow1: Color(0xFFFFE4C3),
      softPurple2: Color(0x338774C3),
      softGreen: Color(0x3347A348),
      softBlue: Color(0x3366B6FF),
      softRed: Color(0xFFFFDBDB),
      orange: Color(0xFFF09654),
      purple: Color(0xFF6C6AEB),
      pink: Color(0xFFFF6E91),
      yellow: Color(0xFFF7931A),
      purple1: Color(0xFF767DFF),
      green: Color(0xFF5FC88F),
      blue: Color(0xFF66B6FF),
      red: Color(0xFFFF6464),
      bgPurple: Color(0xFF9F9DF3),
      bgPink: Color(0xFFFF9BB3),
      bgGrey1: Color(0xFF747792),
      bgCard1: Color(0xFF282C4A),
      bgGrey2: Color(0xFFF7F7FA),
      bgCard2: Color(0xFF1C203A),
      bgCardTransparent: Color(0x66FFFFFF),
      bgBlurModal: Color(0x99252739),
      bgScreen: Color(0xFF141629),
      title: Color(0xFFFFFFFF),
      subTitle: Color(0xFF9395A4),
      txtInactive: Color(0xFFCED0DE),
    );
  }

  @override
  ThemeExtension<AppColors> copyWith({
    Color? softPurple,
    Color? softPink,
    Color? softOrange,
    Color? softYellow1,
    Color? softPurple2,
    Color? softGreen,
    Color? softBlue,
    Color? softRed,
    Color? orange,
    Color? purple,
    Color? pink,
    Color? yellow,
    Color? purple1,
    Color? green,
    Color? blue,
    Color? red,
    Color? bgPurple,
    Color? bgPink,
    Color? bgGrey1,
    Color? bgCard1,
    Color? bgGrey2,
    Color? bgCard2,
    Color? bgCardTransparent,
    Color? bgBlurModal,
    Color? bgScreen,
    Color? title,
    Color? subTitle,
    Color? txtInactive,
  }) {
    return AppColors(
      softPurple: softPurple ?? this.softPurple,
      softPink: softPink ?? this.softPink,
      softOrange: softOrange ?? this.softOrange,
      softYellow1: softYellow1 ?? this.softYellow1,
      softPurple2: softPurple2 ?? this.softPurple2,
      softGreen: softGreen ?? this.softGreen,
      softBlue: softBlue ?? this.softBlue,
      softRed: softRed ?? this.softRed,
      orange: orange ?? this.orange,
      purple: purple ?? this.purple,
      pink: pink ?? this.pink,
      yellow: yellow ?? this.yellow,
      purple1: purple1 ?? this.purple1,
      green: green ?? this.green,
      blue: blue ?? this.blue,
      red: red ?? this.red,
      bgPurple: bgPurple ?? this.bgPurple,
      bgPink: bgPink ?? this.bgPink,
      bgGrey1: bgGrey1 ?? this.bgGrey1,
      bgCard1: bgCard1 ?? this.bgCard1,
      bgGrey2: bgGrey2 ?? this.bgGrey2,
      bgCard2: bgCard2 ?? this.bgCard2,
      bgCardTransparent: bgCardTransparent ?? this.bgCardTransparent,
      bgBlurModal: bgBlurModal ?? this.bgBlurModal,
      bgScreen: bgScreen ?? this.bgScreen,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      txtInactive: txtInactive ?? this.txtInactive,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(covariant ThemeExtension<AppColors>? other, double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }
}
