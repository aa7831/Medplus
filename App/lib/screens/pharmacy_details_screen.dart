import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_plus/utils/colors.dart';

class PharmacyDetailsScreen extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String email;
  final int rating;
  final int reviewCount;
  final String coupon;

  const PharmacyDetailsScreen({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.email,
    required this.rating,
    required this.reviewCount,
    required this.coupon,
  }) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenColor,
        title: Text(name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    for (int i = 0; i < rating; i++)
                      //reviews
                      Icon(Icons.star, color: Colors.amber, size: 16.0),
                    for (int i = rating; i < 5; i++)
                      //empty stars
                      Icon(Icons.star_border, color: Colors.amber, size: 16.0),
                    const SizedBox(width: 4.0),
                    Text(
                      '$rating.0',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '($reviewCount reviews)',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Email: $email',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Row(
                  children: [
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: greenColor),
                      onPressed: () {
                        reviewOverlay(context);
                      },
                      child: const Text('Add Review'),
                    ),
                    const Padding(padding:EdgeInsets.all(80)),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: greenColor),
                      onPressed: () {
                        couponOverlay(context);
                      },
                      child: const Text('Get Coupon'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateReview(context, selectedRating) async{
    int id;
    if(name[name.length - 2] == 'y'){
      id = int.parse(name[name.length-1]);
    }
    else{
      id = int.parse(name.substring(name.length - 2, name.length));
    }

    id--;

    String idString = id.toString();

    final updatedReviewCount = reviewCount + 1;
    final int updatedTotalRating =
        ((rating * reviewCount) + selectedRating) ~/
            updatedReviewCount;
    await FirebaseFirestore.instance
        .collection('pharmacy')
        .doc(idString)
        .update({
        'rating': updatedTotalRating,
        'num_ratings': updatedReviewCount
    });
    Navigator.pop(context);

    print(updatedTotalRating);
    print(updatedReviewCount);
  }

  void reviewOverlay(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        int selectedRating = 1;
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a Review:',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rating:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                          },
                          child: Icon(
                            index < selectedRating ? Icons.star : Icons.star_border,
                            size: 32.0,
                            color: index < selectedRating ? Colors.orange : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: greenColor),
                  onPressed: () async {
                    updateReview(context, selectedRating);
                  },
                  child: const Text('Submit Review'),
                ),
              ],
            ),
          );
        });
      },
    );
  }


  void couponOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Coupon code:',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 8.0),
              Text(
                coupon,
                style: TextStyle(fontSize: 24.0),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: greenColor),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

}
