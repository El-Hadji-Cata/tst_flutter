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
    const serverId = "3FaS3lzbJ6AzznZ310g8";
    const authorId = "x4S39GlVDpftERhBX3eJnhpZ0n42";
    const authorName = "Hugo";
    final authorAvatarUrl = "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes-thumbnail.png";
    const channelId = "user123";

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
                            onPressed: () {
                              fetchMessageForChannel(channelId, serverId);
                            },
                            child: const Text("Messages"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              addMessage(serverId: serverId, authorId: authorId, authorName: authorName, authorAvatarUrl: authorAvatarUrl, channelId: channelId, content: "Test message avatar change");
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
                              fetchReactionsForMessage("x4S39GlVDpftERhBX3eJnhpZ0n42", "👍", "NKIQxGkMmLmjkfniaErw");
                            },
                            child: const Text("Réactions"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              addReaction(userId: "x4S39GlVDpftERhBX3eJnhpZ0n42", emoji: "👍", messageId: "NKIQxGkMmLmjkfniaErw");
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddServer()),
                              );*/
                            },
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
