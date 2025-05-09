import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../features/post/data/datasources/comment_like_datasource.dart';
import '../../features/post/data/datasources/post_comment_datasource.dart';
import '../../features/post/data/datasources/post_comment_datasource_impl.dart';
import '../../features/post/data/datasources/post_datasource.dart';
import '../../features/post/data/datasources/post_datasource_impl.dart';
import '../../features/post/data/datasources/post_like_datasource.dart';
import '../../features/post/data/datasources/post_like_datasource_impl.dart';
import '../../features/post/data/datasources/post_reply_datasource.dart';
import '../../features/post/data/datasources/post_reply_datasource_impl.dart';
import '../../features/post/data/datasources/comment_like_datasource_impl.dart';
import '../../features/post/data/datasources/reply_like_datasource.dart';
import '../../features/post/data/datasources/transaction_datasource.dart';
import '../../features/post/data/datasources/transaction_datasource_impl.dart';
import '../../features/post/data/repositories/post_comment_repository_impl.dart';
import '../../features/post/data/repositories/post_like_repository_impl.dart';
import '../../features/post/data/repositories/post_reply_repository_impl.dart';
import '../../features/post/data/repositories/post_repository_impl.dart';
import '../../features/post/data/repositories/comment_like_repository_impl.dart';
import '../../features/post/data/repositories/reply_like_repository_impl.dart';
import '../../features/post/domain/repositories/post_reply_repository.dart';
import '../../features/post/domain/repositories/post_repository.dart';
import '../../features/post/domain/repositories/comment_like_repository.dart';
import '../../features/post/domain/repositories/reply_like_repository.dart';
import '../../features/post/domain/usecases/add_post_reply_usecase.dart';
import '../../features/post/domain/usecases/delete_post_usecaes.dart';
import '../../features/post/domain/usecases/get_filtered_posts_usecase.dart';
import '../../features/post/domain/usecases/get_post_comments_usecase.dart';
import '../../features/post/domain/usecases/add_post_usecase.dart';
import '../../features/post/domain/usecases/get_post_with_like_status_usecase.dart';
import '../../features/post/domain/usecases/get_recent_posts_with_like_status_usecase.dart';
import '../../features/post/domain/usecases/add_post_comment_usecase.dart';
import '../../features/post/domain/usecases/handle_post_like_usecase.dart';
import '../../features/post/domain/usecases/handle_comment_like_usecase.dart';
import '../../features/post/domain/usecases/handle_reply_like_usecase.dart';
import '../../features/post/presentation/providers/post_provider.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/image/domain/repositories/image_repository.dart';
import '../../features/post/domain/repositories/post_like_repository.dart';
import '../../features/post/domain/repositories/post_comment_repository.dart';
import '../../features/translation/domain/repositories/translation_repository.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../../features/post/domain/usecases/delete_post_comment_usecase.dart';
import '../../features/post/domain/usecases/delete_post_reply_usecase.dart';
import '../../features/post/domain/usecases/update_post_comment_usecase.dart';
import '../../features/post/domain/usecases/update_post_usecase.dart';
import '../../features/post/domain/usecases/update_post_reply_usecase.dart';
import '../../features/post/domain/usecases/get_current_user_posts_usecase.dart';
import '../../features/post/domain/usecases/get_user_liked_posts_usecase.dart';

class PostDependencies {
  static void initDependencies() {
    final getIt = GetIt.instance;

    // Datasources
    getIt.registerLazySingleton<PostDatasource>(() => PostDatasourceImpl(
          getIt<FirebaseFirestore>(),
        ));

    getIt.registerLazySingleton<PostCommentDatasource>(() => PostCommentDatasourceImpl(
          getIt<FirebaseFirestore>(),
        ));

    getIt.registerLazySingleton<PostLikeDatasource>(() => PostLikeDatasourceImpl(
          getIt<FirebaseFirestore>(),
        ));

    getIt.registerLazySingleton<PostReplyDatasource>(() => PostReplyDatasourceImpl(
          getIt<FirebaseFirestore>(),
        ));

    getIt.registerLazySingleton<CommentLikeDataSource>(() => CommentLikeDataSourceImpl(
          firestore: getIt<FirebaseFirestore>(),
        ));

    getIt.registerLazySingleton<ReplyLikeDataSource>(() => ReplyLikeDataSourceImpl(
          firestore: getIt<FirebaseFirestore>(),
        ));

    getIt.registerLazySingleton<TransactionDatasource>(() => TransactionDatasourceImpl(
          getIt<FirebaseFirestore>(),
        ));

    // Repositories
    getIt.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(
          getIt<PostDatasource>(),
          getIt<PostCommentDatasource>(),
          getIt<PostLikeDatasource>(),
          getIt<PostReplyDatasource>(),
          getIt<CommentLikeDataSource>(),
          getIt<ReplyLikeDataSource>(),
          getIt<TransactionDatasource>(),
        ));

