import 'package:flutter/material.dart';

class ChatHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data
    final chatHistories = [
      
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: chatHistories.length,
          itemBuilder: (context, index) {
            final chat = chatHistories[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(
                  chat['mode'] == 'Companion Mode'
                      ? Icons.people
                      : Icons.local_hospital,
                  color: Colors.blue,
                ),
                title: Text(
                  chat['mode']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  chat['lastMessage']!,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                trailing: Text(
                  chat['timestamp']!,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                onTap: () {
                  // Handle tap to view more details if needed
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
