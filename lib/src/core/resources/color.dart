import 'package:flutter/material.dart';

final class const AppColors._() {
  static const black100 = Color(0xFF000000);
  static const black200 = Color(0xFF1A1A1A);
  static const black300 = Color(0xFF333333);
  static const black400 = Color(0x66192039);
  static const black500 = Color(0xFF4F4F4F);
  static const black600 = Color(0xFF666666);
  static const black700 = Color(0xFF808080);
  static const black800 = Color(0xFF999999);
  static const black900 = Color(0xFF192039);
  static const black950 = Color(0xFFFAFAFA);

  static const gray100 = Color(0xFFEDEDEF);
  static const gray200 = Color(0xFFEEEEEE);
  static const gray300 = Color(0xFFE0E0E0);
  static const gray400 = Color(0xFFBABDC4);
  static const gray500 = Color(0xFF94969E);
  static const gray600 = Color(0xFF757575);
  static const gray700 = Color(0xFF616161);
  static const gray800 = Color(0xFF424242);
  static const gray900 = Color(0xFF212121);

  static const white100 = Color(0xFFFFFFFF);
  static const white200 = Color(0xFFF5F5F5);
  static const white300 = Color(0xFFE0E0E0);
  static const white400 = Color(0xFFBDBDBD);
  static const white500 = Color(0xFFFAFAFA);
  static const white600 = Color(0xFF757575);
  static const white700 = Color(0xFF616161);
  static const white800 = Color(0xFF424242);
  static const white900 = Color(0xFF212121);

  static const pink1 = Color(0xFFD752DA);
  static const pink2 = Color(0xFF933A95);

  ///
  static const iconMainChat1 = Color(0xFF630A65);
  static const iconMainChat2 = Color(0xFF061446);
  static const iconMainChat3 = Color(0xFF083A05);
  static const iconMainChat4 = Color(0xFF713308);
  static const iconMainChat5 = Color(0xFF626677);
  static const iconNeutral = Color(0xFFFFFFFF);
  static const neutralWhite = Color(0xFFFFFFFF);
  static const mobileButtonBg = Color(0xFFFFFFFF);
  static const desktopButtonBg = Color(0xFFEFEFEF);

  ///
  static const Color bgPrimary = gray100;
  static const bgSecondary = Color(0xFFFFFFFF);
  static const bgThird = Color(0xFFDBDBDB);
  static const bgPopup = Color(0xFFFFFFFF);

  ///
  static const inputError = Color(0xFFFF1E1E);
  static const inputCorrect = Color(0xFF15923F);

  ///
  static const Color textPrimary = black900;
  static const Color textSecondary = black400;
  static const Color textNeutral = black900;
  static const Color iconPrimary = black900;
  static const Color iconSecondary = gray400;
  static const Color iconThird = pink1;
  static const Color iconFourth = gray100;
  static const Color iconMain1 = pink2;
  static const Color bgInputPrimary = white500;
  static const Color bgIconButton = white500;

  // Base colors
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const textTertiary = Color(0x661B1E1B);
  static const error = Color(0xFFDF1C41);
  static const success = Color(0xFF22A84F);
  static const warning = Color(0xFFF79009);

  static const gradientDLChat = <Color>[Color(0xFF004CDF), Color(0xFFBE1B83), Color(0xFFFE4135)];

  static const pinkGradient = LinearGradient(
    colors: [white, Color(0xFFC714CB)],
    stops: [0, 1],
    begin: Alignment.topLeft,
    end: Alignment(1, 8),
  );

  static const blueGradient = LinearGradient(
    colors: [white, Color(0xFF1DBBF4)],
    stops: [0, 1],
    begin: Alignment.topLeft,
    end: Alignment(1, 8),
  );

  static const greenGradient = LinearGradient(
    colors: [white, Color(0xFF1DF441)],
    stops: [0, 1],
    begin: Alignment.topLeft,
    end: Alignment(1, 8),
  );

  static const orangeGradient = LinearGradient(
    colors: [white, Color(0xFFE24144)],
    stops: [0, 1],
    begin: Alignment.topLeft,
    end: Alignment(1, 8),
  );

  static const buttonGradient = LinearGradient(
    colors: [Color(0xFF192039), Color(0xFF44495E)],
    stops: [0, 1],
    begin: Alignment(-1, -0.3),
    end: Alignment(1, 0.3),
  );

  static const shimmerGradient = LinearGradient(
    colors: [Color(0xFFEBEBF4), Color(0xFFF4F4F4), Color(0xFFEBEBF4)],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1, -0.3),
    end: Alignment(1, 0.3),
  );

  // Rate gradient
  static const ratePromoBadgeGradient = LinearGradient(
    colors: [Color(0xFFFEC8FF), Color(0xFFFF56DA)],
    stops: [0, 1],
    begin: Alignment(-1, -0),
  );

  static const rateStandardBadgeGradient = LinearGradient(
    colors: [Color(0xFFDF7CE2), Color(0xFF625ECE)],
    stops: [0, 1],
    begin: Alignment(-1, -0),
  );

  static const rateBusinessBadgeGradient = LinearGradient(
    colors: [Color(0xFFDB7CDD), Color(0xFF590082)],
    stops: [0, 1],
    begin: Alignment(-1, -0),
  );

  static const ratePremiumBadgeGradient = LinearGradient(
    colors: [Color(0xFFFFB4B7), Color(0xFFB31268)],
    stops: [0, 1],
    begin: Alignment(-1, -0),
  );

  static const rateEliteBadgeGradient = LinearGradient(
    colors: [Color(0xFFA075FE), Color(0xFF18285B)],
    stops: [0, 1],
    begin: Alignment(-1, -0),
  );
}
