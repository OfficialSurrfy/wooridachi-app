import 'package:flutter/material.dart';

import '../../../block_report/presentation/widgets/block_dialog.dart';
import '../../../block_report/presentation/widgets/report_dialog.dart';
import '../../domain/entities/reply_view_dto.dart';
import '../pages/global_post_screen.dart';
import '../../../block_report/presentation/widgets/custom_snack_bar.dart';
import '../../domain/entities/comment_view_dto.dart';
import '../../domain/entities/post_upload_dto.dart';
import '../../domain/entities/sort_by_options.dart';
import '../../domain/exceptions/post_exceptions.dart';
import '../../domain/exceptions/post_comment_exceptions.dart';
import '../../domain/exceptions/post_like_exceptions.dart';
import '../../domain/exceptions/post_reply_exceptions.dart';
import '../../domain/exceptions/comment_like_exceptions.dart';
import '../../domain/exceptions/reply_like_exceptions.dart';
import '../../domain/usecases/add_post_comment_usecase.dart';
import '../../domain/usecases/add_post_reply_usecase.dart';
import '../../domain/usecases/get_filtered_posts_usecase.dart';
import '../../domain/usecases/get_post_comments_usecase.dart';
import '../../domain/usecases/get_recent_posts_with_like_status_usecase.dart';
import '../../domain/entities/post_view_dto.dart';
import '../../domain/usecases/add_post_usecase.dart';
import '../../domain/usecases/handle_post_like_usecase.dart';
import '../../domain/usecases/handle_comment_like_usecase.dart';
import '../../domain/usecases/handle_reply_like_usecase.dart';
import '../../domain/usecases/update_post_comment_usecase.dart';
import '../../domain/usecases/delete_post_comment_usecase.dart';
import '../../domain/entities/post_comment_entity.dart';
import '../../domain/usecases/update_post_usecase.dart';
import '../../domain/usecases/update_post_reply_usecase.dart';
import '../../domain/entities/post_reply_entity.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/delete_post_reply_usecase.dart';
import '../../domain/usecases/delete_post_usecaes.dart';
import '../../domain/usecases/get_current_user_posts_usecase.dart';
import '../../domain/usecases/get_user_liked_posts_usecase.dart';

class PostProvider extends ChangeNotifier {
  final GetRecentPostsWithLikeStatusUsecase _getRecentPostsWithLikeStatusUsecase;
  final GetPostCommentsUsecase _getCommentsUsecase;
  final UploadPostUsecase _uploadPostUsecase;
  final HandlePostLikeUsecase _handlePostLikeUsecase;
  final HandleCommentLikeUsecase _handleCommentLikeUsecase;
  final HandleReplyLikeUsecase _handleReplyLikeUsecase;
  final GetFilteredPostsUsecase _getFilteredPostsUsecase;
  final AddPostCommentUsecase _addPostCommentUsecase;
  final AddPostReplyUsecase _addPostReplyUsecase;
  final UpdatePostCommentUsecase _updatePostCommentUsecase;
  final DeletePostCommentUsecase _deletePostCommentUsecase;
  final UpdatePostReplyUsecase _updatePostReplyUsecase;
  final DeletePostReplyUsecase _deletePostReplyUsecase;
  final UpdatePostUsecase _updatePostUsecase;
  final DeletePostUsecase _deletePostUsecase;
  final GetCurrentUserPostsUsecase _getCurrentUserPostsUsecase;
  final GetUserLikedPostsUsecase _getUserLikedPostsUsecase;

