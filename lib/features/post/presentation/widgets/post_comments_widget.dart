import 'package:flutter/material.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import '../../domain/entities/comment_view_dto.dart';
import 'comment_item_widget.dart';

class PostCommentsWidget extends StatefulWidget {
  final List<CommentViewDto> comments;

  const PostCommentsWidget({
    super.key,
    required this.comments,
  });

  @override
  State<PostCommentsWidget> createState() => _PostCommentsWidgetState();
}

class _PostCommentsWidgetState extends State<PostCommentsWidget> {
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);

    if (widget.comments.isEmpty) {
      return Center(child: Text(localization.no_comments_yet));
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.comments.length,
      itemBuilder: (context, index) {
        final comment = widget.comments[index];
        return SingleCommentWidget(commentView: comment);
      },
    );
  }
}
