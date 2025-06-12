import 'dart:convert';
import 'package:http/http.dart' as http;

class KazakhLearningApi {
  static const String baseUrl = 'https://guestuser33-kazakh-learning-api.hf.space/gradio_api/call';

  final http.Client httpClient;
  String? userId;
  String? sessionToken;

  KazakhLearningApi({http.Client? client}) : httpClient = client ?? http.Client();

  Future<dynamic> _callApi(String endpoint, List<dynamic> data) async {
    print('Calling _callApi: endpoint=$endpoint, data=$data');
    try {
      final postResponse = await httpClient.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'data': data}),
      );

      if (postResponse.statusCode != 200) {
        throw Exception('POST failed: ${postResponse.statusCode}');
      }

      final postJson = jsonDecode(postResponse.body);
      final eventId = postJson['event_id'];
      if (eventId == null) throw Exception('No event_id from POST');

      final getResponse = await httpClient.get(Uri.parse('$baseUrl/$endpoint/$eventId'));

      if (getResponse.statusCode != 200) throw Exception('GET failed: ${getResponse.statusCode}');

      final body = getResponse.body.trim();
      print('GET response body:\n$body');

      final lines = body.split('\n');
      for (final line in lines) {
        if (line.startsWith('data: ')) {
          final jsonString = line.substring(6).trim();
          final decoded = jsonDecode(jsonString);
          print('Decoded API response: $decoded');
          return decoded;
        }
      }

      throw Exception('No valid data line found in GET response');
    } catch (e) {
      print('API call error in _callApi: $e');
      rethrow;
    }
  }

  Future<bool> login(String userId) async {
    print('login() called with userId: $userId');
    this.userId = userId;
    final response = await _callApi('api_login', [userId]);
    if (response is List && response.isNotEmpty && response[0] is Map) {
      sessionToken = response[0]['session_token'];
      print('Login successful, sessionToken: $sessionToken');
      return sessionToken != null;
    }
    print('Login failed');
    return false;
  }

  Future<dynamic> sendMessage({
    required String message,
    required String targetLanguage,
  }) {
    print('sendMessage() called with message: "$message", targetLanguage: "$targetLanguage"');
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_chat', [message, userId, sessionToken, targetLanguage]);
  }

  Future<dynamic> sendMessageAnonymously({
    required String message,
    required String targetLanguage,
  }) {
    print('sendMessageAnonymously() called with message: "$message", targetLanguage: "$targetLanguage"');
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('chat', [message, sessionToken, targetLanguage]);
  }

  Future<dynamic> getProgress() {
    print('getProgress() called');
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_progress', [userId, sessionToken]);
  }

  Future<dynamic> getRecommendations() {
    print('getRecommendations() called');
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_recommendations', [userId, sessionToken]);
  }

  Future<dynamic> getReviewWords() {
    print('getReviewWords() called');
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_review_words', [userId, sessionToken]);
  }

  Future<dynamic> getMasteredWords() {
    print('getMasteredWords() called');
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_mastered_words', [userId, sessionToken]);
  }

  Future<dynamic> getLearningWords() {
    print('getLearningWords() called');
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_learning_words', [userId, sessionToken]);
  }

  Future<dynamic> getNewIdioms() {
    print('getNewIdioms() called');
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_new_idiom', [userId, sessionToken]);
  }

  Future<dynamic> getNewWords() {
    print('getNewWords() called');
    if (userId == null || sessionToken == null) throw Exception("Not logged in");
    return _callApi('api_new_word', [userId, sessionToken]);
  }

  Future<dynamic> fetchLambda(int lambdaNumber) {
    print('fetchLambda() called with lambdaNumber: $lambdaNumber');
    return _callApi('lambda_$lambdaNumber', []);
  }

  void dispose() {
    print('dispose() called — closing httpClient');
    httpClient.close();
  }

  void logout() {
    print('logout() called');
    userId = null;
    sessionToken = null;
    print("Logged out.");
  }
}
