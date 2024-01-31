import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_plus/screens/pharmacy_details_screen.dart';
import 'package:med_plus/utils/colors.dart';
import 'package:med_plus/widgets/pharmacy_card.dart';
import 'package:med_plus/utils/global_variables.dart';
import 'dart:math';


class searchItemScreen extends StatefulWidget {
  const searchItemScreen({super.key});

  @override
  State<searchItemScreen> createState() => _searchItemScreenState();
}

class _searchItemScreenState extends State<searchItemScreen> {
  final TextEditingController searchController = TextEditingController();
  bool _searched = false;
  var _stream = FirebaseFirestore.instance.collection('pharmacy').snapshots();
  List<String> _pharmacies = []; 
  List<int> _prices = [];
  List<double> _distances = [];

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
      title: Image.asset("assets/logo.png",
                 height: 100 ),
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
                hintText: 'Search for a medicine or product...',
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
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // if ((!snapshot.hasData || _pharmacies.isEmpty) && _searched) {
                  //   return const Text('No data found');
                  // }

                  final documents = snapshot.data!.docs;
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
                      
                      int? price;
                      double? distanceFromUser;
                      if (_prices.length == _pharmacies.length && _prices.length == _distances.length && _pharmacies.isNotEmpty ) {
                        // Check if the lists have the same length before accessing their elements
                        price = _prices[index];
                        distanceFromUser = _distances[index];
                      }
                      else if (_searched){
                        if(index == 0){
                          return Container(
                            color: Colors.white,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: greenColor,
                              ),
                            ),
                          );
                        }
                        else{
                          return const Text(".");
                        }
                      }

                      
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
                            )
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PharmacyCard(
                            email: email,
                            coupon: coupon,
                            name: name,
                            rating: rating,
                            imageUrl: imageUrl,
                            reviewCount: reviewCount,
                            price: price,
                            distanceFromUser: distanceFromUser,
                            isSearchPerformed: _searched,
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
  
  if(item.isEmpty){
    //default result
    _stream = FirebaseFirestore.instance.collection('pharmacy').snapshots();
    setState(() {
      _searched = false;
    });
    return;
  }


  List<double> latitudes = [];
  List<double> longitudes = [];
  _distances = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('pharmacy').get();

  for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    double latitude = data['latitude'];
    double longitude = data['longitude'];
    latitudes.add(latitude);
    longitudes.add(longitude);
  }

  // print(latitudes);
  // print(longitudes);
  
  DocumentSnapshot snap = await FirebaseFirestore.instance.collection("products").doc(item).get();

  List<dynamic> prices = (snap.data() as Map<String, dynamic>)['price'];
  List<int> intPrices = prices.map((e) => e as int).toList();

  List<dynamic> pharmacies = (snap.data() as Map<String, dynamic>)['pharmacies'];
  List<String> stringPharmacies = pharmacies.map((e) => e as String).toList();

  setState(() {
    _prices = intPrices;    
    _pharmacies = stringPharmacies;
  });

  //sorting
  for (int i = 0; i < _prices.length - 1; i++){
    for (int j = 0; j < _prices.length - i - 1; j++){
        if (_prices[j] > _prices[j + 1]){
            //swapping
            int temp; String temp2; double tempLat; double tempLong;
            temp = _prices[j];
            temp2 = _pharmacies[j];
            tempLat = latitudes[j]; 
            tempLong = longitudes[j];

            _prices[j] = _prices[j+1]; _prices[j+1] = temp;
            _pharmacies[j] = _pharmacies[j+1]; _pharmacies[j+1] = temp2;
            latitudes[j] = latitudes[j+1]; latitudes[j+1] = tempLat;
            longitudes[j] = longitudes[j+1]; longitudes[j+1] = tempLong;
        }
    }
  }


  int id;


  for(int i = 0; i<_pharmacies.length; i++){
    id = int.parse(_pharmacies[i]) + 1;
    _pharmacies[i] = "Pharmacy" + (id.toString());
  }

  double currentLat = currentPosition.latitude;
  double currentLong = currentPosition.longitude;

  //remove all pharmacies that are outside 5 km range.
  double distance = 0;
  int ind = 0;
  while(ind < _pharmacies.length){
    distance = calculateDistance(currentLat, currentLong, latitudes[ind], longitudes[ind]);
    if(distance > 5){
      // remove from list
      _pharmacies.removeAt(ind);
      _prices.removeAt(ind); 
      latitudes.removeAt(ind);
      longitudes.removeAt(ind);
    }
    else{
      _distances.add(double.parse(distance.toStringAsFixed(1)));
      ind++;
    }
  }
  // print(_pharmacies.length);
  // print(_prices.length);
  // print(_distances.length);

  // print(_pharmacies);
  // print(_searched);
  // print(_distances);

    //update stream
    _stream = await FirebaseFirestore.instance.collection('pharmacy')
            .where('name', whereIn: _pharmacies)
            .snapshots();
}


double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const earthRadiusKm = 6371;
  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);
  
  final lat1Radians = _toRadians(lat1);
  final lat2Radians = _toRadians(lat2);

  //haversine formula
  final a = pow(sin(dLat / 2), 2) +
      pow(sin(dLon / 2), 2) *
          cos(lat1Radians) *
          cos(lat2Radians);
  final c = 2 * asin(sqrt(a));

  return earthRadiusKm * c;
}

double _toRadians(double degrees) {
  return degrees * (pi / 180);
}

}