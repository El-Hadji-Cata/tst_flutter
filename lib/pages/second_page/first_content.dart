import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tst_flutter/login/login.dart';
import 'package:tst_flutter/pages/second_page/second_content.dart';
import 'package:tst_flutter/widgets/navbar/bottom_icon.dart';
import 'package:tst_flutter/widgets/searchBar/search_bar_app.dart';
import 'package:tst_flutter/widgets/searchBar/standard_search_anchor.dart';


class FirstContent extends StatelessWidget {
  const FirstContent({super.key});

  @override
  Widget build(BuildContext context) {
    String nameServer = "M2I Formation - Dev Mobile";
    return Scaffold(
      body: Row(
        children: [
          Column(
            children: [
                OutlinedButton(
                  onPressed: () {},
                  child: Center(child: const Icon(Icons.message_rounded)),
                ),

              OutlinedButton(
                onPressed: () {},
                child: const Icon(Icons.person),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()) );

                },
                child: const Icon(Icons.login),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ],
          ),
          VerticalDivider(),
          Column(
            children: [
              Text(nameServer),
              SizedBox(
                child: Row(
                  children: [
                    SizedBox(
                      width: 300.0,
                        height: 50.0,
                        child: SearchBarApp()
                    ),
                    Icon(Icons.insert_invitation),
                    Icon(Icons.event),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                width: 200.0,
                height: 300.0,
                child: ListView(
                  children: [
                    Container(
                      child: Center(child: Text("> Informations")),
                    ),
                    Container(
                      child: Center(child: Text("> Salons textuels")),
                    ),
                    Container(
                      child: Center(child: Text("> Salons vocaux")),
                    ),
                  ],
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}
