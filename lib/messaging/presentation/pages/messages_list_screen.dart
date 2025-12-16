import 'package:flutter/material.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class MessagesListScreen extends StatelessWidget {
  const MessagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages", style: Theme.of(context).textTheme.titleLarge,),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search, color: GlobalColors.darkPurple,)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: GlobalColors.darkPurple,)),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple.shade50,
              child: Text(
                ("Message $index").characters.first.toUpperCase(),
                style: TextStyle(color: GlobalColors.darkPurple, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text("Message $index", style: Theme.of(context).textTheme.titleMedium,),
            subtitle: Text("Subtitle $index", style: Theme.of(context).textTheme.bodyMedium,),
            trailing: Icon(Icons.more_vert, color: GlobalColors.darkPurple,),
          );
        },
      ),
    );
  }
}