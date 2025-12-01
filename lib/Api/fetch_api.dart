import 'dart:convert' as convert;
import 'package:http/http.dart' as http;


/*
* ------------------------------- API -----------------------------
* */
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

/*
* ------------------------------- SERVERS -----------------------------
* */
Future<int> fetchServersForUser(String userId) async {
  try {
    print("Récupération des serveurs pour l'utilisateur : ${userId}");

    const baseUrl = "https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers";

    final url = Uri.parse(baseUrl).replace(queryParameters: {'userId': userId});

    final response = await http.get(url);

    print('Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = convert.json.decode(response.body);

      print('Serveurs reçus: ${data}');

      return data;
      /*if (data is List) {
        final serverCount = data.length;

        print('Nombre de serveurs trouvés: ${serverCount}');
        return serverCount;
      } else {
        print("La réponse de l'API n'est pas une liste comme attendu.");
        return 0;
      }*/
    } else {
      print("Erreur de la récupération des serveurs. Code: ${response.statusCode}, Body: ${response.body}");
      return 0;
    }
  } catch (e) {
    print("Une erreur est survenue lors de l'appel API des serveurs: ${e}");
    return 0;
  }
}

Future<Map<String, dynamic>?> addServer({
  required String name,
  required String ownerId,
}) async {
  try {
    const baseUrl = "https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers";
    final url = Uri.parse(baseUrl);

    final body = convert.json.encode({
      'name': name,
      'ownerId': ownerId,
      'imageUrl': "https://example.com/image.png",
    });

    print("Envoi de la requête POST pour créer un server");
    print("Corps de la requête: ${body}");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    print('Code de statut de la réponse: ${response.statusCode}');

    final responseData = convert.json.decode(response.body);

    if (response.statusCode == 201) { 
      print('Serveur créé avec succès: ${responseData}');
      return responseData as Map<String, dynamic>;
    } else {
      print("Erreur lors de la création du serveur: ${responseData['message']}");
      return null;
    }
  } catch (e) {
    print("Une exception est survenue lors de l'appel API pour ajouter un serveur: ${e}");
    return null;
  }
}

/*
* --------------------------------------- CHANNEL ---------------------------------------
* */
Future<Map<String, dynamic>?> addChannel({
  required String serverId,
  required String name,
}) async {
  try {
    final url = Uri.parse(
        "https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers/${serverId}/channels");

    final body = convert.json.encode({
      'name': name,
    });

    print("Envoi de la requête POST pour créer un canal sur le serveur ${serverId}...");
    print("Corps de la requête: ${body}");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    print('Code de statut de la réponse: ${response.statusCode}');
    final responseData = convert.json.decode(response.body);

    if (response.statusCode == 201) {
      print('Canal créé avec succès: $responseData');
      return responseData as Map<String, dynamic>;
    } else {
      // Gestion des erreurs
      print("Erreur lors de la création du canal: ${responseData['message']}");
      return null;
    }
  } catch (e) {
    print("Une exception est survenue lors de l'appel API pour ajouter un canal: ${e}");
    return null;
  }
}

Future<Map<int, String>?> fetchChannelsForServer(String serverId, String userId) async {
  try {
    print("Récupération des Channels pour le serveur : ${serverId} pour l'Utilisateur : ${userId}");

    final baseUrl = "https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers/${serverId}/channels";

    final url = Uri.parse(baseUrl);

    final response = await http.get(url);

    print('Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = convert.json.decode(response.body);

      print('Serveurs reçus: ${data}');

    } else {
      print("Erreur de la récupération des serveurs. Code: ${response.statusCode}, Body: ${response.body}");
    }
  } catch (e) {
    print("Une erreur est survenue lors de l'appel API des serveurs: ${e}");
  }
  return null;
}
