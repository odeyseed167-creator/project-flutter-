import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/secure_file.dart';

class StorageService {
  // الحصول على المسار الآمن داخل التطبيق
  Future<String> getSecureStoragePath() async {
    final appDir = await getApplicationDocumentsDirectory(); // يعيد مسار مجلد
    final secureDir = Directory(
      '${appDir.path}/secure_vault',
    ); // اسم المجلد تم انشاءه

    // إنشاء المجلد إذا لم يكن موجوداً
    if (!await secureDir.exists()) {
      await secureDir.create(recursive: true);
    }

    return secureDir.path;
  }

  // حفظ معلومات الملفات
  Future<void> saveFileInfo(SecureFile file) async {
    final prefs = await SharedPreferences.getInstance();
    final files = await getStoredFiles();

    // إضافة الملف الجديد للقائمة
    files.add(file);

    // حفظ القائمة كـ JSON
    final filesJson = files.map((f) => f.toMap()).toList();
    await prefs.setString('secure_files', json.encode(filesJson));
  }

  // جلب جميع الملفات المحفوظة
  Future<List<SecureFile>> getStoredFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final filesJson = prefs.getString('secure_files');

    if (filesJson == null) return [];

    // تحويل JSON لقائمة ملفات
    final List<dynamic> filesList = json.decode(filesJson);
    return filesList.map((item) => SecureFile.fromMap(item)).toList();
  }

  // حذف ملف من التخزين
  Future<void> deleteFile(SecureFile file) async {
    // حذف الملف الفعلي
    final fileObj = File(file.path);
    if (await fileObj.exists()) {
      await fileObj.delete();
    }

    // حذف المعلومات من القائمة
    final files = await getStoredFiles();
    files.removeWhere((f) => f.id == file.id);

    // حفظ القائمة المحدثة
    final prefs = await SharedPreferences.getInstance();
    final filesJson = files.map((f) => f.toMap()).toList();
    await prefs.setString('secure_files', json.encode(filesJson));
  }
}
