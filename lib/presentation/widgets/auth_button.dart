import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocr_app_20230902/application/state/auth_provider.dart';
//ll
class AuthButton extends ConsumerWidget {
  const AuthButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    // required this.errorText,
  });

  final VoidCallback onPressed;
  final String buttonText;
  // final String errorText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// レイアウト
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.blueAccent,
        // ボタンの背景色
        onPrimary: Colors.white,
        // ボタンのテキスト色
        elevation: 8,
        // 影の大きさ
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(5), // ボタンの角丸
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12), // ボタンの内側のパディング
      ),
      child: Text(
        buttonText,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
