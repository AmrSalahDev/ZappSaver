import 'package:flutter/material.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:flutter_status_up/features/widgets/custom_app_bar.dart';

class RecoveryChatScreen extends StatelessWidget {
  const RecoveryChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            children: [
              CustomAppBar(title: 'Recovery Chat'),
              SizedBox(height: context.screenHeight * 0.04),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 24),
                ),
                title: Text('User Name'),
                subtitle: Text('Hi, how are you?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
