import 'package:google_sign_in/google_sign_in.dart';

class LoginAPi  {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future signOut  = _googleSignIn.signOut();



}
