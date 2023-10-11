import 'package:flutter/material.dart';
//test
//ss
//ntt
class HomeButton extends StatelessWidget {
  const HomeButton({
    super.key,
    required this.iconData,
    required this.label,
    required this.color,
    required this.widget,
  });

  final IconData iconData;
  final String label;
  final Color color;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: EdgeInsets.fromLTRB(40.0, 10, 40, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color, // background
        ),
        onPressed: () {
          // ボタンが押された時の処理
          Navigator.push(
              context,
              MaterialPageRoute(
                // （2） 実際に表示するページ(ウィジェット)を指定する
                  builder: (context) => widget));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(iconData, color: Colors.white, size: 30),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}