import 'package:flutter/foundation.dart';

class Translations {
  static final ValueNotifier<String> currentLang = ValueNotifier<String>('th');

  static void changeLanguage(String lang) {
    if (lang == 'th' || lang == 'en') {
      currentLang.value = lang;
    }
  }

  static String get(String key) {
    final lang = currentLang.value;
    if (_texts[lang] != null && _texts[lang]!.containsKey(key)) {
      return _texts[lang]![key]!;
    }
    return _texts['en']?[key] ?? key;
  }

  static const Map<String, Map<String, String>> _texts = {
    'th': {
      // Main Navbar
      'nav_timeline': 'ไทม์ไลน์',
      'nav_garage': 'โรงรถ',
      'nav_scan': 'สแกน',
      
      // Main Scaffold Modal
      'select_module': 'เลือกโมดูล',
      'choose_analysis_tool': 'เลือกเครื่องมือวิเคราะห์ AI',
      'module_predict': 'ตรวจสภาพยาง',
      'module_ocr': 'ตรวจอายุยาง',

      // Settings Page
      'settings_title': 'ตั้งค่า',
      'section_account': 'บัญชี',
      'personal_info': 'ข้อมูลส่วนตัว',
      'notifications': 'การแจ้งเตือน',
      'security_privacy': 'ความปลอดภัยและความเป็นส่วนตัว',
      'section_system': 'ระบบ',
      'language': 'ภาษา',
      'dark_mode': 'โหมดมืด',
      'always_on': 'เปิดตลอด',
      'sign_out': 'ออกจากระบบ',

      // Timeline Page
      'app_name_subtitle': 'แผงควบคุมการวินิจฉัย',
      'recent_analysis': 'การวิเคราะห์ล่าสุด',
      'no_data': 'ไม่มีข้อมูล',
      'system_status': 'สถานะระบบ',
      'algorithms_ready': 'พร้อมทำงาน',
      'no_scan_history': 'ยังไม่มีประวัติการสแกน',
      'captured': 'บันทึกเมื่อ:',
      'ai_confidence': 'ความมั่นใจ AI',

      // Garage Page
      'my_garage': 'โรงรถของฉัน',
      'managed_vehicles': 'จัดการยานพาหนะ',
      'add_vehicle': 'เพิ่มยานพาหนะ',
      'no_vehicles_yet': 'ยังไม่มียานพาหนะ',
      'recent_scan': 'สแกนล่าสุด',
      'never_scanned': 'ยังไม่เคยสแกน',
      'delete_title': 'ลบยานพาหนะ',
      'delete_confirm': 'คุณแน่ใจหรือไม่ที่จะลบยานพาหนะนี้?',
      'cancel': 'ยกเลิก',
      'delete': 'ลบ',

      // Garage Form Page
      'add_new_vehicle': 'เพิ่มยานพาหนะใหม่',
      'edit_vehicle': 'แก้ไขยานพาหนะ',
      'brand': 'ยี่ห้อ (เช่น Toyota)',
      'brand_req': 'กรุณาระบุยี่ห้อ',
      'model': 'รุ่น (เช่น Camry)',
      'model_req': 'กรุณาระบุรุ่น',
      'year': 'ปี (เช่น 2022)',
      'year_req': 'กรุณาระบุปี',
      'plate_number': 'ป้ายทะเบียน (เช่น 1กข 1234)',
      'plate_req': 'กรุณาระบุป้ายทะเบียน',
      'image_req': 'กรุณาเลือกรูปภาพ',
      'select_vehicle_image': 'เลือกรูปยานพาหนะ',
      'camera': 'กล้อง',
      'gallery': 'คลังภาพ',
      'save_vehicle': 'บันทึกข้อมูล',

      // Vehicle Selection Page
      'select_vehicle': 'เลือกยานพาหนะ',
      'select_vehicle_for_predict': 'เลือกยานพาหนะสำหรับ ตรวจสภาพยาง',
      'select_vehicle_for_ocr': 'เลือกยานพาหนะสำหรับ ตรวจอายุยาง',
      'no_vehicles_found': 'ไม่พบยานพาหนะ',
      'back_to_menu': 'กลับสู่เมนูหลัก',
      'select_image_source': 'เลือกแหล่งที่มาของรูปภาพ',

      // Scan Page
      'ai_scanner_active': 'AI สแกนเนอร์ทำงาน',
      'analyzing': 'กำลังวิเคราะห์...',
      'detected_dot': 'ตรวจพบ DOT',
      'detected_issue': 'ตรวจพบปัญหา',
      'confidence': 'ความมั่นใจ',
      'data_analytics': 'การวิเคราะห์ข้อมูล',
      'quick_scan': 'สแกนด่วน',
      'ai_advice': 'คำแนะนำจาก AI',
      'unknown_condition': 'ไม่ทราบสภาพ',
      'surface_integrity': 'ความสมบูรณ์ของพื้นผิว',
      'finish': 'เสร็จสิ้น',
      'optimal': 'เหมาะสม',

      // Detail Page
      'scan_details': 'รายละเอียดการสแกน',
      'status': 'สถานะ',
      'analysis_result': 'ผลการวิเคราะห์',
      'analysis_report': 'รายงานการวิเคราะห์',
      'date_captured': 'วันที่บันทึก',
      'health_status': 'สถานะสุขภาพ',
      'prediction_confidence': 'ความมั่นใจในการทำนาย',
      'vehicle_information': 'ข้อมูลยานพาหนะ',
      'loading_vehicle_info': 'กำลังโหลดข้อมูล...',
      'vehicle_name': 'ชื่อยานพาหนะ',
      'ai_diagnosis': 'การวินิจฉัยโดย AI',
      'desc_normal': 'พื้นผิวยางดูปกติ ไม่พบรอยแตกหักหรือการสึกหรอที่ผิดปกติ',
      'desc_cracked': 'ตรวจพบรอยแตกหรือโครงสร้างเสื่อมสภาพบนแก้มยาง อาจทำให้ยางระเบิด ควรตรวจสอบโดยช่างผู้เชี่ยวชาญทันที',
      'desc_worn_out': 'ดอกยางลดลงกว่าระดับที่ปลอดภัย ประสิทธิภาพการเบรกและการยึดเกาะถนนเปียกลดลง แนะนำให้เปลี่ยนยางทันที',
      'desc_uneven_wear': 'ตรวจพบการสึกหรอที่ไม่สม่ำเสมอ ซึ่งอาจเกิดจากปัญหาศูนย์ล้อหรือระบบกันสะเทือน ควรเช็คศูนย์ล้อถ่วงล้อ',
      'desc_default': 'การวิเคราะห์เสร็จสมบูรณ์ โปรดดูสถานะสรุปด้านบน',
    },
    'en': {
      // Main Navbar
      'nav_timeline': 'Timeline',
      'nav_garage': 'Garage',
      'nav_scan': 'Scan',
      
      // Main Scaffold Modal
      'select_module': 'Select Module',
      'choose_analysis_tool': 'Choose an AI analysis tool',
      'module_predict': 'Predict',
      'module_ocr': 'OCR',

      // Settings Page
      'settings_title': 'Settings',
      'section_account': 'Account',
      'personal_info': 'Personal Information',
      'notifications': 'Notifications',
      'security_privacy': 'Security & Privacy',
      'section_system': 'System',
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'always_on': 'Always On',
      'sign_out': 'Sign Out',

      // Timeline Page
      'app_name_subtitle': 'DIAGNOSTIC DASHBOARD',
      'recent_analysis': 'RECENT ANALYSIS',
      'no_data': 'NO DATA',
      'system_status': 'System Status',
      'algorithms_ready': 'ALGORITHMS READY',
      'no_scan_history': 'No scan history yet',
      'captured': 'Captured:',
      'ai_confidence': 'AI CONFIDENCE',

      // Garage Page
      'my_garage': 'MY GARAGE',
      'managed_vehicles': 'MANAGED VEHICLES',
      'add_vehicle': 'ADD VEHICLE',
      'no_vehicles_yet': 'No vehicles yet',
      'recent_scan': 'Recent Scan',
      'never_scanned': 'Never scanned',
      'delete_title': 'Delete Vehicle',
      'delete_confirm': 'Are you sure you want to delete this vehicle?',
      'cancel': 'Cancel',
      'delete': 'Delete',

      // Garage Form Page
      'add_new_vehicle': 'ADD NEW VEHICLE',
      'edit_vehicle': 'EDIT VEHICLE',
      'brand': 'Brand (e.g. Toyota)',
      'brand_req': 'Please enter brand',
      'model': 'Model (e.g. Camry)',
      'model_req': 'Please enter model',
      'year': 'Year (e.g. 2022)',
      'year_req': 'Please enter year',
      'plate_number': 'Plate Number (e.g. ABC-123)',
      'plate_req': 'Please enter plate number',
      'image_req': 'Please select an image',
      'select_vehicle_image': 'Select Vehicle Image',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'save_vehicle': 'SAVE VEHICLE',

      // Vehicle Selection Page
      'select_vehicle': 'SELECT VEHICLE',
      'select_vehicle_for_predict': 'Select a vehicle for Tire Analysis',
      'select_vehicle_for_ocr': 'Select a vehicle for OCR',
      'no_vehicles_found': 'No vehicles found',
      'back_to_menu': 'BACK TO MENU',
      'select_image_source': 'Select Image Source',

      // Scan Page
      'ai_scanner_active': 'AI SCANNER ACTIVE',
      'analyzing': 'ANALYZING...',
      'detected_dot': 'DETECTED DOT',
      'detected_issue': 'DETECTED ISSUE',
      'confidence': 'Confidence',
      'data_analytics': 'Data Analytics',
      'quick_scan': 'Quick Scan',
      'ai_advice': 'AI ADVICE',
      'unknown_condition': 'Unknown condition',
      'surface_integrity': 'Surface Integrity',
      'finish': 'FINISH',
      'optimal': 'Optimal',

      // Detail Page
      'scan_details': 'SCAN DETAILS',
      'status': 'Status',
      'analysis_result': 'Analysis Result',
      'analysis_report': 'Analysis Report',
      'date_captured': 'Date captured',
      'health_status': 'HEALTH STATUS',
      'prediction_confidence': 'Prediction Confidence',
      'vehicle_information': 'VEHICLE INFORMATION',
      'loading_vehicle_info': 'Loading vehicle info...',
      'vehicle_name': 'Vehicle Name',
      'ai_diagnosis': 'AI DIAGNOSIS',
      'desc_normal': 'The tire surface appears healthy. No significant cracks, uneven wear, or dangerous patterns detected. Continue regular maintenance.',
      'desc_cracked': 'Signs of dry rot or structural aging detected on the sidewall. This can lead to sudden tire failure. Immediate inspection by a professional is recommended.',
      'desc_worn_out': 'The tread depth is below safe limits. Braking distance and wet surface traction are significantly reduced. Replacement is highly recommended.',
      'desc_uneven_wear': 'Detection of inconsistent tread patterns suggests alignment or suspension issues. Check wheel balance and alignment soon.',
      'desc_default': 'AI analysis complete. Please refer to the summarized status above for the primary diagnosis.',
    }
  };
}
