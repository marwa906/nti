sealed class LoginState {
  const LoginState();
}

final class LoginInitialState extends LoginState {
  const LoginInitialState();
}

final class LoginLoadingState extends LoginState {
  const LoginLoadingState();
}

final class LoginSuccessState extends LoginState {
  const LoginSuccessState();
}

final class LoginErrorState extends LoginState {
  const LoginErrorState(this.message);

  final String message;
}

