import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import '../../../../../main.dart';
import '../../providers/user_provider.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  String? _profileImageUrl;
  File? _selectedImageFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      if (user != null) {
        setState(() {
          _profileImageUrl = user.profileImageUrl;
          _usernameController.text = user.username;
        });
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFFECEFFF),
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.008744),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.008744),
              child: Text(
                localization.edit_profile,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          centerTitle: false,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.07651),
            child: Divider(
              color: const Color(0xffe8e8e8),
            ),
          ),
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight * 0.19674,
                  decoration: const BoxDecoration(
                    color: Color(0xFFECEFFF),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.2186,
                ),
                Positioned(
                  left: screenWidth * 0.361,
                  top: screenHeight * 0.107,
                  child: Container(
                    height: screenHeight * 0.123509,
                    width: screenWidth * 0.274251,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.387,
                  top: screenHeight * 0.1133,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundImage: _selectedImageFile != null
                        ? FileImage(_selectedImageFile!)
                        : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty)
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/images/Avatar.png') as ImageProvider,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _pickImage,
                  child: Text(
                    localization.change_photo,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.017488),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04854),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        localization.nickname,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.008744),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.029124,
                    ),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.5, color: Color(0xFF545454)),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        return TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            hintText: 'Input New Name',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            color: Color(0xFF989898),
                            fontSize: 14,
                            fontFamily: 'SF Pro Rounded',
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.017488),
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () async {
                            _toggleLoading();
                            final userProvider = Provider.of<UserProvider>(context, listen: false);
                            await userProvider.updateUser(
                              context,
                              _usernameController.text,
                              _selectedImageFile,
                            );
                            _toggleLoading();
                          },
                    child: Container(
                      height: screenHeight * 0.05246,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.017488),
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(1.00, -0.06),
                          end: Alignment(-1, 0.06),
                          colors: [
                            Color(0xFFECE6FF),
                            Color(0xFFBAC9FF)
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: const CircularProgressIndicator(),
                              )
                            : Text(
                                localization.apply,
                                style: const TextStyle(
                                  color: Color(0xFF0E0E0E),
                                  fontSize: 14,
                                  fontFamily: 'SF Pro Rounded',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
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
