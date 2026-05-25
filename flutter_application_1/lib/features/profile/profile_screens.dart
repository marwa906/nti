part of '../../main.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoStore store = context.store;
    final L10n t = context.t;

    return AppPageScaffold(
      title: t.profile,
      subtitle: t.profileSubtitle,
      showBack: true,
      child: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(22),
            decoration: softCardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(child: ProfileAvatar(size: 78)),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    store.profile.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF143B2F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    store.profile.email,
                    style: TextStyle(
                      color: const Color(0xFF496458).withValues(alpha: 0.92),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    store.profile.location,
                    style: TextStyle(
                      color: const Color(0xFF496458).withValues(alpha: 0.92),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  store.profile.bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.55,
                    color: const Color(0xFF496458).withValues(alpha: 0.96),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: SmallMetricCard(
                  value: '${store.totalTasks}',
                  label: t.totalTasks,
                  color: const Color(0xFF2F7CF6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SmallMetricCard(
                  value: '${store.completedTasks}',
                  label: t.doneTasks,
                  color: const Color(0xFF18A95D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SettingsTile(
            icon: Icons.person_outline_rounded,
            title: t.updateProfile,
            subtitle: t.updateProfileSubtitle,
            onTap: () => context.store.push(AppScreen.updateProfile),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            icon: Icons.lock_outline_rounded,
            title: t.changePassword,
            subtitle: t.changePasswordSubtitle,
            onTap: () => context.store.push(AppScreen.changePassword),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            icon: Icons.translate_rounded,
            title: t.languageTitle,
            subtitle: t.languageSubtitle,
            onTap: () => context.store.push(AppScreen.language),
          ),
          const SizedBox(height: 20),
          SecondaryButton(
            label: t.logout,
            icon: Icons.logout_rounded,
            foregroundColor: const Color(0xFF143B2F),
            onPressed: () => unawaited(context.store.logout()),
          ),
        ],
      ),
    );
  }
}

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final UserProfile profile = context.store.profile;
    _nameController = TextEditingController(text: profile.fullName);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _locationController = TextEditingController(text: profile.location);
    _bioController = TextEditingController(text: profile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submit() {
    final L10n t = context.t;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.store.updateProfile(
      fullName: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      location: _locationController.text,
      bio: _bioController.text,
    );
    context.showMessage(t.profileUpdatedMessage);
  }

  @override
  Widget build(BuildContext context) {
    final L10n t = context.t;

    return AppPageScaffold(
      title: t.updateProfile,
      subtitle: t.updateProfileSubtitle,
      showBack: true,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const HeroFlagCard(height: 146),
              const SizedBox(height: 18),
              AppTextField(
                controller: _nameController,
                label: t.fullName,
                icon: Icons.person_outline_rounded,
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty)
                    ? t.fillRequiredFields
                    : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _emailController,
                label: t.email,
                icon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty)
                    ? t.fillRequiredFields
                    : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _phoneController,
                label: t.phone,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty)
                    ? t.fillRequiredFields
                    : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _locationController,
                label: t.location,
                icon: Icons.location_on_outlined,
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty)
                    ? t.fillRequiredFields
                    : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _bioController,
                label: t.bio,
                icon: Icons.notes_rounded,
                maxLines: 4,
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty)
                    ? t.fillRequiredFields
                    : null,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: t.saveChanges,
                icon: Icons.save_outlined,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final L10n t = context.t;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!context.store.matchesPassword(_oldPasswordController.text)) {
      context.showMessage(t.wrongCurrentPassword);
      return;
    }
    if (_newPasswordController.text.length < 6) {
      context.showMessage(t.shortPassword);
      return;
    }
    if (_newPasswordController.text != _repeatPasswordController.text) {
      context.showMessage(t.passwordsDoNotMatch);
      return;
    }

    context.store.updatePassword(_newPasswordController.text);
    context.store.pop();
    context.showMessage(t.passwordUpdatedMessage);
  }

  @override
  Widget build(BuildContext context) {
    final L10n t = context.t;

    return AppPageScaffold(
      title: t.changePassword,
      subtitle: t.changePasswordSubtitle,
      showBack: true,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const HeroFlagCard(height: 146),
              const SizedBox(height: 18),
              AppTextField(
                controller: _oldPasswordController,
                label: t.oldPassword,
                icon: Icons.lock_clock_outlined,
                obscureText: true,
                validator: (String? value) => (value == null || value.isEmpty)
                    ? t.fillRequiredFields
                    : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _newPasswordController,
                label: t.newPassword,
                icon: Icons.lock_outline_rounded,
                obscureText: true,
                validator: (String? value) => (value == null || value.isEmpty)
                    ? t.fillRequiredFields
                    : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _repeatPasswordController,
                label: t.repeatPassword,
                icon: Icons.lock_reset_rounded,
                obscureText: true,
                validator: (String? value) => (value == null || value.isEmpty)
                    ? t.fillRequiredFields
                    : null,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: t.saveChanges,
                icon: Icons.password_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoStore store = context.store;
    final L10n t = context.t;

    return AppPageScaffold(
      title: t.languageTitle,
      subtitle: t.languageSubtitle,
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LanguageOptionCard(
            title: t.english,
            subtitle: 'English',
            selected: store.language == AppLanguage.english,
            onTap: () => store.setLanguage(AppLanguage.english),
          ),
          const SizedBox(height: 12),
          LanguageOptionCard(
            title: t.arabic,
            subtitle: 'العربية',
            selected: store.language == AppLanguage.arabic,
            onTap: () => store.setLanguage(AppLanguage.arabic),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: softCardDecoration(color: const Color(0xFFFAFCFB)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  t.languageTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF143B2F),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.languagePreview,
                  style: TextStyle(
                    height: 1.55,
                    color: const Color(0xFF496458).withValues(alpha: 0.95),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(
            label: t.done,
            icon: Icons.check_rounded,
            onPressed: () => context.store.pop(),
          ),
        ],
      ),
    );
  }
}

