import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocr_app_20230902/application/state/choose_category_provider.dart';
import 'package:ocr_app_20230902/application/state/ocr_provider.dart';
import 'package:ocr_app_20230902/infrastructure/firebase/firebase.dart';
import 'package:ocr_app_20230902/presentation/screens/category/choose_category.dart';
import 'package:ocr_app_20230902/presentation/screens/home.dart';

class OcrResult extends StatefulWidget {
  const OcrResult({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  State<OcrResult> createState() => _OcrResultState();
}

class _OcrResultState extends State<OcrResult> {
  String categoryId = "";
  String title = "";
  String resultText = "";
  final _formKey = GlobalKey<FormState>(); //フォームで使用

  @override
  void initState() {
    // TODO: implement initState
    resultText = widget.text;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('追加'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // 戻るアイコン
          onPressed: () {
            Navigator.pop(context); // 前の画面に戻る
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 45.0, // ボタンの幅を20に設定
                    height: 40.0, // ボタンの高さを20に設定
                    decoration: BoxDecoration(
                      color: Colors.red, // ボタンの背景色を青に設定
                      borderRadius: BorderRadius.circular(10.0), // 角丸にするための半径を設定
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.category, // アイコンを設定
                          color: Colors.white,
                          size: 22.0, // アイコンのサイズを12に設定
                        ),
                        onPressed: () async{
                          final category = await Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChooseCategory()));
                          setState(() {
                            categoryId = category as String;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'タイトルを入力してください';
                        }
                        return null;
                      },
                      // 初期値を設定
                      maxLength: 20,
                      onChanged: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "タイトル",
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
                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'テキストを入力してください';
                        }
                        return null;
                      },
                      initialValue: resultText,
                      // 初期値を設定
                      maxLength: 300,
                      onChanged: (value) {
                        setState(() {
                          resultText = value;
                        });
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
                      maxLines: 10 /*最大行数*/,
                    ),
                    SizedBox(height: 35,),
                    TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await DefaultFirebaseService()
                                  .addPost(categoryId, title, resultText);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Home(), // ホーム画面に遷移
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('追加しました。'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('追加できません。'),
                                ),
                              );
                              print("エラー");
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.fromLTRB(20, 13, 20, 13)),
                        child: Text("追加する")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//
// class ResultScreen extends ConsumerWidget {
//   const ResultScreen({super.key, required this.text});
//
//   final String text; // カメラのテキスト情報を受け取るコンストラクタ
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final String resultText = ref.watch(ocrResultProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Result'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back), // 戻るアイコン
//           onPressed: () {
//             print("object");
//             Navigator.pop(context); // 前の画面に戻る
//           },
//         ),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(30.0),
//         child: Column(
//           children: [
//             TextFormField(
//               // validator: (value) {
//               //   if (value == null || value.isEmpty) {
//               //     return 'テキストを入力してください';
//               //   }
//               //   return null;
//               // },
//               initialValue: text,
//               // 初期値を設定
//               maxLength: 300,
//               onChanged: (value) {
//                 ref.read(ocrResultProvider.notifier).state = value;
//               },
//               decoration: InputDecoration(
//                 fillColor: Colors.white,
//                 filled: true,
//                 enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black87)),
//                 focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black87)),
//               ),
//               keyboardType: TextInputType.multiline,
//               maxLines: 10 /*最大行数*/,
//             ),
//             Text(resultText),
//           ],
//         ),
//       ),
//     );
//   }
// }
