import 'package:flutter/material.dart';
import '../models/secure_file.dart';
import '../services/storage_service.dart';
import '../widgets/file_card.dart';
import 'import_screen.dart';
import 'preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<SecureFile> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  // تحميل الملفات من التخزين
  Future<void> _loadFiles() async {
    setState(() => _isLoading = true);
    final files = await _storageService.getStoredFiles();
    setState(() {
      _files = files;
      _isLoading = false;
    });
  }

  // الانتقال لشاشة الاستيراد
  void _goToImport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImportScreen()),
    ).then((_) => _loadFiles()); // إعادة تحميل الملفات بعد العودة
  }

  // معاينة ملف
  void _previewFile(SecureFile file) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PreviewScreen(file: file)),
    );
  }

  // حذف ملف
  void _deleteFile(SecureFile file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف الملف'),
        content: Text('هل متأكد من حذف ${file.name}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              await _storageService.deleteFile(file);
              _loadFiles(); // إعادة تحميل القائمة
              Navigator.pop(context);
            },
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الخزنة الآمنة'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadFiles,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body:
          _isLoading //true نعرض تحكميل
          ? Center(child: CircularProgressIndicator())
          : _files.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'لا توجد ملفات محفوظة',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'انقر على + لاستيراد ملفاتك الأولى',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _files.length,
              itemBuilder: (context, index) {
                final file = _files[index];
                return FileCard(
                  file: file,
                  onTap: () => _previewFile(file),
                  onDelete: () => _deleteFile(file),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToImport,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[700],
      ),
    );
  }
}
