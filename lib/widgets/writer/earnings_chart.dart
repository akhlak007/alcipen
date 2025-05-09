import 'package:flutter/material.dart';

class EarningsChart extends StatelessWidget {
  const EarningsChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for the last 7 days
    final List<double> earningsData = [120, 200, 0, 350, 180, 270, 150];
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          earningsData.length,
          (index) => _buildBar(
            context,
            days[index],
            earningsData[index],
            earningsData.reduce((max, value) => max > value ? max : value),
          ),
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context, String day, double amount, double maxAmount) {
    final double percentage = maxAmount > 0 ? amount / maxAmount : 0;
    final double height = 60 * percentage;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: height,
          width: 28,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}