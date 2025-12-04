import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tst_flutter/Api/fetch_api.dart';

class AddServer extends StatefulWidget {
  const AddServer({Key? key}) : super(key: key);

  @override
  _AddServerState createState() => _AddServerState();
}

class _AddServerState extends State<AddServer> {

  final _formKey = GlobalKey<FormState>();
  final nameServerController = TextEditingController();
  final imageUrlController = TextEditingController();


  @override
  void dispose() {
    nameServerController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un serveur"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameServerController,
                decoration: const InputDecoration(
                  labelText: 'Nom du serveur',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom pour le serveur';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: "Url de l'image du serveur",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un UrlImage pour le serveur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Création du serveur en cours...")),
                      );

                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text("Erreur : Utilisateur non connecté.")),
                        );
                        return;
                      }

                      final serverName = nameServerController.text;
                      final imageUrl = imageUrlController.text;
                      
                      // Appeler l'API et attendre le résultat
                      final newServer = await addServer(
                        name: serverName,
                        ownerId: user.uid,
                        imageUrl: imageUrl,
                      );

                      // Si la création a réussi et que le widget est toujours monté
                      if (newServer != null && mounted) {
                        // Fermer cette page et renvoyer 'true' à la page précédente
                        Navigator.pop(context, true);
                      } else if (mounted) {
                        // Afficher un message d'erreur si la création a échoué
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Erreur : La création du serveur a échoué.")),
                        );
                      }
                    }
                  },
                  child: const Text("Créer le serveur"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
