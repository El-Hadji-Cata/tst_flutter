import 'package:flutter/material.dart';
import 'package:tst_flutter/widgets/custom_text.dart';

class CustomButton extends StatefulWidget {
  final Function event;

  const CustomButton({
    super.key,
    required this.event,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF1D4ED8),
      borderRadius: .circular(8),
      child: InkWell(
        onTap: () {
          widget.event();
        },
        splashColor: Colors.green,
        borderRadius: .circular(8),
        child: Container(
          padding: .symmetric(horizontal: 24, vertical: 12),
          child: FittedBox(
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                SizedBox(width: 15),
                CustomText(text: "Incrémenter le counter"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
