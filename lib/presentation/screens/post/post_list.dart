import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocr_app_20230902/application/state/my_category_provider.dart';
import 'package:ocr_app_20230902/application/state/post_list_provider.dart';
import 'package:ocr_app_20230902/infrastructure/firebase/firebase.dart';
import 'package:ocr_app_20230902/presentation/screens/category/add_category.dart';
import 'package:ocr_app_20230902/presentation/widgets/post_tile.dart';
import 'package:intl/intl.dart';

class PostList extends ConsumerWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postListQuerySnapshot = ref.watch(postListProvider);
    final postCategory = ref.watch(postCategoryProvider);
    final myCategory = ref.watch(myCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("メモ"),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                myCategory.when(
                  loading: () => SizedBox.shrink(),
                  error: (error, stack) => Text("error"),
                  data: (data) {
                    final defaultItem = DropdownMenuItem<String>(
                      value: "",
                      child: Text("全て"),
                    );
                    final dropdownItem = data.docs.map((DocumentSnapshot data) {
                      Map<String, dynamic> category =
                          data.data() as Map<String, dynamic>;
                      final categoryId = data.id;
                      final categoryName = category["category_name"];
                      return DropdownMenuItem<String>(
                        value: categoryId,
                        child: Text(categoryName),
                      );
                      // return Text(categoryName);
                    }).toList();
                    dropdownItem.insert(0, defaultItem);
                    return DropdownButton<String>(
                        value: postCategory,
                        onChanged: (newValue) {
                          ref.read(postCategoryProvider.notifier).state =
                              newValue!;
                        },
                        items: dropdownItem);
                  },
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            Text(postCategory),
            postListQuerySnapshot.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => const Text('error'),
              data: (data) {
                final postTileList = data.docs.map((DocumentSnapshot data) {
                  Map<String, dynamic> post =
                      data.data() as Map<String, dynamic>;
                  final postId = data.id;
                  final title = post["title"];
                  final text = post["text"];
                  final createdAt = DateFormat('yyyy/MM/dd')
                      .format(post["created_at"].toDate());
                  return PostTile(
                    title: Text(
                      title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(createdAt.toString()),
                    text: Text(
                      text,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 17),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          try {
                            DefaultFirebaseService().deletePost(postId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('削除しました。'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('削除できません。'),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 30,
                        )),
                  );
                  // return Text(categoryName);
                }).toList();
                if (postTileList.isNotEmpty) {
                  return Expanded(
                    child: ListView(
                      children: postTileList,
                    ),
                  );
                } else {
                  return Center(child: Text("メモはありません。"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
