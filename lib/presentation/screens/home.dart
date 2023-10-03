import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocr_app_20230902/application/state/auth_provider.dart';
import 'package:ocr_app_20230902/presentation/screens/category/choose_category.dart';
import 'package:ocr_app_20230902/presentation/screens/category/list_category.dart';
import 'package:ocr_app_20230902/presentation/screens/ocr/camera.dart';
import 'package:ocr_app_20230902/presentation/screens/post/post_list.dart';
import 'package:ocr_app_20230902/presentation/widgets/home_button.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? userProfiles = ref.read(userProfile);
    final navigator = Navigator.of(context); //ページ遷移の下準備

    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Text(userProfiles != null ? userProfiles.email.toString() : ""),
                SizedBox(height: 10,),
                TextButton(
                    onPressed: () {
                      //ログアウト
                      FirebaseAuth.instance.signOut();
                    },
                    child: Text("ログアウト")),
              ],
            ),
            Column(
              children: [
                TextButton(onPressed: () {}, child: Text("プライバシーポリシー")),
                SizedBox(height: 40,),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              HomeButton(iconData: Icons.map,
                  label: 'カメラ',
                  color: Colors.blueAccent,
                  widget: OcrScreen()),
              HomeButton(iconData: Icons.format_list_bulleted,
                  label: 'メモ一覧',
                  color: Colors.orange,
                  widget: PostList()),
              HomeButton(iconData: Icons.category,
                  label: 'カテゴリー',
                  color: Colors.red,
                  widget: ListCategory()),
            ],
          ),
        ),
      ),
    );
  }
}
