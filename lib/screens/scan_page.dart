import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../widgets/navbar.dart';
import '../services/api_service.dart';
import 'dart:io';

class ScanPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final File? preSelectedImage;
  final String? targetCarId;
  final String? targetCarName;
  final String analysisType;
  
  const ScanPage({
    super.key, 
    required this.cameras, 
    this.preSelectedImage,
    this.targetCarId,
    this.targetCarName,
    this.analysisType = 'predict',
  });

  @override
  State<ScanPage> createState() => _ScanPageState();
}

enum ScanState { menu, scanning, result }

class _ScanPageState extends State<ScanPage> {
  CameraController? _controller;
  ScanState _currentState = ScanState.menu;
  XFile? _capturedImage;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _predictionResult;

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedImage != null) {
      _capturedImage = XFile(widget.preSelectedImage!.path);
      _currentState = ScanState.result;
      _performPrediction(widget.preSelectedImage!);
    } else if (widget.cameras.isNotEmpty) {
      _initCamera(widget.cameras.first);
      _currentState = ScanState.scanning;
    }
  }

  Future<void> _initCamera(CameraDescription camera) async {
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _performPrediction(File file) async {
    setState(() => _isAnalyzing = true);
    
    Map<String, dynamic>? result;
    if (widget.analysisType == 'ocr') {
      final ocrResult = await ApiService.ocr(file, carId: widget.targetCarId ?? '1');
      if (ocrResult != null) {
        result = {
          'ai_result': 'DOT ${ocrResult['dot_code'] ?? 'FOUND'}',
          'confidence': 'W${ocrResult['week'] ?? '-'}/Y${ocrResult['year'] ?? '-'}',
          'filename': ocrResult['image_url']?.split('/').last ?? 'OCR_IMG.jpg',
          'image_url': ocrResult['image_url'],
          'advice': ocrResult['advice'],
          'is_ocr': true,
        };
      }
    } else {
      // Use the targetCarId passed from selection page or default to 1 (deprecated but for safety)
      result = await ApiService.predict(file, carId: widget.targetCarId ?? '1'); 
    }

    if (mounted) {
      setState(() {
        _predictionResult = result;
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      setState(() {
        _isAnalyzing = true;
        _currentState = ScanState.scanning;
      });
      final image = await _controller!.takePicture();
      
      if (mounted) {
        setState(() {
          _capturedImage = image;
          _currentState = ScanState.result;
        });
        await _performPrediction(File(image.path));
      }
    } catch (e) {
      debugPrint('Capture error: $e');
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          _buildBackgroundGrid(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildMainContent()),
              ],
            ),
          ),
          if (_currentState == ScanState.result)
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomNavbar(
                currentIndex: 2,
                onTap: (index) {
                   if (index == 0) Navigator.pop(context);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGrid() {
    return Positioned.fill(child: CustomPaint(painter: GridPainter()));
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                ).animate(onPlay: (controller) => controller.repeat()).fade(duration: 800.ms, begin: 0.3, end: 1.0),
                const SizedBox(width: 8),
                const Text('AI SCANNER ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppTheme.primary)),
              ],
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_currentState) {
      case ScanState.menu:
        return const SizedBox();
      case ScanState.scanning:
        return _buildCameraView();
      case ScanState.result:
        return _buildResult();
    }
  }

  Widget _buildCameraView() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CameraPreview(_controller!),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.8), blurRadius: 10, spreadRadius: 2)],
                      ),
                    ).animate(onPlay: (c) => c.repeat()).moveY(begin: 0, end: 500, duration: 2.seconds, curve: Curves.linear),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: GestureDetector(
                        onTap: _captureImage,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
                          padding: const EdgeInsets.all(4),
                          child: Container(decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                        ),
                      ),
                    ),
                  ),
                  if (_isAnalyzing)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: AppTheme.primary),
                            SizedBox(height: 16),
                            Text('ANALYZING...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final String rawResult = _predictionResult?['ai_result'] ?? 'Analyzing...';
    final String resultText = rawResult.isNotEmpty 
        ? '${rawResult[0].toUpperCase()}${rawResult.substring(1).toLowerCase()}'
        : rawResult;
    final bool isNormal = resultText.toLowerCase() == 'normal';
    final String confidence = _predictionResult?['confidence']?.toString() ?? '-%';
    
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_predictionResult != null && _predictionResult!['image_url'] != null)
                      Image.network(
                        ApiService.getImageUrl(_predictionResult!['image_url']),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to local image if network image fails
                          return _capturedImage != null
                              ? Image.file(File(_capturedImage!.path), fit: BoxFit.cover)
                              : const Center(child: Icon(Icons.broken_image, color: Colors.white54, size: 50));
                        },
                      )
                    else if (_capturedImage != null)
                      Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
                      
                    if (_isAnalyzing)
                       Container(color: Colors.black54, child: const Center(child: CircularProgressIndicator(color: AppTheme.primary))),
                    if (_predictionResult != null) ...[
                      Positioned(top: 100, left: 100, child: _buildDetectionDot(AppTheme.primary)),
                      Positioned(bottom: 16, left: 16, right: 16, child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_predictionResult?['is_ocr'] == true ? 'DETECTED DOT' : 'DETECTED ISSUE', style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle)),
                                    const SizedBox(width: 8),
                                    Text(resultText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
                              child: Text('$confidence Confidence', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(32)),
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
                          const Text('Data Analytics', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                          Text(widget.targetCarName ?? 'Quick Scan', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Text('#${_predictionResult?['filename']?.substring(0, 8) ?? 'TR-SCAN'}', style: const TextStyle(color: Colors.white30, fontSize: 10, fontFamily: 'monospace')),
                  ],
                ),
                const SizedBox(height: 24),
                _predictionResult?['is_ocr'] == true
                  ? _buildMetric('Tire Age Advice', _predictionResult!['advice'] ?? 'Unknown', 0.8, Colors.purpleAccent)
                  : _buildMetric('Surface Integrity', isNormal ? 'Optimal' : resultText, isNormal ? 0.95 : 0.45, isNormal ? AppTheme.success : AppTheme.danger),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.05),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('FINISH', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).moveY(begin: 30, end: 0),
    );
  }

  Widget _buildDetectionDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10)],
      ),
    ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 1.seconds).fade(begin: 1.0, end: 0.0);
  }

  Widget _buildMetric(String label, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.05)..strokeWidth = 1;
    const double spacing = 30;
    for (double i = 0; i <= size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i <= size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
