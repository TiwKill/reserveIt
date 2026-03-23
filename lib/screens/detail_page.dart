import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/api_service.dart';
import '../translations.dart';

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
    final String title = data['title'] ?? Translations.get('analysis_report');
    final String date = data['date'] ?? 'N/A';
    final String imageUrl = data['imageUrl'] ?? '';
    final String status = data['status'] ?? 'N/A';

    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: context.bgColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'image_${data['id']}',
                child: imageUrl.isNotEmpty 
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Container(color: context.borderFaded, child: Icon(Icons.image_not_supported, color: context.textFaded)),
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
                            Text(title, style: TextStyle(color: context.textMain, fontSize: 24, fontWeight: FontWeight.bold)),
                            Text('${Translations.get('date_captured')}: $date', style: TextStyle(color: context.textTertiary, fontSize: 14)),
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
                   _buildSectionTitle(context, Translations.get('health_status')),
                   const SizedBox(height: 12),
                   Container(
                     padding: const EdgeInsets.all(20),
                     decoration: BoxDecoration(
                       color: context.cardColor,
                       borderRadius: BorderRadius.circular(24),
                     ),
                     child: Column(
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                             Text(Translations.get('prediction_confidence'), style: TextStyle(color: context.textSec, fontSize: 12)),
                           ],
                         ),
                         const SizedBox(height: 12),
                         ClipRRect(
                           borderRadius: BorderRadius.circular(10),
                           child: LinearProgressIndicator(
                             value: wearLevel,
                             minHeight: 8,
                             backgroundColor: context.borderFaded,
                             valueColor: AlwaysStoppedAnimation<Color>(color),
                           ),
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(height: 32),
                   _buildSectionTitle(context, Translations.get('vehicle_information')),
                   const SizedBox(height: 12),
                   FutureBuilder<Map<String, dynamic>?>(
                     future: ApiService.getCar(data['car_id']?.toString() ?? ''),
                     builder: (context, snapshot) {
                       final carName = snapshot.hasData 
                         ? '${snapshot.data!['brand']} ${snapshot.data!['model']}'
                         : Translations.get('loading_vehicle_info');
                       return _buildInfoRow(context, Translations.get('vehicle_name'), carName);
                     },
                   ),
                   const SizedBox(height: 32),
                   _buildSectionTitle(context, Translations.get('ai_diagnosis')),
                   const SizedBox(height: 12),
                   Text(
                     _getAiDescription(status),
                     style: TextStyle(color: context.textSec, fontSize: 16, height: 1.5),
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
      case 'GOOD':
      case 'EXCELLENT':
        return Translations.get('desc_normal');
      case 'CRACKED':
        return Translations.get('desc_cracked');
      case 'WORN OUT':
      case 'DEFECTIVE':
        return Translations.get('desc_worn_out');
      case 'UNEVEN WEAR':
        return Translations.get('desc_uneven_wear');
      default:
        return Translations.get('desc_default');
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: TextStyle(color: context.textFaded, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5));
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: context.textSec, fontSize: 16)),
          Text(value, style: TextStyle(color: context.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
