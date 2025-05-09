import 'package:flutter/material.dart';
import 'package:uridachi/widgets/translate_button_comment.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isCurrentUser;
  final bool isLastMessageInSequence;
  final String time;
  final bool isRead;

  ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.isLastMessageInSequence,
    required this.time,
    required this.isRead,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool showOriginal = false;
  String? translatedChatText;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return IntrinsicWidth(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: widget.isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding:  EdgeInsets.only(
                top: screenHeight * 0.001093 * 10,
                right: screenWidth * 0.002427 * 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (widget.isCurrentUser && !widget.isRead)
                  const Text(
                    " 1",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                if (widget.isCurrentUser && widget.isLastMessageInSequence)
                  Text(
                    widget.time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          Flexible(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: screenWidth * 0.002427 * 300),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isCurrentUser
                      ? const Color(0xFF4D27C7)
                      : const Color(0xFFECEFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.002427 * 11,
                    vertical: screenHeight * 0.001093 * 11),
                margin: EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                  right: widget.isCurrentUser ? 11 : 0,
                  left: widget.isCurrentUser ? 0 : 11,
                ),
                child: Text(
                  translatedChatText ?? widget.message,
                  style: TextStyle(
                    color: widget.isCurrentUser ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true,
                ),
              ),
            ),
          ),
          if (!widget.isCurrentUser)
            TranslateButtonComment(
              description: widget.message,
              onTranslated: (String translatedChat) {
                if (mounted) {
                  setState(() {
                    translatedChatText = translatedChat;
                  });
                }
              },
            ),
        ],
      ),
    );
  }
}