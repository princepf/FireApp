import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'fireapp_page_list.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FireappPageList()));
      print(_currentUser);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  await _googleSignIn.signIn();
                } catch (error) {
                  print(error);
                }
              },
              child: Container(
                child: Image.network(
                  'https://icons-for-free.com/iconfiles/png/512/Google-1320568266385361674.png',
                  height: 70,
                  width: 70,
                ),
              ),
            ),
            _currentUser?.photoUrl == null
                ? SizedBox()
                : Image.network('${_currentUser?.photoUrl}'),
            ListTile(
              title: Text('${_currentUser?.displayName}'),
            ),
            ListTile(
              title: Text('${_currentUser?.photoUrl}'),
            ),
            ListTile(
              title: Text('${_currentUser?.id}'),
            ),
            ListTile(
              title: Text('${_currentUser?.email}'),
            ),
            TextButton(
                onPressed: () {
                  _googleSignIn.signOut();
                },
                child: Text("Signout"))
          ],
        ),
      ),
    );
  }
}
