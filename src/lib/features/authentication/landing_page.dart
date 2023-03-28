import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../common/themes/comfy_theme.dart';
import 'google_provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(children: [
        _buildBackgroundArt(context),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMotto(context),
              const SizedBox(height: 48),
              _buildLoginButton(context),
            ],
          ),
        ),
      ]);

  Widget _buildLoginButton(BuildContext context) => FilledButton(
        style: FilledButton.styleFrom(minimumSize: const Size(240, 48)),
        child: const Text('GET STARTED'),
        onPressed: () => context.read<GoogleSignInProvider>().googleLogin(),
      );

  Widget _buildMotto(BuildContext context) => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Welcome To\n',
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color:
                    Theme.of(context).extension<CustomPalette>()!.unselected),
            children: [
              TextSpan(
                text: 'ASLearner\n',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color:
                        Theme.of(context).extension<CustomPalette>()!.selected),
              ),
              TextSpan(
                  text:
                      'A spaced-repetition flashcard ASL learning app.\nLearn American Sign Language simply and effectively!',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Theme.of(context)
                          .extension<CustomPalette>()!
                          .unselected)),
            ]),
      );

  Widget _buildBackgroundArt(BuildContext context) => SvgPicture.asset(
        'assets/images/LandingArt.svg',
        colorFilter: ColorFilter.mode(
            Theme.of(context).extension<CustomPalette>()!.surface as Color,
            BlendMode.srcATop),
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      );
}
