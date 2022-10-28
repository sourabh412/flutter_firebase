import 'package:firebase_2/ui/auth/login_screen.dart';
import 'package:firebase_2/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_2/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../posts/post_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login(){
    setState(() {
      loading = true;
    });
    _auth.createUserWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString())
        .then((value){
      setState(() {
        loading = false;
      });
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => const PostScreen()
      ));
    }).onError((error, stackTrace){
      Utils(success: false).toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Enter email";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Enter password";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.password),
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
            const SizedBox(height: 50,),
            RoundButton(
              onTap: (){
                if(_formKey.currentState!.validate()){
                  login();
                }
              },
              title: "Sign up",
              loading: loading,
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already a member?"),
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  },
                  child: const Text("Login"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
