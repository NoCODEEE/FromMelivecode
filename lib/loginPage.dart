import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/tabMenuPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _fromKey = GlobalKey<FormState>();
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final url = Uri.parse('https://www.melivecode.com/api/login');
    final header = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': _usernameController.text,
      'password': _passwordController.text
    });
    final response = await http.post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      _showSnackBar(jsonResponse['message']);
      _navigatorKey.currentState?.push(
        MaterialPageRoute(
            builder: (context) => TabMenuPage(
                username: jsonResponse['user']['username']))
      );
    }
  }
  
  void _showSnackBar(String msg) {
    final snackBar = SnackBar(
        content: Text(msg),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                        key: _fromKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(labelText: 'UserName'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Name';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(labelText: 'Password'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24,),
                              ElevatedButton(onPressed: () {
                                if (_fromKey.currentState!.validate()) {
                                  _login();
                                }
                              },
                                  child: const Text('Login'))
                        ])
                    ),
                ),
              ),
            ));
      },
    );
  }
  
}