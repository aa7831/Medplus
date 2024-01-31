import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_plus/resources/auth_methods.dart';
import 'package:med_plus/screens/home_screen.dart';
import 'package:med_plus/screens/login_screen.dart';
import 'package:med_plus/utils/colors.dart';
import 'package:med_plus/utils/utils.dart';
import 'package:med_plus/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    super.dispose();
    //destructor
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
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
                  //text field for username
                  const SizedBox(height: 64),
                  //text field for email
                  TextFieldInput(
                    hint_text: "Enter your username",
                    textInputType: TextInputType.text,
                    textEditingController: _usernameController,
                  ),

                  //text field for description
                  const SizedBox(height: 20),

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

                  const SizedBox(height: 20),

                  //button for login
                  InkWell(
                    onTap : SignUpUser,
                    child: Container(
                      child: _loading 
                      ? const Center(
                        child: CircularProgressIndicator(
                          color : Colors.white,
                        ),
                        )
                      :const Text("Sign up",
                      style:  TextStyle(color: Colors.white),),
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
                        child: const Text("Already have an account?"),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),
                      GestureDetector(
                        onTap : goToSignIn,
                        child: Container(
                          child: const Text(
                            " Sign in.", 
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
  void SignUpUser () async{
    setState(() {
      _loading = true;
    });
    String success = await AuthMethods().signUpUser(
    email: _emailController.text, 
    password: _passwordController.text, 
    username: _usernameController.text,
    );

    if(success != "Sucessfully created!"){
      //error 
      showSnackBar(success, context);
    }

    else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
    setState(() {
      _loading = false;
    });
  }

  void goToSignIn(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}


