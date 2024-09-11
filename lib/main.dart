import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// Ganti dengan URL API Anda
const String apiBaseUrl = 'https://letter-a.co.id/api/v1/chattings/';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: const ChatListPage(),
      );
}

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late Future<List<dynamic>> _chatListFuture;
  bool _isDataFetched = false;

  bool amITheFirstSender = true;
  String myUserId = '';
  String myUserName = '';
  String lawanBicara = '';
  String lawanBicaraPhoto = '';
  String userId1 = '';
  String userId2 = '';
  String userName1 = '';
  String userName2 = '';
  String userPhoto1 = '';
  String userPhoto2 = '';

  @override
  void initState() {
    super.initState();
    // amITheFirstSender = '104';
    //_saveDummyData();
    _printAllSharedPreferencesData();
    // inisiasi();
    _chatListFuture = _fetchChatList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _isDataFetched = true;
      inisiasi();
    }
  }

  Future<void> inisiasi() async {
    // Pastikan FutureBuilder selesai memuat data
    await _chatListFuture; // Tunggu hingga Future selesai
    await checkMyUser(); // Pastikan untuk memanggil checkMyUser di sini
  }

  // Fungsi untuk menyimpan data contoh ke SharedPreferences
  // Future<void> _saveDummyData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('userId', '104');
  // }

  // Fungsi untuk mencetak semua data di SharedPreferences
  Future<void> _printAllSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs
        .getKeys(); // Mendapatkan semua kunci yang ada di SharedPreferences

    for (String key in keys) {
      // Mengambil nilai berdasarkan tipe data yang sesuai
      dynamic value = prefs.get(key);
      print('Key: $key, Value: $value');
    }
  }

  Future<void> checkMyUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _myIdUser = prefs.getString('userId') ?? '';
    String _myNameUser = prefs.getString('userName') ?? '';
    setState(() {
      myUserId = '$_myIdUser';
      myUserName = '$_myNameUser';
      //myUserId = '59';
    });

    print('>>My User $myUserId');
  }

  Future<List<dynamic>> _fetchChatList() async {
    final response = await http.get(Uri.parse('${apiBaseUrl}chat-list.php'));

    if (response.statusCode == 200) {
      print('${jsonDecode(response.body)}');
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load chat list');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Chat List' + ' - $myUserId'),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _chatListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No chats available'));
            }

            final chatList = snapshot.data!;

            return ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                final chat = chatList[index];
                // setState(() {
                userId1 = chat['user_1_id'];
                userId2 = chat['user_2_id'];
                userName1 = chat['user1_name'];
                userName2 = chat['user2_name'];
                userPhoto1 = chat['user1_imageUrl'];
                userPhoto2 = chat['user2_imageUrl'];
                // });
                return ListTile(
                  leading: Image.network(
                      myUserId == userId1
                          ? 'https://letter-a.co.id/api/v1/${chat['user2_imageUrl']}'
                          : myUserId == userId2
                              ? 'https://letter-a.co.id/api/v1/${chat['user1_imageUrl']}'
                              : 'https://letter-a.co.id/api/v1/uploads/logo.png',
                      width: 40,
                      height: 40),
                  title:
                      Text(chat['chat_id']), // Sesuaikan dengan field nama chat
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(myUserId == userId1
                                ? chat['user2_name']
                                : myUserId == userId2
                                    ? chat['user1_name']
                                    : '404'),
                          ),
                        ],
                      ),
                      Image.network(
                          'https://letter-a.co.id/api/v1/${chat['user1_imageUrl']}',
                          width: 40,
                          height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: Text('user1_name' +
                                chat['user1_name'] +
                                chat['user_1_id']),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('user2_name' +
                                chat['user2_name'] +
                                chat['user_2_id']),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                'last_message_id' + chat['last_message_id']),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text((chat['updated_at'] != '' &&
                                    chat['updated_at'] != null &&
                                    chat['updated_at'] != 'null')
                                ? "${DateFormat('dd-MM-yyyy - HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(chat['updated_at'])))}"
                                : "${DateFormat('dd-MM-yyyy - HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(chat['created_at'])))}"),
                          )
                        ],
                      ),
                      Image.network(
                          'https://letter-a.co.id/api/v1/${chat['user2_imageUrl']}',
                          width: 40,
                          height: 40),
                    ],
                  ),
                  onTap: () {
                    // setState(() {
                    userId1 = chat['user_1_id'];
                    userId2 = chat['user_2_id'];
                    userName1 = chat['user1_name'];
                    userName2 = chat['user2_name'];
                    userPhoto1 = chat['user1_imageUrl'];
                    userPhoto2 = chat['user2_imageUrl'];
                    // });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          chatId: chat['chat_id'],
                          userId: '$myUserId',
                          userName: '$myUserName',
                          lawanBicara: myUserId == userId1
                              ? chat['user2_name']
                              : myUserId == userId2
                                  ? chat['user1_name']
                                  : '404',

                          //: '404'

                          lawanBicaraPhoto: myUserId == userId1
                              ? chat['user2_imageUrl']
                              : myUserId == userId2
                                  ? chat['user1_imageUrl']
                                  : '404',
                          userPhoto: myUserId == userId1
                              ? chat['user1_imageUrl']
                              : myUserId == userId2
                                  ? chat['user2_imageUrl']
                                  : '404',
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      );
}

