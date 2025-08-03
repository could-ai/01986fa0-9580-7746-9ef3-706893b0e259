import 'dart:async';

import 'package:couldai_user_app/chat_message.dart';
import 'package:couldai_user_app/constants.dart';
import 'package:couldai_user_app/models/message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final Stream<List<Message>> _messagesStream;
  final Map<String, String> _profileCache = {};

  @override
  void initState() {
    super.initState();
    _messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((maps) => maps
            .map((map) => Message.fromMap(map: map, myUserId: supabase.auth.currentUser!.id))
            .toList());
  }

  Future<void> _loadProfile(String userId) async {
    if (_profileCache.containsKey(userId)) {
      return;
    }
    final data =
        await supabase.from('profiles').select('username').eq('id', userId).single();
    final username = data['username'] as String;
    setState(() {
      _profileCache[userId] = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          TextButton(
            onPressed: () async {
              await supabase.auth.signOut();
              if (mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: StreamBuilder<List<Message>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation!'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            _loadProfile(message.profileId);

                            return ChatMessage(
                              message: message,
                              username: _profileCache[message.profileId],
                            );
                          },
                        ),
                ),
                _MessageBar(),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _MessageBar extends StatefulWidget {
  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final text = _textController.text.trim();
    _textController.clear();
    if (text.isNotEmpty) {
      try {
        final userId = supabase.auth.currentUser!.id;
        await supabase.from('messages').insert({'profile_id': userId, 'content': text});
      } catch (error) {
        if (mounted) {
          context.showErrorSnackBar(message: 'Failed to send message');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                maxLines: null,
                autofocus: true,
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
            IconButton(
              onPressed: () => _submitMessage(),
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
