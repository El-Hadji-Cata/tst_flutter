import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tst_flutter/Api/fetch_api.dart';
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
  final userId = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.center, // <-- Ajout de cette ligne pour centrer
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
                            addServer(name: "Mon Super Serveur", ownerId: "user123");
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
                          child: const Text("Canaux"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            addChannel(serverId: "abc123", name: "général");
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
            ],
          ),
        ), 
      ),
    );
  }
}

// Counter: 15
// Button : incrementer le counter
