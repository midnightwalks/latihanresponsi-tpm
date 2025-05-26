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

  @override
  void initState() {
    super.initState();
    check_if_already_login();
  }

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    if (newuser == false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
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
      appBar: AppBar(title: Text('Login Page', style: TextStyle(color: Colors.white)) ,
      backgroundColor: const Color(0xFF001F3F),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login to RestaurantList', style: TextStyle(fontSize: 30)),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: username_controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'username',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: password_controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001F3F),
                      foregroundColor: const Color(0xFFF5F5DC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
              onPressed: () async {
                String username = username_controller.text.trim();
                String password = password_controller.text.trim();

                var box = Hive.box('users');

                // Cek field kosong
                if (username.isEmpty && password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Username dan password kosong")),
                  );
                  return;
                }
                if (username.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Username kosong")));
                  return;
                }
                if (password.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Password kosong")));
                  return;
                }

                // Cek apakah username ada di database
                bool usernameExists = box.containsKey(username);

                // Cek apakah password ada di database (ada user dengan password tersebut)
                bool passwordExists = box.values.contains(password);

                if (usernameExists) {
                  String storedPassword = box.get(username);
                  if (password == storedPassword) {
                    // Login berhasil
                    logindata.setBool('login', false);
                    logindata.setString('username', username);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Login berhasil")));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  } else {
                    // Username benar tapi password salah
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Password salah")));
                  }
                } else {
                  if (passwordExists) {
                    // Username salah tapi password benar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Username tidak ditemukan")),
                    );
                  } else {
                    // Username dan password salah semua
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Username dan password tidak ditemukan"),
                      ),
                    );
                  }
                }
              },
              child: Text('Login'),
            ),


            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
