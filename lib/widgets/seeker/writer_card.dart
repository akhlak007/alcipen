import 'package:flutter/material.dart';
import 'package:alcipen/config/theme.dart';
import 'package:alcipen/models/user.dart';

class WriterCard extends StatelessWidget {
  final User writer;
  final VoidCallback onTap;

  const WriterCard({
    Key? key,
    required this.writer,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final writerDetails = writer.writerDetails;
    final pageRate = writerDetails?['pageRate'] ?? 0.0;
    final isAvailable = writerDetails?['isAvailable'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Writer photo and availability indicator
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    writer.photo,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isAvailable ? AppColors.success : AppColors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isAvailable ? 'Available' : 'Unavailable',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Writer name and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          writer.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${writer.rating}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price per page
                  Row(
                    children: [
                      Icon(
                        Icons.price_change_outlined,
                        size: 16,
                        color: AppColors.darkGrey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '₹$pageRate per page',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.assignment_turned_in_outlined,
                        size: 16,
                        color: AppColors.darkGrey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${writer.completedProjects} projects',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Specialties
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (writer.specialties ?? []).map((specialty) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                  const SizedBox(height: 16),
                  // Short bio (truncated)
                  Text(
                    writer.bio ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}