    getIt.registerLazySingleton<PostLikeRepository>(() => PostLikeRepositoryImpl(
          getIt<PostLikeDatasource>(),
          getIt<PostDatasource>(),
          getIt<TransactionDatasource>(),
        ));

    getIt.registerLazySingleton<PostCommentRepository>(() => PostCommentRepositoryImpl(
          getIt<PostCommentDatasource>(),
          getIt<PostDatasource>(),
          getIt<PostReplyDatasource>(),
          getIt<CommentLikeDataSource>(),
          getIt<ReplyLikeDataSource>(),
          getIt<TransactionDatasource>(),
        ));

    getIt.registerLazySingleton<PostReplyRepository>(() => PostReplyRepositoryImpl(
          getIt<PostReplyDatasource>(),
          getIt<PostDatasource>(),
          getIt<ReplyLikeDataSource>(),
          getIt<TransactionDatasource>(),
        ));

    getIt.registerLazySingleton<CommentLikeRepository>(() => CommentLikeRepositoryImpl(
          likeDataSource: getIt<CommentLikeDataSource>(),
          commentDatasource: getIt<PostCommentDatasource>(),
          transactionDatasource: getIt<TransactionDatasource>(),
        ));

    getIt.registerLazySingleton<ReplyLikeRepository>(() => ReplyLikeRepositoryImpl(
          likeDataSource: getIt<ReplyLikeDataSource>(),
          replyDatasource: getIt<PostReplyDatasource>(),
          transactionDatasource: getIt<TransactionDatasource>(),
        ));

    // Usecases
    getIt.registerLazySingleton<UploadPostUsecase>(() => UploadPostUsecase(
          authRepository: getIt<AuthRepository>(),
          userRepository: getIt<UserRepository>(),
          postRepository: getIt<PostRepository>(),
          imageRepository: getIt<ImageRepository>(),
          translationRepository: getIt<TranslationRepository>(),
          uuid: getIt<Uuid>(),
        ));

    getIt.registerLazySingleton<GetPostCommentsUsecase>(() => GetPostCommentsUsecase(
          getIt<PostCommentRepository>(),
          getIt<UserRepository>(),
          getIt<PostReplyRepository>(),
          getIt<CommentLikeRepository>(),
          getIt<ReplyLikeRepository>(),
          getIt<AuthRepository>(),
        ));

    getIt.registerLazySingleton<GetPostWithLikeStatusUsecase>(() => GetPostWithLikeStatusUsecase(
          getIt<UserRepository>(),
          getIt<PostRepository>(),
          getIt<PostLikeRepository>(),
        ));

    getIt.registerLazySingleton<GetRecentPostsWithLikeStatusUsecase>(() => GetRecentPostsWithLikeStatusUsecase(
          getIt<AuthRepository>(),
          getIt<UserRepository>(),
          getIt<PostRepository>(),
          getIt<PostLikeRepository>(),
        ));

    getIt.registerLazySingleton<AddPostCommentUsecase>(() => AddPostCommentUsecase(
          getIt<AuthRepository>(),
          getIt<PostCommentRepository>(),
          getIt<TranslationRepository>(),
          getIt<Uuid>(),
        ));

    getIt.registerLazySingleton<AddPostReplyUsecase>(() => AddPostReplyUsecase(
          getIt<AuthRepository>(),
          getIt<PostReplyRepository>(),
          getIt<TranslationRepository>(),
          getIt<Uuid>(),
        ));

