import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';
import 'global_postcard.dart';

class SearchResults extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredPosts;

  const SearchResults({super.key, required this.filteredPosts});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context);

    return ListView.builder(
      itemCount: filteredPosts.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            GlobalPostcard(postViewDto: provider.globalPosts[index], isPreview: true),
            Divider(color: Colors.grey),
          ],
        );
      },
    );
  }
}
