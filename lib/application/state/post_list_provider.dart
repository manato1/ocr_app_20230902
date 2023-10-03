import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocr_app_20230902/infrastructure/firebase/firebase.dart';

final postListProvider = FutureProvider((ref) async {
  QuerySnapshot querySnapshot;
  final postCategory = ref.watch(postCategoryProvider);

  if (postCategory == "") {
    querySnapshot = await DefaultFirebaseService()
        .db
        .collection("post")
        .where("user_id", isEqualTo: DefaultFirebaseService().uid)
        .get();
  } else {
    querySnapshot = await DefaultFirebaseService()
        .db
        .collection("post")
        .where("category_id", isEqualTo: postCategory)
        .where("user_id", isEqualTo: DefaultFirebaseService().uid)
        .get();
  }

  return querySnapshot;
});

final postCategoryProvider = StateProvider<String>((ref) {
  return "";
});
