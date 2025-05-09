import 'package:flutter/material.dart';
import 'package:alcipen/config/routes.dart';
import 'package:alcipen/config/theme.dart';
import 'package:alcipen/models/user.dart';

class WriterProfileScreen extends StatefulWidget {
  const WriterProfileScreen({Key? key}) : super(key: key);

  @override
  _WriterProfileScreenState createState() => _WriterProfileScreenState();
}

class _WriterProfileScreenState extends State<WriterProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
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
    // Get the writer object from route arguments
    final User writer = ModalRoute.of(context)!.settings.arguments as User;
    final writerDetails = writer.writerDetails;
    final pageRate = writerDetails?['pageRate'] ?? 0.0;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with writer photo and back button
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                writer.photo,
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
            ],
          ),
          
          // Writer info and tabs
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              writer.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${writer.rating}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Completed ${writer.completedProjects} projects • ₹$pageRate per page',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (writer.specialties ?? []).map((specialty) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              specialty,
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        writer.bio ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                AppRoutes.navigateTo(context, '/chat', arguments: {
                                  'userId': writer.id,
                                });
                              },
                              icon: const Icon(Icons.chat_bubble_outline),
                              label: const Text('Chat'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                AppRoutes.navigateTo(context, '/schedule-handover', arguments: {
                                  'writer': writer,
                                });
                              },
                              icon: const Icon(Icons.calendar_today_outlined),
                              label: const Text('Schedule'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primaryBlue,
                  unselectedLabelColor: AppColors.grey,
                  indicatorColor: AppColors.primaryBlue,
                  tabs: const [
                    Tab(text: 'Portfolio'),
                    Tab(text: 'Reviews'),
                    Tab(text: 'About'),
                  ],
                ),
              ],
            ),
          ),
          
          // Tab content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPortfolioTab(writer),
                _buildReviewsTab(writer),
                _buildAboutTab(writer),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPortfolioTab(User writer) {
    final sampleWork = writer.writerDetails?['sampleWork'] as List<dynamic>? ?? [];
    
    if (sampleWork.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.work_outline,
              size: 64,
              color: AppColors.lightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'No portfolio samples yet',
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
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sample Work',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: sampleWork.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text('Sample ${index + 1}'),
                    subtitle: Text('View sample work'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Open PDF viewer or document preview
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReviewsTab(User writer) {
    // Mock reviews
    final reviews = [
      {
        'name': 'Arjun Desai',
        'rating': 5.0,
        'text': 'Excellent work on my physics assignment. The diagrams were clear and well-explained.',
        'date': '2 weeks ago',
      },
      {
        'name': 'Neha Sharma',
        'rating': 4.5,
        'text': 'Very helpful with my literature review. Delivered on time and made all requested revisions promptly.',
        'date': '1 month ago',
      },
      {
        'name': 'Raj Kumar',
        'rating': 5.0,
        'text': 'Outstanding work on my engineering diagrams. Will definitely work with again!',
        'date': '2 months ago',
      },
    ];
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Rating summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      '${writer.rating}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < (writer.rating ?? 0).floor() ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${writer.completedProjects} reviews',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, 0.7),
                      _buildRatingBar(4, 0.2),
                      _buildRatingBar(3, 0.1),
                      _buildRatingBar(2, 0.0),
                      _buildRatingBar(1, 0.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Reviews list
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            review['date'] as String,
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < (review['rating'] as double).floor() ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        review['text'] as String,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 14,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAboutTab(User writer) {
    final subjects = writer.writerDetails?['subjects'] as List<dynamic>? ?? [];
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subjects
          Text(
            'Subjects',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: subjects.map((subject) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.lightGrey),
                ),
                child: Text(
                  subject as String,
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          
          // Education
          Text(
            'Education',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school,
                color: AppColors.primaryBlue,
                size: 20,
              ),
            ),
            title: const Text('Delhi University'),
            subtitle: const Text('B.Tech in Computer Science • 2020-2024'),
          ),
          const SizedBox(height: 24),
          
          // Stats
          Text(
            'Statistics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.star,
                  iconColor: Colors.amber,
                  title: '${writer.rating}',
                  subtitle: 'Rating',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.assignment_turned_in,
                  iconColor: AppColors.success,
                  title: '${writer.completedProjects}',
                  subtitle: 'Projects',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.access_time,
                  iconColor: AppColors.primaryBlue,
                  title: '24h',
                  subtitle: 'Avg. Response',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}