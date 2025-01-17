import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];

  // Définir deux utilisateurs : un serveur et le cuisinier
  final types.User _server = types.User(id: 'server1', firstName: 'Serveur');
  final types.User _chef = types.User(id: 'chef1', firstName: 'Cuisinier');

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    final textMessage = types.TextMessage(
      author: _chef, // Cuisinier en tant qu'auteur
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: 'msg1',
      text: 'Bienvenue dans le chat avec les cuisines !',
    );
    setState(() {
      _messages = [textMessage];
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _server, // Le serveur envoie le message
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      text: message.text,
    );
    setState(() {
      _messages.insert(0, textMessage);
    });
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
            color: Colors.black
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