  PostProvider({
    required GetRecentPostsWithLikeStatusUsecase getRecentPostsWithLikeStatusUsecase,
    required GetPostCommentsUsecase getCommentsUsecase,
    required UploadPostUsecase uploadPostUsecase,
    required HandlePostLikeUsecase handlePostLikeUsecase,
    required HandleCommentLikeUsecase handleCommentLikeUsecase,
    required HandleReplyLikeUsecase handleReplyLikeUsecase,
    required GetFilteredPostsUsecase getFilteredPostsUsecase,
    required AddPostCommentUsecase addPostCommentUsecase,
    required AddPostReplyUsecase addPostReplyUsecase,
    required UpdatePostCommentUsecase updatePostCommentUsecase,
    required DeletePostCommentUsecase deletePostCommentUsecase,
    required UpdatePostReplyUsecase updatePostReplyUsecase,
    required DeletePostReplyUsecase deletePostReplyUsecase,
    required UpdatePostUsecase updatePostUsecase,
    required DeletePostUsecase deletePostUsecase,
    required GetCurrentUserPostsUsecase getCurrentUserPostsUsecase,
    required GetUserLikedPostsUsecase getUserLikedPostsUsecase,
  })  : _getRecentPostsWithLikeStatusUsecase = getRecentPostsWithLikeStatusUsecase,
        _getCommentsUsecase = getCommentsUsecase,
        _uploadPostUsecase = uploadPostUsecase,
        _handlePostLikeUsecase = handlePostLikeUsecase,
        _handleCommentLikeUsecase = handleCommentLikeUsecase,
        _handleReplyLikeUsecase = handleReplyLikeUsecase,
        _getFilteredPostsUsecase = getFilteredPostsUsecase,
        _addPostCommentUsecase = addPostCommentUsecase,
        _addPostReplyUsecase = addPostReplyUsecase,
        _updatePostCommentUsecase = updatePostCommentUsecase,
        _deletePostCommentUsecase = deletePostCommentUsecase,
        _updatePostReplyUsecase = updatePostReplyUsecase,
        _deletePostReplyUsecase = deletePostReplyUsecase,
        _updatePostUsecase = updatePostUsecase,
        _deletePostUsecase = deletePostUsecase,
        _getCurrentUserPostsUsecase = getCurrentUserPostsUsecase,
        _getUserLikedPostsUsecase = getUserLikedPostsUsecase;

  List<PostViewDto> _globalPosts = [];
  List<PostViewDto> get globalPosts => _globalPosts;

  List<PostViewDto> _filteredPosts = [];
  List<PostViewDto> get filteredPosts => _filteredPosts;

  List<CommentViewDto> _comments = [];
  List<CommentViewDto> get comments => _comments;

  bool _isLikeLoading = false;
  bool get isLikeLoading => _isLikeLoading;

  void setIsLikeLoading(bool value) {
    _isLikeLoading = value;
    notifyListeners();
  }

  void setPosts(List<PostViewDto> posts) {
    _globalPosts = posts;
    notifyListeners();
  }

  static void showBlockDialog(BuildContext context, String uploaderId, bool? isChat) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return BlockDialog(userId: uploaderId, isChat: isChat);
      },
    );
  }

  static void showReportDialog(BuildContext context, String uploaderId) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return ReportDialog(userId: uploaderId);
      },
    );
  }


