part of '../../main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPageScaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SplashLogo(),
            SizedBox(height: 26),
            Text(
              'TODO',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF18A95D),
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final L10n t = context.t;

    return AppPageScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 18),
            SizedBox(
              height: 320,
              child: Image.asset(brandIllustrationAsset, fit: BoxFit.contain),
            ),
            const SizedBox(height: 18),
            Text(
              t.welcomeTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              t.welcomeSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 46,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF18A95D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => context.store.push(AppScreen.register),
                child: Text(
                  t.letsStart,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF18A95D), width: 3),
      ),
      child: const Icon(
        Icons.check_rounded,
        size: 148,
        color: Color(0xFF18A95D),
      ),
    );
  }
}

class _AuthHeaderImage extends StatelessWidget {
  const _AuthHeaderImage();

  @override
  Widget build(BuildContext context) {
    final L10n t = context.t;
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              flagIllustrationAsset,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                t.isArabic ? 'اختر صورة' : 'Pick image',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12,
          color: Colors.black.withValues(alpha: 0.35),
        ),
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        prefixIcon: Icon(prefixIcon, size: 18),
        suffixIcon: suffixIcon == null
            ? null
            : Icon(suffixIcon, size: 18, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF18A95D), width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final L10n t = context.t;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_passwordController.text.length < 6) {
      context.showMessage(t.shortPassword);
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      context.showMessage(t.passwordsDoNotMatch);
      return;
    }
    setState(() {
      _submitting = true;
    });
    final bool ok = await context.store.register(
      fullName: _emailController.text,
      email: _emailController.text,
      phone: '',
      password: _passwordController.text,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _submitting = false;
    });
    if (!ok) {
      context.showMessage(context.store.authErrorMessage ?? t.incorrectCredentials);
      return;
    }
    context.showMessage(t.accountReadyMessage);
  }

  @override
  Widget build(BuildContext context) {
    final L10n t = context.t;

    return AppPageScaffold(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _AuthHeaderImage(),
              const SizedBox(height: 16),
              _AuthTextField(
                controller: _emailController,
                hintText: t.email,
                prefixIcon: Icons.person_outline_rounded,
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty)
                        ? t.fillRequiredFields
                        : null,
              ),
              const SizedBox(height: 12),
              _AuthTextField(
                controller: _passwordController,
                hintText: t.password,
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                validator: (String? value) => (value == null || value.isEmpty)
                    ? t.fillRequiredFields
                    : null,
              ),
              const SizedBox(height: 12),
              _AuthTextField(
                controller: _confirmPasswordController,
                hintText: t.confirmPassword,
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                validator: (String? value) => (value == null || value.isEmpty)
                    ? t.fillRequiredFields
                    : null,
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 46,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF18A95D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _submitting ? null : () => unawaited(_submit()),
                  child: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          t.createAccount,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    t.isArabic ? 'لديك حساب بالفعل؟' : 'Already Have An Account?',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 6),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                    onPressed: () => context.store.replaceTop(AppScreen.login),
                    child: Text(
                      t.signIn,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginCubit? _cubit;
  bool _didInitCubit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitCubit) {
      return;
    }
    _cubit = LoginCubit(context.store);
    _didInitCubit = true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _cubit?.close();
    super.dispose();
  }

  Future<void> _submit() async {
    final L10n t = context.t;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final bool ok = await _cubit!.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!ok && mounted) {
      context.showMessage(context.store.authErrorMessage ?? t.incorrectCredentials);
    }
  }

  @override
  Widget build(BuildContext context) {
    final L10n t = context.t;

    return BlocProvider<LoginCubit>.value(
      value: _cubit!,
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (BuildContext context, LoginState state) {
          final bool submitting = state is LoginLoadingState;
          return AppPageScaffold(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const _AuthHeaderImage(),
                    const SizedBox(height: 16),
                    _AuthTextField(
                      controller: _emailController,
                      hintText: t.email,
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (String? value) =>
                          (value == null || value.trim().isEmpty)
                              ? t.fillRequiredFields
                              : null,
                    ),
                    const SizedBox(height: 12),
                    _AuthTextField(
                      controller: _passwordController,
                      hintText: t.password,
                      prefixIcon: Icons.lock_outline_rounded,
                      suffixIcon: Icons.lock_outline_rounded,
                      obscureText: true,
                      validator: (String? value) =>
                          (value == null || value.isEmpty)
                              ? t.fillRequiredFields
                              : null,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 46,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF18A95D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                            submitting ? null : () => unawaited(_submit()),
                        child: submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                t.signIn,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          t.isArabic
                              ? 'ليس لديك حساب؟'
                              : "Don't Have An Account?",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(width: 6),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6),
                          ),
                          onPressed: () =>
                              context.store.replaceTop(AppScreen.register),
                          child: Text(
                            t.createAccount,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
