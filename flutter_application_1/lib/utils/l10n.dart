import '../models/models.dart';

class L10n {
  const L10n(this.language);

  final AppLanguage language;

  bool get isArabic => language == AppLanguage.arabic;

  // App
  String get appName => 'TODO';
  String get splashSubtitle => isArabic
      ? 'رتّب يومك بخطوات واضحة وبسيطة.'
      : 'Plan your day with clear, calm steps.';

  // Welcome
  String get welcomeTitle =>
      isArabic ? 'مرحبًا بك في To Do!' : 'Welcome To Do It !';
  String get welcomeSubtitle => isArabic
      ? 'سجّل مهامك، حدّد أولوياتك، وخلي يومك أخف وأسهل.'
      : 'Capture tasks, set priorities, and move through the day with less stress.';
  String get letsStart => isArabic ? 'ابدأ الآن' : "Let's Start";

  // Auth
  String get signIn => isArabic ? 'تسجيل الدخول' : 'Login';
  String get createAccount => isArabic ? 'إنشاء حساب' : 'Create account';
  String get registerTitle => isArabic ? 'أنشئ حسابك' : 'Create your account';
  String get registerSubtitle => isArabic
      ? 'ابدأ بتنظيم يومك في دقائق قليلة.'
      : 'Start organizing your schedule in just a few steps.';
  String get loginTitle => isArabic ? 'أهلًا بعودتك' : 'Welcome back';
  String get loginSubtitle => isArabic
      ? 'ادخل للحساب لمتابعة مهامك.'
      : 'Sign in to continue managing your tasks.';

  // Fields
  String get fullName => isArabic ? 'الاسم الكامل' : 'Full name';
  String get email => isArabic ? 'البريد الإلكتروني' : 'Email address';
  String get phone => isArabic ? 'رقم الهاتف' : 'Phone number';
  String get password => isArabic ? 'كلمة المرور' : 'Password';
  String get confirmPassword =>
      isArabic ? 'تأكيد كلمة المرور' : 'Confirm password';
  String get oldPassword =>
      isArabic ? 'كلمة المرور الحالية' : 'Current password';
  String get newPassword => isArabic ? 'كلمة المرور الجديدة' : 'New password';
  String get repeatPassword =>
      isArabic ? 'أعد كتابة كلمة المرور' : 'Repeat new password';
  String get location => isArabic ? 'الموقع' : 'Location';
  String get bio => isArabic ? 'نبذة قصيرة' : 'Short bio';
  String get saveChanges => isArabic ? 'حفظ التغييرات' : 'Save changes';

  // Home
  String get homeTitle => isArabic ? 'مهامي' : 'My tasks';
  String get homeSubtitle => isArabic
      ? 'تابع يومك وركّز على الأهم.'
      : 'Stay on top of the day and focus on what matters.';
  String get todayFocus => isArabic ? 'ترتيب اليوم' : 'Today focus';
  String get totalTasks => isArabic ? 'إجمالي المهام' : 'Total tasks';
  String get activeTasks => isArabic ? 'قيد التنفيذ' : 'Active';
  String get doneTasks => isArabic ? 'المكتملة' : 'Done';
  String get highPriority => isArabic ? 'أولوية عالية' : 'High priority';

  // Tasks
  String get noTasksTitle =>
      isArabic ? 'لا توجد مهام حتى الآن' : 'There are no tasks yet';
  String get noTasksSubtitle => isArabic
      ? 'أضف أول مهمة وسيظهر كل شيء هنا بشكل مرتب.'
      : 'Add your first task and your board will come to life here.';
  String get addFirstTask => isArabic ? 'إضافة أول مهمة' : 'Add your first task';
  String get addTask => isArabic ? 'إضافة مهمة' : 'Add Task';
  String get editTask => isArabic ? 'تعديل المهمة' : 'Edit Task';
  String get taskTitle => isArabic ? 'عنوان المهمة' : 'Title';
  String get taskDescription => isArabic ? 'تفاصيل المهمة' : 'Description';
  String get taskCategory => isArabic ? 'التصنيف' : 'Category';
  String get taskPriority => isArabic ? 'الأولوية' : 'Priority';
  String get taskStatus => isArabic ? 'الحالة' : 'Status';
  String get taskDate => isArabic ? 'التاريخ' : 'Date';
  String get taskTime => isArabic ? 'الوقت' : 'Time';
  String get taskPreview => isArabic ? 'معاينة سريعة' : 'Quick preview';
  String get taskFormHint => isArabic
      ? 'أضف تفاصيل واضحة لتصبح المهمة أسهل في المتابعة.'
      : 'Add enough detail so the task is easy to follow later.';

