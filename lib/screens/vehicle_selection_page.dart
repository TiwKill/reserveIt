import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../theme.dart';
import '../services/api_service.dart';
import 'scan_page.dart';

class VehicleSelectionPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final File? preSelectedImage;
  final bool isGalleryMode;

  const VehicleSelectionPage({
    super.key,
    required this.cameras,
    this.preSelectedImage,
    this.isGalleryMode = false,
  });

  @override
  State<VehicleSelectionPage> createState() => _VehicleSelectionPageState();
}

class _VehicleSelectionPageState extends State<VehicleSelectionPage> {
  List<Map<String, dynamic>> _vehicles = [];
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    setState(() => _isLoading = true);
    final cars = await ApiService.getCars();
    if (mounted) {
      setState(() {
        _vehicles = cars;
        _isLoading = false;
      });
    }
  }

  Future<void> _onVehicleSelected(Map<String, dynamic> car) async {
    File? selectedFile = widget.preSelectedImage;

    // If we are in gallery mode, we must pick the image NOW after selecting the car
    if (widget.isGalleryMode) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      
      if (image == null) return; // User cancelled
      selectedFile = File(image.path);
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanPage(
          cameras: widget.cameras,
          preSelectedImage: selectedFile,
          targetCarId: car['id'].toString(),
          targetCarName: '${car['brand']} ${car['model']}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
        title: const Text(
          'SELECT VEHICLE',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : _vehicles.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        widget.isGalleryMode 
                          ? 'Select a vehicle to upload from gallery' 
                          : 'Select a vehicle to scan with camera',
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _vehicles.length,
                        itemBuilder: (context, index) {
                          final car = _vehicles[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildVehicleCard(car),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_filled_outlined, size: 64, color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 16),
          const Text('No vehicles found', style: TextStyle(color: Colors.white24, fontSize: 16)),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BACK TO MENU', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> car) {
    final String carId = car['id'].toString();
    final List<Color> colors = [AppTheme.primary, AppTheme.success, AppTheme.warning, AppTheme.danger, Colors.purple, Colors.orange];
    final Color color = colors[carId.hashCode % colors.length];

    return GestureDetector(
      onTap: () => _onVehicleSelected(car),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(ApiService.getImageUrl(car['image_url'])),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${car['brand']} ${car['model']}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(car['plate_number'] ?? 'No Plate', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 50.ms).moveX(begin: 20, end: 0);
  }
}
