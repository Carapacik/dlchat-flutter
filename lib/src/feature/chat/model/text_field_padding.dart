import 'dart:math' show max, min;

import 'package:flutter/foundation.dart';

class TextFieldPadding() with ChangeNotifier {
  int _linesNumber = 1;
  bool _isFilePicked = false;

  double get paddingBottom => min(min(_linesNumber, 6) * 20 + (_isFilePicked ? 76 : 0), 170);

  int get linesNumber => _linesNumber;

  bool get isFilePicked => _isFilePicked;

  void setFilePicked({required bool isPicked}) {
    _isFilePicked = isPicked;
    notifyListeners();
  }

  void setNewLinesNumber(int number) {
    _linesNumber = max(1, number);
    notifyListeners();
  }
}
