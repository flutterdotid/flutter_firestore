import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './view/list_catatan.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase CRUD',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseAuth> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            CatatanQu(user: firebaseUser, googleSignIn : googleSignIn)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.redAccent),
        child: Column(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(top: 110),
            ),
            new Icon(
              Icons.event_note,
              color: Colors.white,
              size: 150.0,
            ),
            new Text(
              "CatatanQu",
              style: TextStyle(
                  fontSize: 48.0, fontFamily: 'Pacifico', color: Colors.white),
            ),
            new Padding(padding: EdgeInsets.only(bottom: 110.0)),
            new Padding(
              padding: EdgeInsets.only(top: 110),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: MaterialButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      "images/google3.png",
                      width: 50,
                    ),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(fontSize: 19.0, color: Colors.grey),
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
                color: Colors.white,
                minWidth: 300.0,
                height: 55.0,
                elevation: 16.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    side: BorderSide(color: Colors.white)),
                onPressed: () {
                  _signIn();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}


