import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

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

/// Récupère la liste des serveurs pour un utilisateur donné.
///
/// Renvoie une liste de serveurs en cas de succès, ou une liste vide en cas d'erreur.
Future<List<dynamic>> fetchServersForUser(String userId) async {
  try {
    print("Récupération des serveurs pour l'utilisateur : ${userId}");
    final baseUrl = "https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers";

    final url = Uri.parse(baseUrl).replace(queryParameters: {'userId': userId});

    final response = await http.get(url);

    print('Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = convert.json.decode(response.body);
      if (data != null) {
        print('Serveurs reçus: ${data['servers'].length}');
        return data['servers'];
      } else {
        print('Pas de données reçues.');
        return [];
      }
    } else {
      print("Erreur de la récupération des serveurs. Code: ${response
          .statusCode}");
      return [];
    }
  } catch (e) {
    print("Une erreur est survenue lors de la récupération des serveurs: ${e}");
    return [];
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

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: body,
    );

    if (response.statusCode == 201) {
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

Future<Map<String, dynamic>?> addChannel({
  required String serverId,
  required String name,
}) async {
  try {
    final url = Uri.parse(
        "https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers/${serverId}/channels");

    final body = convert.json.encode({'name': name});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: body,
    );

    if (response.statusCode == 201) {
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
