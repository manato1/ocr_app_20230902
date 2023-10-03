import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocr_app_20230902/infrastructure/firebase/firebase.dart';

//自分のカテゴリーを取る
final myCategoryProvider = FutureProvider((ref) async {
  final QuerySnapshot querySnapshot = await DefaultFirebaseService()
      .db
      .collection("category")
      // .where("user_id", isEqualTo: DefaultFirebaseService().uid)
      .get();
  return querySnapshot;
});

final memberListStreamProvider = StreamProvider((ref) {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('category');
  final stream = collection
      .where("user_id", isEqualTo: DefaultFirebaseService().uid)
      .snapshots()
      .map(
        (e) => e.docs.map((e) => e.data()).toList(),
      );
  return stream;
});

class Post {
  Post(
    this.id,
    this.uName,
    this.profileImage,
  );

  String id;
  String uName;
  String profileImage;
}
