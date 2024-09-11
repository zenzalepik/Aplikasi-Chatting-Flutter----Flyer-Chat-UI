import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model untuk User
class User {
  final int id;
  final String username;

  User({required this.id, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id']),
      username: json['username'],
    );
  }
}

// Model untuk ChatMessage
class ChatMessage {
  final int id;
  final String username;
  final String text;
  final String createdAt;

  ChatMessage({
    required this.id,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: int.parse(json['id']),
      username: json['username'],
      text: json['text'],
      createdAt: json['created_at'],
    );
  }
}

// Fungsi untuk mengambil pesan dari API
Future<List<ChatMessage>> fetchMessages() async {
  final response =
      await http.get(Uri.parse('http://localhost/chat_app/get_messages.php'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => ChatMessage.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load messages');
  }
}

// Fungsi untuk mengirim pesan ke API
Future<void> sendMessage(int userId, String text) async {
  final response = await http.post(
    Uri.parse('http://localhost/chat_app/send_message.php'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'user_id': userId,
      'text': text,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to send message');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    List<ChatMessage> messages = await fetchMessages();
    setState(() {
      _messages = messages;
    });
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await sendMessage(2, _controller.text); // userId is 1 for example
      _controller.clear();
      _loadMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.username),
                  subtitle: Text(message.text),
                  trailing: Text(message.createdAt),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
