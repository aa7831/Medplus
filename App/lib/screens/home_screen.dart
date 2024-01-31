import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:med_plus/utils/colors.dart';
import 'package:med_plus/utils/global_variables.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  late PageController pageController;
  

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  //getting current location of the user upon sign in
  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {   
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return;
    }

    currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return;
  }

  //handles clicking of icons on the bottom bar
  void PageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: Pages,
        controller: pageController,
        onPageChanged: PageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            //search for pharmacy
            icon: Icon(Icons.medication,
                color: _page == 0 ? greenColor : secondaryColor),
            label: ' ',
            backgroundColor: primaryColor,
          ),
          //search for items
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront,
                color: _page == 1 ? greenColor : secondaryColor),
            label: ' ',
            backgroundColor: primaryColor,
          ),
          //profile
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _page == 2 ? greenColor : secondaryColor),
            label: ' ',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigating,
      ),
    );
  }

  void navigating(int page) {
    //when user taps on an icon, change to different screen
    pageController.jumpToPage(page);
  }


  void updatePage(int n){
    _page = n;
  }
}
