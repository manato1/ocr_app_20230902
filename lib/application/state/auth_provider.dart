import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authProvider = StreamProvider((ref) => FirebaseAuth.instance.authStateChanges());
final userProfile = Provider((ref){
  ref.watch(authProvider);
  final User? uid = FirebaseAuth.instance.currentUser;
  return uid;
});
// ユーザー情報の受け渡しを行うためのProvider
final switchAuthPageProvider = StateProvider((ref) {
  //signin 0
  //signout 1
  return 0;
});
final mailAdressProvider = StateProvider.autoDispose((ref) {
  return "";
});
final passwordProvider = StateProvider((ref) {
  return "";
});