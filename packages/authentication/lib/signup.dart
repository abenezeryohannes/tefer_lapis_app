import 'package:authentication/auth.dart';
import 'package:authentication/config/pelete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import './domain/firebase.auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.onSignUp, required this.theme, required this.locale, required this.locales,
    required this.setLang, required this.tr, required this.slideTo, required this.error }) : super(key: key);
  final ThemeData theme;
  final Locale locale;
  final String? error;
  final List<Locale> locales;
  final Future<bool> Function( User, String ) onSignUp;
  final void Function(Locale?) setLang;
  final String Function(String) tr;
  final Function(Slide) slideTo;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late BuildContext _context;
  late FireBaseAuth firebaseAuth;
  String? error;
  static String smsCode = "";
  final TextEditingController nameController = TextEditingController(text: "");
  bool validName = true; bool validPhoneNumber = true;
  bool agree = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'ET';
  PhoneNumber number = PhoneNumber(isoCode: 'ET');
  bool loading = false;String name = '';

  @override
  void initState() {
    firebaseAuth = FireBaseAuth(onVerficationComplete:onVerficationComplete,
          onCodeSent:onCodeSent, onCodeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
        onVerificationFailed: onVerificationFailed);
    error = null;
    super.initState();
  }



   void onVerficationComplete( PhoneAuthCredential credential ) async{
     setState(() { loading = false;});
     print("on verification complete");
      User? user = firebaseAuth.getUser();
      FireBaseAuth.FULLNAME = nameController.text;
      if(user != null) {
        setState(() { error = null; });
        await widget.onSignUp(user, nameController.text);
      } else {
        print("can't get current user");
        setState(() { error = ("cant_get_current_user"); });

      }
   }

   Future<void> onCodeSent(String verificationId, int? resendToken) async{
     print("on code sent");
     setState(() { loading = false;});
     FireBaseAuth.isLogin = false;
     setState(() { error = null; });
     widget.slideTo(Slide.confirm);
   }

   void onCodeAutoRetrievalTimeout(String verificationId) async{
     print("on code sent");
     //await onSignUpClicked();
   }

   void onVerificationFailed(FirebaseAuthException e) {
     setState(() { loading = false;});
     if (e.code == 'invalid-phone-number') {
        setState(() { error = ("invalid_phone_number"); });
         print('The provided phone number is not valid.');
     }else {
       setState(() { error = (e.message); });
     }
   }

  onSignUpClicked() async{
    setState(() { loading = true;});
    FocusScope.of(_context).unfocus();
      if(!agree) {
        setState(() {
          error = widget.tr('agree_to_terms_and_condition');
        });
        setState(() { loading = false;});
        return;
      }
      print('phoneNumber: ${number.phoneNumber}');
      if(formKey.currentState!=null&&formKey.currentState!.validate()&&number.phoneNumber!=null) {
        formKey.currentState!.save();
      }else {
        FocusScope.of(_context).unfocus();
        setState(() {
          error = widget.tr('invalid_phone_format');
        });
        setState(() { loading = false;});
        return;
      }
      formKey.currentState?.validate();
      FireBaseAuth.isLogin = false;
      // phoneController.text.isEmpty ? validPhoneNumber = false : validPhoneNumber = true;
      nameController.text.isEmpty&&name.isEmpty ? validName = false : validName = true;
      FireBaseAuth.FULLNAME = nameController.text;
      setState(() { loading = true; error = null; });
      //if(phoneController.text.isNotEmpty && nameController.text.isNotEmpty ) {
      await firebaseAuth.verifyPhoneNumber( number.phoneNumber! );
      setState(() { loading = false; });
    //}
    }


  @override
  Widget build(BuildContext context) {
    _context = context;
    FireBaseAuth.isLogin = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const SizedBox(height: 160),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(widget.tr("sign_up"), style: widget.theme.textTheme.headline3),
              ),
            ),
            const SizedBox(height: 20),

            Form(
              key: formKey,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 42.0, vertical: 10),
                        child: TextFormField(
                          controller: nameController,
                          style: widget.theme.textTheme.button,
                          onChanged: (value) { name = value;},
                          decoration: InputDecoration(
                              hintText: widget.tr("full_name"),
                              focusColor: Colors.yellowAccent,
                              //constraints: const BoxConstraints(maxHeight: 42),
                              filled: true, fillColor: widget.theme.cardColor,
                              hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.dividerColor),
                                  borderRadius: const BorderRadius.all(Radius.circular(15))),
                              border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.colorScheme.secondary),
                                borderRadius: const BorderRadius.all(Radius.circular(15))),
                              contentPadding: const EdgeInsets.symmetric( horizontal: 10, vertical: 10),
                              errorText: !validName ? widget.tr('field_required') : null,
                          )
                        )),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 42.0, vertical: 14),
                        child: Container(
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
                              onSaved: (PhoneNumber pn) {
                                number = pn;
                                // print('On Saved: $number');
                              }, onInputChanged: (PhoneNumber value) { number = value;  },
                            ),
                        ),
                        // child: TextFormField(
                        //   controller: phoneController,
                        //   style:  widget.theme.textTheme.button,
                        //   decoration: InputDecoration(
                        //       hintText: widget.tr("phone_number"),
                        //       focusColor: Colors.yellowAccent,
                        //       constraints: const BoxConstraints(maxHeight: 42),
                        //       filled: true, fillColor: widget.theme.cardColor,
                        //       hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
                        //       border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.colorScheme.secondary),
                        //         borderRadius: const BorderRadius.all(Radius.circular(15))),
                        //        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.dividerColor),
                        //         borderRadius: const BorderRadius.all(Radius.circular(15))),
                        //       contentPadding: const EdgeInsets.symmetric( horizontal: 10, vertical: 10),
                        //       errorText: !validName ? widget.tr('field_required') : null,
                        //   ),
                        // )
                    ),
                  ),

                   Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 0),
                        // child: Text(
                        //   widget.tr("signup_desc"),
                        //   style: widget.theme.textTheme.subtitle2,
                        //   textAlign: TextAlign.start,
                        // ),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                                value: agree,
                                onChanged: (bool? value) { setState(() { agree = value??false; }); }
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(widget.tr('singup_agreement_intro'),
                                    style: widget.theme.textTheme.caption),
                              ),
                            )
                          ],
                        ),

                      ),
                    ),
                ],
              ),
            ),
          ],
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
                        horizontal: 30, vertical: 10),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 3 / 4, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => { onSignUpClicked( ) },
                  child:   Text(
                    widget.tr("sign_up"),
                    style: TextStyle(
                        fontSize: 18, color: widget.theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            const SizedBox(height: 16),
            // Center(
            //     child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children:  [
            //     Text(
            //       "-------------------------------"+widget.tr("or")+"-------------------------------",
            //       style: TextStyle(
            //           fontSize: 12,
            //           fontWeight: FontWeight.bold,
            //           color: widget.theme.dividerColor),
            //     )
            //   ],
            // )),
            // const SizedBox(height: 14),
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
            //             if(user!=null) widget.onSignUp(user, nameController.text);
            //             },
            //           child: const CircleAvatar(
            //               backgroundColor: Colors.redAccent,
            //               child: Icon(
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
            //           onTap: () async{
            //             User? user = await firebaseAuth.signInWithFacebook();
            //             if(user!=null) widget.onSignUp(user, nameController.text);
            //           },
            //           child: const CircleAvatar(
            //               backgroundColor: Colors.transparent,
            //               child: Icon(
            //                 Icons.facebook_outlined,
            //                 color: Colors.white,
            //                 size: 24,
            //               ), //Image.asset("assets/img/google-plus.png"),
            //               radius: 24.0),
            //         )),
            //     Material(
            //         elevation: 5.0,
            //         color: Colors.black87,
            //         shape: const CircleBorder(),
            //         child: InkWell(
            //           onTap: () async{
            //              User? user =await firebaseAuth.signInWithApple();
            //              if(user!=null) widget.onSignUp(user, nameController.text);
            //           },
            //           child: const CircleAvatar(
            //               backgroundColor: Colors.transparent,
            //               child: Icon(
            //                 Icons.apple,
            //                 color: Colors.white,
            //                 size: 24,
            //               ), //Image.asset("assets/img/google-plus.png"),
            //               radius: 24.0),
            //         )),
            //   ],
            // ),
            const SizedBox(height: 20),
          ],
        )
      ],
    );
  }



  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose(){
    nameController.dispose();
    controller.dispose();
    super.dispose();
  }
}
