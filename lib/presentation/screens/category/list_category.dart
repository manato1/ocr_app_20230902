import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocr_app_20230902/application/state/my_category_provider.dart';
import 'package:ocr_app_20230902/infrastructure/firebase/firebase.dart';
import 'package:ocr_app_20230902/presentation/screens/category/add_category.dart';

class ListCategory extends ConsumerWidget {
  const ListCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryQuerySnapshot = ref.watch(myCategoryProvider);
    final categoryQuerySnadspshot = ref.watch(memberListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("カテゴリー"),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 45.0, // ボタンの幅を20に設定
                  height: 40.0, // ボタンの高さを20に設定
                  decoration: BoxDecoration(
                    color: Colors.blue, // ボタンの背景色を青に設定
                    borderRadius: BorderRadius.circular(10.0), // 角丸にするための半径を設定
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.add, // アイコンを設定
                        color: Colors.white, // アイコンの色を白に設定
                        size: 22.0, // アイコンのサイズを12に設定
                      ),
                      onPressed: () {
                        // ボタンが押されたときのアクションをここに追加
                        print('ボタンが押されました');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddCategory()));
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            // categoryQuerySnadspshot.when(
            //   data: (data) {
            //
            //     return Text;
            //   },
            //   loading: () => const CircularProgressIndicator(),
            //   error: (error, stack) => const Text('error'),
            // ),
            categoryQuerySnadspshot.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => const Text('error'),
              data: (data) {
                if(data.isNotEmpty){
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return ListTile(
                          title: Text(item.category_name),
                          trailing: IconButton(
                              onPressed: () {
                                try {
                                  DefaultFirebaseService().deleteCategory(item.categoryId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('カテゴリーを削除しました。'),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('カテゴリーの削除に失敗しました。'),
                                    ),
                                  );                          }
                              },
                              icon: Icon(Icons.delete)),
                        );
                      }
                  );
                }else{
                  return Center(child: Text("カテゴリーはありません。"))
                }
              },
            ),
            TextButton(onPressed: (){print(categoryQuerySnadspshot);}, child: Text("data")),

            SizedBox(
              height: 40,
            ),
            categoryQuerySnapshot.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => const Text('error'),
              data: (data) {
                final categoryTileList = data.docs.map((DocumentSnapshot data) {
                  Map<String, dynamic> category =
                      data.data() as Map<String, dynamic>;
                  final categoryId = data.id;
                  print(categoryId);
                  final categoryName = category["category_name"];
                  return ListTile(
                    title: Text(categoryName),
                    trailing: IconButton(
                        onPressed: () {
                          try {
                            DefaultFirebaseService().deleteCategory(categoryId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('カテゴリーを削除しました。'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('カテゴリーの削除に失敗しました。'),
                              ),
                            );                          }
                        },
                        icon: Icon(Icons.delete)),
                  );
                  // return Text(categoryName);
                }).toList();
                if (categoryTileList.isNotEmpty) {
                  return Expanded(
                    child: ListView(
                      children: categoryTileList,
                    ),
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
