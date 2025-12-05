import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tst_flutter/Api/channel/add_channel.dart';
import 'package:tst_flutter/Api/fetch_api.dart';
import 'package:tst_flutter/Api/server/add_server.dart';

import '../login/login.dart';

class HomePageBis extends StatefulWidget {
  const HomePageBis({super.key});

  @override
  State<HomePageBis> createState() => _HomePageBisState();
}

class _HomePageBisState extends State<HomePageBis> {
  String? _selectedServerId;
  String? _selectedChannelId;
  late Future<List<dynamic>> _serversFuture;
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadServers();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _loadServers() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _serversFuture = fetchServersForUser(user.uid);
    } else {
      _serversFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFF36393F),
      body: Row(
        children: [
          _buildServerList(),
          _buildChannelList(serverId: _selectedServerId, userId: user?.uid),
          _buildMainContent(serverId: _selectedServerId, channelId: _selectedChannelId, user: user),
        ],
      ),
    );
  }

  Widget _buildServerList() {
    return Container(
        width: 70,
        color: const Color(0xFF202225),
        child: FutureBuilder<List<dynamic>>(
            future: _serversFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Icon(Icons.error, color: Colors.red));
              }
              if (snapshot.hasData) {
                final servers = snapshot.data!;
                if (_selectedServerId == null && servers.isNotEmpty) {
                  _selectedServerId = servers.first['id'];
                }
                return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: servers.length + 1,
                    itemBuilder: (context, index) {
                      if (index == servers.length) {
                        return _buildAddServerButton();
                      }
                      final server = servers[index];
                      final isSelected = server['id'] == _selectedServerId;
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedServerId != server['id']) {
                                _selectedChannelId = null;
                              }
                              _selectedServerId = server['id'];
                            });
                          },
                          child: _buildServerIcon(server: server, isSelected: isSelected));
                    });
              }
              return const Center(child: Icon(Icons.error, color: Colors.orange));
            }));
  }

  Widget _buildAddServerButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddServer()),
              );
              if (result == true) {
                setState(() {
                  _loadServers();
                });
              }
            },
            child: const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFF36393F),
                child: Icon(Icons.add, color: Colors.green, size: 30))));
  }

  Widget _buildServerIcon({required Map<String, dynamic> server, bool isSelected = false}) {
    final String? imageUrl = server['imageUrl'];
    final String serverName = server['name'] ?? '';
    final Widget fallbackIcon = Text(
      serverName.isNotEmpty ? serverName[0].toUpperCase() : '',
      style: const TextStyle(color: Colors.white, fontSize: 24),
    );
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CircleAvatar(
            radius: 25,
            backgroundColor: isSelected ? Colors.deepPurple : const Color(0xFF36393F),
            child: (imageUrl != null && imageUrl.isNotEmpty)
                ? ClipOval(
                    child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) => fallbackIcon,
                  ))
                : fallbackIcon));
  }

  Widget _buildChannelList({String? serverId, String? userId}) {
    if (serverId == null || userId == null) {
      return Container(
          width: 240,
          color: const Color(0xFF2B2D2B),
          child: const Center(child: Text('Sélectionnez un serveur', style: TextStyle(color: Colors.grey))));
    }

    return Container(
        width: 240,
        color: const Color(0xFF2B2D2B),
        child: Column(children: [
          Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.2)))),
              child: const Text('Canaux', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
          Expanded(
              child: FutureBuilder<List<dynamic>>(
                  future: fetchChannelsForServer(serverId, userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Erreur de chargement', style: TextStyle(color: Colors.red)));
                    }
                    if (snapshot.hasData) {
                      final channels = snapshot.data!;
                      if (_selectedChannelId == null && channels.isNotEmpty) {
                        _selectedChannelId = channels.first['id'];
                      }
                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: channels.length + 1,
                          itemBuilder: (context, index) {
                            if (index == channels.length) {
                              return _buildAddChannelButton(serverId);
                            }
                            final channel = channels[index];
                            final isSelected = channel['id'] == _selectedChannelId;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedChannelId = channel['id'];
                                });
                              },
                              child: _buildChannelItem(channel: channel, isSelected: isSelected),
                            );
                          });
                    }
                    return const Center(child: Text('Aucun canal', style: TextStyle(color: Colors.grey)));
                  })),
          _buildUserPanel(),
        ]));
  }

  Widget _buildAddChannelButton(String serverId) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddChannel(serverId: serverId),
                ),
              );
              if (result == true) {
                setState(() {});
              }
            },
            child: const Row(children: [
              Icon(Icons.add, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Text('Ajouter un canal', style: TextStyle(color: Colors.grey))
            ])));
  }

  Widget _buildChannelItem({required Map<String, dynamic> channel, bool isSelected = false}) {
    final String name = channel['name'] ?? 'canal sans nom';
    final isVoice = channel['type'] == 'voice';
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: isSelected ? Colors.grey.withOpacity(0.3) : Colors.transparent,
        child: Row(children: [
          Icon(isVoice ? Icons.volume_up : Icons.tag, color: Colors.grey, size: 20),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 16))
        ]));
  }

  Widget _buildUserPanel() {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
        padding: const EdgeInsets.all(8),
        color: const Color(0xFF292B2F),
        child: Row(children: [
          const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(
            user?.email ?? 'Utilisateur',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          )),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: const Icon(Icons.logout, color: Colors.redAccent))
        ]));
  }

  Widget _buildMainContent({String? serverId, String? channelId, User? user}) {
    if (serverId == null || channelId == null || user == null) {
      return const Expanded(
          child: Center(
        child: Text('Sélectionnez un canal pour voir les messages', style: TextStyle(color: Colors.grey)),
      ));
    }

    return Expanded(
        child: Column(children: [
      Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.2)))),
          child: Row(children: [
            const Icon(Icons.tag, color: Colors.white70),
            const SizedBox(width: 8),
            Text('Canal', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
          ])),
      Expanded(
        child: FutureBuilder<List<dynamic>>(
          future: fetchMessagesForChannel(serverId, channelId, user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Erreur de chargement des messages', style: TextStyle(color: Colors.red)));
            }
            if (snapshot.hasData) {
              final messages = snapshot.data!;
              if (messages.isEmpty) {
                return const Center(child: Text('Soyez le premier à envoyer un message !', style: TextStyle(color: Colors.grey)));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return MessageItem(message: message, currentUser: user);
                },
              );
            }
            return const Center(child: Text('Aucun message', style: TextStyle(color: Colors.grey)));
          },
        ),
      ),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: const Color(0xFF40444B), borderRadius: BorderRadius.circular(20)),
              child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'Envoyer un message',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.grey),
                        onPressed: () async {
                          final content = _messageController.text;
                          if (content.isNotEmpty) {
                            final success = await addMessageToChannel(
                              serverId: serverId,
                              channelId: channelId,
                              authorId: user.uid,
                              authorName: user.displayName ?? user.email ?? 'Utilisateur Anonyme',
                              content: content,
                            );

                            if (success != null) {
                              _messageController.clear();
                              setState(() {});
                            }
                          }
                        },
                      )))))
    ]));
  }
}

