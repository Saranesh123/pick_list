// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextFieldController =
      TextEditingController();
  final TextEditingController _pwdTextFieldController = TextEditingController();
  bool isWrong = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                    width: 250,
                    height: 200,
                    child: Image.asset('images/kaynes.jpg')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: null,
                    errorText: isWrong ? '' : null,
                    errorStyle: const TextStyle(
                        color: Colors.red, fontStyle: FontStyle.italic)),
                controller: _emailTextFieldController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: null,
                    errorText: isWrong ? '' : null,
                    errorStyle: const TextStyle(
                        color: Colors.red, fontStyle: FontStyle.italic)),
                controller: _pwdTextFieldController,
              ),
            ),
            Container(
              height: 50,
              width: 100,
              padding: const EdgeInsets.only(
                  left: 0.0, right: 0, top: 15, bottom: 0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  final url =
                      Uri.parse('http://192.168.68.104:8003/api/method/login');
                  final body = {
                    'usr': _emailTextFieldController.text,
                    'pwd': _pwdTextFieldController.text,
                  };
                  final response = await http.post(url, body: body);
                  final jsonResponse = json.decode(response.body);
                  if (jsonResponse['message'] == 'Logged In') {
                    setState(() {
                      isWrong = false;
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  } else {
                    setState(() {
                      isWrong = true;
                    });
                  }
                },
                label: const Text("Login"),
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
