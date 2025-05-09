import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:uridachi/services/auth/auth_services.dart';
import 'package:uridachi/services/chat/chat_service.dart';
import '../../features/block_report/presentation/providers/block_report_provider.dart';
import '../../widgets/chat_widgets/user_tile.dart';
import 'chat_view_page.dart';

class ChatPage extends StatefulWidget {
  final ScrollController scrollController;

  const ChatPage({super.key, required this.scrollController});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with AutomaticKeepAliveClientMixin {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  List<Map<String, dynamic>>? _cachedUserTiles;
  final Map<String, Map<String, dynamic>> _individualUserTileCache = {};
  bool isLoadingFirstTime = true;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenHeight = MediaQuery.of(context).size.height;
    String currentUserID = _authService.getCurrentUser()!.uid;
    var localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.chat,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
          child: Container(
            height: screenHeight,
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        localization.my_chat,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(controller: widget.scrollController, child: _buildUserList(currentUserID)),
              ],
            ),
          )),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildUserList(String currentUserID) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getChatRoomsStream(currentUserID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading chat rooms"));
        }

        if (isLoadingFirstTime && snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
          isLoadingFirstTime = false;
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          _cachedUserTiles = snapshot.data;
        }
        final chatRooms = _cachedUserTiles ?? [];

        if (chatRooms.isEmpty) {
          return const Center(child: Text("No chat rooms available"));
        }

        return ListView.builder(
          shrinkWrap: true, // This makes ListView take only the needed height
          physics: NeverScrollableScrollPhysics(),
          itemCount: chatRooms.length,
          itemBuilder: (context, index) {
            return _buildUserListItem(chatRooms[index], context, currentUserID);
          },
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> chatRoomData, BuildContext context, String currentUserID) {
    String chatRoomID = chatRoomData['chatRoomID'];
    String? otherUserID = chatRoomData['participants'].firstWhere(
      (id) => id != currentUserID,
      orElse: () => null,
    );

    if (otherUserID == null) {
      return const ListTile(
        title: Text("No other participant found"),
        subtitle: Text("This chat room has no other participants."),
      );
    }

    // Use StreamBuilder to listen to real-time updates, but show cached data immediately
    return StreamBuilder<Map<String, dynamic>>(
      stream: _getUserDataAndUnreadCountStream(otherUserID, chatRoomID, currentUserID),
      builder: (context, snapshot) {
        // If no data yet, or while waiting, show cached data
        if ((!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) && _individualUserTileCache.containsKey(chatRoomID)) {
          final cachedData = _individualUserTileCache[chatRoomID]!;
          return UserTile(
            username: cachedData['userData']['username'],
            university: cachedData['userData']['university'],
            chatRecentText: cachedData['mostRecentMessage'],
            time: cachedData['messageTime'],
            unreadCount: cachedData['unreadCount'],
            profileImage: cachedData['userData']['profileImage'],
            onTap: () async {
              await _navigateToChatViewPage(cachedData['userData'], chatRoomID, currentUserID);
            },
          );
        }

        if (snapshot.hasError) {
          if (kDebugMode) {
            print("Error loading user data: ${snapshot.error}");
          }
          return const ListTile(title: Text('Error loading user data'));
        }

        if (!snapshot.hasData) {
          return Container();
        }

        final userData = snapshot.data!['userData'];
        final unreadCount = snapshot.data!['unreadCount'] ?? 0;
        final mostRecentMessage = snapshot.data!['mostRecentMessage'] ?? 'No messages';
        final messageTime = snapshot.data!['messageTime'] ?? 'No time available';

        // Update cache with the latest data
        _individualUserTileCache[chatRoomID] = snapshot.data!;

        return Consumer<BlockReportProvider>(
          builder: (context, blockReportProvider, child) {
            print(otherUserID);
            if (blockReportProvider.isBlocked(otherUserID ?? '')) {
              return SizedBox.shrink();
            }
            return UserTile(
              username: userData['username'],
              university: userData['university'],
              chatRecentText: mostRecentMessage,
              time: messageTime,
              unreadCount: unreadCount,
              profileImage: userData['profileImage'],
              onTap: () async {
                await _navigateToChatViewPage(userData, chatRoomID, currentUserID);
              },
            );
          },
        );
      },
    );
  }

  Future<void> _navigateToChatViewPage(Map<String, dynamic> userData, String chatRoomID, String currentUserID) async {
    await _chatService.markMessagesAsRead(chatRoomID, currentUserID);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatViewPage(
          receiverEmail: userData["email"],
          receiverID: userData["uid"],
          receiverUsername: userData["username"],
          receiverUniversity: userData["university"],
        ),
      ),
    );
    if (result == true) {
      setState(() {});
    }
  }

  Stream<Map<String, dynamic>> _getUserDataAndUnreadCountStream(String otherUserID, String chatRoomID, String currentUserID) async* {
    try {
      final userDoc = await _chatService.getUserData(otherUserID);
      if (!userDoc.exists) {
        throw FirebaseException(plugin: 'firebase_firestore', message: 'User document does not exist');
      }

      final userData = userDoc.data()!;

      yield* FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomID).collection('messages').orderBy('timestamp', descending: true).limit(1).snapshots().asyncMap((messageSnapshot) async {
        String mostRecentMessage = 'No messages';
        Timestamp? messageTime;
        int unreadCount = await _chatService.countUnreadMessages(chatRoomID, currentUserID);

        if (messageSnapshot.docs.isNotEmpty) {
          final messageData = messageSnapshot.docs.first.data();
          mostRecentMessage = messageData['message'] ?? 'No messages';
          messageTime = messageData['timestamp'];
        }

        return {
          'userData': userData,
          'unreadCount': unreadCount,
          'mostRecentMessage': mostRecentMessage,
          'messageTime': messageTime,
        };
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error in _getUserDataAndUnreadCountStream: $e");
      }
      rethrow;
    }
  }
}
