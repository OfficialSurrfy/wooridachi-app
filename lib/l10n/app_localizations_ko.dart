// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get welcome_back => '안녕하세요!';

  @override
  String get login_greeting => '손바닥에서 꽃피는 한일교류! 한일 대학생들의 생각이 궁금하지 않으신가요?';

  @override
  String get email_address_hint => '이메일 주소';

  @override
  String get password_hint1 => '비밀번호';

  @override
  String get log_in_button => '로그인';

  @override
  String get forgot_password => '비밀번호 변경하기';

  @override
  String get or_text => 'or';

  @override
  String get create_account_button => '회원가입';

  @override
  String get incorrect_password_alert_title => '비밀번호가 틀렸습니다';

  @override
  String get please_enter_both_email_password => '이메일과 비밀번호를 입력하시오.';

  @override
  String login_failed_message(Object message) {
    return '로그인 실패: $message';
  }

  @override
  String get error_occurred_message => '오류가 발생했습니다. 다시 시도해주십시오.';

  @override
  String get create_account_title => '회원가입';

  @override
  String get required_field_note => '* 필수 항목';

  @override
  String get select_university => '대학교 선택';

  @override
  String get choose_language => '어플 언어 선택';

  @override
  String get password_hint2 => '비밀번호 입력하기';

  @override
  String get password_min_length_error => '비밀번호는 최소 6자 이상이어야 합니다.';

  @override
  String get confirm_password_hint => '비밀번호 재입력';

  @override
  String get please_select_language => '언어를 선택해 주세요.';

  @override
  String get please_select_university => '대학교를 선택해 주세요.';

  @override
  String get please_enter_password => '비밀번호를 입력해 주세요.';

  @override
  String get please_confirm_password => '비밀번호를 확인해 주세요.';

  @override
  String get passwords_do_not_match => '비밀번호가 일치하지 않습니다.';

  @override
  String get send_confirmation_button => '다음 단계';

  @override
  String get email_already_exists_error => '이미 등록된 이메일입니다.';

  @override
  String get failed_sign_up_error =>
      '회원가입에 실패했습니다. officialsurrfy@gmail.com으로 문의해 주세요.';

  @override
  String get terms_agreement_title => '약관 동의하기';

  @override
  String get agree_to_all_terms => '아래 이용약관 다 동의합니다';

  @override
  String get service_terms_agreement => '서비스 이용약관 동의';

  @override
  String get privacy_policy_agreement => '개인정보처리방침 동의';

  @override
  String get community_guidelines_confirmation => '커뮤니티이용규칙 동의';

  @override
  String get ads_info_consent => '광고성 정보 수신 동의 (선택)';

  @override
  String get over_14_years_old_confirmation => '만 14세 이상입니다';

  @override
  String get next_step_button => '다음 단계';

  @override
  String get verification_email_sent => '본인 확인 메일이 발송되었습니다';

  @override
  String get email_sent_to => '확인 이메일을 아래 주소로 보냈습니다:';

  @override
  String get verify_and_proceed => '인증 버튼을 눌렀다면 \'다음\'을 눌러주십시오.';

  @override
  String get next_button1 => '다음 단계';

  @override
  String get congratulations => '축하합니다!';

  @override
  String get registration_complete => '회원가입이 완료 되었습니다';

  @override
  String get welcome_message => '한일 대학생 커뮤니티에 오셔오세요!';

  @override
  String get next_button2 => '다음';

  @override
  String get latest_sort => '최신순';

  @override
  String get popular_sort => '인기순';

  @override
  String get home => '홈';

  @override
  String get home_back => '홈 (뒤로가기)';

  @override
  String get current_trends => '요즘 한일트렌드는?';

  @override
  String get ask_uridachi => '우리다치한테 다 물어봐!';

  @override
  String get korea_japan_sns => '한일 SNS';

  @override
  String get trending_news => '트렌드 뉴스';

  @override
  String get what_know_uridachi => '우리다치에서 어떤것을 알고싶어?';

  @override
  String get profile => '프로필';

  @override
  String get nickname => '닉네임';

  @override
  String get edit_profile => '프로필 수정하기';

  @override
  String get change_photo => '사진 바꾸기';

  @override
  String get modify => '수정하기';

  @override
  String get apply => '적용하기';

  @override
  String get content => '컨텐츠';

  @override
  String get liked_posts => '좋아요한 게시물';

  @override
  String get use_policy => '이용약관 / 개인정보처리방침';

  @override
  String get my_posts => '내 게시물';

  @override
  String get settings => '설정';

  @override
  String get faq => '문의하기';

  @override
  String get logout => '로그아웃';

  @override
  String get chat => '채팅';

  @override
  String get write_post => '글쓰기';

  @override
  String get upload => '업로드';

  @override
  String get title => '제목';

  @override
  String get content_body => '내용';

  @override
  String get attach_photo => '사진첨부';

  @override
  String get nav_home => '홈';

  @override
  String get nav_chat => '채팅';

  @override
  String get nav_trend => '트렌드 뉴스';

  @override
  String get nav_my => 'MY';

  @override
  String get my_chat => '내 채팅';

  @override
  String get type_message => '메시지를 입력하세요...';

  @override
  String get write_a_reply => '답글 작성...';

  @override
  String get reply => '답글';

  @override
  String get like => '공감';

  @override
  String get report => '신고';

  @override
  String get error_loading_images => '이미지 로드 오류';

  @override
  String get no_trending_posts => '인기 게시물이 없습니다';

  @override
  String get failed_to_load_comments => '댓글 로드에 실패했습니다';

  @override
  String get no_comments_yet => '아직 댓글이 없습니다.';

  @override
  String get write_a_comment => '댓글 작성...';

  @override
  String get edit_profile_reminder => '프로필 아이콘을 탭하여 \n개인 정보 및 설정을 언제든지 수정하세요.';

  @override
  String get required_field_indicator => '* 필수 입력 항목';

  @override
  String get terms_agreement => '약관 동의';

  @override
  String get mandatory => '(필수)';

  @override
  String get view_details => '자세히 보기';

  @override
  String get advertising_consent => '광고성 정보 수신 동의 (선택)';

  @override
  String get age_confirmation => '만 14세입니다';

  @override
  String get change_password => '비밀번호 변경하기';

  @override
  String get enter_email => '이메일 입력하기';

  @override
  String get verify_email => '이메일 인증하기';

  @override
  String get bookmarked_posts => '북마크된 게시물';

  @override
  String get no_bookmarked_posts => '북마크된 게시물이 없습니다';

  @override
  String get change_language => '언어 변경';

  @override
  String get kr_korean => 'KR 한국어';

  @override
  String get jp_japanese => 'JP 일본어';

  @override
  String get us_english => 'US 영어';

  @override
  String get restricted => '(제한적)';

  @override
  String get apply_changes => '변경하기';

  @override
  String get contact_us => '문의하기';

  @override
  String get send_feedback => '건의사항이나 문제를 자유롭게 말씀해주세요!';

  @override
  String get send => '보내기';

  @override
  String get university_name => '한국외국어대학교';

  @override
  String get delete_account => '계정 삭제';

  @override
  String get add_post => '게시물 추가';

  @override
  String get select_image => '갤러리 및 카메라에서 이미지 선택';

  @override
  String get select_korean_image => '갤러리 및 카메라에서 한국어 이미지 선택';

  @override
  String get select_japanese_image => '갤러리 및 카메라에서 일본어 이미지 선택';

  @override
  String get write_korean_title => '한국어 제목을 작성하세요';

  @override
  String get write_japanese_title => '일본어 제목을 작성하세요';

  @override
  String get write_korean_content => '한국어 내용을 작성하세요...';

  @override
  String get write_japanese_content => '일본어 내용을 작성하세요...';

  @override
  String get university => '대학';

  @override
  String get search => '검색';

  @override
  String get money_rating => '금전 평가';

  @override
  String get average_rating => '평균 평가';

  @override
  String get star_rating => '별점';

  @override
  String get your_email => '이메일';

  @override
  String get edit_comment => '댓글 수정...';

  @override
  String get edit_reply => '답글 수정...';
}
