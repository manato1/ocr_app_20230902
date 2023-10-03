import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocr_app_20230902/application/state/auth_provider.dart';

class PostTile extends ConsumerWidget {
  const PostTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.text,
    required this.trailing,
    // required this.errorText,
  });

  final Text title;
  final Text subtitle;
  final Text text;
  final IconButton trailing;
  // final String errorText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// レイアウト
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              text,
              subtitle
            ],
          ),
          trailing,
        ],
      ),
    );
  }
}
