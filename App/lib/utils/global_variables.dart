import "package:flutter/material.dart";

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:med_plus/screens/pharmacy_search.dart';
import 'package:med_plus/screens/profile_screen.dart';
import 'package:med_plus/screens/search_items_screen.dart';

List<Widget>  Pages = [
  searchItemScreen(),
  pharmacySearchScreen(),
  UserProfileScreen(),
];

late Position currentPosition;