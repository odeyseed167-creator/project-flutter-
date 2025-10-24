import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({Key? key}) : super(key: key);

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isFirstTime = false;

  @override
  void initState() {
    super.initState();
    _checkIfFirstTime();
  }

  // التحقق إذا كانت أول مرة يستخدم التطبيق
  Future<void> _checkIfFirstTime() async {
    final isPasswordSet = await _authService.isPasswordSet();
    setState(() {
      _isFirstTime = !isPasswordSet;
    });
  }

  // معالجة إدخال كلمة السر
  Future<void> _handlePassword() async {
    if (_passwordController.text.isEmpty) return;

    setState(() => _isLoading = true);

    if (_isFirstTime) {
      // أول مرة - حفظ كلمة السر
      await _authService.setPassword(_passwordController.text);
      _goToHomeScreen();
    } else {
      // تحقق من كلمة السر
      final isValid = await _authService.checkPassword(
        _passwordController.text,
      );
      if (isValid) {
        _goToHomeScreen();
      } else {
        _showError('كلمة السر غير صحيحة');
      }
    }

    setState(() => _isLoading = false);
  }

  // الانتقال للشاشة الرئيسية
  void _goToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  // إظهار خطأ
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة القفل
              Icon(Icons.lock, size: 80, color: Colors.blue[700]),
              SizedBox(height: 20),

              // العنوان
              Text(
                _isFirstTime ? 'اختر كلمة سر للتطبيق' : 'أدخل كلمة السر',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 10),

              // وصف
              Text(
                _isFirstTime
                    ? 'سيتم استخدامها لفتح التطبيق'
                    : 'للدخول للخزنة الآمنة',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 30),

              // حقل إدخال كلمة السر
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة السر',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                onSubmitted: (_) => _handlePassword(),
              ),
              SizedBox(height: 20),

              // زر الدخول
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: Icon(Icons.lock_open),
                      label: Text(_isFirstTime ? 'حفظ والدخول' : 'دخول'),
                      onPressed: _handlePassword,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
