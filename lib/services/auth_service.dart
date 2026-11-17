
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==============================
  // USER
  // ==============================

  // Mendapatkan pengguna yang sedang login
  User? get currentUser => _auth.currentUser;

  // Memantau perubahan status autentikasi
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Memantau perubahan data pengguna
  Stream<User?> get userChanges => _auth.userChanges();

  // Memuat ulang data pengguna dari Firebase
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  // ==============================
  // REGISTER
  // ==============================

  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // ==============================
  // LOGIN
  // ==============================

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // ==============================
  // UPDATE PROFILE
  // ==============================

  // Menyimpan nama lengkap pengguna
  Future<void> updateDisplayName({
    required String displayName,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Tidak ada pengguna yang sedang login.');
    }

    final name = displayName.trim();

    if (name.isEmpty) {
      throw ArgumentError('Nama pengguna tidak boleh kosong.');
    }

    await user.updateDisplayName(name);
    await user.reload();
  }

  // ==============================
  // LOGOUT
  // ==============================

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ==============================
  // RESET PASSWORD
  // ==============================

  Future<void> resetPassword({
    required String email,
  }) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // ==============================
  // EMAIL VERIFICATION
  // ==============================

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Tidak ada pengguna yang sedang login.');
    }

    await user.sendEmailVerification();
  }

  // Memeriksa apakah email sudah diverifikasi
  Future<bool> isEmailVerified() async {
    await reloadUser();

    return _auth.currentUser?.emailVerified ?? false;
  }
}
