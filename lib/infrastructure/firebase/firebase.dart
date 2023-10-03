import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseService {
  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  addPost(category_id,title,text)async{
    final doc = db.collection("post").doc();
    await doc.set({
      "user_id": uid,
      "category_id": category_id,
      "title": title,
      "text": text,
      "created_at": Timestamp.now(),
    });
  }
  deletePost(collectionId){
    db.collection('post').doc(collectionId).delete();
  }
  addCategory(category_name)async{
    final doc = db.collection("category").doc();
    await doc.set({
      "user_id": uid,
      "category_name": category_name,
      "created_at": Timestamp.now(),
    });
  }
  deleteCategory(collectionId){
    db.collection('category').doc(collectionId).delete();
  }
}