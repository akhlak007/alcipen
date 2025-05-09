import 'package:flutter/material.dart';
import 'package:alcipen/config/theme.dart';
import 'package:alcipen/models/assignment.dart';
import 'package:alcipen/services/mock_data_service.dart';
import 'package:alcipen/widgets/shared/app_bottom_nav.dart';
import 'package:alcipen/widgets/writer/project_card.dart';
import 'package:alcipen/widgets/writer/earnings_chart.dart';

class WriterDashboardScreen extends StatefulWidget {
  const WriterDashboardScreen({Key? key}) : super(key: key);

  @override
  _WriterDashboardScreenState createState() => _WriterDashboardScreenState();
}

class _WriterDashboardScreenState extends State<WriterDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Assignment> _assignments = MockDataService.getMockAssignments();
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Writer Dashboard'),
        actions: [
          Switch(
            value: _isAvailable,
            activeColor: AppColors.accentPurple,
            activeTrackColor: AppColors.accentPurpleLight.withOpacity(0.5),
            onChanged: (value) {
              setState(() {
                _isAvailable = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              _isAvailable ? 'Available' : 'Unavailable',
              style: TextStyle(
                color: _isAvailable ? AppColors.accentPurple : AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildEarningsCard(),
          ),
          TabBar(
            controller: _tabController,
            labelColor: AppColors.accentPurple,
            unselectedLabelColor: AppColors.grey,
            indicatorColor: AppColors.accentPurple,
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProjectsList(AssignmentStatus.inProgress),
                _buildProjectsList(AssignmentStatus.pending),
                _buildProjectsList(AssignmentStatus.completed),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0, isWriter: true),
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accentPurple,
            AppColors.accentPurpleLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Earnings',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹5,620',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rating',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.8',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const EarningsChart(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(Icons.assignment_turned_in, '32', 'Projects'),
              _buildStatItem(Icons.people, '24', 'Clients'),
              _buildStatItem(Icons.trending_up, '#3', 'Ranking'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProjectsList(AssignmentStatus status) {
    final filteredAssignments = _assignments.where((a) => a.status == status).toList();

    if (filteredAssignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == AssignmentStatus.pending
                  ? Icons.hourglass_empty
                  : status == AssignmentStatus.completed
                      ? Icons.check_circle_outline
                      : Icons.assignment_outlined,
              size: 64,
              color: AppColors.lightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${status.toString().split('.').last} projects',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredAssignments.length,
      itemBuilder: (context, index) {
        return ProjectCard(
          assignment: filteredAssignments[index],
          isWriter: true,
        );
      },
    );
  }
}