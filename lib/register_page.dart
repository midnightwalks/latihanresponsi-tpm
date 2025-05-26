import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(title: Text('Register Page', style: TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF001F3F),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Register to RestaurantList', style: TextStyle(fontSize: 30)),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
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
                String username = usernameController.text;
                String password = passwordController.text;

                if (username != "" && password != "") {
                  var box = Hive.box('users');
                  if (box.containsKey(username)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Username already exists!")),
                    );
                  } else {
                    await box.put(username, password);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registered successfully!")),
                    );
                    Navigator.pop(context);
                  }
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
