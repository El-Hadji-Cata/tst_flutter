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
      if (data != null ) {
        print('Canaux reçus: ${data}');
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
  required String userId,
  required String content,
}) async {
  try {
    print("Envoi du message au canal : ${channelId}");
    final url = Uri.parse("https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/channels/${channelId}/messages");

    // CORRECTION : Le backend attend 'authorId' et non 'userId'
    final body = convert.json.encode({
      'authorId': userId,
      'content': content,
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
