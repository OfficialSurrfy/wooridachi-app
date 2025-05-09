import 'package:flutter/material.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:uridachi/features/post/presentation/pages/global_postcard.dart';

import '../../domain/entities/post_view_dto.dart';

class OriginalContent extends StatelessWidget {
  final List<PostViewDto> globalPosts;
  final bool isLoading;
  final bool isInitialLoad;

  const OriginalContent({
    super.key,
    required this.globalPosts,
    required this.isLoading,
    required this.isInitialLoad, required ScrollController scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);
    String localeName = localization.localeName;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.038832),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSnsSection(screenHeight, localization, screenWidth),
          ],
        ),
      ),
    );
  }

  Column _buildSnsSection(double screenHeight, AppLocalizations localization, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.028418),
          child: Text(
            localization.korea_japan_sns,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: screenWidth * 0.008),
          child: const Divider(
            color: Color(0xffE0E0E0),
          ),
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: globalPosts.length,
                itemBuilder: (context, index) {
                  final doc = globalPosts[index];
                  return Column(
                    children: [
                      GlobalPostcard(postViewDto: doc, isPreview: true),
                      Padding(
                        padding: EdgeInsets.only(bottom: screenWidth * 0.008, top: screenHeight * 0.015),
                        child: const Divider(
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ],
    );
  }
}
