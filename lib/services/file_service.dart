import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../models/secure_file.dart';
import 'storage_service.dart';

class FileService {
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();

  // استيراد صورة من المعرض
  Future<SecureFile?> importImage() async {
    try {
      // اختيار صورة من المعرض
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        return await _moveFileToSecureStorage(File(pickedFile.path), 'image');
      }
    } catch (e) {
      print('خطأ في استيراد الصورة: $e');
    }
    return null;
  }

  // استيراد أي نوع ملف
  Future<SecureFile?> importAnyFile() async {
    try {
      // اختيار ملف عبر file_picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileType = _getFileType(result.files.single.extension);

        return await _moveFileToSecureStorage(file, fileType);
      }
    } catch (e) {
      print('خطأ في استيراد الملف: $e');
    }
    return null;
  }

  // نقل الملف للتخزين الآمن
  Future<SecureFile> _moveFileToSecureStorage(
    File originalFile,
    String type,
  ) async {
    // إنشاء معرف فريد للملف
    final String fileId = DateTime.now().millisecondsSinceEpoch.toString();

    // الحصول على المسار الآمن
    final securePath = await _storageService.getSecureStoragePath();

    // إنشاء اسم جديد للملف
    final String originalName = originalFile.path.split('/').last;
    final String newPath = '$securePath/$fileId\_$originalName';

    // نقل الملف (نسخ ثم حذف الأصل)
    await originalFile.copy(newPath);
    await originalFile.delete();

    // إنشاء كائن الملف الآمن
    final secureFile = SecureFile(
      id: fileId,
      name: originalName,
      type: type,
      path: newPath,
      dateAdded: DateTime.now(),
    );

    // حفظ معلومات الملف
    await _storageService.saveFileInfo(secureFile);

    return secureFile;
  }

  // استرجاع ملف للتخزين العادي
  Future<bool> restoreFile(SecureFile file, String destinationPath) async {
    try {
      final secureFile = File(file.path);
      final newPath = '$destinationPath/${file.name}';

      // نسخ الملف للموقع الجديد
      await secureFile.copy(newPath);
      return true;
    } catch (e) {
      print('خطأ في استرجاع الملف: $e');
      return false;
    }
  }

  // تحديد نوع الملف
  String _getFileType(String? extension) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
    final videoExtensions = ['mp4', 'avi', 'mov', 'mkv'];

    if (extension == null) return 'document';
    if (imageExtensions.contains(extension.toLowerCase())) return 'image';
    if (videoExtensions.contains(extension.toLowerCase())) return 'video';

    return 'document';
  }
}
