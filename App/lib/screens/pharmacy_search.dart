import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_plus/screens/pharmacy_details_screen.dart';
import 'package:med_plus/utils/colors.dart';
import 'package:med_plus/widgets/pharmacy_card.dart';


class pharmacySearchScreen extends StatefulWidget {
  const pharmacySearchScreen({super.key});

  @override
  State<pharmacySearchScreen> createState() => _pharmacySearchScreenState();
}

class _pharmacySearchScreenState extends State<pharmacySearchScreen> {
  final TextEditingController searchController = TextEditingController();
  var _stream = FirebaseFirestore.instance.collection('pharmacy').snapshots();
  bool _searched = false;

  @override
  void dispose(){
    super.dispose();
    searchController.dispose();
  }
    
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: mobileBackgroundColor,
      centerTitle: false,
      title:Image.asset("assets/logo.png",
            height: 100 )
    ),
    body: Container(
      child: Column(
        children: [
          //adding space between widgets
          SizedBox(height: 16),

          SizedBox(
            width: 400,
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                hintText: 'Search for a pharmacy...',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 22),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500], size: 22),
                  onPressed: () => searchController.clear(),
                ),
              ),
              onFieldSubmitted: (String item) {
                setState(() {
                  _searched = true;
                });
                getData(item);
              }
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return  Text(snapshot.error.toString());
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var doc = snapshot.data!.docs[index];
                    var name = doc.get('name');
                    var rating = doc.get('rating');
                    var reviewCount = doc.get('num_ratings');
                    var email = doc.get('email');
                    var coupon = doc.get('coupon');
                    var imageUrl = doc.get('imageURL');
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => PharmacyDetailsScreen(
                                  name: name,
                                  rating: rating,
                                  reviewCount: reviewCount,
                                  email: email,
                                  imageUrl: imageUrl,
                                  coupon: coupon,
                                )));
                      },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      
                      child: PharmacyCard(
                        email : email,
                        coupon: coupon,
                        name: name,
                        rating: rating,
                        imageUrl: imageUrl,
                        reviewCount: reviewCount,
                        isSearchPerformed: false,
                      ),
                    ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

void getData (String item) async{
  _stream = await FirebaseFirestore.instance.collection("pharmacy")
  .where("name", isGreaterThanOrEqualTo: item)
  .snapshots();
}


}