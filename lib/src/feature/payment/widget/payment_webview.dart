import 'dart:async';
import 'dart:io';

import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class const PaymentWebView({required final String url, super.key}) extends StatefulWidget {
  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState() extends State<PaymentWebView> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    unawaited(_initWebViewController());
  }

  Future<void> _initWebViewController() async {
    if (kIsWeb) {
      return;
    }
    _controller = WebViewController();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    final controller = WebViewController.fromPlatformCreationParams(params);

    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);

    await controller.setNavigationDelegate(
      NavigationDelegate(
        onWebResourceError: (error) {
          context.dependencies.logger.error('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
  url: ${error.url}
          ''', error: error);
        },
        onNavigationRequest: (request) async {
          final String url = request.url;
          if (url.startsWith(RegExp('^bank.*')) ||
              url.startsWith(RegExp('^sberpay.*')) ||
              url.startsWith(RegExp('^mirpay.*'))) {
            try {
              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              if (mounted) {
                context
                  ..pop()
                  ..pop();
              }
            } on PlatformException {
              if (mounted) {
                showErrorMessage(context, 'Приложение банка не найдено');
                return NavigationDecision.prevent;
              }
            }
          }

          if (url.startsWith('https://yoomoney.ru/checkout/payments/v2/success')) {
            if (mounted) {
              context.pop(true);
            }
          }
          if (url.startsWith('https://your-return-url.com')) {
            if (mounted) {
              context.pop(false);
            }
          }

          return NavigationDecision.navigate;
        },
      ),
    );

    if (Platform.isAndroid || Platform.isIOS) {
      await controller.setBackgroundColor(AppColors.white);
    }

    if (controller.platform is AndroidWebViewController) {
      await AndroidWebViewController.enableDebugging(true);
      await (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    await controller.loadRequest(Uri.parse(widget.url));

    if (mounted) {
      setState(() => _controller = controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildPlatformAppBar(context),
      body: _controller == null ? const SizedBox.shrink() : SafeArea(child: WebViewWidget(controller: _controller!)),
    );
  }
}
