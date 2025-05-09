import 'dart:io';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';

class InquiryScreen extends StatefulWidget {
  InquiryScreen({super.key});

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final Logger _logger = Logger('InquiryLogger');
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController _inquiryController = TextEditingController();
  bool isSendingEmail = false; // Track email sending state

  Future<void> sendEmail() async {
    setState(() {
      isSendingEmail = true; // Start loading
    });

    String username = 'officialsurrfy@gmail.com';
    String password = 'pzpr dcgh yzuo yqmp';
    String? inquiryUser = currentUser.email;
    String inquiryReason = _inquiryController.text;
    final smtpServer = SmtpServer(
      'smtp.gmail.com',
      port: 587,
      username: username,
      password: password,
      ignoreBadCertificate: false, // Set false to enforce certificate checks
    );
    final message = Message()
      ..from = Address(username, 'Wooridachi')
      ..recipients.add(username)
      ..subject = 'Inquiry email from Wooridachi'
      ..text = 'User: $inquiryUser \n Inquiry: $inquiryReason';

    try {
      final sendInquiry = await send(message, smtpServer);
      _logger.info('Message sent: $sendInquiry');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inquiry sent!', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
        );
        _inquiryController.clear();
      }
    } on MailerException catch (e) {
      _logger.severe('Message not sent: $e');
      for (var p in e.problems) {
        _logger.severe('Problem: ${p.code}: ${p.msg}');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send inquiry.', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e, stackTrace) {
      _logger.severe('Unexpected error: $e', e, stackTrace);
      if (e is SocketException) {
        _logger.severe('Socket Exception: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSendingEmail = false; // Stop loading
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _inquiryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context)!;

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
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Text(
            localization.contact_us,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
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
                  top: screenHeight * 0.11,
                  child: Container(
                    height: screenHeight * 0.123509,
                    width: screenHeight * 0.123509,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage('assets/images/inquiry.png'), scale: 0.9),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.002427 * 31),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        localization.contact_us,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.001093 * 16),
                  Container(
                    width: screenWidth * 0.002427 * 320,
                    height: screenHeight * 0.001093 * 344,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFFADADAD)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: TextField(
                      controller: _inquiryController,
                      style: TextStyle(color: Colors.black),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: localization.send_feedback,
                        hintStyle: TextStyle(color: Color(0xFFADADAD), fontSize: 12),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.002427 * 14, vertical: screenHeight * 0.001093 * 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: isSendingEmail ? null : sendEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSendingEmail ? Colors.black : Color(0xff582ab2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(
                  screenWidth * 0.002427 * 353,
                  screenHeight * 0.001093 * 56,
                ),
              ),
              child: isSendingEmail
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      localization.send,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
