// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get welcome_back => 'こんにちは!';

  @override
  String get login_greeting => '手軽に始める日韓交流！日韓の大学生たちの考え、気になりませんか？';

  @override
  String get email_address_hint => '学生メールアドレス';

  @override
  String get password_hint1 => 'パスワード';

  @override
  String get log_in_button => 'ログイン';

  @override
  String get forgot_password => 'パスワード変更';

  @override
  String get or_text => 'or';

  @override
  String get create_account_button => '会員登録';

  @override
  String get incorrect_password_alert_title => 'パスワードが間違えました。';

  @override
  String get please_enter_both_email_password => 'メールアドレスとパスワードを入力してください。';

  @override
  String login_failed_message(Object message) {
    return 'ログイン失敗: $message';
  }

  @override
  String get error_occurred_message => 'エラーが起きてしまいました。もう一度試してください。';

  @override
  String get create_account_title => '会員登録';

  @override
  String get required_field_note => '* 必須項目';

  @override
  String get select_university => '大学校選択';

  @override
  String get choose_language => 'アプリ言語選択';

  @override
  String get password_hint2 => 'パスワード入力';

  @override
  String get password_min_length_error => 'パスワードは6文字以上に設定してください。';

  @override
  String get confirm_password_hint => 'パスワード再入力';

  @override
  String get please_select_language => '言語を選択してください。';

  @override
  String get please_select_university => '大学を選択してください。';

  @override
  String get please_enter_password => 'パスワードを入力してください。';

  @override
  String get please_confirm_password => 'パスワードを確認してください。';

  @override
  String get passwords_do_not_match => 'パスワードが違います。';

  @override
  String get send_confirmation_button => '次へ';

  @override
  String get email_already_exists_error => '登録したメールアドレスです。';

  @override
  String get failed_sign_up_error =>
      '会員登録に失敗しました。 officialsurrfy@gmail.comに問い合わせてください。';

  @override
  String get terms_agreement_title => '規約同意';

  @override
  String get agree_to_all_terms => '以下の規約を全部同意';

  @override
  String get service_terms_agreement => 'サービス利用規約同意';

  @override
  String get privacy_policy_agreement => 'プライバシーポリシー同意';

  @override
  String get community_guidelines_confirmation => 'コミュニティ利用規約同意';

  @override
  String get ads_info_consent => '広告受信同意 (選択)';

  @override
  String get over_14_years_old_confirmation => '14歳以上です  (必須)';

  @override
  String get next_step_button => '次へ';

  @override
  String get verification_email_sent => '本人確認メールを送信しました';

  @override
  String get email_sent_to => '確認メールを以下のメールアドレスに送信しました :';

  @override
  String get verify_and_proceed => '確認ボタンを押したら、下のボタンを押してください。';

  @override
  String get next_button1 => '次へ';

  @override
  String get congratulations => 'ようこそ!';

  @override
  String get registration_complete => '会員登録が完了しました！';

  @override
  String get welcome_message => '日韓大学生こみゅにてぃようこそ！';

  @override
  String get next_button2 => 'ウリダチを始めよう！';

  @override
  String get latest_sort => '最新順';

  @override
  String get popular_sort => '人気順';

  @override
  String get home => 'ホーム';

  @override
  String get home_back => 'ホーム（以前）';

  @override
  String get current_trends => '最近の日韓トレンド？';

  @override
  String get ask_uridachi => '何が知りたいですか？';

  @override
  String get korea_japan_sns => '日韓SNS';

  @override
  String get trending_news => 'トレンドニュース';

  @override
  String get what_know_uridachi => 'ウリダチで何を知りたいですか？';

  @override
  String get profile => 'MY';

  @override
  String get nickname => 'ユーザID';

  @override
  String get edit_profile => 'MY情報変更';

  @override
  String get change_photo => '写真を置き換え';

  @override
  String get modify => '変更する';

  @override
  String get apply => '確認';

  @override
  String get content => 'コンテンツ';

  @override
  String get liked_posts => 'いいねした投稿';

  @override
  String get use_policy => '利用規約/個人情報処理方針';

  @override
  String get my_posts => 'MYポスト';

  @override
  String get settings => '設定';

  @override
  String get faq => '問い合わせ';

  @override
  String get logout => 'ログアウト';

  @override
  String get chat => 'チャット';

  @override
  String get write_post => '投稿';

  @override
  String get upload => '投稿';

  @override
  String get title => 'タイトル';

  @override
  String get content_body => '内容';

  @override
  String get attach_photo => '写真添付';

  @override
  String get nav_home => 'ホーム';

  @override
  String get nav_chat => 'チャット';

  @override
  String get nav_trend => 'トレンドニュース';

  @override
  String get nav_my => 'MY';

  @override
  String get my_chat => 'MYチャット';

  @override
  String get type_message => 'メッセージを入力してください...';

  @override
  String get write_a_reply => '返信を書く...';

  @override
  String get reply => '返信';

  @override
  String get like => 'いいね';

  @override
  String get report => '報告';

  @override
  String get error_loading_images => '画像の読み込みエラー';

  @override
  String get no_trending_posts => 'トレンド投稿がありません';

  @override
  String get failed_to_load_comments => 'コメントの読み込みに失敗しました';

  @override
  String get no_comments_yet => 'まだコメントがありません。';

  @override
  String get write_a_comment => 'コメントを書く...';

  @override
  String get edit_profile_reminder => 'プロフィールアイコンをタップして、\n個人情報や設定をいつでも編集できます。';

  @override
  String get required_field_indicator => '* 必須項目';

  @override
  String get terms_agreement => '利用規約同意';

  @override
  String get mandatory => '（必須）';

  @override
  String get view_details => '詳細を見る';

  @override
  String get advertising_consent => '広告情報受信同意（任意）';

  @override
  String get age_confirmation => '14歳以上です';

  @override
  String get change_password => 'パスワードを変更する';

  @override
  String get enter_email => 'メールを入力してください';

  @override
  String get verify_email => 'メールを認証する';

  @override
  String get bookmarked_posts => 'ブックマークした投稿';

  @override
  String get no_bookmarked_posts => 'ブックマークした投稿はありません';

  @override
  String get change_language => '言語を変更する';

  @override
  String get kr_korean => 'KR 韓国語';

  @override
  String get jp_japanese => 'JP 日本語';

  @override
  String get us_english => 'US 英語';

  @override
  String get restricted => '（制限付き）';

  @override
  String get apply_changes => '変更を適用する';

  @override
  String get contact_us => 'お問い合わせ';

  @override
  String get send_feedback => 'フィードバックや問題点を自由にお聞かせください！';

  @override
  String get send => '送信';

  @override
  String get university_name => '韓国外国語大学';

  @override
  String get delete_account => 'アカウントを削除する';

  @override
  String get add_post => '投稿を追加する';

  @override
  String get select_image => 'ギャラリーとカメラから画像を選択';

  @override
  String get select_korean_image => 'ギャラリーとカメラから韓国語画像を選択';

  @override
  String get select_japanese_image => 'ギャラリーとカメラから日本語画像を選択';

  @override
  String get write_korean_title => '韓国語のタイトルを入力してください';

  @override
  String get write_japanese_title => '日本語のタイトルを入力してください';

  @override
  String get write_korean_content => '韓国語の内容を書く...';

  @override
  String get write_japanese_content => '日本語の内容を書く...';

  @override
  String get university => '大学';

  @override
  String get search => '検索';

  @override
  String get money_rating => 'お金の評価';

  @override
  String get average_rating => '平均評価';

  @override
  String get star_rating => '星評価';

  @override
  String get your_email => 'あなたのメール';

  @override
  String get edit_comment => 'コメントを編集...';

  @override
  String get edit_reply => '返信を編集...';
}
