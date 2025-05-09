import 'package:flutter/material.dart';
import 'package:alcipen/config/routes.dart';
import 'package:alcipen/config/theme.dart';
import 'package:alcipen/models/assignment.dart';
import 'package:intl/intl.dart';

class ProjectCard extends StatelessWidget {
  final Assignment assignment;
  final bool isWriter;

  const ProjectCard({
    Key? key,
    required this.assignment,
    this.isWriter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(assignment.status);
    final String statusText = _getStatusText(assignment.status);
    final DateTime dueDate = assignment.dueDate;
    final bool isUrgent = dueDate.difference(DateTime.now()).inHours < 24;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to assignment details page
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status bar
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          assignment.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    assignment.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  // Timeline and details
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: isUrgent ? AppColors.error : AppColors.darkGrey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Due: ${DateFormat('MMM d, yyyy').format(dueDate)}',
                        style: TextStyle(
                          color: isUrgent ? AppColors.error : AppColors.darkGrey,
                          fontSize: 14,
                          fontWeight: isUrgent ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.description_outlined,
                        size: 16,
                        color: AppColors.darkGrey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${assignment.pages} pages',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                      if (assignment.totalAmount != null) ...[
                        const SizedBox(width: 16),
                        Icon(
                          Icons.payments_outlined,
                          size: 16,
                          color: AppColors.darkGrey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '₹${assignment.totalAmount}',
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (assignment.status == AssignmentStatus.pending && isWriter)
                        OutlinedButton(
                          onPressed: () {
                            // Handle reject
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            minimumSize: const Size(100, 40),
                          ),
                          child: const Text('Decline'),
                        ),
                      const SizedBox(width: 12),
                      if (assignment.status == AssignmentStatus.pending)
                        ElevatedButton(
                          onPressed: () {
                            // Handle accept
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isWriter ? AppColors.accentPurple : AppColors.primaryBlue,
                            minimumSize: const Size(100, 40),
                          ),
                          child: Text(isWriter ? 'Accept' : 'View Details'),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () {
                            AppRoutes.navigateTo(context, '/chat', arguments: {
                              'userId': isWriter ? assignment.seeker.id : assignment.writer?.id,
                              'assignmentId': assignment.id,
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isWriter ? AppColors.accentPurple : AppColors.primaryBlue,
                            minimumSize: const Size(120, 40),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text('Chat'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.pending:
        return AppColors.warning;
      case AssignmentStatus.accepted:
        return AppColors.primaryBlue;
      case AssignmentStatus.inProgress:
        return AppColors.accentPurple;
      case AssignmentStatus.completed:
        return AppColors.success;
      case AssignmentStatus.cancelled:
        return AppColors.error;
    }
  }

  String _getStatusText(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.pending:
        return 'Pending';
      case AssignmentStatus.accepted:
        return 'Accepted';
      case AssignmentStatus.inProgress:
        return 'In Progress';
      case AssignmentStatus.completed:
        return 'Completed';
      case AssignmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}