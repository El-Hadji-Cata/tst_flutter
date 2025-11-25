import 'package:flutter/material.dart';
import 'package:tst_flutter/widgets/navbar/bottom_icon.dart';

class BottomNavBar extends StatelessWidget {
  final Function func;

  const BottomNavBar({
    super.key,
    required this.func,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Row(
          mainAxisAlignment: .spaceAround,
          children: [
            BottomIcon(
              icon: Icons.home,
              text: "Accueil",
              color: ColorScheme
                  .light()
                  .primary,
              func: () => func(0),
            ),
            BottomIcon(
              icon: Icons.notification_important,
              text: "Notifications",
              func: () => func(1),
            ),
            BottomIcon(
              icon: Icons.emoji_emotions,
              text: "Toi",
              func: () => func(2),
            ),

          ],
        ),
      ],
    );
  }
}
