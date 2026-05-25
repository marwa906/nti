part of '../main.dart';

class TodoScope extends InheritedNotifier<TodoStore> {
  const TodoScope({super.key, required TodoStore store, required super.child})
    : super(notifier: store);

  static TodoStore of(BuildContext context) {
    final TodoScope? scope = context
        .dependOnInheritedWidgetOfExactType<TodoScope>();
    assert(scope != null, 'TodoScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}

extension TodoContext on BuildContext {
  TodoStore get store => TodoScope.of(this);

  L10n get t => L10n(store.language);

  void showMessage(String message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }
}

