part of '../main.dart';

void main() {
  runApp(const TodoApp());
}

const String brandIllustrationAsset = 'assets/images/brand.png';
const String emptyIllustrationAsset = 'assets/images/empty_state.png';
const String flagIllustrationAsset = 'assets/images/flag.png';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final TodoStore store = TodoStore();
  late final LoginCubit _loginCubit;
  late final TasksCubit _tasksCubit;
  Timer? _timer;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _loginCubit = LoginCubit(store);
    _tasksCubit = TasksCubit(store);
    unawaited(store.bootstrap());
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _loginCubit.close();
    _tasksCubit.close();
    store.dispose();
    super.dispose();
  }

  Widget _buildCurrentScreen(TodoStore store) {
    switch (store.currentRoute.screen) {
      case AppScreen.welcome:
        return const WelcomeScreen(key: ValueKey<String>('welcome'));
      case AppScreen.register:
        return const RegisterScreen(key: ValueKey<String>('register'));
      case AppScreen.login:
        return const LoginScreen(key: ValueKey<String>('login'));
      case AppScreen.home:
        return const HomeScreen(key: ValueKey<String>('home'));
      case AppScreen.addTask:
        return const TaskEditorScreen(key: ValueKey<String>('add-task'));
      case AppScreen.editTask:
        return TaskEditorScreen(
          key: ValueKey<String>('edit-${store.currentRoute.taskId}'),
          task: store.taskById(store.currentRoute.taskId!),
        );
      case AppScreen.profile:
        return const ProfileScreen(key: ValueKey<String>('profile'));
      case AppScreen.updateProfile:
        return const UpdateProfileScreen(
          key: ValueKey<String>('update-profile'),
        );
      case AppScreen.changePassword:
        return const ChangePasswordScreen(
          key: ValueKey<String>('change-password'),
        );
      case AppScreen.language:
        return const LanguageScreen(key: ValueKey<String>('language'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? child) {
        return TodoScope(
          store: store,
          child: MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<LoginCubit>.value(value: _loginCubit),
              BlocProvider<TasksCubit>.value(value: _tasksCubit),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'TODO',
              theme: buildTheme(),
              locale: store.language == AppLanguage.arabic
                  ? const Locale('ar')
                  : const Locale('en'),
              supportedLocales: const <Locale>[Locale('en'), Locale('ar')],
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              home: Directionality(
                textDirection: store.textDirection,
                child: PopScope<Object?>(
                  canPop: !store.canPop,
                  onPopInvokedWithResult: (bool didPop, Object? result) {
                    if (!didPop && store.canPop) {
                      store.pop();
                    }
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: _showSplash
                        ? const SplashScreen(key: ValueKey<String>('splash'))
                        : _buildCurrentScreen(store),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
