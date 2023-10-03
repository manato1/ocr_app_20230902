import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocr_app_20230902/application/state/add_category_provider.dart';
import 'package:ocr_app_20230902/application/state/my_category_provider.dart';
import 'package:ocr_app_20230902/infrastructure/firebase/firebase.dart';
import 'package:ocr_app_20230902/presentation/screens/category/list_category.dart';

class AddCategory extends ConsumerWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryName = ref.watch(addCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("カテゴリー追加"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Column(
          children: [
            TextFormField(
              maxLength: 10,
              onChanged: (value) {
                ref.read(addCategoryProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87)),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 1 /*最大行数*/,
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  DefaultFirebaseService().addCategory(categoryName);
                  Navigator.pop(context); // 前の画面に戻る
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('カテゴリーを追加しました。'),
                    ),
                  );
                } catch (e) {
                  print("エラー");
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.fromLTRB(20, 13, 20, 13)),
              child: Text('追加する'),
            ),
          ],
        ),
      ),
    );
  }
}
