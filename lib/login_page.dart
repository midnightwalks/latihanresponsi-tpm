import 'package:flutter/material.dart';
import 'package:latihanresponsi/dashboard.dart';
import 'package:latihanresponsi/register_page.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username_controller = TextEditingController();
  final password_controller = TextEditingController();

  late SharedPreferences logindata;
  late bool newuser;

  String? usernameError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    check_if_already_login();
  }

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    if (!newuser) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    }
  }

  void validateAndLogin() async {
    String username = username_controller.text.trim();
    String password = password_controller.text.trim();

    setState(() {
      usernameError = null;
      passwordError = null;
    });

    var box = Hive.box('users');
    bool valid = true;

    if (username.isEmpty) {
      usernameError = "Username tidak boleh kosong";
      valid = false;
    }

    if (password.isEmpty) {
      passwordError = "Password tidak boleh kosong";
      valid = false;
    }

    if (!valid) {
      setState(() {});
      return;
    }

    bool usernameExists = box.containsKey(username);
    bool passwordExists = box.values.contains(password);

    if (usernameExists) {
      String storedPassword = box.get(username);
      if (password == storedPassword) {
        // Login sukses
        await logindata.setBool('login', false);
        await logindata.setString('username', username);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        setState(() {
          passwordError = "Password salah";
        });
      }
    } else {
      setState(() {
        usernameError = passwordExists
            ? "Username tidak ditemukan"
            : "Username dan password tidak ditemukan";
        passwordError = passwordExists
            ? null
            : "Username dan password tidak ditemukan";
      });
    }
  }

  @override
  void dispose() {
    username_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: const Text('Login Page', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF001F3F),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Text('Login to RestaurantList', style: TextStyle(fontSize: 30)),
              const SizedBox(height: 20),
              TextField(
                controller: username_controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Username',
                  errorText: usernameError,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: password_controller,
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
                onPressed: validateAndLogin,
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
