import 'package:flutter/foundation.dart';

class BaseController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value, {bool notify = true}) {
    if (_isLoading == value) {
      return;
    }
    _isLoading = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setError(String? message, {bool notify = true}) {
    if (_errorMessage == message) {
      return;
    }
    _errorMessage = message;
    if (notify) {
      notifyListeners();
    }
  }

  void clearError({bool notify = true}) {
    if (_errorMessage == null) {
      return;
    }
    _errorMessage = null;
    if (notify) {
      notifyListeners();
    }
  }

  void emit() {
    notifyListeners();
  }
}
