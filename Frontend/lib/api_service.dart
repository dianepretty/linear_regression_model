import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://student-performance-prediction-qsit.onrender.com'; // Use 10.0.2.2 for Android emulator

  Future<Map<String, dynamic>> predictExamScore(Map<String, dynamic> input) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(input),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'predicted_exam_score': jsonDecode(response.body)['predicted_exam_score']
        };
      } else {
        return {
          'success': false,
          'error': jsonDecode(response.body)['detail'] ?? 'Unknown error'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to connect to server: $e'
      };
    }
  }
}