import '../services/firebase_service.dart';

class AppBootstrap {
  AppBootstrap._();

  static Future<void> initialize() async {
    await FirebaseService.instance.initialize();
  }
}
