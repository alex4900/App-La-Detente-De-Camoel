import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    List<dynamic> messages = await recupererMessagesEnregistres();
    setState(() {
      _messages = messages;
    });
  }

  void _fetchMessages() async {
    try {
      List<dynamic> messages = await recupererMessages();
      await enregistrerMessages(messages);
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des messages: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat avec les cuisines'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchMessages,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_messages[index]['text']),
          );
        },
      ),
    );
  }
}


Future<void> enregistrerMessages(List<dynamic> messages) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('messages', jsonEncode(messages));
}

Future<List<dynamic>> recupererMessagesEnregistres() async {
  final prefs = await SharedPreferences.getInstance();
  String? messagesString = prefs.getString('messages');
  if (messagesString != null) {
    return jsonDecode(messagesString);
  } else {
    return [];
  }
}