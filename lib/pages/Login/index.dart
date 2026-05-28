
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
		setState(() => _loading = true);
		await Future.delayed(const Duration(seconds: 1)); // simulate auth
		setState(() => _loading = false);
		// In a real app, authenticate and navigate on success.
		ScaffoldMessenger.of(context).showSnackBar(
			const SnackBar(content: Text('登录成功（模拟）')),
		);
	}

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
								TextFormField(
									controller: _usernameController,
									decoration: const InputDecoration(
										labelText: '用户名',
										prefixIcon: Icon(Icons.person),
										border: OutlineInputBorder(),
									),
									validator: (v) {
										if (v == null || v.trim().isEmpty) return '请输入用户名';
										return null;
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
											icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
											onPressed: () => setState(() => _obscure = !_obscure),
										),
									),
									validator: (v) {
										if (v == null || v.isEmpty) return '请输入密码';
										if (v.length < 4) return '密码至少4位';
										return null;
									},
								),
								const SizedBox(height: 20),
								SizedBox(
									width: double.infinity,
									height: 48,
									child: ElevatedButton(
										onPressed: _loading ? null : _submit,
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
