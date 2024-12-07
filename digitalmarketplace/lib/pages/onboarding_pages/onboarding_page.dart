import 'package:digitalmarketplace/pages/login_logout_pages/login_screen.dart';
import 'package:digitalmarketplace/pages/onboarding_pages/page1.dart';
import 'package:digitalmarketplace/pages/onboarding_pages/page2.dart';
import 'package:digitalmarketplace/pages/onboarding_pages/page3.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:digitalmarketplace/styles/color_themes.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool onfirstPage = false;
  bool onSecondPage = false;
  bool onThirdPage = false;
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final Color tertiaryColor = Theme.of(context).colorScheme.tertiary;
    final Color onTertiaryColor = Theme.of(context).colorScheme.onTertiary;

    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onfirstPage = (index == 0);
              onSecondPage = (index == 1);
              onThirdPage = (index == 2);
            });
          },
          children: const [
            Page1(),
            Page2(),
            Page3(),
          ],
        ),
        Container(
          alignment: const Alignment(0, 0.75),
          child: Padding(
            padding: const EdgeInsets.only(left: 150.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const JumpingDotEffect(
                      dotColor: Color.fromARGB(255, 53, 45, 57),
                      activeDotColor: Color.fromARGB(255, 109, 67, 90)),
                ),
                GestureDetector(
                  onTap: () {
                    onfirstPage
                        ? _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          )
                        : onSecondPage
                            ? _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              )
                            : onThirdPage
                                ? Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const LoginScreen(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const LoginScreen(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );

                    // _controller.nextPage(
                    //   duration: const Duration(milliseconds: 500),
                    //   curve: Curves.easeIn,
                    // );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: onfirstPage
                            ? Color.fromARGB(255, 162, 161, 131)
                            : onSecondPage
                                ? Color.fromARGB(255, 242, 230, 214)
                                : onThirdPage
                                    ? Color.fromARGB(255, 70, 67, 67)
                                    : Color.fromARGB(255, 162, 161, 131)),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowRight01,
                      color: onfirstPage
                          ? Colors.white
                          : onSecondPage
                              ? Color.fromARGB(255, 200, 103, 69)
                              : onThirdPage
                                  ? Color.fromARGB(255, 252, 241, 228)
                                  : Color.fromARGB(255, 162, 161, 131),
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
