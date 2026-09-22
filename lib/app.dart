import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'app_view.dart';
import 'screens/auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'screens/settings/blocs/settings_cubit/settings_cubit.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<UserRepository>.value(
      value: userRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(userRepository: userRepository),
          ),
          BlocProvider(
            create: (context) => SettingsCubit(),
          ),
        ],
        child: const MyAppView(),
      ),
    );
  }
}