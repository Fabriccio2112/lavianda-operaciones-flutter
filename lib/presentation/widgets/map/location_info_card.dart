import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LocationInfoCard extends StatelessWidget {
  final int totalUsers;
  final int onlineUsers;
  final DateTime lastUpdate;
  final bool isTrackingEnabled;

  const LocationInfoCard({
    super.key,
    required this.totalUsers,
    required this.onlineUsers,
    required this.lastUpdate,
    required this.isTrackingEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  icon: Icons.people,
                  label: 'Total',
                  value: totalUsers.toString(),
                  color: Colors.blue,
                ),
                _buildInfoItem(
                  icon: Icons.person,
                  label: 'En línea',
                  value: onlineUsers.toString(),
                  color: Colors.green,
                ),
                _buildInfoItem(
                  icon: Icons.access_time,
                  label: 'Actualizado',
                  value: DateFormat('HH:mm').format(lastUpdate),
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
