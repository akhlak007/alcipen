import 'package:flutter/material.dart';
import 'package:alcipen/config/routes.dart';
import 'package:alcipen/config/theme.dart';
import 'package:alcipen/models/user.dart';
import 'package:alcipen/services/mock_data_service.dart';
import 'package:alcipen/widgets/seeker/writer_card.dart';
import 'package:alcipen/widgets/shared/app_bottom_nav.dart';

class SeekerHomeScreen extends StatefulWidget {
  const SeekerHomeScreen({Key? key}) : super(key: key);

  @override
  _SeekerHomeScreenState createState() => _SeekerHomeScreenState();
}

class _SeekerHomeScreenState extends State<SeekerHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isMapView = false;
  final List<User> _writers = MockDataService.getMockWriters();
  final List<String> _subjects = ['All', 'Engineering', 'Literature', 'Business', 'Medicine'];
  String _selectedSubject = 'All';
  RangeValues _rateRangeValues = const RangeValues(6, 10);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      _isMapView = !_isMapView;
    });
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Writers',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Subject',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _subjects.map((subject) {
                    final isSelected = _selectedSubject == subject;
                    return FilterChip(
                      label: Text(subject),
                      selected: isSelected,
                      backgroundColor: AppColors.offWhite,
                      selectedColor: AppColors.primaryBlue.withOpacity(0.2),
                      checkmarkColor: AppColors.primaryBlue,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primaryBlue : AppColors.darkGrey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedSubject = subject;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Text(
                  'Rate per page (₹)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${_rateRangeValues.start.round()}',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '₹${_rateRangeValues.end.round()}',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                RangeSlider(
                  values: _rateRangeValues,
                  min: 6,
                  max: 10,
                  divisions: 4,
                  activeColor: AppColors.primaryBlue,
                  inactiveColor: AppColors.lightGrey,
                  labels: RangeLabels(
                    '₹${_rateRangeValues.start.round()}',
                    '₹${_rateRangeValues.end.round()}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      _rateRangeValues = values;
                    });
                  },
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedSubject = 'All';
                            _rateRangeValues = const RangeValues(6, 10);
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Apply filters
                          this.setState(() {
                            // This would normally filter the data
                          });
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Writer'),
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.list : Icons.map),
            onPressed: _toggleView,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for writers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isMapView ? _buildMapView() : _buildListView(),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _writers.length,
      itemBuilder: (context, index) {
        final writer = _writers[index];
        return WriterCard(
          writer: writer,
          onTap: () {
            AppRoutes.navigateTo(context, '/writer-profile', arguments: writer);
          },
        );
      },
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        Container(
          color: Colors.grey[200],
          child: Center(
            child: Text(
              'Map View\n(Simulated)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              itemCount: _writers.length,
              itemBuilder: (context, index) {
                final writer = _writers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  child: InkWell(
                    onTap: () {
                      AppRoutes.navigateTo(context, '/writer-profile', arguments: writer);
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            writer.photo,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                writer.name,
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${writer.rating} • ',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    '₹${writer.writerDetails?['pageRate']} per page',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                writer.specialties?.join(', ') ?? '',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onPressed: () {
                            AppRoutes.navigateTo(context, '/writer-profile', arguments: writer);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}