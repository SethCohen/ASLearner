import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/google_provider.dart';

class SignOut extends StatelessWidget {
  SignOut({Key? key}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: CircleAvatar(backgroundImage: NetworkImage(user.photoURL!)),
        itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(user.photoURL!)),
                    Text(user.displayName!)
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [Text("Sign Out"), Icon(Icons.logout)],
                ),
                onTap: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogout();
                },
              ),
            ]);
  }
}
