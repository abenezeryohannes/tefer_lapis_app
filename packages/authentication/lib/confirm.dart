// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:authentication/config/pelete.dart';
import 'package:authentication/widget/countdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'domain/firebase.auth.dart';

class Confirm extends StatefulWidget {
  const Confirm({Key? key, required this.onConfirm,required this.error, required this.theme, required this.locale, required this.locales, required this.setLang, required this.tr }) : super(key: key);
  final ThemeData theme;
  final String? error;
  final Locale locale;
  final List<Locale> locales;
  final void Function(User, String?) onConfirm;
  final void Function(Locale?) setLang;
  final String Function(String) tr;
  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {

  User? user;
  bool loading = false;
  bool showResend = false;
  String? error;

  void ConfirmWithPhoneNumber() async{
    setState(() { loading = true;});
    if(codeController.text.isEmpty) { validCode = false;
      setState(() { loading = true;});
      return null;
    }
    if(user!=null) widget.onConfirm(user!, FireBaseAuth.FULLNAME);
    FireBaseAuth.SMSCODE = codeController.text;
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: FireBaseAuth.VERIFICATION_ID, smsCode: codeController.text);
    // Sign the user in (or link) with the credential
    await FirebaseAuth.instance.signInWithCredential(credential);
    user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      widget.onConfirm(user!, FireBaseAuth.FULLNAME);
    }
    setState(() { loading = false;});
  }

  final TextEditingController codeController =  TextEditingController(text: "");
  bool validCode = true;
  int counter = 2;

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Column(
          children: [
            SizedBox(height: 160),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(widget.tr("confirm_account"), style: widget.theme.textTheme.headline3),
              ),
            ),
            SizedBox(height: 40),
            Column(
              children: [ 
                Center(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 42.0, vertical: 10),
                      child: TextFormField(
                        controller: codeController,
                        style:  widget.theme.textTheme.button,
                        decoration: InputDecoration(
                            hintText: widget.tr("confirmation_code"),
                            focusColor: Colors.yellowAccent,
                            // constraints: BoxConstraints(maxHeight: 42),
                            filled: true, fillColor: widget.theme.cardColor,
                            hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.dividerColor),
                              borderRadius: const BorderRadius.all(Radius.circular(15))),
                            border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.colorScheme.secondary),
                              borderRadius: const BorderRadius.all(Radius.circular(15))),
                            contentPadding: const EdgeInsets.symmetric( horizontal: 10, ),
                            errorText: !validCode ? widget.tr('field_required') : null,),
                      )),
                ), 
                Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42.0, vertical: 10),
                      child: Text(
                        widget.tr("confirm_account_desc"),
                        style: widget.theme.textTheme.subtitle2,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),

        // if(!showResend)
        // CountDown(theme: widget.theme, tr: widget.tr, start: counter,
        //   onEnd: (){ setState(() {  showResend = true; }); },),
        //
        // if(showResend)
        //   InkWell(
        //     onTap: () async{
        //       setState(() { loading = true;});
        //       PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: FireBaseAuth.VERIFICATION_ID, smsCode: codeController.text);
        //       // Sign the user in (or link) with the credential
        //       await FirebaseAuth.instance.verifyPhoneNumber(
        //
        //       );
        //       setState(() { loading = true;});
        //     },
        //     child: Text(
        //       widget.tr("resend_code"),
        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue),
        //       textAlign: TextAlign.start,
        //     ),
        //   ),

        Column(
          children: [

            if(loading)
              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator( color: widget.theme.colorScheme.secondary,),
                  )
              ),


            if((error!=null&&error!.isNotEmpty)||(widget.error!=null&& widget.error!.isNotEmpty))
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 24,),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(error==null?widget.error!:error!,
                          style:widget.theme.textTheme.caption,),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: (widget.theme.colorScheme.secondary),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                    minimumSize:
                    Size(MediaQuery.of(context).size.width * 3 / 4, 40),
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20) ),
                  ),
                  onPressed: ConfirmWithPhoneNumber,
                  child: Text(
                    widget.tr("confirm"),
                    style: TextStyle(
                        fontSize: 18,
                        color: widget.theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold),
                  )),
            ), 
            SizedBox(height: 20),
          ],
        )
      ],
    );
  }

}
