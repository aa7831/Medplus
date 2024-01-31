import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:med_plus/screens/home_screen.dart';
import 'package:med_plus/screens/login_screen.dart';
import 'package:med_plus/screens/search_items_screen.dart';
import 'package:med_plus/utils/colors.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late User _user;
  bool _loggingOut = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[200],
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'User Profile',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 24.0),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 64.0,
                  backgroundImage: NetworkImage(
                    'https://www.pngitem.com/pimgs/m/517-5177724_vector-transparent-stock-icon-svg-profile-user-profile.png',
                  ),
                ),
                SizedBox(height: 16.0),
                FutureBuilder<String>(
                  future: getData(),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data ?? 'Anonymous',
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Error loading data',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                SizedBox(height: 8.0),
                Text(
                  _user.email ?? '',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  ),
                  onPressed: _loggingOut ? null : _signOut,
                  child: _loggingOut
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Sign Out',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
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


  Future<String> getData() async {
    final DocumentReference docRef = FirebaseFirestore.instance.collection("users").doc(_user.uid);
    final DocumentSnapshot docSnapshot = await docRef.get();
    return docSnapshot.get('username').toString();
  }

  void _signOut() async {
    setState(() {
      _loggingOut = true;
    });
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged Out'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
