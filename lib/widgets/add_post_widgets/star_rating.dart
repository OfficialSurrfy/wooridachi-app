import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;

  const StarRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: index < rating ? primaryColor : Colors.grey,
          ),
          onPressed: () {
            final newRating = index + 1.0;
            onRatingChanged(newRating);
          },
        );
      }),
    );
  }
}

class StarRatingPage extends StatefulWidget {
  const StarRatingPage({super.key});

  @override
  _StarRatingPageState createState() => _StarRatingPageState();
}

class _StarRatingPageState extends State<StarRatingPage> {
  double averageRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Star Rating'),
      ),
      body: Column(
        children: [
          StarRating(
            rating: averageRating,
            onRatingChanged: (newRating) {
              setState(() {
                averageRating = newRating;
              });
            },
          ),
          Text('Average Rating: $averageRating'),
        ],
      ),
    );
  }

  //link this up to the firestore methjods .dart file
  Future<double> calculateAverageRating() async {
    final ratingsSnapshot =
        await FirebaseFirestore.instance.collection('star_ratings').get();
    final ratings = ratingsSnapshot.docs
        .map((doc) => doc.data()['rating'] as double)
        .toList();
    if (ratings.isEmpty) {
      return 0;
    }
    final sum = ratings.reduce((a, b) => a + b);
    return sum / ratings.length;
  }

  @override
  void initState() {
    super.initState();
    calculateAverageRating().then((average) {
      setState(() {
        averageRating = average;
      });
    });
  }
}
