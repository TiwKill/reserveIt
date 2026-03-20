import 'package:flutter/material.dart';
import '../theme.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Safely parse color
    Color color = AppTheme.primary;
    if (data['color'] is Color) {
      color = data['color'];
    }
    
    final double wearLevel = (data['wearLevel'] ?? 0.0) as double;
    final String title = data['title'] ?? 'Analysis Report';
    final String date = data['date'] ?? 'N/A';
    final String imageUrl = data['imageUrl'] ?? '';
    final String status = data['status'] ?? 'N/A';

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'image_${data['id']}',
                child: imageUrl.isNotEmpty 
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Container(color: Colors.white10, child: const Icon(Icons.image_not_supported, color: Colors.white24)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            Text('Date captured: $date', style: const TextStyle(color: Colors.white38, fontSize: 14)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: Text('${(wearLevel * 100).toInt()}%', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ],
                   ),
                   const SizedBox(height: 32),
                   _buildSectionTitle('HEALTH STATUS'),
                   const SizedBox(height: 12),
                   Container(
                     padding: const EdgeInsets.all(20),
                     decoration: BoxDecoration(
                       color: Colors.white.withOpacity(0.05),
                       borderRadius: BorderRadius.circular(24),
                     ),
                     child: Column(
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                             Text('Prediction Confidence', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                           ],
                         ),
                         const SizedBox(height: 12),
                         ClipRRect(
                           borderRadius: BorderRadius.circular(10),
                           child: LinearProgressIndicator(
                             value: wearLevel,
                             minHeight: 8,
                             backgroundColor: Colors.white10,
                             valueColor: AlwaysStoppedAnimation<Color>(color),
                           ),
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(height: 32),
                   _buildSectionTitle('SCAN IDENTIFIER'),
                   const SizedBox(height: 12),
                   _buildInfoRow('Scan ID', '#TR-${data['id'].toString().padLeft(4, '0')}'),
                   _buildInfoRow('Car ID', data['car_id']?.toString() ?? 'N/A'),
                   const SizedBox(height: 32),
                   _buildSectionTitle('AI DIAGNOSIS'),
                   const SizedBox(height: 12),
                   Text(
                     _getAiDescription(status),
                     style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                   ),
                   const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getAiDescription(String status) {
    switch (status.toUpperCase()) {
      case 'NORMAL':
        return 'The tire surface appears healthy. No significant cracks, uneven wear, or dangerous patterns detected. Continue regular maintenance.';
      case 'CRACKED':
        return 'Signs of dry rot or structural aging detected on the sidewall. This can lead to sudden tire failure. Immediate inspection by a professional is recommended.';
      case 'WORN OUT':
        return 'The tread depth is below safe limits. Braking distance and wet surface traction are significantly reduced. Replacement is highly recommended.';
      case 'UNEVEN WEAR':
        return 'Detection of inconsistent tread patterns suggests alignment or suspension issues. Check wheel balance and alignment soon.';
      default:
        return 'AI analysis complete. Please refer to the summarized status above for the primary diagnosis.';
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(color: Colors.white24, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5));
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
