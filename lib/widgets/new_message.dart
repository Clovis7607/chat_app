import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add(
      {
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.data()!['username'],
        'userImage': userData.data()!['image_url'],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        padding: EdgeInsets.only(bottom: 20, top: 10),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(color: Colors.white10),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(left: 15, right: 15, top: 20),
                    hintText: "輸入訊息",
                    filled: true,
                    fillColor: Colors.black12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: _submitMessage,
              icon: const Icon(Icons.send),
            ),
            const SizedBox(width: 15)
          ],
        ),
      ),
    );
  }
}
