import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_plus/models/pharmacy.dart' as pharmacyModel;
import 'package:med_plus/models/product.dart' as productModel;

class pharmacyDeleter{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up user
  Future<String> deleter(
  ) async {
    try{
  final collection = await FirebaseFirestore.instance
      .collection("pharmacies")
      .get();

  final batch = FirebaseFirestore.instance.batch();

  for (final doc in collection.docs) {
    batch.delete(doc.reference);
  }

      return "Sucessfully deleted!";

    }catch(error){
      return error.toString(); //returning error
    }
  }
}