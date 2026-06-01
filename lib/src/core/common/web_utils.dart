import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:flutter/widgets.dart';

class WebUtils() {
  static String proxyWebLink(BuildContext context, String link) {
    final Uri uri = Uri.parse(link);
    return link.replaceFirst('${uri.scheme}://${uri.host}', context.dependencies.config.imageProxyUrl);
  }
}