  // Profile
  String get profile => isArabic ? 'الملف الشخصي' : 'Profile';
  String get profileSubtitle => isArabic
      ? 'تحكّم في بياناتك وإعداداتك.'
      : 'Manage your info and settings.';
  String get updateProfile => isArabic ? 'تعديل البيانات' : 'Edit profile';
  String get updateProfileSubtitle => isArabic
      ? 'حدّث اسمك وبريدك ومعلوماتك.'
      : 'Update your name, email and details.';
  String get changePassword =>
      isArabic ? 'تغيير كلمة المرور' : 'Change password';
  String get changePasswordSubtitle => isArabic
      ? 'غيّر كلمة المرور الحالية.'
      : 'Update your current password.';
  String get languageTitle => isArabic ? 'اللغة' : 'Language';
  String get languageSubtitle =>
      isArabic ? 'غيّر لغة التطبيق.' : 'Change app language.';
  String get languagePreview => isArabic
      ? 'سيتم تحديث العناوين والأزرار فورًا.'
      : 'Headings and buttons update instantly.';
  String get english => isArabic ? 'الإنجليزية' : 'English';
  String get arabic => isArabic ? 'العربية' : 'Arabic';

  // Messages
  String get logout => isArabic ? 'تسجيل الخروج' : 'Logout';
  String get demoHint =>
      isArabic ? 'حساب تجريبي: demo@todo.app / 123456' : 'Demo account: demo@todo.app / 123456';
  String get fillRequiredFields => isArabic
      ? 'من فضلك املأ الحقول المطلوبة.'
      : 'Please fill in the required fields.';
  String get shortPassword => isArabic
      ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل.'
      : 'Password must be at least 6 characters.';
  String get passwordsDoNotMatch =>
      isArabic ? 'كلمتا المرور غير متطابقتين.' : 'Passwords do not match.';
  String get incorrectCredentials => isArabic
      ? 'البريد الإلكتروني أو كلمة المرور غير صحيحة.'
      : 'The email or password is incorrect.';
  String get wrongCurrentPassword => isArabic
      ? 'كلمة المرور الحالية غير صحيحة.'
      : 'The current password is incorrect.';
  String get taskAddedMessage =>
      isArabic ? 'تمت إضافة المهمة بنجاح.' : 'Task added successfully.';
  String get taskUpdatedMessage =>
      isArabic ? 'تم تحديث المهمة بنجاح.' : 'Task updated successfully.';
  String get taskDeletedMessage =>
      isArabic ? 'تم حذف المهمة.' : 'Task deleted.';
  String get profileUpdatedMessage =>
      isArabic ? 'تم تحديث البيانات الشخصية.' : 'Profile updated successfully.';
  String get passwordUpdatedMessage =>
      isArabic ? 'تم تحديث كلمة المرور.' : 'Password updated successfully.';
  String get accountReadyMessage => isArabic
      ? 'الحساب جاهز واللوحة في انتظار مهامك.'
      : 'Your account is ready and the board is waiting for your tasks.';

  // Dialogs
  String get deleteTask => isArabic ? 'حذف المهمة' : 'Delete task';
  String get deleteDialogTitle =>
      isArabic ? 'حذف هذه المهمة؟' : 'Delete this task?';
  String get deleteDialogBody => isArabic
      ? 'لن تتمكن من استرجاعها بعد الحذف.'
      : 'You will not be able to restore it later.';
  String get cancel => isArabic ? 'إلغاء' : 'Cancel';
  String get delete => isArabic ? 'حذف' : 'Delete';
  String get done => isArabic ? 'تم' : 'Done';
  String get markProgress => isArabic ? 'تغيير الحالة' : 'Move task forward';

  // Enums
  String category(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return isArabic ? 'عمل' : 'Work';
      case TaskCategory.personal:
        return isArabic ? 'شخصي' : 'Personal';
      case TaskCategory.study:
        return isArabic ? 'دراسة' : 'Study';
    }
  }

  String priority(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return isArabic ? 'عالية' : 'High';
      case TaskPriority.medium:
        return isArabic ? 'متوسطة' : 'Medium';
      case TaskPriority.low:
        return isArabic ? 'منخفضة' : 'Low';
    }
  }

  String status(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return isArabic ? 'جديدة' : 'To do';
      case TaskStatus.inProgress:
        return isArabic ? 'قيد التنفيذ' : 'In progress';
      case TaskStatus.done:
        return isArabic ? 'مكتملة' : 'Completed';
    }
  }

  String filter(HomeFilter filter) {
    switch (filter) {
      case HomeFilter.all:
        return isArabic ? 'الكل' : 'All';
      case HomeFilter.active:
        return isArabic ? 'النشطة' : 'Active';
      case HomeFilter.completed:
        return isArabic ? 'المكتملة' : 'Completed';
    }
  }
}
