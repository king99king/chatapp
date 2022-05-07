import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat/messge_bubble.dart';

class Messages extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot <QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = snapshot.data?.docs;
          final uid = user!.uid;
          return ListView.builder(
            reverse: true,
            itemCount: chatDocs?.length,
            itemBuilder: (ctx, index) =>
                MessageBubble(
                  chatDocs![index]['text'],
                  chatDocs[index]['username'],
                  chatDocs[index]['userId'] == uid,
                  key: ValueKey(chatDocs[index].id),
                ),
          );
        });
  }
}