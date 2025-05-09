import 'package:flutter/material.dart';
import 'package:alcipen/config/routes.dart';
import 'package:alcipen/config/theme.dart';
import 'package:alcipen/models/user.dart';
import 'package:intl/intl.dart';

class ScheduleHandoverScreen extends StatefulWidget {
  const ScheduleHandoverScreen({Key? key}) : super(key: key);

  @override
  _ScheduleHandoverScreenState createState() => _ScheduleHandoverScreenState();
}

class _ScheduleHandoverScreenState extends State<ScheduleHandoverScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final List<String> _recommendedLocations = [
    'Central Library',
    'Student Union Building',
    'Campus Café',
    'Engineering Block',
    'Science Building',
  ];
  
  User? _writer;
  
  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the writer from arguments, if available
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map && args.containsKey('writer')) {
      _writer = args['writer'] as User;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _scheduleHandover() {
    if (_locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a meeting location'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Handover'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to schedule this handover?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.event,
              label: 'Date',
              value: DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
            ),
            _buildInfoRow(
              icon: Icons.access_time,
              label: 'Time',
              value: _selectedTime.format(context),
            ),
            _buildInfoRow(
              icon: Icons.location_on,
              label: 'Location',
              value: _locationController.text,
            ),
            if (_notesController.text.isNotEmpty)
              _buildInfoRow(
                icon: Icons.note,
                label: 'Notes',
                value: _notesController.text,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle scheduling logic here
              Navigator.pop(context); // Close dialog
              
              // Show success message and navigate back
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Handover scheduled successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
              
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Handover'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Writer info (if available)
              if (_writer != null) _buildWriterCard(),
              
              // Date and time selection
              const SizedBox(height: 24),
              Text(
                'Select Date & Time',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimePicker(),
                  ),
                ],
              ),
              
              // Location selection
              const SizedBox(height: 24),
              Text(
                'Meeting Location',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Enter meeting location',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Suggested Locations',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _recommendedLocations.map((location) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _locationController.text = location;
                      });
                    },
                    child: Chip(
                      label: Text(location),
                      backgroundColor: AppColors.offWhite,
                    ),
                  );
                }).toList(),
              ),
              
              // Additional notes
              const SizedBox(height: 24),
              Text(
                'Additional Notes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: 'E.g., "I\'ll be wearing a red jacket" or "Meeting at the front entrance"',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              
              // Schedule button
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _scheduleHandover,
                child: const Text('Schedule Handover'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWriterCard() {
    return Container(
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
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(_writer!.photo),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meeting with',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _writer!.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_writer!.rating}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.darkGrey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${_writer!.completedProjects} projects',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              AppRoutes.navigateTo(context, '/chat', arguments: {
                'userId': _writer!.id,
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy').format(_selectedDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
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

  Widget _buildTimePicker() {
    return InkWell(
      onTap: () => _selectTime(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.access_time,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedTime.format(context),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
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
  
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.darkGrey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}