import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_plus/resources/auth_methods.dart';
import 'package:med_plus/resources/product_seeder.dart';
import 'package:med_plus/screens/home_screen.dart';
import 'package:med_plus/screens/signup_screen.dart';
import 'package:med_plus/utils/colors.dart';
import 'package:med_plus/utils/utils.dart';
import 'package:med_plus/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    super.dispose();
    //destructor
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                  //medPlus logo
                  Image.asset("assets/logo.png",
                              height: 175 ),

                  const SizedBox(height: 64),
                  //text field for email
                  TextFieldInput(
                    hint_text: "Enter your email",
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                  ),

                  //empty space
                  const SizedBox(height: 20),

                  //text field for password
                  TextFieldInput(
                    hint_text: "Enter your Password",
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    is_password: true,
                  ),

                  //empty space
                  const SizedBox(height: 20),

                  //button for login
                  InkWell(
                    onTap: LoginUser, //calls login function when user taps on button
                    child: Container(
                      child: _loading 
                      ? const Center(
                        child:CircularProgressIndicator(
                          color : Colors.white,
                        ),
                        ) 
                      : const Text("Log in", 
                      style: TextStyle(color: Colors.white),),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        color: greenColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                  //sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text("Haven't joined our awesome app yet?"),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),
                      GestureDetector(
                        onTap : goToSignUp, //sign up transition
                        child: Container(
                          child: const Text(
                            " Sign up.", 
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ))),
    );
  }

  void goToSignUp(){
    //navigate to sign up screen
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  void LoginUser() async{
    setState(() {
      _loading = true;
    });
    //pharmacySeeder().seeder(); //ONLY UNCOMMENT WHEN SEEDING DUMMY DATA TO DATABASE
    //productSeeder().seeder(); //ONLY UNCOMMENT WHEN SEEDING DUMMY DATA TO DATABASE
    String success = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);

    if(success != "success"){
      showSnackBar(success, context); //showing error, if any
    }
    else{
      //logged in, transitioning to home page
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
    
    setState(() {
      _loading = false;
    });

  }


}
