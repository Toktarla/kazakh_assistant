import 'dart:convert';
import 'package:http/http.dart' as http;

class KazakhLearningApi {
  static const String baseUrl = 'https://guestuser33-kazakh-learning-api.hf.space/gradio_api/call';

  final http.Client httpClient;
  String? userId;
  String? sessionToken;

  KazakhLearningApi({http.Client? client}) : httpClient = client ?? http.Client();

  Future<dynamic> _callApi(String endpoint, List<dynamic> data) async {
    try {
      final postResponse = await httpClient.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'data': data}),
      );

      if (postResponse.statusCode != 200) throw Exception('POST failed: ${postResponse.statusCode}');

      final postJson = jsonDecode(postResponse.body);
      final eventId = postJson['event_id'];
      if (eventId == null) throw Exception('No event_id from POST');

      final getResponse = await httpClient.get(Uri.parse('$baseUrl/$endpoint/$eventId'));

      if (getResponse.statusCode != 200) throw Exception('GET failed: ${getResponse.statusCode}');

      final body = getResponse.body.trim();
      print('GET response body:\n$body');

      // Extract JSON from the "data: ..." line
      final lines = body.split('\n');
      for (final line in lines) {
        if (line.startsWith('data: ')) {
          final jsonString = line.substring(6).trim();
          return jsonDecode(jsonString);
        }
      }

      throw Exception('No valid data line found in GET response');
    } catch (e) {
      print('API call error: $e');
      rethrow;
    }
  }

  Future<bool> login(String userId) async {
    this.userId = userId;
    final response = await _callApi('api_login', [userId]);
    if (response is List && response.isNotEmpty && response[0] is Map) {
      sessionToken = response[0]['session_token'];
      return sessionToken != null;
    }
    return false;
  }

  Future<dynamic> sendMessage({
    required String message,
    required String targetLanguage,
  }) {
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_chat', [message, userId, sessionToken, targetLanguage]);
  }

  Future<dynamic> sendMessageAnonymously({
    required String message,
    required String targetLanguage,
  }) {
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('chat', [message, sessionToken, targetLanguage]);
  }

  Future<dynamic> getProgress() {
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_progress', [userId, sessionToken]);
  }

  Future<dynamic> getRecommendations() {
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_recommendations', [userId, sessionToken]);
  }

  Future<dynamic> getReviewWords() {
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_review_words', [userId, sessionToken]);
  }

  Future<dynamic> getMasteredWords() {
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_mastered_words', [userId, sessionToken]);
  }

  Future<dynamic> getLearningWords() {
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_learning_words', [userId, sessionToken]);
  }

  Future<dynamic> getNewIdioms() {
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_new_idiom', [userId, sessionToken]);
  }

  Future<dynamic> getNewWords() {
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_new_word', [userId, sessionToken]);
  }

  Future<dynamic> fetchLambda(int lambdaNumber) {
    return _callApi('lambda_$lambdaNumber', []);
  }

  void dispose() {
    httpClient.close();
  }

  void logout() {
    userId = null;
    sessionToken = null;
    print("Logged out.");
  }

}
