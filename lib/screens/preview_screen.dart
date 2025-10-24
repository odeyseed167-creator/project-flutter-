import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import '../models/secure_file.dart';
import '../services/file_service.dart';

class PreviewScreen extends StatefulWidget {
  final SecureFile file;

  const PreviewScreen({Key? key, required this.file}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final FileService _fileService = FileService();

  // استرجاع الملف للجهاز
  Future<void> _restoreFile() async {
    try {
      // نستخدم مجلد التنزيلات كموقع افتراضي
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir != null) {
        final success = await _fileService.restoreFile(
          widget.file,
          downloadsDir.path,
        );

        if (success) {
          _showSuccess('تم استرجاع الملف إلى مجلد التنزيلات');
        } else {
          _showError('فشل في استرجاع الملف');
        }
      } else {
        _showError('لا يمكن الوصول لمجلد التنزيلات');
      }
    } catch (e) {
      _showError('حدث خطأ: $e');
    }
  }

  // مشاركة الملف
  Future<void> _shareFile() async {
    // هنا يمكن إضافة حزمة share_plus لاحقاً
    _showInfo('ميزة المشاركة قريباً...');
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

  // إظهار رسالة معلومات
  void _showInfo(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // بناء واجهة المعاينة حسب نوع الملف
  Widget _buildPreview() {
    switch (widget.file.type) {
      case 'image':
        return PhotoView(
          imageProvider: FileImage(File(widget.file.path)),
          backgroundDecoration: BoxDecoration(color: Colors.black),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        );
      case 'video':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text('فيديو', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text(widget.file.name),
            ],
          ),
        );
      case 'document':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text('مستند', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text(widget.file.name),
            ],
          ),
        );
      default:
        return Center(child: Text('نوع ملف غير معروف'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: Text(
          widget.file.name,
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // زر الاسترجاع
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _restoreFile,
            tooltip: 'استرجاع للجهاز',
          ),
          // زر المشاركة
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareFile,
            tooltip: 'مشاركة',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'info') {
                _showFileInfo();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    Icon(Icons.info),
                    SizedBox(width: 10),
                    Text('معلومات الملف'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildPreview(),
    );
  }

  // إظهار معلومات الملف
  void _showFileInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('معلومات الملف'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('الاسم:', widget.file.name),
            _buildInfoRow('النوع:', widget.file.type),
            _buildInfoRow('الحجم:', 'جاري الحساب...'), // يمكن إضافة حساب الحجم
            _buildInfoRow('تم الإضافة:', _formatDate(widget.file.dateAdded)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  // بناء صف معلومات
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // تنسيق التاريخ
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}';
  }
}
