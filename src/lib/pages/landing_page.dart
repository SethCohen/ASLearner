import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/google_provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(children: [
        SvgPicture.asset(
          'assets/images/LandingArt.svg',
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome To',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff828282)),
              ),
              const SizedBox(height: 16),
              const Text(
                'ASLearner',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'A spaced-repetition flashcard ASL learning app.\nLearn American Sign Language simply and effectively!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff828282),
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1E1E1E)),
                    elevation: 10,
                    backgroundColor: const Color(0xFF292929),
                    padding: const EdgeInsets.all(10),
                    textStyle: const TextStyle(fontSize: 14),
                    minimumSize: const Size(240, 48)),
                child: const Text('GET STARTED'),
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                },
              ),
            ],
          ),
        ),
      ]);
}
