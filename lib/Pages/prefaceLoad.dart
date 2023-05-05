import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lib_org/Firebase_Auth/Login_Page.dart';
import 'package:lib_org/Services/Firebase_Auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  final bool isDone;
  OnboardingPage({Key? key, required this.isDone}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Store a flag indicating that the user has completed the onboarding process
    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.setBool('hasOnboarded', true);
    // });
    widget.isDone == false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              OnboardingPageWidget(
                imagePath: 'lib/assets/addLibraries.svg',
                title: 'Welcome to MyApp!',
                description: 'Get started by creating an account.',
              ),
              OnboardingPageWidget(
                imagePath: 'lib/assets/find.svg',
                title: 'Find Your Favorite Books',
                description:
                    'Search and find thousands of books on any topic you want.',
              ),
              OnboardingPageWidget(
                imagePath: 'lib/assets/book.svg',
                title: 'Read Books Anywhere',
                description:
                    'Enjoy reading your favorite books on any device, anytime, anywhere.',
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.indigo)),
              onPressed: () {
                if (_currentPage == 2) {
                  // Handle last page button press
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              },
              child: Text(
                _currentPage == 2 ? 'Get Started' : 'Next',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPageWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPageWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imagePath,
          height: 300,
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  final bool isActive;

  const Indicator({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A4E69),
            Color(0xFF6B7382),
          ],
        ),
      ),
      child: Center(
        child: Text(
          'Hello, world!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
