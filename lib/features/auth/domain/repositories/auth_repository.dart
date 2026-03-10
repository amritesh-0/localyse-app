import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> signUpWithEmail(String email, String password, String fullName, String role);
  Future<UserCredential> signInWithGoogle();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> updateUserData(String uid, Map<String, dynamic> data);
  Future<bool> checkOnboardingStatus(String uid);
  Future<void> completeOnboarding(String uid);
  Future<Map<String, dynamic>?> getUserData(String uid);
}
