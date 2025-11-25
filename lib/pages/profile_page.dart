import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.chevron_left, size: 50),
              ),
            ],
          ),
          Center(
            child: Hero(
              tag: "profilePicture",
              child: Image.asset("images/profile.png"),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
