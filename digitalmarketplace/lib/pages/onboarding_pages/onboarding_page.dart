import 'package:digitalmarketplace/pages/login_logout_pages/login_screen.dart';
import 'package:digitalmarketplace/pages/onboarding_pages/page1.dart';
import 'package:digitalmarketplace/pages/onboarding_pages/page2.dart';
import 'package:digitalmarketplace/pages/onboarding_pages/page3.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool onFirstPage = false;
  bool onSecondPage = false;
  bool onThirdPage = false;
  final PageController _controller = PageController();

  /// Method to mark onboarding as complete
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true); // Save "seen" flag
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onFirstPage = (index == 0);
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
                      activeDotColor: Color.fromARGB(255, 109, 67, 90),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (onThirdPage) {
                        _completeOnboarding();
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: onFirstPage
                            ? const Color.fromARGB(255, 162, 161, 131)
                            : onSecondPage
                                ? const Color.fromARGB(255, 242, 230, 214)
                                : const Color.fromARGB(255, 70, 67, 67),
                      ),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowRight01,
                        color: onFirstPage
                            ? Colors.white
                            : onSecondPage
                                ? const Color.fromARGB(255, 200, 103, 69)
                                : const Color.fromARGB(255, 252, 241, 228),
                        size: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
