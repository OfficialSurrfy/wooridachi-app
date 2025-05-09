import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko')
  ];

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Hi! 👋'**
  String get welcome_back;

  /// No description provided for @login_greeting.
  ///
  /// In en, this message translates to:
  /// **'Curious about what Korean and Japanese university students think? Log in to start connecting!'**
  String get login_greeting;

  /// No description provided for @email_address_hint.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_address_hint;

  /// No description provided for @password_hint1.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_hint1;

  /// No description provided for @log_in_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get log_in_button;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgot_password;

  /// No description provided for @or_text.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or_text;

  /// No description provided for @create_account_button.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get create_account_button;

  /// No description provided for @incorrect_password_alert_title.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get incorrect_password_alert_title;

  /// No description provided for @please_enter_both_email_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter both email and password.'**
  String get please_enter_both_email_password;

  /// No description provided for @login_failed_message.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {message}'**
  String login_failed_message(Object message);

  /// No description provided for @error_occurred_message.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get error_occurred_message;

  /// No description provided for @create_account_title.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get create_account_title;

  /// No description provided for @required_field_note.
  ///
  /// In en, this message translates to:
  /// **'*mandatory field'**
  String get required_field_note;

  /// No description provided for @select_university.
  ///
  /// In en, this message translates to:
  /// **'University Name'**
  String get select_university;

  /// No description provided for @choose_language.
  ///
  /// In en, this message translates to:
  /// **'Choose App Language'**
  String get choose_language;

  /// No description provided for @password_hint2.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get password_hint2;

  /// No description provided for @password_min_length_error.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get password_min_length_error;

  /// No description provided for @confirm_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get confirm_password_hint;

  /// No description provided for @please_select_language.
  ///
  /// In en, this message translates to:
  /// **'Please select a language.'**
  String get please_select_language;

  /// No description provided for @please_select_university.
  ///
  /// In en, this message translates to:
  /// **'Please select a university.'**
  String get please_select_university;

  /// No description provided for @please_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password.'**
  String get please_enter_password;

  /// No description provided for @please_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password.'**
  String get please_confirm_password;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwords_do_not_match;

  /// No description provided for @send_confirmation_button.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get send_confirmation_button;

  /// No description provided for @email_already_exists_error.
  ///
  /// In en, this message translates to:
  /// **'Email address is already registered.'**
  String get email_already_exists_error;

  /// No description provided for @failed_sign_up_error.
  ///
  /// In en, this message translates to:
  /// **'Sign-up failed. Please contact officialsurrfy@gmail.com.'**
  String get failed_sign_up_error;

  /// No description provided for @terms_agreement_title.
  ///
  /// In en, this message translates to:
  /// **'Accept Terms and Conditions'**
  String get terms_agreement_title;

  /// No description provided for @agree_to_all_terms.
  ///
  /// In en, this message translates to:
  /// **'I agree to all of the terms and conditions below'**
  String get agree_to_all_terms;

  /// No description provided for @service_terms_agreement.
  ///
  /// In en, this message translates to:
  /// **'Service Terms Agreement'**
  String get service_terms_agreement;

  /// No description provided for @privacy_policy_agreement.
  ///
  /// In en, this message translates to:
  /// **'Agreement to the Privacy Policy'**
  String get privacy_policy_agreement;

  /// No description provided for @community_guidelines_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation of Community Guidelines'**
  String get community_guidelines_confirmation;

  /// No description provided for @ads_info_consent.
  ///
  /// In en, this message translates to:
  /// **'Receive Promotional Information (Optional)'**
  String get ads_info_consent;

  /// No description provided for @over_14_years_old_confirmation.
  ///
  /// In en, this message translates to:
  /// **'I am 14 years of age or older'**
  String get over_14_years_old_confirmation;

  /// No description provided for @next_step_button.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next_step_button;

  /// No description provided for @verification_email_sent.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Email Sent!'**
  String get verification_email_sent;

  /// No description provided for @email_sent_to.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation email to this address:'**
  String get email_sent_to;

  /// No description provided for @verify_and_proceed.
  ///
  /// In en, this message translates to:
  /// **'If you have clicked the link, press the next button!'**
  String get verify_and_proceed;

  /// No description provided for @next_button1.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next_button1;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @registration_complete.
  ///
  /// In en, this message translates to:
  /// **'You have successfully registered as a member!'**
  String get registration_complete;

  /// No description provided for @welcome_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome onboard!'**
  String get welcome_message;

  /// No description provided for @next_button2.
  ///
  /// In en, this message translates to:
  /// **'Click to start!'**
  String get next_button2;

  /// No description provided for @latest_sort.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest_sort;

  /// No description provided for @popular_sort.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get popular_sort;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @home_back.
  ///
  /// In en, this message translates to:
  /// **'Home (Back)'**
  String get home_back;

  /// No description provided for @current_trends.
  ///
  /// In en, this message translates to:
  /// **'Look what\'s hot'**
  String get current_trends;

  /// No description provided for @ask_uridachi.
  ///
  /// In en, this message translates to:
  /// **'Search Anything!'**
  String get ask_uridachi;

  /// No description provided for @korea_japan_sns.
  ///
  /// In en, this message translates to:
  /// **'KR / JPN SNS'**
  String get korea_japan_sns;

  /// No description provided for @trending_news.
  ///
  /// In en, this message translates to:
  /// **'Trend News'**
  String get trending_news;

  /// No description provided for @what_know_uridachi.
  ///
  /// In en, this message translates to:
  /// **'What do you want to know about Uridachi?'**
  String get what_know_uridachi;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'MY'**
  String get profile;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @change_photo.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get change_photo;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get modify;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get apply;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get content;

  /// No description provided for @liked_posts.
  ///
  /// In en, this message translates to:
  /// **'Liked Posts'**
  String get liked_posts;

  /// No description provided for @use_policy.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use / Privacy Policy'**
  String get use_policy;

  /// No description provided for @my_posts.
  ///
  /// In en, this message translates to:
  /// **'My Posts'**
  String get my_posts;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Q/A'**
  String get faq;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @write_post.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get write_post;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get upload;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @content_body.
  ///
  /// In en, this message translates to:
  /// **'Context'**
  String get content_body;

  /// No description provided for @attach_photo.
  ///
  /// In en, this message translates to:
  /// **'Attach Photos'**
  String get attach_photo;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get nav_chat;

  /// No description provided for @nav_trend.
  ///
  /// In en, this message translates to:
  /// **'Trend News'**
  String get nav_trend;

  /// No description provided for @nav_my.
  ///
  /// In en, this message translates to:
  /// **'MY'**
  String get nav_my;

  /// No description provided for @my_chat.
  ///
  /// In en, this message translates to:
  /// **'My chat'**
  String get my_chat;

  /// No description provided for @type_message.
  ///
  /// In en, this message translates to:
  /// **'type message...'**
  String get type_message;

  /// No description provided for @write_a_reply.
  ///
  /// In en, this message translates to:
  /// **'Write a reply...'**
  String get write_a_reply;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @error_loading_images.
  ///
  /// In en, this message translates to:
  /// **'Error loading images'**
  String get error_loading_images;

  /// No description provided for @no_trending_posts.
  ///
  /// In en, this message translates to:
  /// **'No trending posts available'**
  String get no_trending_posts;

  /// No description provided for @failed_to_load_comments.
  ///
  /// In en, this message translates to:
  /// **'Failed to load comments'**
  String get failed_to_load_comments;

  /// No description provided for @no_comments_yet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet.'**
  String get no_comments_yet;

  /// No description provided for @write_a_comment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get write_a_comment;

  /// No description provided for @edit_profile_reminder.
  ///
  /// In en, this message translates to:
  /// **'Don’t forget that you can always edit \nyour personal information and preferences\nby tapping on the Profile icon.'**
  String get edit_profile_reminder;

  /// No description provided for @required_field_indicator.
  ///
  /// In en, this message translates to:
  /// **'* Indicates required field'**
  String get required_field_indicator;

  /// No description provided for @terms_agreement.
  ///
  /// In en, this message translates to:
  /// **'Terms Agreement'**
  String get terms_agreement;

  /// No description provided for @mandatory.
  ///
  /// In en, this message translates to:
  /// **'(Mandatory)'**
  String get mandatory;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get view_details;

  /// No description provided for @advertising_consent.
  ///
  /// In en, this message translates to:
  /// **'Consent to receive advertising information (Optional)'**
  String get advertising_consent;

  /// No description provided for @age_confirmation.
  ///
  /// In en, this message translates to:
  /// **'I am 14 years old'**
  String get age_confirmation;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enter_email;

  /// No description provided for @verify_email.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verify_email;

  /// No description provided for @bookmarked_posts.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked Posts'**
  String get bookmarked_posts;

  /// No description provided for @no_bookmarked_posts.
  ///
  /// In en, this message translates to:
  /// **'No bookmarked posts found'**
  String get no_bookmarked_posts;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get change_language;

  /// No description provided for @kr_korean.
  ///
  /// In en, this message translates to:
  /// **'KR Korean'**
  String get kr_korean;

  /// No description provided for @jp_japanese.
  ///
  /// In en, this message translates to:
  /// **'JP Japanese'**
  String get jp_japanese;

  /// No description provided for @us_english.
  ///
  /// In en, this message translates to:
  /// **'US English'**
  String get us_english;

  /// No description provided for @restricted.
  ///
  /// In en, this message translates to:
  /// **'(Restricted)'**
  String get restricted;

  /// No description provided for @apply_changes.
  ///
  /// In en, this message translates to:
  /// **'Apply Changes'**
  String get apply_changes;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @send_feedback.
  ///
  /// In en, this message translates to:
  /// **'Feel free to share any feedback or issues!'**
  String get send_feedback;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @university_name.
  ///
  /// In en, this message translates to:
  /// **'Korean Foreign Language University'**
  String get university_name;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account;

  /// No description provided for @add_post.
  ///
  /// In en, this message translates to:
  /// **'Add Post'**
  String get add_post;

  /// No description provided for @select_image.
  ///
  /// In en, this message translates to:
  /// **'Select Image from Gallery and Camera'**
  String get select_image;

  /// No description provided for @select_korean_image.
  ///
  /// In en, this message translates to:
  /// **'Select Korean Image from Gallery and Camera'**
  String get select_korean_image;

  /// No description provided for @select_japanese_image.
  ///
  /// In en, this message translates to:
  /// **'Select Japanese Image from Gallery and Camera'**
  String get select_japanese_image;

  /// No description provided for @write_korean_title.
  ///
  /// In en, this message translates to:
  /// **'Write your Korean Title'**
  String get write_korean_title;

  /// No description provided for @write_japanese_title.
  ///
  /// In en, this message translates to:
  /// **'Write your Japanese Title'**
  String get write_japanese_title;

  /// No description provided for @write_korean_content.
  ///
  /// In en, this message translates to:
  /// **'Write your Korean content...'**
  String get write_korean_content;

  /// No description provided for @write_japanese_content.
  ///
  /// In en, this message translates to:
  /// **'Write your Japanese content...'**
  String get write_japanese_content;

  /// No description provided for @university.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get university;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @money_rating.
  ///
  /// In en, this message translates to:
  /// **'Money Rating'**
  String get money_rating;

  /// No description provided for @average_rating.
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get average_rating;

  /// No description provided for @star_rating.
  ///
  /// In en, this message translates to:
  /// **'Star Rating'**
  String get star_rating;

  /// No description provided for @your_email.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get your_email;

  /// No description provided for @edit_comment.
  ///
  /// In en, this message translates to:
  /// **'Edit comment...'**
  String get edit_comment;

  /// No description provided for @edit_reply.
  ///
  /// In en, this message translates to:
  /// **'Edit reply...'**
  String get edit_reply;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
