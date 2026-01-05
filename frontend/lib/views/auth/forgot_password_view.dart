import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/forgot_password_viewmodel.dart';
import 'reset_password_step1.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordViewModel(),
      child: const _ForgotPasswordContent(),
    );
  }
}

class _ForgotPasswordContent extends StatelessWidget {
  const _ForgotPasswordContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 39, 61),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 39, 61),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mot de passe oublié',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Image.asset('assets/supcom_logo.png', width: 160),
                const SizedBox(height: 24),

                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 48,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  "Réinitialiser le mot de passe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Description
                const Text(
                  "Entrez votre adresse email pour recevoir un code de réinitialisation",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Email field
                TextFormField(
                  controller: vm.emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
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
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: vm.isLoading
                        ? null
                        : () async {
                            try {
                              final email = vm.emailController.text.trim();
                              final message = await vm.submit();

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              // Navigate to OTP verification
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ResetPasswordStep1View(email: email),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString().replaceFirst('Exception: ', '')),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
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
                        : const Text(
                            'Envoyer le code',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Info box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.lightBlueAccent, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Un code de vérification sera envoyé à votre adresse email",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Back to login
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Retour à la connexion',
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
