import 'dart:convert';

import 'package:http/http.dart' as http;

class RegistrationException implements Exception {
  const RegistrationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RegistrationService {
  RegistrationService({http.Client? client}) : _client = client ?? http.Client();

  static final Uri _endpoint =
      Uri.parse('https://formsubmit.co/ajax/novateur221@gmail.com');

  final http.Client _client;

  Future<void> submit({
    required String name,
    required String profession,
    required String email,
  }) async {
    final response = await _client
        .post(
          _endpoint,
          headers: const <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'Nom': name.trim(),
            'Profession': profession.trim(),
            'Email': email.trim(),
            'Application': 'DroneAtlas Academy',
            '_subject': 'Nouvel utilisateur DroneAtlas Academy',
            '_template': 'table',
            '_captcha': 'false',
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw const RegistrationException(
        'L’envoi des informations n’a pas pu être finalisé.',
      );
    }
  }

  void dispose() => _client.close();
}