    getIt.registerLazySingleton<HandlePostLikeUsecase>(() => HandlePostLikeUsecase(
          getIt<AuthRepository>(),
          getIt<PostLikeRepository>(),
          getIt<Uuid>(),
        ));

    getIt.registerLazySingleton<HandleCommentLikeUsecase>(() => HandleCommentLikeUsecase(
          repository: getIt<CommentLikeRepository>(),
        ));

    getIt.registerLazySingleton<HandleReplyLikeUsecase>(() => HandleReplyLikeUsecase(
          repository: getIt<ReplyLikeRepository>(),
        ));

    getIt.registerLazySingleton<GetFilteredPostsUsecase>(() => GetFilteredPostsUsecase(
          getIt<PostRepository>(),
          getIt<AuthRepository>(),
          getIt<UserRepository>(),
          getIt<PostLikeRepository>(),
        ));

    getIt.registerLazySingleton<DeletePostCommentUsecase>(() => DeletePostCommentUsecase(
          getIt<PostCommentRepository>(),
        ));

    getIt.registerLazySingleton<DeletePostReplyUsecase>(() => DeletePostReplyUsecase(
          getIt<PostReplyRepository>(),
        ));

    getIt.registerLazySingleton<UpdatePostCommentUsecase>(() => UpdatePostCommentUsecase(
          getIt<PostCommentRepository>(),
        ));

    getIt.registerLazySingleton<UpdatePostUsecase>(() => UpdatePostUsecase(
          getIt<PostRepository>(),
        ));

    getIt.registerLazySingleton<UpdatePostReplyUsecase>(() => UpdatePostReplyUsecase(
          getIt<PostReplyRepository>(),
        ));

    getIt.registerLazySingleton<DeletePostUsecase>(() => DeletePostUsecase(
          getIt<PostRepository>(),
          getIt<ImageRepository>(),
        ));

    getIt.registerLazySingleton<GetCurrentUserPostsUsecase>(() => GetCurrentUserPostsUsecase(
          getIt<AuthRepository>(),
          getIt<UserRepository>(),
          getIt<PostRepository>(),
          getIt<PostLikeRepository>(),
        ));

    getIt.registerLazySingleton<GetUserLikedPostsUsecase>(() => GetUserLikedPostsUsecase(
          getIt<AuthRepository>(),
          getIt<UserRepository>(),
          getIt<PostRepository>(),
          getIt<PostLikeRepository>(),
        ));

    // Provider
    getIt.registerLazySingleton<PostProvider>(() => PostProvider(
          getCurrentUserPostsUsecase: getIt<GetCurrentUserPostsUsecase>(),
          getRecentPostsWithLikeStatusUsecase: getIt<GetRecentPostsWithLikeStatusUsecase>(),
          getCommentsUsecase: getIt<GetPostCommentsUsecase>(),
          uploadPostUsecase: getIt<UploadPostUsecase>(),
          handlePostLikeUsecase: getIt<HandlePostLikeUsecase>(),
          handleCommentLikeUsecase: getIt<HandleCommentLikeUsecase>(),
          handleReplyLikeUsecase: getIt<HandleReplyLikeUsecase>(),
          getFilteredPostsUsecase: getIt<GetFilteredPostsUsecase>(),
          addPostCommentUsecase: getIt<AddPostCommentUsecase>(),
          addPostReplyUsecase: getIt<AddPostReplyUsecase>(),
          updatePostCommentUsecase: getIt<UpdatePostCommentUsecase>(),
          deletePostCommentUsecase: getIt<DeletePostCommentUsecase>(),
          updatePostReplyUsecase: getIt<UpdatePostReplyUsecase>(),
          deletePostReplyUsecase: getIt<DeletePostReplyUsecase>(),
          updatePostUsecase: getIt<UpdatePostUsecase>(),
          deletePostUsecase: getIt<DeletePostUsecase>(),
          getUserLikedPostsUsecase: getIt<GetUserLikedPostsUsecase>(),
        ));
  }
}
