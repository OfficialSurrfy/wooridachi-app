import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserTile extends StatefulWidget {
  final String username;
  final String university;
  final String chatRecentText;
  final Timestamp time;
  final int unreadCount;
  final void Function()? onTap;
  final String profileImage;

  const UserTile({
    super.key,
    required this.username,
    required this.university,
    required this.chatRecentText,
    required this.time,
    required this.unreadCount,
    required this.onTap,
    required this.profileImage,
  });

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.005465,
            horizontal: screenWidth * 0.02427),
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02186,
          horizontal: screenWidth * 0.04854,
        ),
        child: Row(
          children: [
            widget.profileImage != ''
                ? ClipOval(
                    child: Image.network(
                      widget.profileImage,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    'assets/images/Avatar.png',
                    width: 30,
                    height: 30,
                  ),
            SizedBox(width: screenWidth * 0.02427),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.username,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(width: screenWidth * 0.02427),
                      Text(
                        widget.university,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Spacer(),
                      Text(
                        timeago.format(
                            DateTime.fromMicrosecondsSinceEpoch(
                                widget.time.microsecondsSinceEpoch),
                            locale: 'en_custom'),
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  SizedBox(width: screenWidth * 0.012135),
                  Row(
                    children: [
                      Text(
                        widget.chatRecentText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black),
                      ),
                      const Spacer(),
                      if (widget.unreadCount > 0)
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.purple,
                          child: Text(
                            '${widget.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
