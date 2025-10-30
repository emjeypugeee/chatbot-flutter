import 'package:chatbot/components/custom_button.dart';
import 'package:chatbot/components/custom_textfield.dart';
import 'package:chatbot/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  // Changed to StatefulWidget
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => context.push('/welcome'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20), // Fixed padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Login Your Account',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Fixed Login Button
            CustomButton(
              text: authProvider.isLoading ? 'Logging in...' : 'Login',
              corner: 50,
              onTap: authProvider.isLoading
                  ? null
                  : () async {
                      // Validation
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final success = await authProvider.login(
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

            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create New Account?',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () => context.push('/register'),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Divider(color: Colors.grey, height: 20, thickness: 1),
            const Text(
              'Connect With Accounts',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Removed 'spacing' property, use SizedBox instead
                CustomButton(
                  text: '    G O O G L E    ',
                  corner: 10,
                  onTap: () {},
                  buttonColor: Colors.red.shade100,
                  textColor: Colors.red,
                ),
                const SizedBox(width: 20), // Added proper spacing
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
