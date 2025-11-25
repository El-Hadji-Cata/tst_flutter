import 'package:flutter/material.dart';
import 'package:tst_flutter/pages/profile_page.dart';
import 'package:tst_flutter/widgets/navbar/bottom_nav_bar.dart';

class ThirdContent extends StatelessWidget {
  const ThirdContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Hero(
              tag: "profilePicture",
              child: Material(
                color: Colors.amber,
                borderRadius: .circular(500),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  },
                  borderRadius: .circular(500),
                  child: ClipRRect(
                    borderRadius: .circular(500),
                    child: Image.asset(
                      "images/profile.png",
                      height: MediaQuery.of(context).size.width / 7.5,
                      width: MediaQuery.of(context).size.width / 7.5,
                      fit: .cover,
                    ),
                  ),
                ),
              ),
            ),
            Text("Ndiaye"),
          ],
      ),
    );
  }
}

