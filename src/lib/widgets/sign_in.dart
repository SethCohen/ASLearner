import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asl/providers/google_provider.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const SizedBox(height: 16),
          const Align(
              alignment: Alignment.center,
              child: Text('Welcome To ASL Learner!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ))),
          const Text('An ASL Learning App made simple.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              )),
          const Spacer(),
          const Spacer(),
          TextButton(
            child: const Text('Sign In With Google'),
            onPressed: () {
              final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            },
          ),
        ],
      ));
}