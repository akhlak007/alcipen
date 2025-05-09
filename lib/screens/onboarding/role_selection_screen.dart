import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alcipen/config/routes.dart';
import 'package:alcipen/config/theme.dart';
import 'package:alcipen/models/user.dart';
import 'package:alcipen/services/user_provider.dart';
import 'package:alcipen/widgets/shared/animated_gradient_button.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> with SingleTickerProviderStateMixin {
  UserRole? _selectedRole;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectRole(UserRole role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _continueWithRole() {
    if (_selectedRole != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setSelectedRole(_selectedRole!);
      
      if (_selectedRole == UserRole.seeker) {
        AppRoutes.navigateAndRemoveUntil(context, '/seeker-onboarding');
      } else {
        AppRoutes.navigateAndRemoveUntil(context, '/writer-onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Welcome to Alcipen',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'How would you like to use the app?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                Expanded(
                  child: Column(
                    children: [
                      _buildRoleCard(
                        context,
                        'Find a Writer',
                        'Connect with fellow students who can help with your assignments',
                        Icons.search,
                        AppColors.primaryBlue,
                        UserRole.seeker,
                      ),
                      const SizedBox(height: 24),
                      _buildRoleCard(
                        context,
                        'Become a Writer',
                        'Help other students and earn money for your writing skills',
                        Icons.create,
                        AppColors.accentPurple,
                        UserRole.writer,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedGradientButton(
                  onPressed: _selectedRole != null ? _continueWithRole : null,
                  text: 'Continue',
                  isEnabled: _selectedRole != null,
                  height: 56,
                  gradient: LinearGradient(
                    colors: [
                      _selectedRole == UserRole.seeker ? AppColors.primaryBlue : AppColors.accentPurple,
                      _selectedRole == UserRole.seeker ? AppColors.primaryBlueLight : AppColors.accentPurpleLight,
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    UserRole role,
  ) {
    final isSelected = _selectedRole == role;
    
    return GestureDetector(
      onTap: () => _selectRole(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 180,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.lightGrey,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      icon,
                      color: color,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? color : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : AppColors.lightGrey,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isSelected ? color : AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkGrey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}