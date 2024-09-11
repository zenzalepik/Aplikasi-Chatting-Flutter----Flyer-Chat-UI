import 'package:http/http.dart' as http;

Future<void> loginUser(String username, String password) async {
  final response = await http.post(
    Uri.parse('http://your-backend-url.com/login'),
    body: {'username': username, 'password': password},
  );
  // Handle response
}
