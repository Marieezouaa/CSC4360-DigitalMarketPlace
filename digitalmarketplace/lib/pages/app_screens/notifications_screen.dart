import 'package:digitalmarketplace/pages/messaging/chat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
         
          bottom: TabBar(
            indicatorColor: Colors.deepPurple,
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Text(
                  'Notifications',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Messages',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NotificationsTab(),
            MessagesTab(),
          ],
        ),
      ),
    );
  }
}

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy notifications for now
    final notifications = [
      {
        'title': 'New Artwork Listed',
        'subtitle': 'A new artwork has been added to the marketplace',
        'time': '2 hours ago',
        'read': false,
      },
      {
        'title': 'Price Drop',
        'subtitle': 'An artwork you liked is now on sale',
        'time': 'Yesterday',
        'read': true,
      },
    ];

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return ListTile(
          leading: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: notification['read'] == false 
                ? Colors.deepPurple 
                : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          title: Text(
            notification['title'] as String,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            notification['subtitle'] as String,
            style: GoogleFonts.montserrat(),
          ),
          trailing: Text(
            notification['time'] as String,
            style: GoogleFonts.montserrat(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy messages for now
    final messages = [
      {
        'name': 'John Doe',
        'lastMessage': 'Hey, I\'m interested in your artwork.',
        'time': '10:30 AM',
        'unread': 2,
      },
      {
        'name': 'Jane Smith',
        'lastMessage': 'Can we discuss the pricing?',
        'time': 'Yesterday',
        'unread': 1,
      },
    ];

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  contactName: message['name'] as String,
                ),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurple.shade100,
            child: Text(
              message['name'].toString()[0],
              style: const TextStyle(color: Colors.deepPurple),
            ),
          ),
          title: Text(
            message['name'] as String,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            message['lastMessage'] as String,
            style: GoogleFonts.montserrat(),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message['time'] as String,
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              if (message['unread'] as int > 0)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${message['unread']}',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}