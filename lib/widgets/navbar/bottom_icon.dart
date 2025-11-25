import 'package:flutter/material.dart';

class BottomIcon extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Function() func;

  BottomIcon({
    super.key,
    this.icon = Icons.question_mark_rounded,
    this.text = "Not configured",
    this.color = Colors.black38,
    required this.func,
  });

  @override
  State<BottomIcon> createState() => _BottomIconState();
}

class _BottomIconState extends State<BottomIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.func();
      },
      borderRadius: .circular(50),
      child: Padding(
        padding: .all(16.0),
        child: Column(
          children: [
            Icon(
              widget.icon,
              color: widget.color,
            ),
            Text(
              widget.text,
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }
}
