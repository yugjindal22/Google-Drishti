import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

final currentUserDataProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getCurrentUserData();
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AsyncValue.loading()) {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authService.getCurrentUserData();
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    state = const AsyncValue.loading();

    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          await FirebaseAuth.instance.signInWithCredential(credential);
          await _loadCurrentUser();
        },
        verificationFailed: (FirebaseAuthException e) {
          state = AsyncValue.error(
              e.message ?? 'Verification failed', StackTrace.current);
        },
        codeSent: (String verificationId, int? resendToken) {
          // Store verification ID for OTP verification
          state = const AsyncValue.data(null);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
        },
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<bool> verifyOTP(String verificationId, String smsCode) async {
    state = const AsyncValue.loading();

    try {
      final userCredential = await _authService.verifyOTP(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      if (userCredential != null) {
        await _loadCurrentUser();
        return true;
      }
      return false;
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return false;
    }
  }

  Future<bool> staffLogin(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final userCredential = await _authService.staffLogin(
        email: email,
        password: password,
      );

      if (userCredential != null) {
        await _loadCurrentUser();
        return true;
      }
      return false;
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return false;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    try {
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

// Phone verification state provider
class PhoneVerificationNotifier extends StateNotifier<String?> {
  PhoneVerificationNotifier() : super(null);

  void setVerificationId(String verificationId) {
    state = verificationId;
  }

  void clear() {
    state = null;
  }
}

final phoneVerificationProvider =
    StateNotifierProvider<PhoneVerificationNotifier, String?>((ref) {
  return PhoneVerificationNotifier();
});
