import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tst_flutter/Api/fetch_api.dart';
import 'package:tst_flutter/pages/home_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 110.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 100,
                    child: Image.asset('images/discord.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone number, email or username',
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: passwordController ,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    ),
              ),
            ),
            SizedBox(
              height: 65,
              width: 360,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    child: Text(
                      'Log in ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () async { // Rendre la fonction asynchrone
                      if(emailController.text.isNotEmpty && passwordController.text.length > 6)
                        {
                          await loginUser();
                          // Après une connexion réussie, l'utilisateur est disponible via FirebaseAuth.instance.currentUser
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null && mounted) {
                            // Vous pouvez maintenant accéder aux informations de l'utilisateur
                            print("Utilisateur connecté: ${user.uid}");
                            print("Email: ${user.email}");


                            // Naviguer vers la page d'accueil
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const HomePage())
                            );
                          }
                        }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigoAccent,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 65,
              width: 360,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextButton(
                    onPressed: () async { // Rendre la fonction asynchrone
                    try {
                      final auth = FirebaseAuth.instance;
                      final userCredential = await auth.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                      );
                      // Après une inscription réussie, l'utilisateur est disponible
                      final user = userCredential.user;
                       if (user != null && mounted) {
                          print('Nouvel utilisateur inscrit: ${user.uid}');
                          // Naviguer vers la page d'accueil
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const HomePage())
                          );
                        }
                    } on FirebaseAuthException catch (e) {
                        // Gérer les erreurs (ex: email déjà utilisé)
                        print("Erreur d'inscription: ${e.message}");
                    }
                  },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigoAccent,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )
                      ),
                    child: Text( 'Inscription ', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                    ),
              ),
            ),

            SizedBox(
              height: 50,
            ),
            Container(
                child: Center(
                  child: Row(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 62),
                        child: Text('Forgot your login details? '),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left:1.0),
                        child: InkWell(
                            onTap: (){
                              print('hello');
                            },
                            child: Text('Get help logging in.', style: TextStyle(fontSize: 14, color: Colors.blue),)),
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Future <void> loginUser() async {
    try {
      final auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
    } on FirebaseAuthException catch (e) {
      // Idéalement, affichez une erreur à l'utilisateur ici (ex: avec un SnackBar)
      print("Erreur de connexion: \${e.message}");
    }
  }

}
