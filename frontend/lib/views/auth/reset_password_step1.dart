import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/reset_password_viewmodel.dart';

class ResetPasswordStep1View extends StatefulWidget {
  final String email;

  const ResetPasswordStep1View({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordStep1View> createState() => _ResetPasswordStep1ViewState();
}

class _ResetPasswordStep1ViewState extends State<ResetPasswordStep1View> {
  @override
  void initState() {
    super.initState();
    debugPrint('📧 ResetPasswordStep1View initialized with email: "${widget.email}"');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResetPasswordViewModel(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 4, 39, 61),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 4, 39, 61),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Vérification du code',
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
              child: Consumer<ResetPasswordViewModel>(
                builder: (context, vm, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Image.asset('assets/supcom_logo.png', width: 140),
                      const SizedBox(height: 24),

                      // Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_user,
                          size: 48,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title
                      const Text(
                        "Vérification du code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // Description
                      Text(
                        "Entrez le code envoyé à\n${widget.email}",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // OTP Input
                      TextFormField(
                        controller: vm.otpController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          letterSpacing: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLength: 6,
                        decoration: InputDecoration(
                          hintText: '• • • • • •',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 24,
                            letterSpacing: 8,
                          ),
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.08),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.amber),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.redAccent),
                          ),
                        ),
                      ),

                      // Error message
                      if (vm.errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  vm.errorMessage!,
                                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Verify button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: vm.isLoading
                              ? null
                              : () => vm.verifyOtp(context, widget.email),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade700,
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
                                  'Vérifier le code',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Resend code
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Nouveau code envoyé'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: const Icon(Icons.refresh, color: Colors.lightBlueAccent, size: 18),
                        label: const Text(
                          "Renvoyer le code",
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
