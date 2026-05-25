import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../state/todo_store.dart';
import 'tasks_state.dart';

export 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit(this._store)
    : super(TasksInitialState(tasks: _store.tasks)) {
    _listener = () {
      if (isClosed) {
        return;
      }
      emit(TasksInitialState(tasks: _store.tasks));
    };
    _store.addListener(_listener);
  }

  final TodoStore _store;
  late final VoidCallback _listener;

  Future<void> refresh() async {
    emit(TasksLoadingState(tasks: _store.tasks));
    try {
      await _store.refreshMyTasks();
      emit(TasksInitialState(tasks: _store.tasks));
    } catch (_) {
      emit(TasksErrorState(tasks: _store.tasks, message: 'refresh_failed'));
    }
  }

  @override
  Future<void> close() {
    _store.removeListener(_listener);
    return super.close();
  }
}

