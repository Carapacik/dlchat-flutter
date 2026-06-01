import 'dart:io' show Platform;

import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart' show BuildContext;

class StoreValidation() {
  static bool isTestPhone(String? phone) {
    if (phone == null) {
      return true;
    }
    if (phone.contains('79999999999')) {
      return true;
    }
    return false;
  }

  static bool hidePayments(BuildContext context, String? phone) {
    final bool isOnValidation = context.dependencies.appStateRepository.isOnValidation;
    final bool isTest = isTestPhone(phone);
    final bool isOsX = !kIsWeb && (Platform.isIOS || Platform.isMacOS);
    return isOsX && (isTest || isOnValidation);
  }
}
