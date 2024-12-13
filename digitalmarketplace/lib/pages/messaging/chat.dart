import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Chat Message Model
class ChatMessage {
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
    this.isMe = false,
  });
}

class ChatScreen extends StatefulWidget {
  final String contactName;

  const ChatScreen({Key? key, required this.contactName}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Dummy chat log
  List<ChatMessage> messages = [
    ChatMessage(
      sender: 'John Doe',
      message: 'Hey, I\'m interested in your artwork.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isMe: false,
    ),
    ChatMessage(
      sender: 'Me',
      message: 'Sure! Which piece are you interested in?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
      isMe: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Scroll to bottom when chat screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(
          ChatMessage(
            sender: 'Me',
            message: _messageController.text.trim(),
            timestamp: DateTime.now(),
            isMe: true,
          ),
        );
        _messageController.clear();
      });

      // Scroll to bottom after sending message
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 5),
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                SizedBox(height: padding.top + 60), // Reserve space for the custom app bar
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
                ),
                _buildMessageInput(),
              ],
            ),
            // Custom App Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildCustomAppBar(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Container(
      padding: EdgeInsets.only(
        top: padding.top, // Adds spacing for the notch or cutout
        left: 16,
        right: 16,
      ),
      color: Colors.deepPurple,
      height: padding.top + 60,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          CircleAvatar(
            backgroundColor: Colors.deepPurple.shade100,
            child: Text(
              widget.contactName[0],
              style: const TextStyle(color: Colors.deepPurple),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.contactName,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Add more options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.deepPurple.shade50 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: GoogleFonts.montserrat(),
            ),
            const SizedBox(height: 5),
            Text(
              DateFormat('h:mm a').format(message.timestamp),
              style: GoogleFonts.montserrat(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: GoogleFonts.montserrat(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.deepPurple,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
