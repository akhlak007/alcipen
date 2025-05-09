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

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
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
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
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
    if (_selectedRole == null) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setSelectedRole(_selectedRole!);

    final route = _selectedRole == UserRole.seeker
        ? '/seeker-onboarding'
        : '/writer-onboarding';
    AppRoutes.navigateAndRemoveUntil(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-brightness background image
          Positioned.fill(
            child: Image.network(
              'https://media-hosting.imagekit.io/8e77d53bc83d41a6/Handwritten%20Symbols%20On%20Blackboard%20Education%20Math%20Formula%20Background%20Wallpaper%20Image%20For%20Free%20Download%20-%20Pngtree.jpg?Expires=1841374504&Key-Pair-Id=K2ZIVPTIP2VGHC&Signature=pP3XOs8A6FHx96O74UbaGTLVocfQKvzJCK1H0pwLLBg7nGUQX5VGCk1QxteVdOIFgyQFikKllTwG8NcmUKDIsKRX4Jga333TCvulqKfYoOtbqB2Wn0VLRCKGPYTPOXeBOse3taQPmYZg7Xg-597nQ-IVSuIhsDuaHKxA-k-KI4NNREXKfUZA2~jzqsWO3YFIecHNmI5iYUcEm~Jq4U~ijvKWVOzulwH2U82TResgXBHzMZjXz56LMWVj8Y6aG2Q2yxFiw5NmgEIkRy9rtsglHL~7EY7iHaDXLTzcAP1C-dySBp9l0D3HzI81CXBYW~oMUo0IniPcr0gPvGdXgGnlyA__',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) => Opacity(
                  opacity: _fadeAnimation.value,
                  child: child,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Welcome to Alcipen',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'How would you like to use the app?',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: SingleChildScrollView(
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
                    ),
                    const SizedBox(height: 24),
                    AnimatedGradientButton(
                      onPressed:
                          _selectedRole != null ? _continueWithRole : null,
                      text: 'Continue',
                      isEnabled: _selectedRole != null,
                      height: 56,
                      gradient: LinearGradient(
                        colors: _selectedRole == UserRole.seeker
                            ? [
                                AppColors.primaryBlue,
                                AppColors.primaryBlueLight
                              ]
                            : [
                                AppColors.accentPurple,
                                AppColors.accentPurpleLight
                              ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
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
        height: 120,
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.15)
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.white54,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 15 : 10,
              offset: Offset(0, isSelected ? 5 : 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: isSelected ? color : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isSelected ? color : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? color : Colors.white54,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 14)
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.darkGrey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
