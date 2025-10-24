// نموذج يمثل ملف محفوظ في التطبيق
class SecureFile {
  final String id; // معرف فريد للملف
  final String name; // اسم الملف الأصلي
  final String type; // نوع الملف (image, video, document)
  final String path; // المسار داخل التطبيق
  final DateTime dateAdded; // تاريخ الإضافة

  SecureFile({
    required this.id,
    required this.name,
    required this.type,
    required this.path,
    required this.dateAdded,
  });

  // تحويل الكائن لـ Map لحفظه
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'path': path,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  // إنشاء كائن من Map
  factory SecureFile.fromMap(Map<String, dynamic> map) {
    return SecureFile(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      path: map['path'],
      dateAdded: DateTime.parse(map['dateAdded']),
    );
  }
}
