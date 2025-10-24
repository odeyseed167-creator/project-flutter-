import 'package:flutter/material.dart';
import '../services/file_service.dart';
import '../models/secure_file.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({Key? key}) : super(key: key);

  @override
  _ImportScreenState createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  final FileService _fileService = FileService();
  bool _isImporting = false;

  // استيراد صورة
  Future<void> _importImage() async {
    setState(() => _isImporting = true);

    final SecureFile? file = await _fileService.importImage();

    setState(() => _isImporting = false);

    if (file != null) {
      _showSuccess('تم استيراد الصورة بنجاح');
      Navigator.pop(context); // العودة للشاشة الرئيسية
    } else {
      _showError('فشل في استيراد الصورة');
    }
  }

  // استيراد ملف
  Future<void> _importFile() async {
    setState(() => _isImporting = true);

    final SecureFile? file = await _fileService.importAnyFile();

    setState(() => _isImporting = false);

    if (file != null) {
      _showSuccess('تم استيراد الملف بنجاح');
      Navigator.pop(context);
    } else {
      _showError('فشل في استيراد الملف');
    }
  }

  // إظهار رسالة نجاح
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  // إظهار رسالة خطأ
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('استيراد ملفات'),
        backgroundColor: Colors.blue[800],
      ),
      body: _isImporting
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // تنبيه مهم
                  Card(
                    color: Colors.orange[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'سيتم نقل الملفات نهائياً إلى التطبيق ولن تكون متاحة خارجياً',
                              style: TextStyle(color: Colors.orange[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // عنوان
                  Text(
                    'اختر نوع الملف',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'اختر من الخيارات التالية',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30),

                  // خيارات الاستيراد
                  Expanded(
                    child: Column(
                      children: [
                        // خيار الصور
                        ListTile(
                          leading: Icon(
                            Icons.photo,
                            size: 40,
                            color: Colors.blue,
                          ),
                          title: Text(
                            'استيراد صورة',
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text('من معرض الصور'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: _importImage,
                          contentPadding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        SizedBox(height: 20),

                        // خيار الملفات
                        ListTile(
                          leading: Icon(
                            Icons.insert_drive_file,
                            size: 40,
                            color: Colors.green,
                          ),
                          title: Text(
                            'استيراد ملف',
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text('أي نوع ملف (PDF, Word, etc)'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: _importFile,
                          contentPadding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        SizedBox(height: 20),

                        // خيار الفيديو
                        ListTile(
                          leading: Icon(
                            Icons.videocam,
                            size: 40,
                            color: Colors.purple,
                          ),
                          title: Text(
                            'استيراد فيديو',
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text('من معرض الفيديو'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: _importFile, // نفس دالة الملفات
                          contentPadding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
