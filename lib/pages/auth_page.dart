import 'package:crewlink/providers/common_providers.dart';
import 'package:crewlink/widgets/frosted_text_field.dart';
import 'package:crewlink/widgets/gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCreatingAccount = ref.watch(createAccountProvider);

    return GradientScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                spacing: 16.0,
                children: [
                  // Image.asset(
                  //   'assets/images/logo.png',
                  //   width: double.infinity,
                  // ),
                  Text(
                    'CL',
                    style: TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (isCreatingAccount)
                    const FrostedTextField(
                      name: 'name',
                      label: 'Name',
                    ),
                  const FrostedTextField(
                    name: 'email',
                    label: 'Email',
                  ),
                  const FrostedTextField(
                    name: 'password',
                    label: 'Password',
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(isCreatingAccount ? 'Sign up' : 'Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(createAccountProvider.notifier).toggle();
                    },
                    child: Text(
                      isCreatingAccount
                          ? 'I already have an account'
                          : 'Create an account',
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
