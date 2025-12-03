import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageBis extends StatefulWidget {
  const HomePageBis({super.key});

  @override
  State<HomePageBis> createState() => _HomePageBisState();
}

class _HomePageBisState extends State<HomePageBis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Utilisation des couleurs sombres de Discord
      backgroundColor: const Color(0xFF36393F),
      body: Row(
        children: [
          // 1. Colonne des Serveurs (gauche)
          _buildServerList(),

          // 2. Colonne des Salons (centre-gauche)
          _buildChannelList(),

          // 3. Contenu Principal / Chat (droite)
          _buildMainContent(),
        ],
      ),
    );
  }

  /// Construit la colonne de gauche avec la liste des serveurs.
  Widget _buildServerList() {
    return Container(
      width: 70,
      color: const Color(0xFF202225), // Arrière-plan de la liste des serveurs
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildServerIcon(Icons.discord, isSelected: true),
          _buildServerIcon(Icons.games),
          _buildServerIcon(Icons.music_note),
          _buildServerIcon(Icons.add, isAddButton: true),
        ],
      ),
    );
  }

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
              'Mon Serveur Flutter',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // Liste des salons
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildChannelCategory('SALONS TEXTUELS'),
                _buildChannelItem('général', isActive: true),
                _buildChannelItem('questions'),
                _buildChannelCategory('SALONS VOCAUX'),
                _buildChannelItem('Lobby', isVoice: true),
                _buildChannelItem('Gaming', isVoice: true),
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

  // --- Widgets d'aide pour la construction de l'UI ---

  Widget _buildServerIcon(IconData icon, {bool isSelected = false, bool isAddButton = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: isSelected ? Colors.deepPurple : const Color(0xFF36393F),
        child: Icon(icon, color: isAddButton ? Colors.green : Colors.white),
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
      color: const Color(0xFF292B2F), // Couleur de fond du panneau utilisateur
      child: Row(
        children: [
          const CircleAvatar(radius: 20, backgroundColor: Colors.grey), // Remplacer par l'avatar de l'utilisateur
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              user?.email ?? 'Utilisateur', // Affiche l'email ou un texte par défaut
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
