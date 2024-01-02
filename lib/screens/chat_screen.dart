import 'package:chat_app/common_widgets/chat_bubble.dart';
import 'package:chat_app/common_widgets/custom_text_field.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  TextEditingController? email;
  ChatScreen({super.key, required this.email});

  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  TextEditingController? email;
  @override
  void initState() {
    email = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapchot) {
        if (snapchot.hasData) {
          List<MessageModel> messagesList = [];
          for (int i = 0; i < snapchot.data!.docs.length; i++) {
            messagesList.add(MessageModel.fromJson(snapchot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child:
                        Image.asset(height: 50, 'assets/images/download.png'),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'chat',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            body: WillPopScope(
              onWillPop: () async {
                print("Not  allowing navigator to pop");
                return true;
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: messagesList.length,
                        itemBuilder: (context, index) {
                          return messagesList[index].id == email!.text
                              ? ChatBubble(
                                  message: messagesList[index],
                                )
                              : ChatBubbleFriend(message: messagesList[index]);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: messageController,
                      onSubmitted: (value) {
                        messages.add({
                          'message': value,
                          'createdAt': DateTime.now(),
                          'id': email!.text
                        });
                        _scrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                        messageController.clear();
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              messages.add({
                                'message': messageController.text,
                                'createdAt': DateTime.now(),
                                'id': email!.text
                              });
                              _scrollController.animateTo(
                                0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                              messageController.clear();
                            },
                            icon: Icon(
                              Icons.send,
                              color: kPrimaryColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: kPrimaryColor))),
                    ),
                  )
                ],
              ),
            ),
          );
        }

        if (snapchot.hasError) {
          return Text('error');
        } else {
          return Text('Text Loading');
        }
      },
    );
  }
}
