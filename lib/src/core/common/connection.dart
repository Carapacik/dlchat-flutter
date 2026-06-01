import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dlchat/src/feature/shared_widgets/common/internet_connection_overlay.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionUtility() {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  var _connected = true;
  OverlayEntry? _overlayBarEntry;

  void init(BuildContext context) {
    _subscription = Connectivity().onConnectivityChanged.listen((event) async {
      _connected = await InternetConnection().hasInternetAccess;
      if (context.mounted && !_connected) {
        showInternetConnectionTopSnack(context);
      } else {
        hideInternetConnectionTopSnack();
      }
    });
  }

  void showInternetConnectionTopSnack(BuildContext context) {
    if (_overlayBarEntry != null) {
      // Если OverlayEntry уже показан, не показываем новый
      return;
    }

    _overlayBarEntry = OverlayEntry(builder: (context) => InternetConnectionSnackBar(connectionUtility: this));

    Overlay.of(context).insert(_overlayBarEntry!);
  }

  void hideInternetConnectionTopSnack() {
    _overlayBarEntry?.remove();
    _overlayBarEntry = null;
  }

  Future<void> dispose() async {
    await _subscription.cancel();
    hideInternetConnectionTopSnack();
  }
}
