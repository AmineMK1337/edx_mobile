import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/login_viewmodel.dart';
import 'home_view.dart';
import 'student_e_view.dart';
import 'auth/forgot_password_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginScaffold(),
    );
  }
}

class _LoginScaffold extends StatefulWidget {
  const _LoginScaffold();

  @override
  State<_LoginScaffold> createState() => _LoginScaffoldState();
}

class _LoginScaffoldState extends State<_LoginScaffold> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String? _loginError;

  Future<void> _handleLogin(LoginViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loginError = null;
    });

    try {
      final result = await vm.login();

      if (!mounted) return;

      final role = (result['user']?['role'] ?? '').toString().toLowerCase();
      final selectedRole = vm.selectedRole;
      final isStudent =
          role.contains('etudiant') || role.contains('student') || selectedRole == 0;

      if (isStudent) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const StudentHome()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      String errorMsg = e.toString().replaceFirst('Exception: ', '');
      
      // Check for common error patterns and show user-friendly message
      if (errorMsg.contains('401') || 
          errorMsg.toLowerCase().contains('invalid') ||
          errorMsg.toLowerCase().contains('incorrect') ||
          errorMsg.toLowerCase().contains('wrong') ||
          errorMsg.toLowerCase().contains('not found')) {
        errorMsg = 'Email ou mot de passe incorrect';
      } else if (errorMsg.contains('connexion') || errorMsg.contains('timeout')) {
        errorMsg = 'Erreur de connexion au serveur';
      }
      
      setState(() {
        _loginError = errorMsg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 39, 61),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/supcom_logo.png', width: 180),
                  const SizedBox(height: 20),
                  const Text(
                    'Veuillez saisir votre login et mot de passe',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  // Role selector
                  ToggleButtons(
                    isSelected: List.generate(3, (index) => index == vm.selectedRole),
                    borderRadius: BorderRadius.circular(8),
                    fillColor: Colors.white.withOpacity(0.15),
                    selectedColor: Colors.white,
                    color: Colors.white70,
                    onPressed: vm.isLoading
                        ? null
                        : (index) {
                            vm.selectRole(index);
                          },
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text('Étudiant'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text('Prof'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text('Admin'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Email
                  TextFormField(
                    controller: vm.identifiantController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      if (!value.contains('@')) {
                        return 'Email invalide';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: vm.passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      if (value.length < 6) {
                        return 'Le mot de passe doit contenir au moins 6 caractères';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Error message display
                  if (_loginError != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _loginError!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vm.isLoading ? null : () => _handleLogin(vm),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: vm.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Se connecter'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Forgot password link
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordView()),
                      );
                    },
                    child: const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
