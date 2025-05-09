import 'package:flutter/material.dart';
import 'package:alcipen/config/routes.dart';
import 'package:alcipen/config/theme.dart';
import 'package:alcipen/widgets/shared/animated_gradient_button.dart';

class SeekerOnboardingScreen extends StatefulWidget {
  const SeekerOnboardingScreen({Key? key}) : super(key: key);

  @override
  _SeekerOnboardingScreenState createState() => _SeekerOnboardingScreenState();
}

class _SeekerOnboardingScreenState extends State<SeekerOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Find the Perfect Writer',
      'description': 'Connect with fellow students who can help complete your assignments, create diagrams, or assist with your writing needs.',
      'icon': Icons.search,
      'color': AppColors.primaryBlue,
    },
    {
      'title': 'Chat & Schedule',
      'description': 'Discuss your requirements in detail and schedule a convenient time to meet for assignment handover.',
      'icon': Icons.chat_bubble_outline,
      'color': AppColors.primaryBlue,
    },
    {
      'title': 'Safe & Secure',
      'description': 'Pay directly to writers, with no middleman fees. Rate your experience to help the community grow.',
      'icon': Icons.shield_outlined,
      'color': AppColors.primaryBlue,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      AppRoutes.navigateAndRemoveUntil(context, '/seeker-home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < _totalPages - 1)
                    TextButton(
                      onPressed: () {
                        AppRoutes.navigateAndRemoveUntil(context, '/seeker-home');
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return _buildOnboardingPage(
                    title: data['title'],
                    description: data['description'],
                    icon: data['icon'],
                    color: data['color'],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _totalPages,
                      (index) => _buildDot(index),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AnimatedGradientButton(
                    onPressed: _nextPage,
                    text: _currentPage == _totalPages - 1 ? 'Get Started' : 'Next',
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryBlue,
                        AppColors.primaryBlueLight,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 60,
              color: color,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primaryBlue : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}