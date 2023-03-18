import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:librarian_frontend/pages/pages.dart';

// TODO(Rob): Build intro tutorial

class IntroScreen extends StatelessWidget {
  final User? user;
  const IntroScreen({final Key? key, this.user}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final List<PageViewModel> buildIntroPages = <PageViewModel>[
      PageViewModel(
        title: 'Screen 01',
        body: '',
        // image: _buildImage(''),
      ),
      PageViewModel(
        title: 'Screen 02',
        body: '',
        // image: _buildImage(''),
      ),
      PageViewModel(
        title: 'Screen 03',
        body: '',
        // image: _buildImage(''),
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: buildIntroPages,
          onDone: () {
            usersRef.doc(user!.uid).update(<String, bool>{'firstRun': false});
            Navigator.of(context).push(
              MaterialPageRoute<dynamic>(
                builder: (final _) => const LibraryScreen(),
              ),
            );
          },
          onSkip: () {
            usersRef.doc(user!.uid).update(<String, bool>{'firstRun': false});
            Navigator.of(context).push(
              MaterialPageRoute<dynamic>(
                builder: (final _) => const LibraryScreen(),
              ),
            );
          },
          showSkipButton: true,
          skip: const Icon(Icons.skip_next_rounded),
          next: const Icon(Icons.navigate_next_rounded),
          done: const Icon(Icons.done_rounded),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: const Color(0xFFBDBDBD),
            color: const Color(0x42000000), //Colors.black26
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}
