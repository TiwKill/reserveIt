import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../services/api_service.dart';
import 'detail_page.dart';
import 'dart:ui' as ui;

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
    final String result = apiData['ai_result'] ?? 'Normal';
    final Color color = result == 'Normal' ? AppTheme.success : (result == 'Worn Out' ? AppTheme.danger : AppTheme.warning);
    
    return {
      'id': apiData['id'].toString(),
      'car_id': apiData['car_id'],
      'title': result,
      'date': apiData['created_at'] != null ? DateTime.parse(apiData['created_at']).toString().substring(0, 10) : 'N/A',
      'status': result == 'Normal' ? 'EXCELLENT' : result.toUpperCase(),
      'icon': result == 'Normal' ? 'check' : 'warning',
      'color': color,
      'imageUrl': ApiService.getImageUrl(apiData['image_url']),
      'wearLevel': (apiData['confidence'] ?? 90.0) / 100.0,
      'badgeText': result == 'Normal' ? null : result,
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TireGuard AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: -0.5)),
                    Text('DIAGNOSTIC DASHBOARD', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
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
                      Text('RECENT ANALYSIS', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Text(_timelineItems.isNotEmpty ? _timelineItems.first['ai_result'].toString().toUpperCase() : 'NO DATA',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('System Status', style: TextStyle(color: Colors.white38, fontSize: 10, fontStyle: FontStyle.italic)),
                      Text('ALGORITHMS READY', style: TextStyle(color: AppTheme.success, fontSize: 10, fontWeight: FontWeight.bold)),
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
            const Text('No scan history yet', style: TextStyle(color: Colors.white24)),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double timelineHeight = 200.0 * _timelineItems.length;

        final path = Path();
        path.moveTo(width * 0.5, 0);
        
        // Dynamic path based on count
        for (int i = 0; i < _timelineItems.length; i++) {
          final double h = (i + 1) * 200.0;
          path.cubicTo(
            i % 2 == 0 ? width * 0.1 : width * 0.9, h - 150,
            i % 2 == 0 ? width * 0.9 : width * 0.1, h - 50,
            width * 0.5, h,
          );
        }

        final metrics = path.computeMetrics().first;

        Widget buildNodeAt(Map<String, dynamic> apiData, int index) {
          final double percent = (index + 0.5) / _timelineItems.length;
          final uiData = _mapToUI(apiData, percent);
          final pos = metrics.getTangentForOffset(metrics.length * percent)!.position;
          final bool isActive = _activeDetailId == uiData['id'];

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: pos.dx - 50,
                top: pos.dy - 50,
                child: GestureDetector(
                  onTap: () => _toggleDetail(uiData['id']),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(uiData['date'].toString().toUpperCase(),
                          style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      const SizedBox(height: 8),
                      _buildTimelineNodeIcon(
                        color: uiData['color'],
                        icon: uiData['icon'],
                        badgeText: uiData['badgeText'],
                        badgeOnTop: true,
                        isActive: isActive,
                      ),
                    ],
                  ),
                ),
              ),
              if (isActive)
                Positioned(
                  left: 24,
                  right: 24,
                  top: pos.dy + 60,
                  child: _buildDetailCard(context, uiData),
                ),
            ],
          );
        }

        return SizedBox(
          height: timelineHeight + (_activeDetailId != null ? 220 : 0),
          width: width,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: TimelineSnakePainter(path: path),
                ),
              ),
              ..._timelineItems.asMap().entries.map((entry) => buildNodeAt(entry.value, entry.key)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineNodeIcon({
    required Color color,
    required String icon,
    String? badgeText,
    bool badgeOnTop = false,
    bool isActive = false,
  }) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        if (badgeText != null)
          Positioned(
            top: badgeOnTop ? -40 : null,
            bottom: !badgeOnTop ? -40 : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 5))
                ],
              ),
              child: Text(
                badgeText.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
            ),
          ).animate().scale(curve: Curves.easeOutBack),

        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.3, 1.3)).fadeOut(),

        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.backgroundDark, width: 8),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))
            ],
          ),
          child: Center(
            child: Icon(
                    icon == 'warning' ? Icons.warning_rounded : Icons.check_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(BuildContext context, Map<String, dynamic> data) {
    final color = data['color'] as Color;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(data: data))),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 15))
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
                    Text('Captured: ${data['date']}', style: const TextStyle(color: Colors.white38, fontSize: 10, fontStyle: FontStyle.italic)),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
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
                        children: [
                          const Text('AI CONFIDENCE', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                          Text(data['status'], style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
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
              child: Text('Tap to view full report', style: TextStyle(color: color.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ).animate().fadeIn().moveY(begin: 20, end: 0),
    );
  }
}

class TimelineSnakePainter extends CustomPainter {
  final Path path;
  TimelineSnakePainter({required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 50;
    final mainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [
          const Color(0xFFEF4444).withOpacity(0.4),
          const Color(0xFFF59E0B).withOpacity(0.4),
          const Color(0xFF10B981).withOpacity(0.4),
        ],
        [0.0, 0.5, 1.0],
      );

    canvas.drawPath(path, mainPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