class ChatPage extends StatefulWidget {
  final String chatId;
  final String userId;
  final String userPhoto;
  final String userName;
  final String lawanBicara;
  final String lawanBicaraPhoto;
  ChatPage({
    required this.chatId,
    required this.userId,
    required this.userPhoto,
    required this.userName,
    required this.lawanBicara,
    required this.lawanBicaraPhoto,
    super.key,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  late types.User _user;
  // late types.User _user; // Menggunakan late untuk menunda inisialisasi

  @override
  void initState() {
    super.initState();
    inisiasi();
  }

  Future<void> inisiasi() async {
    await setUser();
    await _loadMessages();
  }

  Future<void> setUser() async {
    _user = types.User(
      id: '${widget.userId}',
    );
  }

  Future<void> _loadMessages() async {
  final response = await http.get(
    Uri.parse('${apiBaseUrl}get-messages.php?chat_id=${widget.chatId}'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> messagesJson = jsonDecode(response.body);
    print("${jsonDecode(response.body)}");

    if (messagesJson.isNotEmpty) {
      final List<types.Message> messages = messagesJson.map((json) {
        final messageJson = json as Map<String, dynamic>;

        // Tentukan jenis pesan berdasarkan 'type'
        switch (messageJson['type']) {
          case 'text':
            return types.TextMessage(
              author: types.User(
                id: messageJson['author']['id'] as String,
                firstName: "${messageJson['author']['firstName'] as String}" +
                    " - ${DateFormat('dd-MM-yyyy - HH:mm').format(DateTime.fromMillisecondsSinceEpoch(DateTime.fromMillisecondsSinceEpoch(messageJson['createdAt']).millisecondsSinceEpoch))}" +
                    " ${messageJson['author']['imageUrl']}",
                imageUrl: (messageJson['author']['imageUrl'] != '' &&
                        messageJson['author']['imageUrl'] != null)
                    ? messageJson['author']['imageUrl'] as String
                    : null,
              ),
              createdAt: DateTime.fromMillisecondsSinceEpoch(messageJson['createdAt']).millisecondsSinceEpoch,
              id: messageJson['id'] as String,
              text: messageJson['text'] as String,
            );
          case 'image':
            return types.ImageMessage(
              author: types.User(
                id: messageJson['author']['id'] as String,
                firstName: "${messageJson['author']['firstName'] as String}" +
                    " - ${DateFormat('dd-MM-yyyy - HH:mm').format(DateTime.fromMillisecondsSinceEpoch(DateTime.fromMillisecondsSinceEpoch(messageJson['createdAt']).millisecondsSinceEpoch))}" +
                    " ${messageJson['author']['imageUrl']}",
                imageUrl: (messageJson['author']['imageUrl'] != '' &&
                        messageJson['author']['imageUrl'] != null)
                    ? messageJson['author']['imageUrl'] as String
                    : null,
              ),
              createdAt: DateTime.fromMillisecondsSinceEpoch(messageJson['createdAt']).millisecondsSinceEpoch,
              id: messageJson['id'] as String,
              name: messageJson['name'] as String,
              uri: messageJson['uri'] as String,
              size: messageJson['size'] as int,
              width: messageJson['width'] as double,
              height: messageJson['height'] as double,
            );
          case 'file':
            return types.FileMessage(
              author: types.User(
                id: messageJson['author']['id'] as String,
                firstName: "${messageJson['author']['firstName'] as String}" +
                    " - ${DateFormat('dd-MM-yyyy - HH:mm').format(DateTime.fromMillisecondsSinceEpoch(DateTime.fromMillisecondsSinceEpoch(messageJson['createdAt']).millisecondsSinceEpoch))}" +
                    " ${messageJson['author']['imageUrl']}",
                imageUrl: (messageJson['author']['imageUrl'] != '' &&
                        messageJson['author']['imageUrl'] != null)
                    ? messageJson['author']['imageUrl'] as String
                    : null,
              ),
              createdAt: DateTime.fromMillisecondsSinceEpoch(messageJson['createdAt']).millisecondsSinceEpoch,
              id: messageJson['id'] as String,
              name: messageJson['name'] as String,
              uri: messageJson['uri'] as String,
              size: messageJson['size'] as int,
              mimeType: messageJson['mimeType'] as String,
            );
          default:
            return types.TextMessage(
              author: types.User(
                id: messageJson['author']['id'] as String,
                firstName: "${messageJson['author']['firstName'] as String}" +
                    " - ${DateFormat('dd-MM-yyyy - HH:mm').format(DateTime.fromMillisecondsSinceEpoch(DateTime.fromMillisecondsSinceEpoch(messageJson['createdAt']).millisecondsSinceEpoch))}" +
                    " ${messageJson['author']['imageUrl']}",
                imageUrl: (messageJson['author']['imageUrl'] != '' &&
                        messageJson['author']['imageUrl'] != null)
                    ? messageJson['author']['imageUrl'] as String
                    : null,
              ),
              createdAt: DateTime.fromMillisecondsSinceEpoch(messageJson['createdAt']).millisecondsSinceEpoch,
              id: messageJson['id'] as String,
              text: messageJson['text'] as String,
            );
        }
      }).toList();

      setState(() {
        _messages = messages.reversed.toList();
      });
    } else {
      // Handle empty messages
    }
  } else {
    throw Exception('Failed to load messages');
  }
}

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    try {
      final response = await http.post(
        Uri.parse('${apiBaseUrl}send-message.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'chat_id': widget.chatId,
          'author_id': _user.id,
          'author_first_name': widget.userName,
          'author_last_name': '',
          'author_image_url': widget.userPhoto,
          'text': message.text,
          'type': 'text', // Jenis pesan, 'text' dalam hal ini
          'status': 'sent', // Status pesan, 'sent' berarti pesan sudah dikirim
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'created_at_column':
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'uri': '', // URL untuk file jika ada (kosong jika tidak)
          'name': '', // Nama file jika ada (kosong jika tidak)
          'size': 0, // Ukuran file jika ada (0 jika tidak)
          'mime_type': '', // MIME type file jika ada (kosong jika tidak)
          'width': 0, // Lebar file jika ada (0 jika tidak)
          'height': 0, // Tinggi file jika ada (0 jika tidak)
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody['status'] == 'success') {
          print('Message sent successfully: ${responseBody['data']['id']}');
        } else {
          throw Exception('Failed to send message: ${responseBody['message']}');
        }
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      // Tangani kesalahan pengiriman pesan di sini
      print('Error sending message: $e');
      // Tampilkan pesan kesalahan kepada pengguna jika diperlukan
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    // Cari index dari message berdasarkan id
    final index = _messages.indexWhere((element) => element.id == message.id);

    // Pastikan index ditemukan
    if (index != -1) {
      // Pastikan elemen yang ditemukan adalah TextMessage
      if (_messages[index] is types.TextMessage) {
        final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
          previewData: previewData,
        );

        // Update pesan di dalam _messages
        setState(() {
          _messages[index] = updatedMessage;
        });
      } else {
        // Log atau tangani jika tipe pesan tidak sesuai
        print('Pesan dengan id: ${message.id} bukan TextMessage');
      }
    } else {
      // Log atau tangani jika pesan tidak ditemukan
      print('Pesan dengan id: ${message.id} tidak ditemukan');
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('${widget.lawanBicara}'),
          //title: Text('Chat ${widget.lawanBicara} ${widget.userId}'),
          actions: [
            Image.network(
                widget.lawanBicaraPhoto != '404'
                    ? 'https://letter-a.co.id/api/v1/${widget.lawanBicaraPhoto}'
                    : 'https://cdn.pixabay.com/photo/2021/10/11/00/59/warning-6699085_1280.png',
                height: 24,
                width: 24)
          ],
        ),
        body: Chat(
          messages: _messages,
          onAttachmentPressed: _handleAttachmentPressed,
          // onAttachmentPressed: () async {
          //   final picker = ImagePicker();
          //   final pickedFile =
          //       await picker.pickImage(source: ImageSource.gallery);
          //   if (pickedFile != null) {
          //     final file = File(pickedFile.path);
          //     final directory = await getApplicationDocumentsDirectory();
          //     final newFile = await file.copy(
          //         '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png');
          //     // Implementasi untuk mengirim file
          //   }
          // },
          onMessageTap: _handleMessageTap,
          //onMessageTap: (context, message) {
          // Implementasi untuk tap pesan
          //},
          onPreviewDataFetched: _handlePreviewDataFetched,
          //onPreviewDataFetched: (message, previewData) {
          // Implementasi untuk preview data
          //},
          onSendPressed: _handleSendPressed,
          showUserAvatars: true,
          showUserNames: true,
          user: _user,
        ),
      );
}
