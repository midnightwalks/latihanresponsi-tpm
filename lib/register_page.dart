import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:latihanresponsi/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String? usernameError;
  String? passwordError;

  bool isPasswordValid(String password) {
    final hasLetters = password.contains(RegExp(r'[A-Za-z]'));
    final hasDigits = password.contains(RegExp(r'\d'));
    return hasLetters && hasDigits;
  }

  void validateAndRegister() async {
    String username = usernameController.text.trim();
    String password = passwordController.text;

    setState(() {
      usernameError = null;
      passwordError = null;
    });

    bool valid = true;

    if (username.length < 5) {
      setState(() {
        usernameError = "Username minimal 5 karakter";
      });
      valid = false;
    }

    if (password.length < 5) {
      setState(() {
        passwordError = "Password minimal 5 karakter";
      });
      valid = false;
    } else if (!isPasswordValid(password)) {
      setState(() {
        passwordError = "Password harus mengandung huruf dan angka";
      });
      valid = false;
    }

    if (!valid) return;

    var box = Hive.box('users');
    if (box.containsKey(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username sudah terdaftar.")),
      );
    } else {
      await box.put(username, password);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registrasi berhasil!")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Register Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF001F3F),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Text(
                'Register to RestaurantList',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Username',
                  errorText: usernameError,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  errorText: passwordError,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001F3F),
                  foregroundColor: const Color(0xFFF5F5DC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: validateAndRegister,
                child: const Text('Register'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
