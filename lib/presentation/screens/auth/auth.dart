import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocr_app_20230902/application/state/auth_provider.dart';
import 'package:ocr_app_20230902/presentation/screens/home.dart';
import 'package:ocr_app_20230902/presentation/widgets/auth_button.dart';
import 'package:ocr_app_20230902/presentation/widgets/auth_form.dart';

class Auth extends ConsumerWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final int authPage = ref.watch(switchAuthPageProvider);
    final String mailAdress = ref.watch(mailAdressProvider);
    final String password = ref.watch(passwordProvider);
    final _formKey = GlobalKey<FormState>();
    final _auth = FirebaseAuth.instance;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: authPage == 0 ? Text("ログイン") : Text("新規登録"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        color: Colors.grey[400],
        child: Center(
          child: Column(
            children: [
              authPage == 0
                  ? Container(
                      color: Colors.grey[200],
                      padding: EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 50.0),
                      margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              AuthForm(
                                providerName: 'mailAdressProvider',
                                labelText: 'メールアドレス',
                                errorText: 'メールアドレスを入力してください',
                              ),
                              AuthForm(
                                providerName: 'passwordProvider',
                                labelText: 'パスワード',
                                errorText: 'パスワードを入力してください',
                              ),
                              Text(mailAdress),
                              Text(password),
                              SizedBox(
                                height: 30,
                              ),
                              AuthButton(
                                onPressed: () async {
                                  try {
                                    //ログイン処理
                                    final user =
                                        await _auth.signInWithEmailAndPassword(
                                            email: mailAdress,
                                            password: password);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()));
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'invalid-email') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(''),
                                        ),
                                      );
                                      print('メールアドレスのフォーマットが正しくありません');
                                    } else if (e.code == 'user-disabled') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('現在指定したメールアドレスは使用できません'),
                                        ),
                                      );
                                      print('現在指定したメールアドレスは使用できません');
                                    } else if (e.code == 'user-not-found') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('指定したメールアドレスは登録されていません'),
                                        ),
                                      );
                                      print('指定したメールアドレスは登録されていません');
                                    } else if (e.code == 'wrong-password') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('パスワードが間違っています'),
                                        ),
                                      );
                                      print('パスワードが間違っています');
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('ログインできません'),
                                        ),
                                      );
                                      print('ログインできません');
                                    }
                                  }
                                },
                                buttonText: 'ログイン',
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              if (authPage == 0)
                                ref
                                    .read(switchAuthPageProvider.notifier)
                                    .state = 1;
                              if (authPage == 1)
                                ref
                                    .read(switchAuthPageProvider.notifier)
                                    .state = 0;
                              // ref.read(mailAdressProvider.notifier).state = "";
                              // ref.read(passwordProvider.notifier).state = "";
                            },
                            child: authPage == 0
                                ? Text("新規登録ページへ")
                                : Text("ログインページへ"),
                          )
                        ],
                      ),
                    )
                  : Container(
                      color: Colors.blueGrey[100],
                      padding: EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 50.0),
                      margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              AuthForm(
                                providerName: 'mailAdressProvider',
                                labelText: 'メールアドレス',
                                errorText: 'メールアドレスを入力してください',
                              ),
                              AuthForm(
                                providerName: 'passwordProvider',
                                labelText: 'パスワード',
                                errorText: 'パスワードを入力してください',
                              ),
                              Text(mailAdress),
                              Text(password),
                              SizedBox(
                                height: 30,
                              ),
                              AuthButton(
                                onPressed: () async {
                                  try {
                                    final user = await _auth
                                        .createUserWithEmailAndPassword(
                                            email: mailAdress,
                                            password: password);
                                    //ページ遷移
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()));
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'email-already-in-use') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('指定したメールアドレスは登録済みです'),
                                        ),
                                      );
                                      print('指定したメールアドレスは登録済みです');
                                    } else if (e.code == 'invalid-email') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('メールアドレスのフォーマットが正しくありません'),
                                        ),
                                      );
                                      print('メールアドレスのフォーマットが正しくありません');
                                    } else if (e.code ==
                                        'operation-not-allowed') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '指定したメールアドレス・パスワードは現在使用できません'),
                                        ),
                                      );
                                      print('指定したメールアドレス・パスワードは現在使用できません');
                                    } else if (e.code == 'weak-password') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('パスワードは６文字以上にしてください'),
                                        ),
                                      );
                                      print('パスワードは６文字以上にしてください');
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('アカウントを作成できません'),
                                        ),
                                      );
                                      print('アカウントを作成できません');
                                    }
                                  }
                                },
                                buttonText: '新規登録',
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              if (authPage == 0)
                                ref
                                    .read(switchAuthPageProvider.notifier)
                                    .state = 1;
                              if (authPage == 1)
                                ref
                                    .read(switchAuthPageProvider.notifier)
                                    .state = 0;
                              // ref.read(mailAdressProvider.notifier).state = "";
                              // ref.read(passwordProvider.notifier).state = "";
                            },
                            child: authPage == 0
                                ? Text("新規登録ページへ")
                                : Text("ログインページへ"),
                          )
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
