import 'package:flutter/material.dart';
import '../models/secure_file.dart';

class FileCard extends StatelessWidget {
  final SecureFile file;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FileCard({
    Key? key,
    required this.file,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  // الحصول على أيقونة حسب نوع الملف
  IconData _getFileIcon() {
    switch (file.type) {
      case 'image':
        return Icons.photo;
      case 'video':
        return Icons.videocam;
      case 'document':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  // الحصول على لون حسب نوع الملف
  Color _getFileColor() {
    switch (file.type) {
      case 'image':
        return Colors.blue;
      case 'video':
        return Colors.purple;
      case 'document':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // تنسيق تاريخ الإضافة
  String _formatDate() {
    final now = DateTime.now();
    final difference = now.difference(file.dateAdded);

    if (difference.inDays > 0) {
      return 'قبل ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'قبل ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'قبل ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  // عرض حوار الاسترجاع - تأخذ context كمعامل
  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context, // ✅ الآن context متوفر
      builder: (context) => AlertDialog(
        title: Text('استرجاع الملف'),
        content: Text('سيتم نسخ الملف إلى مجلد التنزيلات. هل تريد المتابعة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restoreFile(context); // ✅ نمرر context
            },
            child: Text('استرجاع'),
          ),
        ],
      ),
    );
  }

  // استرجاع الملف - تأخذ context كمعامل
  void _restoreFile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      // ✅ الآن context متوفر
      SnackBar(content: Text('ميزة الاسترجاع قريباً...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: ListTile(
        // أيقونة الملف
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getFileColor().withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_getFileIcon(), color: _getFileColor(), size: 30),
        ),

        // معلومات الملف
        title: Text(
          file.name,
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${file.type} • ${_formatDate()}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 2),
            Text(
              'محمي داخل التطبيق',
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
          ],
        ),

        // زر القائمة
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'delete') {
              onDelete();
            } else if (value == 'restore') {
              _showRestoreDialog(context); // ✅ نمرر context للدالة
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'restore',
              child: Row(
                children: [
                  Icon(Icons.download, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('استرجاع للجهاز'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 10),
                  Text('حذف من التطبيق'),
                ],
              ),
            ),
          ],
        ),

        // النقر للمعاينة
        onTap: onTap,
      ),
    );
  }
}
