import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/google_provider.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({Key? key}) : super(key: key);

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextButton(
          onPressed: _signOut,
          child: const Text(
            'Sign Out',
            textScaleFactor: 1.05,
          ),
        ),
        TextButton(
          onPressed: _deleteAccount,
          child: const Text(
            'Delete Account',
          ),
        ),
      ],
    );
  }

  void _signOut() {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.googleLogout();
    Navigator.pop(context);
  }

  void _deleteAccount() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              backgroundColor: Colors.grey.shade900,
              title: const Text('Are You Sure?'),
              content: const Text(
                  'You\'re trying to delete your account.\nYour account and data will be deleted immediately. This action is not reversible.\nPlease hold YES to confirm.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onLongPress: () {
                    FirebaseAuth.instance.currentUser!.delete();
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogout();
                    Navigator.pop(context);

                    const snackBar = SnackBar(
                      content: Text('Account Deleted'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    Navigator.pop(context);
                  },
                  onPressed: () {},
                  child: const Text('Yes'),
                ),
              ],
            ));
  }
}
