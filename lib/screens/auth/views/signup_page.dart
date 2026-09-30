import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';
import 'sign_up_screen.dart';

class SignupPage extends StatelessWidget {
  final UserRepository userRepository;
  const SignupPage({required this.userRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocProvider(
        create: (context) => SignUpBloc(userRepository),
        child: const SignUpScreen(),
      ),
    );
  }
}
