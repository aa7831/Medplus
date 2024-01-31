import 'package:flutter/material.dart';
import 'package:med_plus/utils/colors.dart';

class PharmacyCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String email;
  final String coupon;
  final int rating;
  final int reviewCount;
  final int? price;
  final double? distanceFromUser;
  final bool isSearchPerformed;

  const PharmacyCard({
    Key? key,
    required this.name,
    required this.email,
    required this.coupon,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    this.price,
    this.distanceFromUser,
    this.isSearchPerformed = false,
  }) : super(key: key);

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: 120.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      for (int i = 0; i < rating; i++)
                        Icon(Icons.star, color: Colors.amber, size: 16.0),
                      for (int i = rating; i < 5; i++)
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
                  if (isSearchPerformed && price != null) // Add condition to display banner
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(
                            '\AED ${price}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        SizedBox(width: 230),
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(
                            '${distanceFromUser}km',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
