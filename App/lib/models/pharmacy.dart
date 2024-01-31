//pharmacy data model


class Pharmacy{
    final String name;
    final int rating;
    final int num_ratings;
    final String email;
    final String coupon;

    const Pharmacy({
      required this.name,
      required this.rating,
      required this.num_ratings,
      required this.email,
      required this.coupon
      }
    );

    Map <String, dynamic> toJson() => {
      "name" : name,
      "rating" : rating,
      "num_ratings" : num_ratings,
      "email" : email,
      "coupon" : coupon,
    };
}

