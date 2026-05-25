import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../state/todo_store.dart';
import 'login_state.dart';

export 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._store) : super(const LoginInitialState());

  final TodoStore _store;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoadingState());
    final bool ok = await _store.login(email: email, password: password);
    if (ok) {
      emit(const LoginSuccessState());
      return true;
    }
    emit(const LoginErrorState('login_failed'));
    return false;
  }
}
