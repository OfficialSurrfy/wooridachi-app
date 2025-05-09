import 'package:flutter/material.dart';
import '../../domain/entities/reply_view_dto.dart';
import 'reply_item_widget.dart';

class PostRepliesWidget extends StatelessWidget {
  final List<ReplyViewDto> replies;

  const PostRepliesWidget({
    super.key,
    required this.replies,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: replies.length,
      itemBuilder: (context, index) {
        return ReplyItemWidget(
          replyViewDto: replies[index],
        );
      },
    );
  }
}
