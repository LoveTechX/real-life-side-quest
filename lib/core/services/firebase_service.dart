import 'dart:async';

import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  bool _isInitialized = false;
  Completer<void>? _initializationCompleter;

  bool get isInitialized => _isInitialized;

  Future<void> initialize({FirebaseOptions? options, String? name}) async {
    if (_isInitialized) {
      return;
    }

    if (_initializationCompleter != null) {
      return _initializationCompleter!.future;
    }

    _initializationCompleter = Completer<void>();

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: options, name: name);
      }
      _isInitialized = true;
      _initializationCompleter!.complete();
    } catch (error, stackTrace) {
      _initializationCompleter!.completeError(error, stackTrace);
      _initializationCompleter = null;
      rethrow;
    }
  }
}
