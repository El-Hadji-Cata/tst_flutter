import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tst_flutter/Api/fetch_api.dart';

class AddChannel extends StatefulWidget {
  final String serverId;

  const AddChannel({Key? key, required this.serverId}) : super(key: key);

  @override
  _AddChannelState createState() => _AddChannelState();
}

class _AddChannelState extends State<AddChannel> {

  final _formKey = GlobalKey<FormState>();
  final nameChannelController = TextEditingController();

  @override
  void dispose() {
    nameChannelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Canal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameChannelController,
                decoration: const InputDecoration(
                  labelText: 'Nom du canal',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez compléter le champ';
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
                    if (_formKey.currentState!.validate() && user != null) {

                      final nameChannel = nameChannelController.text;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Création du canal en cours...")),
                      );

                      final newChannel = await addChannel(
                        serverId: widget.serverId,
                        name: nameChannel,
                        userId: user.uid, // CORRECTION : On passe le userId
                      );

                      if (newChannel != null && mounted) {
                        Navigator.pop(context, true);
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Erreur lors de la création du canal.")),
                        );
                      }
                    }
                  },
                  child: const Text("Créer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
