import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tst_flutter/Api/channel/add_channel.dart';
import 'package:tst_flutter/Api/fetch_api.dart';
import 'package:tst_flutter/Api/server/add_server.dart';
import 'package:tst_flutter/login/login.dart';
import 'package:tst_flutter/pages/second_page.dart';
import 'package:tst_flutter/pages/second_page/first_content.dart';
import 'package:tst_flutter/widgets/counter_widget.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDark = false;
  final userId = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(brightness: isDark ? Brightness.dark : Brightness.light);
    return MaterialApp(

      theme: themeData,
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Bienvenue sur l'App",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),),

                /*SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Image.asset("images/profile.png"),
              ),

              CounterWidget(),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              //fetchApi();
                              if(userId != null) {
                                //userId!.uid
                                fetchServersForUser("user123");
                              } else {
                                print("L'utilisateur n'est pas connecté");
                              }
                            },
                            child: const Text("Serveurs"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddServer()),
                              );
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              fetchChannelsForServer("4dy0sgHXnSdmvQOJezBo", "user123");
                            },
                            child: const Text("Canaux"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddChannel()),
                              );
                              //addChannel(serverId: "abc123", name: "gaming");
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text("Messages"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const Login()),
                              (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: const Icon(Icons.logout),

                  ),
                ),
                Tooltip(
                  message: 'Change brightness mode',
                  child: IconButton(
                    isSelected: isDark,
                    onPressed: () {
                      setState(() {
                        isDark = !isDark;
                      });
                    },
                    icon: const Icon(Icons.wb_sunny_outlined),
                    selectedIcon: const Icon(Icons.brightness_2_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Counter: 15
// Button : incrementer le counter