// --- Nouveau Widget pour un item de message ---

class MessageItem extends StatefulWidget {
  final Map<String, dynamic> message;
  final User currentUser;

  const MessageItem({Key? key, required this.message, required this.currentUser}) : super(key: key);

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  late Future<Map<String, dynamic>> _reactionsFuture;

  @override
  void initState() {
    super.initState();
    _loadReactions();
  }

  void _loadReactions() {
    setState(() {
      _reactionsFuture = fetchReactionsForMessage(widget.message['id']);
    });
  }

  void _handleReaction(String emoji) async {
    final success = await addReactionToMessage(
      messageId: widget.message['id'],
      userId: widget.currentUser.uid,
      emoji: emoji,
    );
    if (success) {
      _loadReactions();
    }
  }

  void _showReactionPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une réaction'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['👍', '❤️', '😂', '😢', '😮'].map((emoji) {
            return TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleReaction(emoji);
              },
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String authorName = widget.message['author']?['username'] ?? 'Utilisateur inconnu';
    final String? authorAvatarUrl = widget.message['author']?['avatarUrl'];
    final String content = widget.message['content'] ?? '';

    final Widget fallbackAvatar = const CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey,
      child: Icon(Icons.person, color: Colors.white),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: (authorAvatarUrl != null && authorAvatarUrl.isNotEmpty)
                    ? ClipOval(
                        child: Image.network(
                          authorAvatarUrl,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, color: Colors.white);
                          },
                        ),
                      )
                    : const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(authorName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(content, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<Map<String, dynamic>>(
            future: _reactionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(height: 20);
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildAddReactionButton();
              }

              final reactions = snapshot.data!;
              return Wrap(
                spacing: 8.0,
                children: [
                  ...reactions.entries.map((entry) {
                    final emoji = entry.key;
                    final reactionData = entry.value;
                    final count = reactionData['count'] as int;
                    final users = List<String>.from(reactionData['users'] ?? []);
                    final hasReacted = users.contains(widget.currentUser.uid);

                    return GestureDetector(
                      onTap: () async {
                        if (hasReacted) {
                          await removeReactionFromMessage(
                            messageId: widget.message['id'],
                            userId: widget.currentUser.uid,
                            emoji: emoji,
                          );
                        } else {
                          await addReactionToMessage(
                            messageId: widget.message['id'],
                            userId: widget.currentUser.uid,
                            emoji: emoji,
                          );
                        }
                        _loadReactions();
                      },
                      child: Chip(
                        backgroundColor: hasReacted ? Colors.blue.withOpacity(0.5) : const Color(0xFF40444B),
                        label: Text('$emoji $count'),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    );
                  }),
                  _buildAddReactionButton(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddReactionButton() {
    return InkWell(
      onTap: _showReactionPicker,
      child: const Chip(
        label: Icon(Icons.add_reaction_outlined, size: 16, color: Colors.grey),
        backgroundColor: Color(0xFF40444B),
      ),
    );
  }
}
