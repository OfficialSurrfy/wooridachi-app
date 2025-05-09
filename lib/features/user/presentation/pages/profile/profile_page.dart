import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:uridachi/app/auth_page.dart';
import 'package:uridachi/features/user/presentation/pages/profile/profile_edit_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uridachi/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../auth/presentation/providers/app_auth_provider.dart';
import '../../../domain/entities/user_entity.dart';
import '../../providers/user_provider.dart';
import 'change_language.dart';
import 'inquiry.dart';
import 'like_page.dart';
import 'my_posts_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUser(context);
    });
  }

  Future<void> removeFcmToken(String email) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await FirebaseFirestore.instance.collection('users').doc(email).update({
        'fcmTokens': FieldValue.arrayRemove([
          fcmToken
        ])
      });
    }
  }

  void signUserOut() async {
    try {
      // await removeFcmToken(email);

      final appAuthProvider = Provider.of<AppAuthProvider>(context, listen: false);
      await appAuthProvider.signOut(context);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthPage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print(e.toString());
      if (mounted) {
        showSnackBar(context, 'Error signing out. Please try again.');
      }
    }
  }

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _confirmDeleteAccount() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Do you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () async {
                final appAuthProvider = Provider.of<AppAuthProvider>(context, listen: false);
                await appAuthProvider.deleteAccount(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(localization),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
        child: Container(
          color: Colors.white,
          height: screenHeight,
          child: _buildUserProfile(context, screenHeight, screenWidth, localization),
        ),
      ),
    );
  }

  AppBar _buildAppBar(AppLocalizations localization) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        localization.profile,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w800,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildUserProfile(BuildContext context, double screenHeight, double screenWidth, AppLocalizations localization) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        if (user != null) {
          return _buildProfileContent(user, screenHeight, screenWidth, localization);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildProfileContent(UserEntity userData, double screenHeight, double screenWidth, AppLocalizations localization) {
    String? profileImageUrl = userData.profileImageUrl;

    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.038832,
        right: screenWidth * 0.038832,
      ),
      child: Column(
        children: [
          _buildProfileHeader(userData, profileImageUrl, screenHeight, screenWidth, localization),
          SizedBox(height: screenHeight * 0.001093 * 18),
          const Divider(color: Colors.grey),
          _buildContentSection(localization),
          const Divider(color: Colors.grey),
          _buildSettingsSection(localization),
          SizedBox(height: screenHeight * 0.001093 * 30),
          _buildLogoutButton(screenWidth, screenHeight, localization),
          _buildDeleteAccountLink(screenHeight, localization),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserEntity userData, String? profileImageUrl, double screenHeight, double screenWidth, AppLocalizations localization) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.001093 * 230,
      decoration: ShapeDecoration(
        color: const Color(0xFFECEFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.001093 * 8,
          horizontal: screenWidth * 0.013116,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileInfo(userData, profileImageUrl, screenHeight, screenWidth, localization),
            SizedBox(height: screenHeight * 0.013116),
            _buildEditProfileButton(screenHeight, screenWidth, localization),
            SizedBox(height: screenHeight * 0.013116),
            const Divider(),
            _buildUserEmail(userData, screenWidth),
            SizedBox(height: screenHeight * 0.004372),
            _buildUserUniversity(userData, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(UserEntity userData, String? profileImageUrl, double screenHeight, double screenWidth, AppLocalizations localization) {
    return SizedBox(
      width: screenWidth * 0.817899,
      height: screenHeight * 0.052464,
      child: Row(
        children: [
          _buildProfileImage(profileImageUrl, screenHeight, screenWidth),
          SizedBox(width: screenWidth * 0.021843),
          _buildUserName(userData, localization),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String? profileImageUrl, double screenHeight, double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.116496,
      height: screenHeight * 0.052464,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: screenWidth * 0.116496,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 0.00499962,
            top: screenHeight * 0.00225158,
            child: Container(
              width: screenWidth * 0.002427 * 40,
              height: screenHeight * 0.001093 * 40,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: screenWidth * 0.0012135,
                    color: const Color(0xFFDDDDDD),
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: profileImageUrl != null && profileImageUrl.isNotEmpty ? Image.network(profileImageUrl, fit: BoxFit.cover) : Image.asset('assets/images/Avatar.png', fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserName(UserEntity userData, AppLocalizations localization) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.nickname,
            style: TextStyle(
              color: const Color(0xff582ab2),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            userData.username,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton(double screenHeight, double screenWidth, AppLocalizations localization) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: SizedBox(
        height: screenHeight * 0.060115,
        width: screenWidth * 0.84945,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileEditPage()),
            );
          },
          child: Text(
            localization.modify,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'SF Pro Rounded',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserEmail(UserEntity userData, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.03),
      child: Text(
        userData.email,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildUserUniversity(UserEntity userData, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.03),
      child: Text(
        userData.university,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildContentSection(AppLocalizations localization) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              localization.content,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Divider(color: Colors.grey),
        _buildContentOptions(),
      ],
    );
  }

  Widget _buildContentOptions() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      child: Column(
        children: [
          _buildContentOption(
            'assets/images/heart_icon.png',
            AppLocalizations.of(context).liked_posts,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserLikes(currentUserEmail: currentUser.email),
                ),
              );
            },
          ),
          _buildContentOption(
            'assets/images/new_post_icon.png',
            AppLocalizations.of(context).my_posts,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UsersPosts(currentUserEmail: currentUser.email),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContentOption(String iconPath, String text, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.015302,
                  width: MediaQuery.of(context).size.width * 0.033978,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(iconPath),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.0090708),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(
              child: Image.asset('assets/images/arrow_right.png'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(AppLocalizations localization) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              localization.settings,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Divider(color: Colors.grey),
        _buildSettingsOptions(),
      ],
    );
  }

  Widget _buildSettingsOptions() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      child: Column(
        children: [
          _buildSettingsOption(
            AppLocalizations.of(context).change_language,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeLanguage()),
              );
            },
          ),
          _buildSettingsOption(
            AppLocalizations.of(context).faq,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InquiryScreen()),
              );
            },
          ),
          _buildSettingsOption(
            AppLocalizations.of(context).use_policy,
            () {
              launchURL('https://citrine-scent-fa8.notion.site/133d64f786f9806c8e34de68376579ea');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(String text, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              child: Image.asset('assets/images/arrow_right.png'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(double screenWidth, double screenHeight, AppLocalizations localization) {
    return GestureDetector(
      onTap: () {
        signUserOut();
      },
      child: Container(
        width: screenWidth * 0.837315,
        height: screenHeight * 0.001093 * 55,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.058248,
          vertical: screenHeight * 0.017488,
        ),
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localization.logout,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'SF Pro Rounded',
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccountLink(double screenHeight, AppLocalizations localization) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.001093 * 10),
      child: InkWell(
        onTap: _confirmDeleteAccount,
        child: Text(
          localization.delete_account,
          style: TextStyle(color: Color(0xff582ab2)),
        ),
      ),
    );
  }
}
