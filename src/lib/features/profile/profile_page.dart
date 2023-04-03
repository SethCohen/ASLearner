import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/themes/comfy_theme.dart';
import '../../common/widgets/custom_divider.dart';
import '../../common/widgets/custom_iconbutton.dart';
import '../authentication/google_provider.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int? streak = 0;

  @override
  void initState() {
    super.initState();
    _getStreak().then((value) {
      setState(() {
        streak = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<GoogleSignInProvider>().user!;

    return Align(
      alignment: Alignment.topCenter,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(currentUser.photoURL!),
              ),
              const SizedBox(width: 20),
              RichText(
                text: TextSpan(
                  text: currentUser.displayName!,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color:
                          Theme.of(context).extension<CustomPalette>()!.text),
                  children: [
                    TextSpan(
                      text:
                          '\nJoined on ${DateFormat.yMMMd().format(currentUser.metadata.creationTime!)}',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context)
                              .extension<CustomPalette>()!
                              .unselected),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              RoundedDivider(
                color:
                    Theme.of(context).extension<CustomPalette>()!.background!,
                height: 100,
                width: 8,
              ),
              const SizedBox(width: 20),
              RichText(
                text: TextSpan(
                  text: 'Streak',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context)
                          .extension<CustomPalette>()!
                          .unselected),
                  children: [
                    TextSpan(
                      text: '\n$streak',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context)
                              .extension<CustomPalette>()!
                              .text),
                    ),
                  ],
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: 'Sign Out',
                    child: CustomIconButton(
                      onPressed: _signOut,
                      icon: const Icon(Icons.logout),
                    ),
                  ),
                  Tooltip(
                    message: 'Delete Account',
                    child: CustomIconButton(
                      onPressed: _deleteAccount,
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
                    context.read<GoogleSignInProvider>().deleteUser();
                    const snackBar = SnackBar(content: Text('Account Deleted'));

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  },
                  onPressed: () {},
                  child: const Text('Yes'),
                ),
              ],
            ));
  }

  Future<int> _getStreak() async {
    final currentUser = context.read<GoogleSignInProvider>().user!;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      return userData['streak'];
    } else {
      debugPrint('Document does not exist on the database');
      return 0;
    }
  }
}
