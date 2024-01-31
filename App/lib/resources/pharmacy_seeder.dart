import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_plus/models/pharmacy.dart' as pharmacyModel;
import 'package:med_plus/models/product.dart' as productModel;

class pharmacySeeder{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up user
  Future<String> seeder(
  ) async {
    try{
        String name = "";
        int rating; 
        int num_ratings;
        String email = "";
        String coupon = "";
        int index;
        int price;

        List<String> medicines = ["Ibuprofen", "Acetaminophen", "Aspirin", "Lisinopril",
    "Metformin", "Levothyroxine", "Atorvastatin", "Simvastatin",
    "Citalopram", "Sertraline", "Fluoxetine","Omeprazole",
    "Lansoprazole", "Pantoprazole", "Albuterol", "Advair",
    "Prozac", "Zoloft", "Lexapro", "Nexium"];

    List<String> descriptions = [
  "Ibuprofen is a nonsteroidal anti-inflammatory drug (NSAID) used to relieve pain, reduce fever, and decrease inflammation.",
  "Acetaminophen is a pain reliever and fever reducer that is used to treat many conditions such as headache, muscle aches, arthritis, backache, toothaches, colds, and fevers.",
  "Aspirin is a nonsteroidal anti-inflammatory drug (NSAID) used to treat pain, fever, and inflammation.",
  "Lisinopril is an ACE inhibitor used to treat high blood pressure and heart failure.",
  "Metformin is an oral medication used to treat type 2 diabetes. It works by decreasing glucose production in the liver and improving insulin sensitivity.",
  "Levothyroxine is a thyroid hormone replacement used to treat hypothyroidism.",
  "Atorvastatin is a medication used to treat high cholesterol and reduce the risk of heart disease.",
  "Simvastatin is a medication used to treat high cholesterol and reduce the risk of heart disease.",
  "Citalopram is an antidepressant medication used to treat depression and anxiety disorders.",
  "Sertraline is an antidepressant medication used to treat depression, anxiety disorders, and obsessive-compulsive disorder (OCD).",
  "Fluoxetine is an antidepressant medication used to treat depression, anxiety disorders, and OCD.",
  "Omeprazole is a proton pump inhibitor used to reduce the amount of acid in the stomach and treat conditions such as gastroesophageal reflux disease (GERD) and ulcers.",
  "Lansoprazole is a proton pump inhibitor used to reduce the amount of acid in the stomach and treat conditions such as GERD and ulcers.",
  "Pantoprazole is a proton pump inhibitor used to reduce the amount of acid in the stomach and treat conditions such as GERD and ulcers.",
  "Albuterol is a bronchodilator used to treat symptoms of asthma and chronic obstructive pulmonary disease (COPD).",
  "Advair is a combination medication used to treat asthma and COPD. It contains a corticosteroid and a bronchodilator.",
  "Prozac is an antidepressant medication used to treat depression, anxiety disorders, and OCD.",
  "Zoloft is an antidepressant medication used to treat depression, anxiety disorders, and OCD.",
  "Lexapro is an antidepressant medication used to treat depression and anxiety disorders.",
  "Nexium is a proton pump inhibitor used to reduce the amount of acid in the stomach and treat conditions such as GERD and ulcers."
];

        List<String> form = ["pills", "liquid", "injection", "capsules"];

        for(int i = 0; i <10; i++){
          name = "Pharmacy"+(i+1).toString();
          rating =  1 + Random().nextInt(5);
          num_ratings = 5 + Random().nextInt(100);
          email = name + "@gmail.com";
          coupon = name + "10OFF";


          pharmacyModel.Pharmacy pharmacy = pharmacyModel.Pharmacy(
            name: name, rating: rating, 
            num_ratings: num_ratings, 
            email: email, 
            coupon: coupon);

          await _firestore.collection('pharmacy').doc(i.toString()).set(pharmacy.toJson());

        //   for(int z = 0 ; z < 10; z++){
        //     index = 0 + Random().nextInt(4);
        //     price = 15 + Random().nextInt(80-15);

        //     //productModel.Product product = productModel.Product(description: descriptions[z], price: price, form: form[index], name:medicines[z]);
            
        //     await _firestore.collection('pharmacy')
        //     .doc(i.toString())
        //     .collection("products")
        //     .doc(z.toString())
        //     .set(product.toJson());
        // }
      }

      return "Sucessfully created!";

    }catch(error){
      return error.toString(); //returning error
    }
  }
}