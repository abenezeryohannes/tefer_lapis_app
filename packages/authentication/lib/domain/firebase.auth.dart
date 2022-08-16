
import 'dart:convert';
import 'dart:math'; 
import 'package:crypto/crypto.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FireBaseAuth{

  static String VERIFICATION_ID = "";
  static String IDENTIFIER = "";
  static bool isLogin = false;
  static int? RESEND_TOKEN;
  static String SMSCODE = "";
  static String FULLNAME = "";

  final void Function( PhoneAuthCredential credential ) onVerficationComplete;
  final Future<void> Function(String verificationId, int? resendToken) onCodeSent;
  final void Function(String verificationId) onCodeAutoRetrievalTimeout;
  final void Function(FirebaseAuthException e) onVerificationFailed;


  FireBaseAuth({required this.onVerficationComplete, required this.onCodeSent,
              required this.onCodeAutoRetrievalTimeout, required this.onVerificationFailed});

    //
    //sign in with facebook
    //
    Future<User?> signInWithFacebook() async {
        IDENTIFIER = "facebook";
        // Trigger the sign-in flow
        final LoginResult loginResult = await FacebookAuth.instance.login();

        String token = loginResult.accessToken!.token;
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider
            .credential(token);
        // Once signed in, return the UserCredential
        await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        return FirebaseAuth.instance.currentUser;

    }



    //
    //sign in with Apple
    // 
    /// Generates a cryptographically secure random nonce, to be included in a
    /// credential request.
    String generateNonce([int length = 32]) {
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(length, (_) => charset[random.nextInt(charset.length)])
          .join();
    }

    /// Returns the sha256 hash of [input] in hex notation.
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    Future<User?> signInWithApple() async {
      IDENTIFIER = "apple";
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      ); 
      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return FirebaseAuth.instance.currentUser;
    }






    //
    //sign in with Google
    //
    Future<User?> signInWithGoogle() async {
      IDENTIFIER = "google";
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      return FirebaseAuth.instance.currentUser;
    }




    //
    //sign in with phone number
    //
    verifyPhoneNumber(String phoneNumber ) async {
      IDENTIFIER = "phone_number";
      await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            verificationCompleted: onVerficationComplete,
            verificationFailed: onVerificationFailed,
            codeSent: (String verificationId, int? resendToken){
              VERIFICATION_ID = verificationId;
              RESEND_TOKEN = resendToken;
              onCodeSent(verificationId, resendToken);
            },
            timeout: const Duration(seconds: 120),
            forceResendingToken: RESEND_TOKEN,
            codeAutoRetrievalTimeout:  (String verificationId) {
                  verificationId = VERIFICATION_ID;
                  onCodeAutoRetrievalTimeout(verificationId);
            },
          );
          return FirebaseAuth.instance.currentUser;
    }
    //
    // get user
    //
    User? getUser() { return FirebaseAuth.instance.currentUser; }


    // void onVerificationFailed(FirebaseAuthException e){
    //     if (e.code == 'invalid-phone-number') {
    //           print('The provided phone number is not valid.');
    //     }
    // }
    // Future<void> onCodeSent(String verificationId, int? resendToken) async {
    //     // Update the UI - wait for the user to enter the SMS code
    //     String smsCode = 'xxxx';
    //
    //     // Create a PhoneAuthCredential with the code
    //     PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    //
    //     // Sign the user in (or link) with the credential
    //     await FirebaseAuth.instance.signInWithCredential(credential);
    // }
    //


}