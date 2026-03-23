import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import '../theme.dart';
import '../services/api_service.dart';
import '../translations.dart';

class GarageFormPage extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const GarageFormPage({super.key, this.initialData});

  @override
  State<GarageFormPage> createState() => _GarageFormPageState();
}

class _GarageFormPageState extends State<GarageFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _plateController;
  
  late String _imageUrl; // This is the relative path from server
  File? _selectedImage;
  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.initialData?['brand'] ?? '');
    _modelController = TextEditingController(text: widget.initialData?['model'] ?? '');
    _yearController = TextEditingController(text: widget.initialData?['year']?.toString() ?? '');
    _plateController = TextEditingController(text: widget.initialData?['plate_number'] ?? '');
    _imageUrl = widget.initialData?['image_url'] ?? '';
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: context.borderFaded),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: context.textFaded, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Text(Translations.get('upload_vehicle_photo'), style: TextStyle(color: context.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildSourceOption(context, Icons.camera_alt_rounded, Translations.get('camera'), AppTheme.primary, () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                })),
                const SizedBox(width: 16),
                Expanded(child: _buildSourceOption(context, Icons.photo_library_rounded, Translations.get('gallery'), Colors.blue, () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                })),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(color: context.textMain, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      String? currentImageUrl = _imageUrl;

      // 1. Upload new image if selected
      if (_selectedImage != null) {
        final uploadedPath = await ApiService.uploadFile(_selectedImage!);
        if (uploadedPath != null) {
          currentImageUrl = uploadedPath;
        }
      }

      final carData = {
        'brand': _brandController.text,
        'model': _modelController.text,
        'year': int.tryParse(_yearController.text) ?? 2024,
        'plate_number': _plateController.text,
        'image_url': currentImageUrl,
      };

      Map<String, dynamic>? result;
      if (widget.initialData != null) {
        // Update
        result = await ApiService.updateCar(widget.initialData!['id'], carData);
      } else {
        // Create
        result = await ApiService.createCar(
          brand: carData['brand'] as String,
          model: carData['model'] as String,
          year: carData['year'] as int,
          plateNumber: carData['plate_number'] as String,
          imageUrl: carData['image_url'] as String?,
        );
      }

      if (result != null) {
        if (!mounted) return;
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to save car');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: AppTheme.danger, content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.initialData != null;

    return Scaffold(
      backgroundColor: context.bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.textMain),
        ),
        title: Text(
          isEdit ? Translations.get('edit_vehicle') : Translations.get('add_new_vehicle'),
          style: TextStyle(color: context.textMain, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header / Image Preview with Upload UI
            GestureDetector(
              onTap: _showImageSourcePicker,
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  image: _selectedImage != null || _imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: _selectedImage != null 
                          ? FileImage(_selectedImage!) as ImageProvider
                          : NetworkImage(ApiService.getImageUrl(_imageUrl)),
                        fit: BoxFit.cover,
                      )
                    : null,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [context.bgColor.withOpacity(0.6), Colors.transparent, context.bgColor],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 48),
                        const Icon(Icons.add_a_photo_rounded, color: Colors.white54, size: 48),
                        const SizedBox(height: 12),
                        Text(Translations.get('tap_to_change_photo'), style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vehicle Identity', style: TextStyle(color: context.textMain, fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            context,
                            controller: _brandController,
                            label: Translations.get('brand_label'),
                            hint: Translations.get('brand_hint'),
                            icon: Icons.factory_rounded,
                            validator: (v) => v!.isEmpty ? Translations.get('required') : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            context,
                            controller: _yearController,
                            label: Translations.get('year_label'),
                            hint: '2022',
                            icon: Icons.calendar_today_rounded,
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? Translations.get('required') : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      context,
                      controller: _modelController,
                      label: Translations.get('model_label'),
                      hint: Translations.get('model_hint'),
                      icon: Icons.directions_car_rounded,
                      validator: (v) => v!.isEmpty ? Translations.get('required') : null,
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      context,
                      controller: _plateController,
                      label: Translations.get('plate_label'),
                      hint: Translations.get('plate_hint'),
                      icon: Icons.branding_watermark_rounded,
                      validator: (v) => v!.isEmpty ? Translations.get('required') : null,
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Save Button
                    GestureDetector(
                      onTap: _isSaving ? null : _save,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: _isSaving ? [Colors.grey, Colors.grey] : [AppTheme.primary, AppTheme.primary.withOpacity(0.8)]),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [if (!_isSaving) BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                        ),
                        child: Center(
                          child: _isSaving
                            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            : Text(isEdit ? Translations.get('update_vehicle') : Translations.get('register_vehicle'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95)),
                    
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: context.textTertiary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          style: TextStyle(color: context.textMain, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: context.borderFaded),
            prefixIcon: Icon(icon, color: AppTheme.primary, size: 20),
            filled: true,
            fillColor: context.cardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: context.cardColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.primary)),
          ),
        ),
      ],
    );
  }
}
