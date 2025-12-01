import 'package:flutter/material.dart';
import 'package:tst_flutter/Api/fetch_api.dart';

class AddChannel extends StatefulWidget {
  const AddChannel({Key? key}) : super(key: key);

  @override
  _AddChannelState createState() => _AddChannelState();
}

class _AddChannelState extends State<AddChannel> {

  final _formKey = GlobalKey<FormState>();

  final nameChannelController = TextEditingController();
  final idController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    nameChannelController.dispose();
    idController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Channel"),
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
                    labelText: 'Nom du channel',
                    hintText: 'Entrez le nom du channel',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez completer les champs';
                    }
                    return null;
                  },
                  controller: nameChannelController,
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Id du serveur',
                    hintText: 'Entrez l Id du serveur',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez completer les champs';
                    }
                    return null;
                  },
                  controller: idController,
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()) {

                      final nameChannel = nameChannelController.text;
                      final idServer = idController.text;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Envoi en cours ....."),
                        ),
                      );
                      print("Nom du channel: $nameChannel");
                      print("Id du serveur: $idServer");

                      addChannel(serverId: idServer, name: nameChannel);

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
