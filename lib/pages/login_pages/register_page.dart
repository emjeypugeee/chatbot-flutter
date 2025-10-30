import 'package:chatbot/components/custom_button.dart';
import 'package:chatbot/components/custom_textfield.dart';
import 'package:chatbot/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            onPressed: () => context.push('/welcome'),
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 50, 20, 20),
        child: Column(
          children: [
            Text(
              'Create your Account',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 50),

            // Error message
            if (authProvider.errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        authProvider.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            CustomTextfield(
              hintText: 'Full Name',
              obscureText: false,
              controller: nameController,
            ),
            const SizedBox(height: 20),
            CustomTextfield(
              hintText: 'Email',
              obscureText: false,
              controller: emailController,
            ),
            const SizedBox(height: 20),
            CustomTextfield(
              hintText: 'Password',
              obscureText: true,
              controller: passwordController,
              showVisibilityIcon: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: authProvider.isLoading ? 'Creating Account...' : 'Register',
              corner: 50,
              onTap: authProvider.isLoading
                  ? null
                  : () async {
                      // Basic validation
                      if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final success = await authProvider.register(
                        nameController.text,
                        emailController.text,
                        passwordController.text,
                      );

                      if (success && mounted) {
                        context.push('/chatbot');
                      }
                    },
              buttonColor: const Color(0xFF232627),
              textColor: Colors.white,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () => context.push('/login'),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.grey, height: 20, thickness: 1),
            const Text(
              'Connect With Accounts',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: '    G O O G L E    ',
                  corner: 10,
                  onTap: () {},
                  buttonColor: Colors.red.shade100,
                  textColor: Colors.red,
                ),
                const SizedBox(width: 20), // Added spacing
                CustomButton(
                  text: '  F A C E B O O K  ',
                  corner: 10,
                  onTap: () {},
                  buttonColor: Colors.blue.shade200,
                  textColor: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
