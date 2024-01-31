import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_plus/models/user.dart' as model;

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<model.User> getUserDetails() async{
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //sign up user
  Future<String> signUpUser(
    {
      required String email,
      required String password,
      required String username,
    }
  ) async {
    try{

      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty){
        //register
       UserCredential usercred= await _auth.createUserWithEmailAndPassword(email: email, password: password); //creating user on firebase
       

        //adding user to the database in 'users' collection
        model.User user = model.User(email: email, uid: usercred.user!.uid, username: username);
       await _firestore.collection('users').doc(usercred.user!.uid).set(user.toJson());
      }

      return "Sucessfully created!";

    } catch(error){
      return error.toString();
  }
  }


  //logging in 
  Future<String> loginUser ({
    required String email,
    required String password,
  }) async {
    try {
      if(email.isNotEmpty && password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password); //logging in
        return "success";
      }
      else{
        return "please enter all the fields";
      }

    }on FirebaseAuthException catch (error){
      if(error.code=='wrong-password'){
        return "Incorrect password";
      }

      if(error.code == "invalid-email"){
        return "Incorrect email";
      }

      if(error.code == "too-many-requests"){
        return "Too many failed attempts to login. Try again later.";
      }


      return error.toString(); //returning error - unrecognized error
    }

    }
  }