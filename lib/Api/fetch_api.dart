import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

/*--------------------------------------------BASE API----------------------------------------------------------------*/
Future<void> fetchApi() async {
  try {
    print("Début de l'appel API...");
    final url = Uri.parse("https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/health");
    final response = await http.get(url);

    print('Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = convert.json.decode(response.body);
      print('Données reçues: ${data}');
    } else {
      print("Échec de la récupération des données. Code: ${response.statusCode}");
    }
  } catch (e) {
    print("Une erreur est survenue lors de l'appel API: ${e}");
  }
}


/*--------------------------------------------SERVEURS----------------------------------------------------------------*/
Future<List<dynamic>> fetchServersForUser(String userId) async {
  try {
    print("Récupération des serveurs pour l'utilisateur : ${userId}");
    const baseUrl = "https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers";

    final url = Uri.parse(baseUrl).replace(queryParameters: {'userId': userId});

    final response = await http.get(url);

    print('Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = convert.json.decode(response.body);
      if (data != null ) {
        print('Serveurs reçus: ${data["servers"].length}');
        return data["servers"];
      } else {
        print('pas de données reçues ou format incorrect.');
        return [];
      }
    } else {
      print("Erreur de la récupération des serveurs. Code: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Une erreur est survenue lors de l'appel API des serveurs: ${e}");
    return [];
  }
}


Future<Map<String, dynamic>?> addServer({
  required String name,
  required String ownerId, required String imageUrl,
}) async {
  try {
    const baseUrl = "https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers";
    final url = Uri.parse(baseUrl);

    final body = convert.json.encode({
      'name': name,
      'ownerId': ownerId,
      'imageUrl': "https://picsum.photos/seed/${name.hashCode}/200", // Image par défaut
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: body,
    );

    if (response.statusCode == 201) {
      print("Serveur créé avec succès.");
      return convert.json.decode(response.body) as Map<String, dynamic>;
    } else {
      print("Erreur lors de la création du serveur: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Une exception est survenue lors de l'ajout du serveur: ${e}");
    return null;
  }
}

/*--------------------------------------------CHANNELS----------------------------------------------------------------*/

Future<List<dynamic>> fetchChannelsForServer(String serverId, String userId) async {
  try {
    print("Récupération des canaux pour le serveur : ${serverId} par l'utilisateur ${userId}");
    final url = Uri.parse("https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers/${serverId}/channels")
        .replace(queryParameters: {'userId': userId});

    final response = await http.get(url);

    print('Status code (canaux): ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = convert.json.decode(response.body);
      if (data is List) {
        print('Canaux reçus: ${data.length}');
        return data;
      } else {
        print('Pas de données reçues ou format incorrect.');
        return [];
      }
    } else {
      print("Erreur de la récupération des canaux. Code: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Une erreur est survenue lors de l'appel API des canaux: ${e}");
    return [];
  }
}

Future<Map<String, dynamic>?> addChannel({
  required String serverId,
  required String name,
  required String userId,
}) async {
  try {
    final url = Uri.parse("https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers/${serverId}/channels");

    final body = convert.json.encode({
      'name': name,
      'userId': userId,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: body,
    );

    if (response.statusCode == 201) {
      print("Canal créé avec succès.");
      return convert.json.decode(response.body) as Map<String, dynamic>;
    } else {
      print("Erreur lors de la création du canal: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Une exception est survenue lors de l'ajout du canal: ${e}");
    return null;
  }
}

/*--------------------------------------------MESSAGES----------------------------------------------------------------*/

Future<List<dynamic>> fetchMessagesForChannel(String serverId, String channelId, String userId) async {
  try {
    print("Récupération des messages pour le canal : ${channelId} sur le serveur ${serverId}");
    final url = Uri.parse("https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/channels/${channelId}/messages")
        .replace(queryParameters: {'userId': userId});

    final response = await http.get(url);

    print('Status code (messages): ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = convert.json.decode(response.body);
      if (data != null) {
        print('Messages reçus: ${data.length}');
        return data;
      } else {
        print('Pas de données de messages reçues ou le format est incorrect.');
        return [];
      }
    } else {
      print("Erreur de la récupération des messages. Code: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Une erreur est survenue lors de l'appel API des messages: ${e}");
    return [];
  }
}

Future<Map<String, dynamic>?> addMessageToChannel({
  required String serverId,
  required String channelId,
  required String authorId,
  required String authorName,
  required String content,
}) async {
  try {
    print("Envoi du message au canal : ${channelId}");
    // CORRECTION : Suppression du \ qui empêchait l'interpolation
    final url = Uri.parse("https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/channels/${channelId}/messages");

    final body = convert.json.encode({
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'serverId': serverId,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: body,
    );

    print('Status code (add message): ${response.statusCode}');

    if (response.statusCode == 201) {
      print('Message envoyé avec succès.');
      return convert.json.decode(response.body) as Map<String, dynamic>;
    } else {
      print("Erreur lors de l'envoi du message: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Une exception est survenue lors de l'envoi du message: ${e}");
    return null;
  }
}


/*--------------------------------------------REACTIONS----------------------------------------------------------------*/

/// Récupère toutes les réactions pour un message donné.
Future<Map<String, dynamic>> fetchReactionsForMessage(String messageId) async {
  try {
    print("Récupération des réactions pour le message : ${messageId}");
    final url = Uri.parse("https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/messages/${messageId}/reactions");

    final response = await http.get(url);

    print('Status code (réactions): ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = convert.json.decode(response.body);
      if (data is Map<String, dynamic>) {
        print('Réactions reçues: ${data.keys.length}');
        return data;
      }
    }
    return {};
  } catch (e) {
    print("Une exception est survenue lors de la récupération des réactions: ${e}");
    return {};
  }
}

/// Ajoute une réaction à un message.
Future<bool> addReactionToMessage({
  required String messageId,
  required String userId,
  required String emoji,
}) async {
  try {
    print("Ajout de la réaction '${emoji}' par ${userId} au message ${messageId}");
    final url = Uri.parse("https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/messages/${messageId}/reactions");

    final body = convert.json.encode({
      'userId': userId,
      'emoji': emoji,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: body,
    );

    print('Status code (ajout réaction): ${response.statusCode}');
    return response.statusCode == 201 || response.statusCode == 200;
  } catch (e) {
    print("Une exception est survenue lors de l'ajout de la réaction: ${e}");
    return false;
  }
}

/// Supprime une réaction d'un message.
Future<bool> removeReactionFromMessage({
  required String messageId,
  required String userId,
  required String emoji,
}) async {
  try {
    print("Suppression de la réaction '${emoji}' par ${userId} du message ${messageId}");
    final url = Uri.parse("https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/messages/${messageId}/reactions");

    final body = convert.json.encode({
      'userId': userId,
      'emoji': emoji,
    });

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: body,
    );

    print('Status code (suppression réaction): ${response.statusCode}');
    // Accepte 200 (OK) ou 204 (No Content) comme succès
    return response.statusCode == 200 || response.statusCode == 204;
  } catch (e) {
    print("Une exception est survenue lors de la suppression de la réaction: ${e}");
    return false;
  }
}
