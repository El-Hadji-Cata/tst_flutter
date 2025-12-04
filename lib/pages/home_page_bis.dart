import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tst_flutter/Api/fetch_api.dart'; // Importation nécessaire

class HomePageBis extends StatefulWidget {
  const HomePageBis({super.key});

  @override
  State<HomePageBis> createState() => _HomePageBisState();
}

class _HomePageBisState extends State<HomePageBis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF36393F),
      body: Row(
        children: [
          _buildServerList(),

          _buildChannelList(),
          _buildMainContent(),
        ],
      ),
    );
  }

  /// Construit la colonne de gauche en appelant l'API pour récupérer les serveurs.
  Widget _buildServerList() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Si l'utilisateur n'est pas connecté, on affiche une colonne vide
      return Container(width: 70, color: const Color(0xFF202225));
    }

    return Container(
      width: 70,
      color: const Color(0xFF202225),
      child: FutureBuilder<List<dynamic>>(
        // On appelle la fonction qui retourne la liste des serveurs
        future: fetchServersForUser(user.uid),
        builder: (context, snapshot) {
          // 1. En cours de chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. En cas d'erreur
          if (snapshot.hasError) {
            return const Center(child: Icon(Icons.error, color: Colors.red));
          }

          // 3. Si les données sont reçues
          if (snapshot.hasData) {
            final servers = snapshot.data!;


            if (servers.isEmpty) {
              return const Center(child: Text("Aucun serveur", style: TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center,));
            }
            
            // On construit la liste des serveurs à partir des données de l'API
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: servers.length,
              itemBuilder: (context, index) {
                final server = servers[index];
                // On passe l'objet serveur complet à la fonction de construction de l'icône
                return _buildServerIcon(server: server);
              },
            );
          }

          // Par défaut (ne devrait pas arriver)
          return const Center(child: Icon(Icons.error, color: Colors.orange));
        },
      ),
      
    );
  }

  // ... (le reste de votre code reste identique)

  /// Construit la colonne du milieu avec les salons et le panneau utilisateur.
  Widget _buildChannelList() {
    return Container(
      width: 240,
      color: const Color(0xFF2F3136), // Arrière-plan de la liste des salons
      child: Column(
        children: [
          // Nom du serveur en haut
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.2))),
            ),
            child: const Text(
              'Mon Canal Flutter',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // Liste des salons
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                /*_buildChannelCategory('SALONS TEXTUELS'),
                _buildChannelItem('général', isActive: true),
                _buildChannelItem('questions'),
                _buildChannelCategory('SALONS VOCAUX'),
                _buildChannelItem('Lobby', isVoice: true),
                _buildChannelItem('Gaming', isVoice: true),*/
              ],
            ),
          ),

          // Panneau utilisateur en bas
          _buildUserPanel(),
        ],
      ),
    );
  }

  /// Construit la zone de contenu principale à droite.
  Widget _buildMainContent() {
    return Expanded(
      child: Column(
        children: [
          // Barre supérieure avec le nom du salon
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.2))),
            ),
            child: const Row(
              children: [
                Icon(Icons.tag, color: Colors.grey),
                SizedBox(width: 8),
                Text('général', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Zone des messages (à remplir)
          const Expanded(
            child: Center(
              child: Text('Les messages du chat apparaîtront ici.', style: TextStyle(color: Colors.grey)),
            ),
          ),

          // Champ de saisie de message
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF40444B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Envoyer un message à #général',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.send, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildServerIcon({required Map<String, dynamic> server, bool isSelected = false}) {
    final String? imageUrl = server['imageUrl'];
    final String serverName = server['name'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: isSelected ? Colors.deepPurple : const Color(0xFF36393F),
        // Utilise NetworkImage si l'URL est disponible, sinon reste vide.
        backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
            ? NetworkImage(imageUrl)
            : null,
        // Si pas d'image, affiche la première lettre du nom.
        child: (imageUrl == null || imageUrl.isEmpty)
            ? Text(
                serverName.isNotEmpty ? serverName[0].toUpperCase() : '',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              )
            : null,
      ),
    );
  }

  Widget _buildChannelCategory(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(name, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildChannelItem(String name, {bool isActive = false, bool isVoice = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isActive ? Colors.grey.withOpacity(0.2) : Colors.transparent,
      child: Row(
        children: [
          Icon(isVoice ? Icons.volume_up : Icons.tag, color: Colors.grey, size: 20),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildUserPanel() {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF292B2F),
      child: Row(
        children: [
          const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              user?.email ?? 'Utilisateur',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(icon: const Icon(Icons.mic, color: Colors.grey), onPressed: () {}),
          IconButton(icon: const Icon(Icons.headset, color: Colors.grey), onPressed: () {}),
        ],
      ),
    );
  }
}
