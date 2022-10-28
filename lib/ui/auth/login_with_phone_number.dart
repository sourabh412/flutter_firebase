import 'package:firebase_2/ui/auth/verify_code.dart';
import 'package:firebase_2/utils/utils.dart';
import 'package:firebase_2/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {

  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  void login(){
    setState(() {
      loading = true;
    });
    auth.verifyPhoneNumber(
      phoneNumber: phoneNumberController.text,
      verificationCompleted: (_){

      },
      verificationFailed: (e){
        setState(() {
          loading = false;
        });
        Utils(success: false).toastMessage(e.toString());
      },
      codeSent: (String verificaionId, int? token){
        setState(() {
          loading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCodeScreen(verificationId: verificaionId,)));
      },
      codeAutoRetrievalTimeout: (e){
        setState(() {
          loading = false;
        });
        Utils(success: false).toastMessage(e.toString());
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 50,),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "+1 234 3455 236"
              ),
            ),
            const SizedBox(height: 80,),
            RoundButton(
              title: "Login",
              loading: loading,
              onTap: (){
                login();
              }
            )
          ],
        ),
      ),
    );
  }
}
