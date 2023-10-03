import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocr_app_20230902/application/state/auth_provider.dart';

class AuthForm extends ConsumerWidget {
  const AuthForm({
    super.key,
    required this.providerName,
    required this.labelText,
    required this.errorText,
  });

  final String providerName;
  final String labelText;
  final String errorText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// レイアウト
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        return null;
      },
      onChanged: (value) async {
        if (providerName == "mailAdressProvider")
          ref.read(mailAdressProvider.notifier).state = value;
        if (providerName == "passwordProvider")
          ref.read(passwordProvider.notifier).state = value;
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
