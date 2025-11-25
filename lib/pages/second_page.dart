import 'package:flutter/material.dart';
import 'package:tst_flutter/pages/profile_page.dart';
import 'package:tst_flutter/pages/second_page/first_content.dart';
import 'package:tst_flutter/pages/second_page/fourth_content.dart';
import 'package:tst_flutter/pages/second_page/second_content.dart';
import 'package:tst_flutter/pages/second_page/third_content.dart';
import 'package:tst_flutter/widgets/navbar/bottom_nav_bar.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int pageIndex = 0;

  List<StatelessWidget> pages = [
    FirstContent(),
    SecondContent(),
    ThirdContent(),
    FourthContent(),
  ];

  void changePage(int newIndex) {
    if (pageIndex != newIndex) {
      setState(() {
        pageIndex = newIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: .only(left: 24, top: 24, right: 24),
        child: Column(
          children: [
            Expanded(
              child: pages[pageIndex],
            ),
            BottomNavBar(func: changePage),
          ],
        ),
      ),
    );
  }
}
