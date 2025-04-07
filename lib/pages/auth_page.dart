import 'package:crewlink/providers/common_providers.dart';
import 'package:crewlink/widgets/custom_snackbar.dart';
import 'package:crewlink/widgets/frosted_text_field.dart';
import 'package:crewlink/widgets/gradient_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _fb = FirebaseAuth.instance;

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCreatingAccount = ref.watch(createAccountProvider);
    final formKey = GlobalKey<FormBuilderState>();

    void submit() async {
      final formState = formKey.currentState;
      if (formState?.saveAndValidate() ?? false) {
        final values = formState!.value;
        final name = values['name'] as String?;
        final email = values['email'] as String;
        final password = values['password'] as String;

        try {
          if (!isCreatingAccount) {
            // login
            await _fb.signInWithEmailAndPassword(
              email: email,
              password: password,
            );
          } else {
            // sign up
            final userCreds = await _fb.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
            // update user displayName
            final user = userCreds.user;
            if (user != null && name != null) {
              await user.updateDisplayName(name);
              await _fb.currentUser?.reload(); // reload current user
              final refreshedUser = _fb.currentUser;
              print('display name set: ${refreshedUser?.displayName}');
            }
          }
        } on FirebaseAuthException catch (error) {
          if (error.code == 'email-already-in-use') {
            CustomSnackbar.showError(
              context,
              'This email is already in use. Please login!',
            );
          } else if (error.code == 'invalid-credential') {
            CustomSnackbar.showError(
              context,
              'This email/password was not found!',
            );
          } else {
            CustomSnackbar.showError(
              context,
              error.message ?? 'Auth error!',
            );
          }
        }
      }
    }

    return GradientScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
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
                    onPressed: () {
                      submit();
                    },
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
