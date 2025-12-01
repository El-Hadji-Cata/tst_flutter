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
  final ownerIdController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    nameServerController.dispose();
    ownerIdController.dispose();
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
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nom du serveur',
                    hintText: 'Entrez le nom du serveur',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez completer les champs';
                    }
                    return null;
                  },
                  controller: nameServerController,
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'NOwnerId du serveur',
                    hintText: 'Entrez le ownerId du serveur',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez completer les champs';
                    }
                    return null;
                  },
                  controller: ownerIdController,
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {

                        final nameServer = nameServerController.text;
                        final ownerId = ownerIdController.text;

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Envoi en cours ....."),
                            ),
                        );
                        print("Nom du serveur: $nameServer");
                        print("OwnerId du serveur: $ownerId");

                        addServer(name: nameServer, ownerId: ownerId);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Envoyer"),
                ),
              ),

            ],
          ),
      ),
      ),
    );
  }
}
