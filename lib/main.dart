import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironkey/app_theme.dart';

void main() {
  runApp(IronKeyApp());
}

class IronKeyApp extends StatelessWidget {
  const IronKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      title: "IronKey",
      home: IronKeyScreen(),
    );
  }
}

class IronKeyScreen extends StatefulWidget {
  const IronKeyScreen({super.key});

  @override
  State<IronKeyScreen> createState() => _IronKeyScreenState();
}

class _IronKeyScreenState extends State<IronKeyScreen> {
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void copyPassword(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Senha copiada!')));
  }

  void generatePassword() {
    const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const lower = "abcdefghijklmnopqrstuvwxyz";
    const numbers = "0123456789";
    const symbols = "!@#\$%&*";
    final chars = upper + lower + numbers + symbols;
    final random = Random();
    setState(() {
      _passwordController.text = List.generate(
        12,
        (_) => chars[random.nextInt(chars.length)],
      ).join();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          "assets/images/IronMask2-removebg-preview.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Jarvis, digite uma senha segura",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      maxLength: 12,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        prefix: Icon(Icons.lock),
                        suffix: _passwordController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  copyPassword(_passwordController.text);
                                },
                                icon: Icon(Icons.copy),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
          
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: generatePassword, 
                child: Text("Gerar senha")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
