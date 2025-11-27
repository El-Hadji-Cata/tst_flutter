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

/// Récupère les serveurs pour un utilisateur donné et renvoie leur nombre.
///
/// Le [userId] est passé en tant que paramètre de requête à l'API.
/// Renvoie le nombre de serveurs en cas de succès, ou 0 en cas d'erreur.
Future<int> fetchServersForUser(String userId) async {
  try {
    print("Récupération des serveurs pour l'utilisateur : ${userId}");

    const baseUrl = "https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers";

    final url = Uri.parse(baseUrl).replace(queryParameters: {'userId': userId});

    final response = await http.get(url);

    print('Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = convert.json.decode(response.body);
      
      // S'assurer que les données sont bien une liste
      if (data is List) {
        final serverCount = data.length;
        print('Serveurs reçus: ${data}');
        print('Nombre de serveurs trouvés: ${serverCount}');
        return serverCount; // Retourne le nombre d'éléments
      } else {
        print("La réponse de l'API n'est pas une liste comme attendu.");
        return 0;
      }
    } else {
      print("Erreur de la récupération des serveurs. Code: ${response.statusCode}, Body: ${response.body}");
      return 0; // Retourne 0 en cas d'erreur
    }
  } catch (e) {
    print("Une erreur est survenue lors de l'appel API des serveurs: ${e}");
    return 0; // Retourne 0 en cas d'exception
  }
}

Future<Map<String, dynamic>?> addServer({
  required String name,
  required String ownerId,
}) async {
  try {
    const baseUrl = "https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers";
    final url = Uri.parse(baseUrl);

    // Préparation du corps de la requête au format JSON
    final body = convert.json.encode({
      'name': name,
      'ownerId': ownerId,
      'imageUrl': "https://example.com/image.png",
    });

    print("Envoi de la requête POST pour créer un serveur...");
    print("Corps de la requête: ${body}");

    // Envoi de la requête POST avec les en-têtes corrects
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    print('Code de statut de la réponse: ${response.statusCode}');

    // Décodage de la réponse JSON
    final responseData = convert.json.decode(response.body);

    // 201 (Created) est le code standard pour une création réussie via POST
    if (response.statusCode == 201) { 
      print('Serveur créé avec succès: ${responseData}');
      return responseData as Map<String, dynamic>;
    } else {
      // Gestion des erreurs comme "name is required"
      print("Erreur lors de la création du serveur: ${responseData['message']}");
      return null;
    }
  } catch (e) {
    print("Une exception est survenue lors de l'appel API pour ajouter un serveur: ${e}");
    return null;
  }
}

/// Ajoute un nouveau canal à un serveur spécifique.
///
/// Prend un [serverId] pour construire l'URL et un [name] pour le canal.
/// Renvoie une Map<String, dynamic> représentant le canal créé en cas de succès,
/// ou null en cas d'échec.
Future<Map<String, dynamic>?> addChannel({
  required String serverId,
  required String name,
}) async {
  try {
    // Construction de l'URL dynamique avec l'ID du serveur
    final url = Uri.parse(
        "https://us-central1-messaging-backend-m2i.cloudfunctions.net/api/servers/${serverId}/channels");

    // Préparation du corps de la requête
    final body = convert.json.encode({
      'name': name,
    });

    print("Envoi de la requête POST pour créer un canal sur le serveur ${serverId}...");
    print("Corps de la requête: ${body}");

    // Envoi de la requête POST
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    print('Code de statut de la réponse: ${response.statusCode}');
    final responseData = convert.json.decode(response.body);

    // 201 (Created) est le code standard pour une création réussie
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
