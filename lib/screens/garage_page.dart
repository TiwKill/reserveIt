import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../services/api_service.dart';
import 'garage_form_page.dart';

class GaragePage extends StatefulWidget {
  const GaragePage({super.key});

  @override
  State<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  List<Map<String, dynamic>> _vehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final cars = await ApiService.getCars();
    if (!mounted) return;
    setState(() {
      _vehicles = cars;
      _isLoading = false;
    });
  }

  Future<void> _addVehicle() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const GarageFormPage()),
    );

    if (result == true) {
      _fetchVehicles();
    }
  }

  Future<void> _editVehicle(Map<String, dynamic> car) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => GarageFormPage(initialData: car),
      ),
    );

    if (result == true) {
      _fetchVehicles();
    }
  }

  void _confirmDelete(Map<String, dynamic> car) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete Vehicle?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to remove ${car['brand']} ${car['model'] ?? ''} from your garage?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () async {
              final success = await ApiService.deleteCar(car['id']);
              if (!mounted) return;
              Navigator.pop(context);
              if (success) {
                _fetchVehicles();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppTheme.danger,
                    content: const Text('Vehicle removed from garage'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            child: const Text('DELETE', style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundDark,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Your Garage', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                Text('${_vehicles.length} Vehicles'.toUpperCase(), style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ],
            ),
            const SizedBox(height: 24),
            if (_isLoading)
               const Center(child: Padding(
                 padding: EdgeInsets.all(40.0),
                 child: CircularProgressIndicator(color: AppTheme.primary),
               ))
            else if (_vehicles.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.directions_car_filled_outlined, size: 64, color: Colors.white.withOpacity(0.05)),
                      const SizedBox(height: 16),
                      const Text('Your garage is empty', style: TextStyle(color: Colors.white24, fontSize: 16)),
                    ],
                  ),
                ),
              )
            else
              ..._vehicles.map((car) {
                 return Padding(
                   padding: const EdgeInsets.only(bottom: 16),
                   child: _buildVehicleCard(
                    context,
                    data: car,
                    onEdit: () => _editVehicle(car),
                    onDelete: () => _confirmDelete(car),
                   ),
                 );
              }),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _addVehicle,
              child: _buildAddVehicleButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TireGuard AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Text('VEHICLE MANAGEMENT', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          icon: const Icon(Icons.settings_rounded, color: Colors.white38, size: 24),
        ),
      ],
    );
  }

  Widget _buildVehicleCard(BuildContext context, {
    required Map<String, dynamic> data,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    // Generate a consistent color based on car ID (UUID string)
    final String carId = data['id'].toString();
    final List<Color> colors = [AppTheme.primary, AppTheme.success, AppTheme.warning, AppTheme.danger, Colors.purple, Colors.orange];
    final Color color = colors[carId.hashCode % colors.length];
    
    // Server doesn't return health for now, default to 100%
    final double health = 1.0; 
    final bool isActive = carId == 1; // Mock active state for now

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: BorderDirectional(start: BorderSide(color: isActive ? color : color.withOpacity(0.2), width: 4)),
      ),
      child: Stack(
        children: [
          if (isActive)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Text('ACTIVE', style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(ApiService.getImageUrl(data['image_url'])), 
                    fit: BoxFit.cover, 
                    opacity: isActive ? 1.0 : 0.6
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data['brand']} ${data['model']}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(data['plate_number'] ?? 'No Plate', style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Health: ${(health * 100).toInt()}%', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: health,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_note_rounded, color: Colors.white24),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.danger, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 50.ms).moveX(begin: 20, end: 0);
  }

  Widget _buildAddVehicleButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
            child: const Icon(Icons.add_rounded, color: Colors.white38, size: 32),
          ),
          const SizedBox(height: 12),
          const Text('REGISTER NEW VEHICLE', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ],
      ),
    );
  }
}
