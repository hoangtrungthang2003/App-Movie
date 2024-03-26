import 'package:app_movie/api/services.dart';
import 'package:app_movie/main.dart';
import 'package:app_movie/screen/login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Tài khoản",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .1),
              child: CachedNetworkImage(
                width: mq.height * .2,
                height: mq.height * .2,
                fit: BoxFit.cover,
                imageUrl: _user!.photoURL ?? '',
                // placeholder: (context, url) => CircleAvatar(
                //   child: Image.network(widget.user.image),
                // ),
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(Icons.person)),
              ),
            ),
            SizedBox(
              width: mq.width,
              height: mq.height * .03,
            ),
            Text(
              _user!.email ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(
              width: mq.width,
              height: mq.height * .05,
            ),
            Text(
              'Name: ${_user!.displayName}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(
              width: mq.width,
              height: mq.height * .02,
            ),
            const Text(
              'About: Hello',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(
              width: mq.width,
              height: mq.height * .03,
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await ApiService.auth.signOut().then((value) async {
                    await GoogleSignIn().signOut().then((value) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context); // Close the current screen
                      } else {
                        // No active route, use push instead of pushReplacement
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()));
                      }
                      ApiService.auth = FirebaseAuth
                          .instance; // Reset the authentication instance
                    });
                  });
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                label: const Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.all(16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
