import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../services/api_service.dart';
import 'detail_page.dart';
import '../translations.dart';


class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  String? _activeDetailId;
  List<Map<String, dynamic>> _timelineItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTimeline();
  }

  Future<void> _fetchTimeline() async {
    setState(() => _isLoading = true);
    final items = await ApiService.getTimeline();
    if (mounted) {
      setState(() {
        _timelineItems = items;
        _isLoading = false;
      });
    }
  }

  void _toggleDetail(String id) {
    setState(() {
      _activeDetailId = _activeDetailId == id ? null : id;
    });
  }

  // Map API data to UI model
  Map<String, dynamic> _mapToUI(Map<String, dynamic> apiData, double percent) {
    final String rawResult = apiData['ai_result']?.toString() ?? 'Normal';
    final String result = rawResult.isNotEmpty ? '${rawResult[0].toUpperCase()}${rawResult.substring(1).toLowerCase()}' : rawResult;
    final String lowerResult = result.toLowerCase();
    
    final bool isOCR = lowerResult.contains('dot') || (apiData['is_ocr'] == true);
    final bool isSuccess = lowerResult == 'good' || lowerResult == 'normal';
    final Color color = isOCR 
        ? Colors.white38 
        : (isSuccess ? AppTheme.success : AppTheme.warning);
    
    return {
      'id': apiData['id'].toString(),
      'car_id': apiData['car_id'],
      'title': result,
      'date': apiData['created_at'] != null ? DateTime.parse(apiData['created_at']).toString().substring(0, 10) : 'N/A',
      'status': isOCR ? 'OCR SCAN' : (isSuccess ? 'EXCELLENT' : 'DEFECTIVE'),
      'icon': isOCR ? 'history' : (isSuccess ? 'check' : 'warning'),
      'color': color,
      'imageUrl': ApiService.getImageUrl(apiData['image_url']),
      'wearLevel': (apiData['confidence'] is num) ? (apiData['confidence'] / 100.0) : 
                   (double.tryParse(apiData['confidence']?.toString().replaceAll('%', '') ?? '90') ?? 90.0) / 100.0,
      'badgeText': (isSuccess || isOCR) ? null : result,
      'percent': percent, // Position on snake
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundDark,
      child: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                   Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildHeader(context),
                  ),
                  _isLoading 
                    ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: AppTheme.primary)))
                    : _buildTimelineSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))
                    ],
                  ),
                  child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TireGuard AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: -0.5)),
                    Text(Translations.get('app_name_subtitle'), style: const TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: const Icon(Icons.person_outline_rounded, color: Colors.white38),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withOpacity(0.3),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Translations.get('recent_analysis'), style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Text(_timelineItems.isNotEmpty ? _timelineItems.first['ai_result'].toString().toUpperCase() : Translations.get('no_data'),
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(Translations.get('system_status'), style: const TextStyle(color: Colors.white38, fontSize: 10, fontStyle: FontStyle.italic)),
                      Text(Translations.get('algorithms_ready'), style: const TextStyle(color: AppTheme.success, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineSection() {
    if (_timelineItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Icon(Icons.history_rounded, size: 64, color: Colors.white.withOpacity(0.05)),
            const SizedBox(height: 16),
            Text(Translations.get('no_scan_history'), style: const TextStyle(color: Colors.white24)),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _timelineItems.length,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemBuilder: (context, index) {
        final apiData = _timelineItems[index];
        final uiData = _mapToUI(apiData, 0.5);
        final bool isActive = _activeDetailId == uiData['id'];
        final bool isLast = index == _timelineItems.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline Line & Dot
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: uiData['color'].withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: uiData['color'], width: 4),
                      boxShadow: [
                        BoxShadow(color: uiData['color'].withOpacity(0.4), blurRadius: 8),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Colors.white.withOpacity(0.1),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  if (isActive && isLast)
                    const SizedBox(height: 16), // Padding for the last item if expanded
                ],
              ),
              const SizedBox(width: 20),
              // Content Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: isActive
                        ? _buildDetailCard(context, uiData)
                        : GestureDetector(
                            onTap: () => _toggleDetail(uiData['id']),
                            child: _buildSummaryCard(uiData),
                          ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.1, end: 0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(Map<String, dynamic> data) {
    final color = data['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              data['icon'] == 'warning' ? Icons.warning_rounded : Icons.check_circle_rounded,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(data['date'], style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, Map<String, dynamic> data) {
    final color = data['color'] as Color;
    return GestureDetector(
      onTap: () => _toggleDetail(data['id']), // Also close when tapped!
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 5))
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
                    Text(data['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${Translations.get('captured')} ${data['date']}', style: const TextStyle(color: Colors.white38, fontSize: 10, fontStyle: FontStyle.italic)),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(data: data))),
                  child: const Icon(Icons.open_in_new_rounded, color: Colors.white54, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(image: NetworkImage(data['imageUrl']), fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Translations.get('ai_confidence'), style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              data['status'], 
                              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: data['wearLevel'],
                          minHeight: 6,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white24),
            ),
          ],
        ),
      ).animate().fadeIn().moveY(begin: 10, end: 0),
    );
  }
}
