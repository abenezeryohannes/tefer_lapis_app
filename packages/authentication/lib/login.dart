// ignore_for_file: prefer_const_constructors


import 'dart:async';

import 'package:authentication/config/pelete.dart';
import 'package:authentication/widget/countdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'auth.dart';
import 'domain/firebase.auth.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key, required this.onLogIn, required this.theme, required this.locale, required this.locales,
    required this.setLang, required this.slideTo, required this.tr, required this.error }) : super(key: key);
  final ThemeData theme;
  final Locale locale;
  final String? error;
  final List<Locale> locales;
  final Future<bool> Function(User user, String?) onLogIn;
  final void Function(Locale?) setLang;
  final String Function(String) tr;
  final Function(Slide) slideTo;

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  late FireBaseAuth firebaseAuth;
  void LogInWithGmail() {}
  void LogInWithFacebook() {}
  void LogInWithApple() {}
  String? error;

  final TextEditingController phoneController =  TextEditingController(text: "");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'ET';
  PhoneNumber number = PhoneNumber(isoCode: 'ET');
  bool loading = false;


  @override
  void initState() {
    firebaseAuth = FireBaseAuth(onVerficationComplete: onVerficationComplete,
        onCodeSent:onCodeSent, onCodeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
        onVerificationFailed: onVerificationFailed);
    error = null;
    super.initState();
  }

  void onVerficationComplete( PhoneAuthCredential credential ) async{
    setState(() { loading = false;});
    print("on verification complete");
    User? user = firebaseAuth.getUser();
    if(user != null) {
      setState(() { error = null; });
      await widget.onLogIn(user, null);
    } else {
      print("can't get current user");
      error = widget.tr("cant_get_current_user");
    }
  }

  Future<void> onCodeSent(String verificationId, int? resendToken) async{
    print("on code sent");
    FireBaseAuth.isLogin = true;
    if(firebaseAuth.getUser()==null) {
      setState(() { loading = false;error = null; });
      widget.slideTo(Slide.confirm);
    }
  }

  void onCodeAutoRetrievalTimeout(String verificationId) async{
    print("on code sent");
    //await onSignUpClicked();
  }

  void onVerificationFailed(FirebaseAuthException e) {

    setState(() { loading = false;});
    if (e.code == 'invalid-phone-number') {
      // print('The provided phone number is not valid.');
      setState(() { error = ("invalid_phone_format"); });
    }else {
      setState(() { error = e.message; });
    }

  }


  onLogInClicked() async{

    setState(() { loading = true;});
    if(formKey.currentState!=null&&formKey.currentState!.validate()&&number.phoneNumber!=null) {
      formKey.currentState!.save();
    }else {
      setState(() { loading = false; error = widget.tr('invalid_phone_format'); });
      return;
    }



    FireBaseAuth.isLogin = true;
    User? alreadyLogedInUser = firebaseAuth.getUser();
    if(alreadyLogedInUser!=null) {
      widget.onLogIn(alreadyLogedInUser, null);
    }
    else {
      await firebaseAuth.verifyPhoneNumber(number.phoneNumber!);
    }
    setState(() { loading = false;});

  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');
    setState(() { this.number = number; });
  }




  @override
  Widget build(BuildContext context) {
    FireBaseAuth.isLogin = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 160),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Text(widget.tr("log_in"), style: widget.theme.textTheme.headline3),
                ),
              ),
              SizedBox(height: 20),

              Column(
                children: [
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 42.0, vertical: 10),
                        child:  Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: widget.theme.dividerColor),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: InternationalPhoneNumberInput(
                            inputDecoration: InputDecoration(
                              hintText: widget.tr("phone_number"),
                              // focusColor: Colors.yellowAccent,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              //constraints: const BoxConstraints(maxHeight: 42),
                              filled: true, fillColor: widget.theme.cardColor,
                              hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
                            ),
                            selectorConfig: const SelectorConfig(
                                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                showFlags: false,
                                trailingSpace: false,
                                leadingPadding: 0
                            ),
                            ignoreBlank: false,
                            textStyle: TextStyle(color: widget.theme.colorScheme.onBackground, fontWeight: FontWeight.bold),
                            spaceBetweenSelectorAndTextField: 0,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: TextStyle(color: widget.theme.colorScheme.onBackground),
                            initialValue: number,
                            textFieldController: controller,
                            formatInput: true,
                            keyboardType:
                            const TextInputType.numberWithOptions(signed: true, decimal: true),
                            inputBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            onSaved: (PhoneNumber pn) { number = pn; }, onInputChanged: (PhoneNumber value) { number = value; },
                          ),
                        ),
                    ),
                  ),

                  Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 42.0, vertical: 10),
                        child: Text(
                          widget.tr("login_desc"),
                          style: widget.theme.textTheme.subtitle2,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),


                ],
              ),
            ],
          ),
        ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 18,),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(error==null?widget.error!:error!,
                            style:widget.theme.textTheme.caption,),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: (widget.theme.colorScheme.secondary),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 3 / 4, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => {onLogInClicked()},
                  child:   Text(
                    widget.tr("log_in"),
                    style: TextStyle(
                        fontSize: 18,
                        color: widget.theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            SizedBox(height: 16),
            // Center(
            //     child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Text(
            //       "------------------------------- "+widget.tr("or")+" -------------------------------",
            //       style: TextStyle(
            //           fontSize: 12,
            //           fontWeight: FontWeight.bold,
            //           color: widget.theme.dividerColor),
            //     )
            //   ],
            // )),
            // SizedBox(height: 14),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Material(
            //         elevation: 5.0,
            //         color: Colors.redAccent,
            //         shape: const CircleBorder(),
            //         child: InkWell(
            //           onTap: () async{
            //             User? user = await firebaseAuth.signInWithGoogle();
            //             if(user!=null) widget.onLogIn(user, null);
            //           },
            //           child: CircleAvatar(
            //               backgroundColor: Colors.redAccent,
            //               child: const Icon(
            //                 Icons.email,
            //                 color: Colors.white,
            //                 size: 24,
            //               ), //Image.asset("assets/img/google-plus.png"),
            //               radius: 24.0),
            //         )),
            //     Material(
            //         elevation: 5.0,
            //         color: Colors.blueAccent,
            //         shape: const CircleBorder(),
            //         child: InkWell(
            //                 onTap: () async{
            //                   User? user = await firebaseAuth.signInWithFacebook();
            //                   if(user!=null) widget.onLogIn(user, null);
            //                 },
            //               child: CircleAvatar(
            //                   backgroundColor: Colors.transparent,
            //                   child: const Icon(
            //                     Icons.facebook_outlined,
            //                     color: Colors.white,
            //                     size: 24,
            //                   ), //Image.asset("assets/img/google-plus.png"),
            //                   radius: 24.0),
            //             )),
            //     Material(
            //         elevation: 5.0,
            //         color: Colors.grey[900],
            //         shape: const CircleBorder(),
            //         child: InkWell(
            //                 onTap: () async{
            //                   User? user =await firebaseAuth.signInWithApple();
            //                   if(user!=null) widget.onLogIn(user, null);
            //                 },
            //               child: CircleAvatar(
            //                   backgroundColor: Colors.transparent,
            //                   child: const Icon(
            //                     Icons.apple,
            //                     color: Colors.white,
            //                     size: 24,
            //                   ), //Image.asset("assets/img/google-plus.png"),
            //                   radius: 24.0),
            //             )),
            //   ],
            // ),
            SizedBox(height: 20),
          ],
        )
      ],
    );
  }

  @override
  void dispose(){
    phoneController.dispose();
    super.dispose();
  }
}
