import 'package:flutter/material.dart';
import 'package:alcipen/config/routes.dart';
import 'package:alcipen/config/theme.dart';
import 'package:alcipen/widgets/shared/animated_gradient_button.dart';

class WriterOnboardingScreen extends StatefulWidget {
  const WriterOnboardingScreen({Key? key}) : super(key: key);

  @override
  _WriterOnboardingScreenState createState() => _WriterOnboardingScreenState();
}

class _WriterOnboardingScreenState extends State<WriterOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Share Your Skills',
      'description': 'Help fellow students by offering your writing and diagramming skills to those who need assistance.',
      'icon': Icons.create,
      'color': AppColors.accentPurple,
    },
    {
      'title': 'Set Your Price',
      'description': 'Decide how much you charge per page, control your availability, and build your portfolio.',
      'icon': Icons.price_change_outlined,
      'color': AppColors.accentPurple,
    },
    {
      'title': 'Earn & Grow',
      'description': 'Receive direct payments from students, build your reputation, and rise in rankings with great reviews.',
      'icon': Icons.trending_up,
      'color': AppColors.accentPurple,
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
      AppRoutes.navigateAndRemoveUntil(context, '/writer-dashboard');
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
                        AppRoutes.navigateAndRemoveUntil(context, '/writer-dashboard');
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
                        AppColors.accentPurple,
                        AppColors.accentPurpleLight,
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
        color: _currentPage == index ? AppColors.accentPurple : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}