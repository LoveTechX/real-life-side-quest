import '../../../core/base/base_controller.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthController extends BaseController {
  AuthController({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository();

  final AuthRepository _authRepository;

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  void _setAuthState({UserModel? user, String? errorMessage}) {
    _currentUser = user;
    setError(errorMessage, notify: false);
    emit();
  }

  Future<bool> login({required String email, required String password}) async {
    setLoading(true);
    try {
      final UserModel? user = await _authRepository.login(
        email: email.trim(),
        password: password,
      );
      if (user == null) {
        setError('Unable to load user account.');
        return false;
      }

      _setAuthState(user: user, errorMessage: null);
      return true;
    } catch (_) {
      setError('Login failed. Please try again.');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    setLoading(true);
    try {
      final UserModel user = await _authRepository.signup(
        name: name.trim(),
        email: email.trim(),
        password: password,
      );
      _setAuthState(user: user, errorMessage: null);
      return true;
    } catch (_) {
      setError('Sign up failed. Please try again.');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    setLoading(true);
    try {
      await _authRepository.logout();
      _setAuthState(user: null, errorMessage: null);
    } catch (_) {
      setError('Logout failed. Please try again.');
    } finally {
      setLoading(false);
    }
  }

  void setCurrentUser(UserModel? user) {
    _setAuthState(user: user, errorMessage: errorMessage);
  }
}
