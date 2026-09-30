import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import 'sign_in_screen.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;
  const LoginPage({required this.userRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocProvider(
        create: (context) => SignInBloc(userRepository),
        child: const SignInScreen(),
      ),
    );
  }
}
