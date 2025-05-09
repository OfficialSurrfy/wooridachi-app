import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:uridachi/services/auth/auth_services.dart';
import 'package:uridachi/services/chat/chat_service.dart';
import '../../features/common/user_menu_utils.dart';
import '../../widgets/chat_widgets/chat_bubble.dart';

class ChatViewPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final String receiverUsername;
  final String receiverUniversity;

  const ChatViewPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    required this.receiverUsername,
    required this.receiverUniversity,
  });

  @override
  State<ChatViewPage> createState() => _ChatViewPageState();
}

class _ChatViewPageState extends State<ChatViewPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  String? chatRoomId;
  final ScrollController _scrollController = ScrollController();

  static const Color purpleColor = Color(0xFF4D27C7);

  @override
  void initState() {
    super.initState();
    _initializeChatRoom();
  }

  Future<void> _initializeChatRoom() async {
    String currentUserID = _authService.getCurrentUser()!.uid;
    List<String> ids = [
      currentUserID,
      widget.receiverID
    ];
    ids.sort();
    chatRoomId = ids.join('_');

    await _chatService.markMessagesAsRead(chatRoomId!, currentUserID);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty && chatRoomId != null) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear();
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: screenHeight * 0.069744,
          leading: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.008744),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ),
          title: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.receiverUsername,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: purpleColor, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () {
                            UserMenuUtils.showBlockDialog(context, widget.receiverID, true);
                          },
                          child: Text(
                            '차단하기',
                            style: TextStyle(
                              color: purpleColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            SizedBox(height: 8),
            if (chatRoomId != null)
              Expanded(
                child: _buildMessageList(),
              )
            else
              const Center(child: CircularProgressIndicator()),
            _buildUserInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    String currentUserID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(currentUserID, widget.receiverID),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        List<DocumentSnapshot> messages = snapshot.data!.docs;

        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final currentMessageData = messages[index].data() as Map<String, dynamic>;
            final previousMessageData = index > 0 ? messages[index - 1].data() as Map<String, dynamic> : null;
            final nextMessageData = index < messages.length - 1 ? messages[index + 1].data() as Map<String, dynamic> : null;

            bool isFirstMessageOfDay = false;
            if (previousMessageData == null || !_isSameDay((previousMessageData['timestamp'] as Timestamp).toDate(), (currentMessageData['timestamp'] as Timestamp).toDate())) {
              isFirstMessageOfDay = true;
            }

            bool isFirstInGroup = index == 0 || currentMessageData["senderID"] != previousMessageData!["senderID"];
            bool isLastInGroup = nextMessageData == null || currentMessageData["senderID"] != nextMessageData["senderID"];

            return _buildMessageItem(
              messages[index],
              isFirstInGroup,
              isLastInGroup,
              isFirstMessageOfDay,
            );
          },
        );
      }),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, bool isFirstInGroup, bool isLastInGroup, bool isFirstMessageOfDay) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;
    _initializeChatRoom();

    bool isRead = data["isRead"];

    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    Timestamp timestamp = data['timestamp'];
    DateTime dateTimeLocal = timestamp.toDate().toLocal();

    String time = DateFormat('HH:mm').format(dateTimeLocal);
    String date = DateFormat('yyyy/MM/dd').format(dateTimeLocal);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        if (isFirstMessageOfDay)
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01093),
            child: Text(
              date,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02427),
          child: Container(
            alignment: alignment,
            child: Column(
              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                ChatBubble(
                  message: data["message"],
                  isCurrentUser: isCurrentUser,
                  isLastMessageInSequence: isLastInGroup,
                  time: time,
                  isRead: isRead,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  Widget _buildUserInput() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.001093 * 26, left: screenWidth * 0.02427, right: screenWidth * 0.02427),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.02427),
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: localization.type_message,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_upward, color: Color(0xff582ab2)),
              onPressed: sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
