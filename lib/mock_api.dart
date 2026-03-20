import '../theme.dart';

class MockApi {
  // Timeline Data
  static final List<Map<String, dynamic>> timelineData = [
    {
      'id': '1',
      'percent': 0.05,
      'date': 'Today, 14:20 PM',
      'title': 'Rear Left Tire',
      'status': 'CRITICAL',
      'statusText': 'DANGER: REPLACEMENT NEEDED',
      'color': AppTheme.danger,
      'icon': '!',
      'badgeText': 'DANGER: REPLACEMENT NEEDED',
      'wearLevel': 0.88,
      'mm': '2.1 mm',
      'imageUrl': 'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&q=80&w=400',
      'description': 'Significant tread wear detected on the inner edge. Immediate replacement is recommended to avoid hydroplaning or blowout.',
      'location': 'Rear Left',
      'pressure': '32 PSI',
      'temperature': '42°C',
    },
    {
      'id': '2',
      'percent': 0.55,
      'date': 'Oct 12, 2023',
      'title': 'Monthly Inspection',
      'status': 'WARNING',
      'statusText': 'MONITOR CLOSELY',
      'color': AppTheme.warning,
      'icon': 'warning',
      'wearLevel': 0.65,
      'mm': '4.2 mm',
      'imageUrl': 'https://images.unsplash.com/photo-1580273916550-e323be2ae537?auto=format&fit=crop&q=80&w=400',
      'description': 'Tread depth is approaching safety limits. Plan for replacement within the next 3,000 miles.',
      'location': 'Front Right',
      'pressure': '35 PSI',
      'temperature': '38°C',
    },
    {
      'id': '3',
      'percent': 0.85,
      'date': 'Sep 04, 2023',
      'title': 'System Check Passed',
      'status': 'GOOD',
      'statusText': 'ALL TIRES SAFE',
      'color': AppTheme.success,
      'icon': 'check',
      'wearLevel': 0.15,
      'mm': '7.8 mm',
      'imageUrl': 'https://images.unsplash.com/photo-1621213349472-88003f47387d?auto=format&fit=crop&q=80&w=400',
      'description': 'All parameters within optimal range. Tires are in excellent condition.',
      'location': 'All Tires',
      'pressure': '34 PSI',
      'temperature': '35°C',
    },
  ];

  // Garage Data
  static List<Map<String, dynamic>> garageData = [
    {
      'id': 'v1',
      'name': 'Tesla Model 3',
      'health': 0.24,
      'isActive': true,
      'imageUrl': 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=400&auto=format&fit=crop',
      'color': AppTheme.danger,
    },
    {
      'id': 'v2',
      'name': 'Porsche Taycan',
      'health': 0.92,
      'isActive': false,
      'imageUrl': 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=400&auto=format&fit=crop',
      'color': AppTheme.success,
    },
    {
      'id': 'v3',
      'name': 'BMW i4 M50',
      'health': 0.72,
      'isActive': false,
      'imageUrl': 'https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=400&auto=format&fit=crop',
      'color': AppTheme.warning,
    },
  ];

  // User Data
  static const Map<String, dynamic> userData = {
    'name': 'Alex Johnson',
    'email': 'alex.j@example.com',
    'profileUrl': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=200',
  };
}
