import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocr_app_20230902/application/state/add_category_provider.dart';
import 'package:ocr_app_20230902/application/state/choose_category_provider.dart';
import 'package:ocr_app_20230902/application/state/my_category_provider.dart';
import 'package:ocr_app_20230902/infrastructure/firebase/firebase.dart';

class ChooseCategory extends ConsumerWidget {
  const ChooseCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryQuerySnapshot = ref.watch(myCategoryProvider);
    final String chooseCategory = ref.watch(chooseCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("カテゴリー選択"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // 戻るアイコン
          onPressed: () {
            Navigator.pop(context,chooseCategory); // 前の画面に戻る
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            categoryQuerySnapshot.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => const Text('error'),
              data: (data) {
                final categoryTileList = data.docs.map((DocumentSnapshot data) {
                  Map<String, dynamic> category =
                  data.data() as Map<String, dynamic>;
                  final categoryId = data.id;
                  final categoryName = category["category_name"];
                  return RadioListTile(
                    title: Text(categoryName),
                    value: categoryId,
                    groupValue: chooseCategory,
                    onChanged: (value) =>
                    ref
                        .read(chooseCategoryProvider.notifier)
                        .state = value.toString(),
                  );
                  // return Text(categoryName);
                }).toList();
                if (categoryTileList.isNotEmpty) {
                  final radioFirstWidget = RadioListTile(
                    title: Text("なし"),
                    value: "",
                    groupValue: chooseCategory,
                    onChanged: (value) =>
                    ref
                        .read(chooseCategoryProvider.notifier)
                        .state = value.toString(),
                  );
                  categoryTileList.insert(0, radioFirstWidget);
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: categoryTileList,
                  );
                } else {
                  return Center(child: Text("カテゴリーはありません。"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
