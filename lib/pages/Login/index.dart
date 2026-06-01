import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('请同意用户协议和隐私政策'),
          width: 250,
          behavior: SnackBarBehavior.floating,
        ),
        //        const SnackBar(content: Text('请同意用户协议和隐私政策')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1)); // simulate auth
    setState(() => _loading = false);
    // In a real app, authenticate and navigate on success.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('登录成功（模拟）')),
    );
  }

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text('账号密码登录',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: '手机号码',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return '请输入手机号码';
                    if (v.contains(' ')) return '手机号码不能包含空格';
                    return RegExp(r'^1[3-9]\d{9}$').hasMatch(v)
                        ? null
                        : '请输入有效的11位手机号码';
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: '密码',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  onChanged: (v) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.isEmpty) return '请输入密码';
                    if (v.contains(' ')) return '密码不能包含空格';
                    if (v.length < 6 || v.length > 16) return '密码至少6位，最多16位';
                    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(v)
                        ? null
                        : '密码只能包含字母和数字';
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: _isChecked,
                        activeColor: Colors.red,
                        onChanged: (v) =>
                            setState(() => _isChecked = v ?? false)),
                    const Text.rich(TextSpan(
                      text: '同意',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                      children: [
                        TextSpan(
                          text: '《用户协议》',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 230, 51, 15)),
                          recognizer: null, // TODO: add TapGestureRecognizer
                        ),
                        TextSpan(text: '和'),
                        TextSpan(
                          text: '《隐私政策》',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 230, 51, 15)),
                          recognizer: null, // TODO: add TapGestureRecognizer
                        ),
                      ],
                    )),
                    // Text('同意用户协议和隐私政策'),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      backgroundColor: Color.fromARGB(255, 134, 47, 29),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('登录'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    // TODO: implement forgot password
                  },
                  child: const Text('忘记密码？'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
