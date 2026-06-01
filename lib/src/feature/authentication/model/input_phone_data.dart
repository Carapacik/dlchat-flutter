import 'package:dlchat/src/core/common/regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:rest_client/auth/dto/init_type.dart';

enum SignInType() {
  sms,
  telegram;

  static InitType encode(SignInType type) => InitType.values.firstWhere((e) => e.name == type.name);
}

class const InputPhoneData({
  required final String phone,
  required final String countryNumber,
  required final String countryCode,
  required final SignInType signInType,
}) {
  String? isValidPhone(BuildContext context) {
    if (phone.isEmpty) {
      return 'Пустой телефон';
    }
    if (countryCode.isEmpty || countryNumber.isEmpty) {
      return 'Неправильный код страны';
    }
    if (!isPhoneValid(fullPhone, defaultCountryCode: countryCode)) {
      return 'Неправильный номер телефона';
    }

    return null;
  }

  String get fullPhone => '+$countryNumber $phone'.replaceAll(AppRegExp.clearPhoneRegex, '');
}