Future<List<PostViewDto>> getUserLikedPosts(BuildContext context) async {
    try {
      return await _getUserLikedPostsUsecase.call();
    } on PostException catch (e) {
      if (!context.mounted) return [];
      if (e is PostGetException) {
        CustomSnackBar.show(context, '게시물을 불러오는데 실패했습니다.');
      }
      return [];
    } catch (e) {
      if (!context.mounted) return [];
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
      return [];
    }
  }

  Future<void> addComment(BuildContext context, String postId, String content) async {
    try {
      await _addPostCommentUsecase.call(postId, content);

      if (!context.mounted) return;
      await fetchComments(context, postId);
    } on PostCommentException catch (e) {
      if (!context.mounted) return;
      if (e is PostCommentAddException) {
        CustomSnackBar.show(context, '댓글 작성에 실패했습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> fetchRecentPosts(BuildContext context) async {
    try {
      final posts = await _getRecentPostsWithLikeStatusUsecase.call();
      setPosts(posts);
    } on PostException catch (e) {
      if (!context.mounted) return;
      if (e is PostGetException) {
        CustomSnackBar.show(context, '게시물을 불러오는데 실패했습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> fetchComments(BuildContext context, String postId) async {
    try {
      final comments = await _getCommentsUsecase.call(postId);

      _comments = comments;
      notifyListeners();
    } on PostCommentException catch (e) {
      if (!context.mounted) return;
      if (e is PostCommentGetException) {
        CustomSnackBar.show(context, '댓글을 불러오는데 실패했습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> uploadPost(BuildContext context, PostUploadDto dto) async {
    try {
      final post = await _uploadPostUsecase.call(dto);
      _globalPosts.insert(0, post);

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GlobalPostScreen(postViewDto: post),
        ),
      );
    } on PostException catch (e) {
      if (!context.mounted) return;
      if (e is PostAddException) {
        CustomSnackBar.show(context, '게시물 업로드에 실패했습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> handlePostLike(BuildContext context, String postId) async {
    try {
      if (_isLikeLoading) return;
      setIsLikeLoading(true);

      final post = _globalPosts.firstWhere((post) => post.post.id == postId);

      final originalLikeStatus = post.isLiked;
      final optimisticLikeStatus = !originalLikeStatus;

      post.setIsLiked(optimisticLikeStatus);
      notifyListeners();

      try {
        await _handlePostLikeUsecase.call(postId, originalLikeStatus);
      } catch (e) {
        post.setIsLiked(originalLikeStatus);
        notifyListeners();
        rethrow;
      }
    } on PostLikeException catch (e) {
      if (!context.mounted) return;
      if (e is PostLikeAddException) {
        CustomSnackBar.show(context, '좋아요 추가에 실패했습니다.');
      } else if (e is PostLikeDeleteException) {
        CustomSnackBar.show(context, '좋아요 취소에 실패했습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    } finally {
      setIsLikeLoading(false);
    }
  }

  Future<void> fetchFilteredPosts(
      BuildContext context,
      String searchQuery,
      PostSortByOptions sortBy,
      ) async {
    final posts = await _getFilteredPostsUsecase.call(
      searchQuery: searchQuery,
      sortBy: sortBy,
    );

    if (!context.mounted) return;

    if (searchQuery.trim().isEmpty) {
      _globalPosts = posts;
    } else {
      _filteredPosts = posts;
    }
    notifyListeners();
  }



  Future<void> addReply(BuildContext context, String postId, String commentId, String content) async {
    try {
      await _addPostReplyUsecase.call(postId, commentId, content);
      if (!context.mounted) return;
      await fetchComments(context, postId);
    } on PostReplyException catch (e) {
      if (!context.mounted) return;
      if (e is PostReplyAddException) {
        CustomSnackBar.show(context, '답글 작성에 실패했습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  void setFilteredPosts(List<PostViewDto> posts) {
    _filteredPosts = posts;
    notifyListeners();
  }

  void clearFilteredPosts() {
    _filteredPosts = [];
    notifyListeners();
  }

  void clearComments() {
    _comments = [];
    notifyListeners();
  }

  void clearGlobalPosts() {
    _globalPosts = [];
    notifyListeners();
  }

  Future<void> updateComment(BuildContext context, String postId, String commentId, String content, String userId) async {
    try {
      final comment = _comments.firstWhere((c) => c.comment.id == commentId);
      final originalComment = comment.comment;

      comment.comment = comment.comment.copyWith(
        content: content,
      );
      notifyListeners();

      try {
        await _updatePostCommentUsecase.call(PostCommentEntity(
          id: commentId,
          postId: postId,
          userId: userId,
          content: content,
          createdAt: originalComment.createdAt,
          likesCount: originalComment.likesCount,
        ));
      } catch (e) {
        comment.comment = originalComment;
        notifyListeners();
        if (!context.mounted) return;
        if (e is PostCommentUpdateException) {
          CustomSnackBar.show(context, '댓글 수정에 실패했습니다.');
        } else {
          CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
        }
        rethrow;
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
      rethrow;
    }
  }

  Future<void> deleteComment(BuildContext context, String postId, String commentId) async {
    try {
      final commentIndex = _comments.indexWhere((comment) => comment.comment.id == commentId);
      if (commentIndex == -1) return;

      final deletedComment = _comments[commentIndex];
      _comments.removeAt(commentIndex);
      notifyListeners();

      try {
        await _deletePostCommentUsecase.call(postId, commentId);
      } catch (e) {
        _comments.insert(commentIndex, deletedComment);
        notifyListeners();
        rethrow;
      }
    } on PostCommentException catch (e) {
      if (!context.mounted) return;
      if (e is PostCommentDeleteException) {
        CustomSnackBar.show(context, '댓글 삭제에 실패했습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> updatePost(BuildContext context, PostEntity post) async {
    try {
      final globalPostIndex = _globalPosts.indexWhere((p) => p.post.id == post.id);
      final filteredPostIndex = _filteredPosts.indexWhere((p) => p.post.id == post.id);

      final originalGlobalPost = globalPostIndex != -1 ? _globalPosts[globalPostIndex] : null;
      final originalFilteredPost = filteredPostIndex != -1 ? _filteredPosts[filteredPostIndex] : null;

      if (globalPostIndex != -1) {
        _globalPosts[globalPostIndex] = _globalPosts[globalPostIndex].copyWith(
          post: post,
        );
      }
      if (filteredPostIndex != -1) {
        _filteredPosts[filteredPostIndex] = _filteredPosts[filteredPostIndex].copyWith(
          post: post,
        );
      }
      notifyListeners();

      try {
        await _updatePostUsecase.call(post);
        if (!context.mounted) return;
      } catch (e) {
        if (globalPostIndex != -1 && originalGlobalPost != null) {
          _globalPosts[globalPostIndex] = originalGlobalPost;
        }
        if (filteredPostIndex != -1 && originalFilteredPost != null) {
          _filteredPosts[filteredPostIndex] = originalFilteredPost;
        }
        notifyListeners();
        rethrow;
      }
    } on PostException catch (e) {
      if (!context.mounted) return;
      if (e is PostUpdateException) {
        CustomSnackBar.show(context, '게시물 수정에 실패했습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> updateReply(BuildContext context, String postId, String replyId, String content, String userId) async {
    try {
      ReplyViewDto? reply;
      for (var comment in _comments) {
        if (comment.replies == null) continue;
        try {
          reply = comment.replies!.firstWhere((r) => r.reply.id == replyId);
          break;
        } catch (_) {
          continue;
        }
      }

      if (reply == null) return;

      final originalReply = reply.reply;

      reply.reply = reply.reply.copyWith(
        content: content,
      );
      notifyListeners();

      try {
        await _updatePostReplyUsecase.call(PostReplyEntity(
          id: replyId,
          postId: postId,
          userId: userId,
          content: content,
          createdAt: originalReply.createdAt,
          likesCount: originalReply.likesCount,
          commentId: originalReply.commentId,
        ));
      } catch (e) {
        reply.reply = originalReply;
        notifyListeners();
        if (!context.mounted) return;
        if (e is PostReplyUpdateException) {
          CustomSnackBar.show(context, '답글 수정에 실패했습니다.');
        } else {
          CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
        }
        rethrow;
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
      rethrow;
    }
  }

  Future<void> deleteReply(BuildContext context, String postId, String replyId) async {
    try {
      CommentViewDto? parentComment;
      int? replyIndex;

      for (var comment in _comments) {
        if (comment.replies == null) continue;
        final index = comment.replies!.indexWhere((r) => r.reply.id == replyId);
        if (index != -1) {
          parentComment = comment;
          replyIndex = index;
          break;
        }
      }

      if (parentComment == null || replyIndex == null) return;

      final deletedReply = parentComment.replies![replyIndex];
      parentComment.replies!.removeAt(replyIndex);
      notifyListeners();

      try {
        await _deletePostReplyUsecase.call(postId, replyId);
      } catch (e) {
        parentComment.replies!.insert(replyIndex, deletedReply);
        notifyListeners();
        rethrow;
      }
    } on PostReplyException catch (e) {
      if (!context.mounted) return;
      if (e is PostReplyDeleteException) {
        CustomSnackBar.show(context, '답글 삭제에 실패했습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> handleCommentLike(BuildContext context, String postId, String commentId, bool isCurrentlyLiked) async {
    try {
      if (_isLikeLoading) return;
      setIsLikeLoading(true);

      final comment = _comments.firstWhere((c) => c.comment.id == commentId);
      final originalLikeStatus = isCurrentlyLiked;
      final optimisticLikeStatus = !originalLikeStatus;

      comment.isLiked = optimisticLikeStatus;
      if (optimisticLikeStatus) {
        comment.comment = comment.comment.copyWith(likesCount: comment.comment.likesCount + 1);
      } else {
        comment.comment = comment.comment.copyWith(likesCount: comment.comment.likesCount - 1);
      }
      notifyListeners();

      try {
        await _handleCommentLikeUsecase.call(postId, commentId, comment.user.id, isCurrentlyLiked);
      } catch (e) {
        comment.isLiked = originalLikeStatus;
        if (originalLikeStatus) {
          comment.comment = comment.comment.copyWith(likesCount: comment.comment.likesCount + 1);
        } else {
          comment.comment = comment.comment.copyWith(likesCount: comment.comment.likesCount - 1);
        }
        notifyListeners();
        rethrow;
      }
    } on CommentLikeException catch (e) {
      if (!context.mounted) return;
      if (e is CommentLikeAddException) {
        CustomSnackBar.show(context, '댓글 좋아요 추가에 실패했습니다.');
      } else if (e is CommentLikeDeleteException) {
        CustomSnackBar.show(context, '댓글 좋아요 취소에 실패했습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    } finally {
      setIsLikeLoading(false);
    }
  }

  Future<void> handleReplyLike(BuildContext context, String postId, String commentId, String replyId, bool isCurrentlyLiked) async {
    try {
      if (_isLikeLoading) return;
      setIsLikeLoading(true);

      ReplyViewDto? reply;
      for (var comment in _comments) {
        if (comment.replies == null) continue;
        try {
          reply = comment.replies!.firstWhere((r) => r.reply.id == replyId);
          break;
        } catch (_) {
          continue;
        }
      }

      if (reply == null) return;

      final originalLikeStatus = isCurrentlyLiked;
      final optimisticLikeStatus = !originalLikeStatus;

      reply.isLiked = optimisticLikeStatus;
      if (optimisticLikeStatus) {
        reply.reply = reply.reply.copyWith(likesCount: reply.reply.likesCount + 1);
      } else {
        reply.reply = reply.reply.copyWith(likesCount: reply.reply.likesCount - 1);
      }
      notifyListeners();

      try {
        await _handleReplyLikeUsecase.call(postId, commentId, replyId, reply.user.id, isCurrentlyLiked);
      } catch (e) {
        reply.isLiked = originalLikeStatus;
        if (originalLikeStatus) {
          reply.reply = reply.reply.copyWith(likesCount: reply.reply.likesCount + 1);
        } else {
          reply.reply = reply.reply.copyWith(likesCount: reply.reply.likesCount - 1);
        }
        notifyListeners();
        rethrow;
      }
    } on ReplyLikeException catch (e) {
      if (!context.mounted) return;
      if (e is ReplyLikeAddException) {
        CustomSnackBar.show(context, '답글 좋아요 추가에 실패했습니다.');
      } else if (e is ReplyLikeDeleteException) {
        CustomSnackBar.show(context, '답글 좋아요 취소에 실패했습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    } finally {
      setIsLikeLoading(false);
    }
  }

  Future<void> deletePost(BuildContext context, String postId) async {
    try {
      final globalPostIndex = _globalPosts.indexWhere((p) => p.post.id == postId);
      final filteredPostIndex = _filteredPosts.indexWhere((p) => p.post.id == postId);

      final originalGlobalPost = globalPostIndex != -1 ? _globalPosts[globalPostIndex] : null;
      final originalFilteredPost = filteredPostIndex != -1 ? _filteredPosts[filteredPostIndex] : null;

      if (globalPostIndex != -1) {
        _globalPosts.removeAt(globalPostIndex);
      }
      if (filteredPostIndex != -1) {
        _filteredPosts.removeAt(filteredPostIndex);
      }
      notifyListeners();

      if (context.mounted) {
        Navigator.pop(context);
      }

      try {
        await _deletePostUsecase.call(postId);
      } catch (e) {
        if (globalPostIndex != -1 && originalGlobalPost != null) {
          _globalPosts.insert(globalPostIndex, originalGlobalPost);
        }
        if (filteredPostIndex != -1 && originalFilteredPost != null) {
          _filteredPosts.insert(filteredPostIndex, originalFilteredPost);
        }
        notifyListeners();
        rethrow;
      }
    } on PostException catch (e) {
      if (!context.mounted) return;
      if (e is PostDeleteException) {
        CustomSnackBar.show(context, '게시물 삭제에 실패했습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<List<PostViewDto>> getCurrentUserPosts(BuildContext context) async {
    try {
      final posts = await _getCurrentUserPostsUsecase.call();
      return posts;
    } on PostException catch (e) {
      if (!context.mounted) return [];
      if (e is PostGetException) {
        CustomSnackBar.show(context, '게시물을 불러오는데 실패했습니다.');
      }
      return [];
    } catch (e) {
      if (!context.mounted) return [];
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
      return [];
    }
  }


}
