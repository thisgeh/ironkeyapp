import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironkey/app_theme.dart';
import 'package:ironkey/models/password_complexity.dart';
import 'package:ironkey/password_generator.dart';
import 'package:ironkey/pin_password_generator.dart';
import 'package:ironkey/standard_password_generator.dart';

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
      themeMode: ThemeMode.light,
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
  final TextEditingController _passWordController = TextEditingController();

  PassowardType passowardSelectType = PassowardType.pin;
  bool isEditable = false;
  bool includeUppercase = true;
  bool includeLowercase = true;
  bool includeNumbers = false;
  bool includeSymbols = false;
  int passwordLength = 12;
  PasswordComplexity selectedComplexity = PasswordComplexity.medium;

  @override
  void initState() {
    super.initState();
    _passWordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passWordController.dispose();
    super.dispose();
  }

  void copyPassword(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Senha copiada!')));
  }

  void generatePassword() {
    late final PasswordGenerator generator;

    switch (passowardSelectType) {
      case PassowardType.pin:
        generator = PinPasswordGenerator();
        break;
      case PassowardType.standard:
        generator = StandardPasswordGenerator(
          includeLowercase: isEditable ? includeLowercase : true,
          includeUppercase: isEditable ? includeUppercase : true,
          includeNumbers: isEditable ? includeNumbers : true,
          includeSymbols: isEditable ? includeSymbols : true,
        );
        break;
    }

    setState(() {
      _passWordController.text = generator.generate(passwordLength);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                        "Jarvis, proteja a minha senha!",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        enabled: isEditable,
                        controller: _passWordController,
                        maxLength: 12,
                        decoration: InputDecoration(
                          labelText: "Passoward",
                          border: OutlineInputBorder(),
                          prefix: Icon(Icons.lock),
                          suffix: _passWordController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    copyPassword(_passWordController.text);
                                  },
                                  icon: Icon(Icons.copy),
                                )
                              : null,
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Tipo de senha"),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              value: PassowardType.pin,
                              groupValue: passowardSelectType,
                              title: Text("Pin"),
                              onChanged: (value) {
                                setState(() {
                                  passowardSelectType = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              value: PassowardType.standard,
                              groupValue: passowardSelectType,
                              title: Text("Senha padrão"),
                              onChanged: (value) {
                                setState(() {
                                  passowardSelectType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      Divider(color: colorScheme.outline),

                      Row(
                        children: [
                          Icon(isEditable ? Icons.lock_open : Icons.lock),
                          SizedBox(width: 8),
                          Expanded(child: Text("Permitir editar a senha?")),
                          Switch(
                            value: isEditable,
                            onChanged: (value) {
                              setState(() {
                                isEditable = value;
                              });
                            },
                          ),
                        ],
                      ),

                      Divider(color: colorScheme.outline),
                      const SizedBox(height: 20),

                      if (isEditable) ...[
                        const SizedBox(height: 20),
                        DropdownButtonFormField<PasswordComplexity>(
                          value: selectedComplexity,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Complexidade da senha',
                            border: OutlineInputBorder(),
                          ),
                          items: PasswordComplexity.values.map((complexity) {
                            return DropdownMenuItem(
                              value: complexity,
                              child: Text(complexity.title),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedComplexity = value!;
                              passwordLength = selectedComplexity.length;
                            });
                          },
                        ),

                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Tamanho da senha $passwordLength"),
                        ),

                        Slider(
                          value: passwordLength.toDouble(),
                          min: 4,
                          max: 12,
                          onChanged: (value) {
                            setState(() {
                              passwordLength = value.toInt();
                            });
                            generatePassword();
                          },
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: includeUppercase,
                                onChanged: (value) => setState(
                                  () => includeUppercase = value ?? false,
                                ),
                                title: Text("Maiúsculas"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: includeLowercase,
                                onChanged: (value) => setState(
                                  () => includeLowercase = value ?? false,
                                ),
                                title: Text("Minúsculas"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: includeNumbers,
                                onChanged: (value) => setState(
                                  () => includeNumbers = value ?? false,
                                ),
                                title: Text("Números"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: includeSymbols,
                                onChanged: (value) => setState(
                                  () => includeSymbols = value ?? false,
                                ),
                                title: Text("Símbolos"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: generatePassword,
                  child: Text("Gerar senha"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum PassowardType { pin, standard }