# Repo Structure (Flutter + BLoC/Cubit)

الملف ده بيشرح تقسيمة المشروع الحالية، وبالأخص مكان الـ `cubit` داخل `lib/`.

## Root

```text
flutter_application_1/
  assets/
  lib/
  test/
  pubspec.yaml
  pubspec.lock
```

## lib/

```text
lib/
  main.dart

  app/
    todo_app.dart
    todo_scope.dart

  api/
    todo_api.dart
    news_api.dart
    token_store.dart

  state/
    todo_store.dart

  models/
    app_enums.dart
    app_route_state.dart
    task_item.dart
    user_profile.dart
    models.dart

  utils/
    colors.dart
    formatters.dart
    image_manager.dart
    l10n.dart
    theme.dart
    utils.dart

  ui/
    components.dart
    page_scaffold.dart
    painters.dart

  features/
    auth/
      auth_screens.dart
      cubit/
        login_cubit.dart
        login_state.dart

    tasks/
      task_screens.dart
      cubit/
        tasks_cubit.dart
        tasks_state.dart

    profile/
      profile_screens.dart
```

## Cubit usage

- `features/auth/cubit/login_cubit.dart`: مسئول عن login (loading/success/error).
- `features/tasks/cubit/tasks_cubit.dart`: بيراقب `TodoStore` ويطلع `TasksState` علشان الـUI يتبني بـ `BlocBuilder`.
- توفير الـCubits تم على مستوى التطبيق في `lib/app/todo_app.dart` باستخدام `MultiBlocProvider`.

## Notes

- `TodoStore` لسه هو المصدر الأساسي للبيانات والـnavigation، والـCubits دلوقتي عاملة “Bridge” للـUI بدل ما الشاشات تعتمد على `store.tasks` مباشرة.
