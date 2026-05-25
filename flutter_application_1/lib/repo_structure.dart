library repo_structure;

// Simple internal reference for the project's `lib/` layout.
// Not required by the app runtime (no imports needed).
//
// Tip: keep this file updated when adding new features/cubits.

class LibLayout {
  // Common paths (mostly for quick copy/paste).
  static const String main = 'lib/main.dart';

  static const String app = 'lib/app';
  static const String api = 'lib/api';
  static const String state = 'lib/state';
  static const String models = 'lib/models';
  static const String utils = 'lib/utils';
  static const String ui = 'lib/ui';
  static const String features = 'lib/features';

  // Feature folders.
  static const String auth = 'lib/features/auth';
  static const String tasks = 'lib/features/tasks';
  static const String profile = 'lib/features/profile';

  // Cubit folders (rule: inside each feature).
  static const String authCubit = 'lib/features/auth/cubit';
  static const String tasksCubit = 'lib/features/tasks/cubit';

  // Rules (quick reminders).
  static const String featureRule = 'features/<feature_name>/';
  static const String cubitRule = 'features/<feature_name>/cubit/';
  static const String cubitFilesRule = '<name>_cubit.dart + <name>_state.dart';
}

// Text tree (for sharing / docs).
const String libTree = r'''
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
''';

// Small helper if you ever want to print the tree in debug.
void debugPrintLibTree() {
  // ignore: avoid_print
  print(libTree);
}
