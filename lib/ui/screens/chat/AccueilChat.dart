import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];

  // Define two users: a server and a chef
  final types.User _server = types.User(id: 'server1', firstName: 'Serveur');
  final types.User _chef = types.User(id: 'chef1', firstName: 'Cuisinier');

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesString = prefs.getString('messages');
    if (messagesString != null) {
      final List<dynamic> messagesJson = jsonDecode(messagesString);
      setState(() {
        _messages = messagesJson.map((json) => types.Message.fromJson(json)).toList();
      });
    } else {
      final textMessage = types.TextMessage(
        author: _chef, // Chef as the author
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: 'msg1',
        text: 'Bienvenue dans le chat avec les cuisines !',
      );
      setState(() {
        _messages = [textMessage];
      });
      _saveMessages(); // Save the welcome message
    }
  }

  void _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = _messages.map((message) => message.toJson()).toList();
    await prefs.setString('messages', jsonEncode(messagesJson));
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _server, // Server sends the message
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      text: message.text,
    );
    setState(() {
      _messages.insert(0, textMessage);
    });
    _saveMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat avec les cuisines'),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _server,
        theme: DefaultChatTheme(
          primaryColor: Color(0xFFA2C4DD),
          secondaryColor: Color(0xFF97EFCE),
          sentMessageBodyTextStyle: TextStyle(
            color: Colors.black,
          ),
          receivedMessageBodyTextStyle: TextStyle(
            color: Colors.black,
          ),
          inputBackgroundColor: Colors.grey[100]!,
          inputTextColor: Colors.grey[800]!,
          inputBorderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}