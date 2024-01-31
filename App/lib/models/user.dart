//user data model

import 'package:cloud_firestore/cloud_firestore.dart';

class User{
    final String username;
    final String uid;
    final String email;

    const User({
      required this.username,
      required this.uid,
      required this.email,
      }
    );

    Map <String, dynamic> toJson() => {
        'username': username,
        'uid' : uid,
        'email' : email,
    };


    static User fromSnap(DocumentSnapshot snap){
      var snapShot = snap.data() as Map<String, dynamic>;

      return User(
        username: snapShot['username'],
        uid : snapShot['uid'],
        email : snapShot['email'],
      );
    }
}

