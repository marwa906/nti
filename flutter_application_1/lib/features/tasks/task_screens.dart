part of '../../main.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TodoStore store = context.store;
    final L10n t = context.t;
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (BuildContext context, TasksState state) {
        List<TaskItem> tasks = state.tasks;
        
        // فلترة المهام حسب البحث
        if (_searchQuery.isNotEmpty) {
          tasks = tasks.where((TaskItem task) {
            return task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   task.description.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();
        }

        final int completedTasks = state.tasks.where((TaskItem t) => t.status == TaskStatus.done).length;
        final int activeTasks = state.tasks.where((TaskItem t) => t.status != TaskStatus.done).length;
        final int highPriorityTasks = state.tasks.where((TaskItem t) => t.priority == TaskPriority.high && t.status != TaskStatus.done).length;

        return AppPageScaffold(
      floatingActionButton: _CircleAddButton(
        onTap: () => context.store.push(AppScreen.addTask),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const _HomeAvatar(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        t.isArabic ? 'مرحبًا!' : 'Hello!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withValues(alpha: 0.55),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        store.profile.fullName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                _HomePlusButton(
                  onTap: () => context.store.push(AppScreen.addTask),
                ),
              ],
            ),
            const SizedBox(height: 22),
            
            // إحصائيات المهام
            if (state.tasks.isNotEmpty) ...<Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: _StatCard(
                      icon: Icons.view_list_outlined,
                      label: t.isArabic ? 'إجمالي' : 'Total',
                      value: '${state.tasks.length}',
                      color: const Color(0xFF18A95D),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.hourglass_bottom,
                      label: t.isArabic ? 'قيد التنفيذ' : 'Active',
                      value: '$activeTasks',
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.check_circle_outline,
                      label: t.isArabic ? 'مكتملة' : 'Done',
                      value: '$completedTasks',
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              
              if (highPriorityTasks > 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE45858).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFE45858).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.warning_rounded, color: const Color(0xFFE45858), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          t.isArabic 
                            ? 'لديك $highPriorityTasks مهام ذات أولوية عالية'
                            : 'You have $highPriorityTasks high priority tasks',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE45858),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 18),
            ],
            
            // حقل البحث
            TextField(
              controller: _searchController,
              onChanged: (String value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: t.isArabic ? 'ابحث عن مهمة...' : 'Search for a task...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF18A95D)),
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFDCECE3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFDCECE3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF18A95D), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 18),
            
            if (state.tasks.isNotEmpty)
              Row(
                children: <Widget>[
                  Text(
                    t.isArabic ? 'المهام' : 'Tasks',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF18A95D).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF18A95D),
                      ),
                    ),
                  ),
                ],
              ),
            if (state.tasks.isNotEmpty) const SizedBox(height: 14),
            
            if (tasks.isEmpty && state.tasks.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    t.isArabic 
                      ? 'لم يتم العثور على نتائج'
                      : 'No results found',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.isEmpty && state.tasks.isEmpty ? 1 : tasks.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  if (tasks.isEmpty && state.tasks.isEmpty) {
                    return const _HomeEmptyState();
                  }
                  final TaskItem task = tasks[index];
                  return _HomeTaskTile(
                    task: task,
                    onTap: () => context.store.push(
                      AppScreen.editTask,
                      taskId: task.id,
                    ),
                  );
                },
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
        );
      },
    );
  }
}

class _HomeAvatar extends StatelessWidget {
  const _HomeAvatar();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Image.asset(
        flagIllustrationAsset,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _HomePlusButton extends StatelessWidget {
  const _HomePlusButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE6E6E6)),
        ),
        child: const Icon(Icons.add, size: 18, color: Colors.black),
      ),
    );
  }
}

class _CircleAddButton extends StatelessWidget {
  const _CircleAddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF18A95D),
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 54,
          height: 54,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeEmptyState extends StatelessWidget {
  const _HomeEmptyState();

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.t.isArabic;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          isArabic
              ? 'لا توجد مهام بعد،\nاضغط الزر لإضافة مهمة جديدة'
              : 'There are no tasks yet,\nPress the button\nto add New Task',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black.withValues(alpha: 0.6),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 190,
          child: Image.asset(emptyIllustrationAsset, fit: BoxFit.contain),
        ),
      ],
    );
  }
}

class _HomeTaskTile extends StatelessWidget {
  const _HomeTaskTile({required this.task, required this.onTap});

  final TaskItem task;
  final VoidCallback onTap;

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();
    return '$day/$month/$year';
  }

  String _formatTime(DateTime date) {
    int hour = date.hour;
    final int minute = date.minute;
    final bool pm = hour >= 12;
    hour = hour % 12;
    if (hour == 0) {
      hour = 12;
    }
    final String mm = minute.toString().padLeft(2, '0');
    return '${hour.toString().padLeft(2, '0')}:$mm ${pm ? 'PM' : 'AM'}';
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.high:
        return const Color(0xFFE45858);
      case TaskPriority.medium:
        return const Color(0xFFF5A623);
      case TaskPriority.low:
        return const Color(0xFF18A95D);
    }
  }

  String _getPriorityLabel() {
    switch (task.priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  IconData _getCategoryIcon() {
    switch (task.category) {
      case TaskCategory.work:
        return Icons.work_outline;
      case TaskCategory.personal:
        return Icons.person_outline;
      case TaskCategory.study:
        return Icons.school_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDone = task.status == TaskStatus.done;
    final Color priorityColor = _getPriorityColor();
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDone 
              ? Colors.grey.withValues(alpha: 0.1)
              : const Color(0xFFDFF4E8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: priorityColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    task.title.isEmpty ? 'My First Task' : task.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDone 
                          ? Colors.black.withValues(alpha: 0.4)
                          : Colors.black,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getPriorityLabel(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: priorityColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withValues(alpha: isDone ? 0.3 : 0.65),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(_getCategoryIcon(), size: 14, color: const Color(0xFF18A95D)),
                    const SizedBox(width: 4),
                    Text(
                      task.category.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.access_time, size: 12, color: Colors.black.withValues(alpha: 0.4)),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(task.dueAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TaskEditorScreen extends StatefulWidget {
  const TaskEditorScreen({super.key, this.task});

  final TaskItem? task;

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _PriorityButton({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.14) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? color : const Color(0xFFDCECE3),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isSelected ? color : const Color(0xFF143B2F),
              ),
            ),
          ),
        ),
      ),
    );
  }

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late TaskStatus _status;
  late TaskCategory _category;
  late TaskPriority _priority;

  bool get isEditing => widget.task != null;

  String get _categoryValue {
    return switch (_category) {
      TaskCategory.work => 'Work',
      TaskCategory.personal => 'Personal',
      TaskCategory.study => 'Home',
    };
  }

  @override
  void initState() {
    super.initState();
    final DateTime initialDate =
        widget.task?.dueAt ?? DateTime.now().add(const Duration(hours: 3));
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _selectedDate = DateTime(
      initialDate.year,
      initialDate.month,
      initialDate.day,
    );
    _selectedTime = TimeOfDay.fromDateTime(initialDate);
    _status = widget.task?.status ?? TaskStatus.todo;
    _category = widget.task?.category ?? TaskCategory.personal;
    _priority = widget.task?.priority ?? TaskPriority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime initialDate = _selectedDate;
    final DateTime firstDate = DateTime.now().subtract(
      const Duration(days: 365),
    );
    final DateTime lastDate = DateTime.now().add(const Duration(days: 365 * 3));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (!mounted || picked == null) {
      return;
    }
    setState(() {
      _selectedDate = DateTime(picked.year, picked.month, picked.day);
    });
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (!mounted || picked == null) {
      return;
    }
    setState(() {
      _selectedTime = picked;
    });
  }

  Future<void> _deleteTask() async {
    final L10n t = context.t;
    final String errorMessage = t.isArabic
        ? 'حدث خطأ. حاول مرة أخرى.'
        : 'Something went wrong. Please try again.';
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(t.deleteDialogTitle),
          content: Text(t.deleteDialogBody),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(t.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE45858),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(t.delete),
            ),
          ],
        );
      },
    );
    if (!mounted || shouldDelete != true || widget.task == null) {
      return;
    }
    final bool ok = await context.store.deleteTask(widget.task!.id);
    if (!mounted) {
      return;
    }
    context.showMessage(ok ? t.taskDeletedMessage : errorMessage);
  }

  Future<void> _submit() async {
    final L10n t = context.t;
    final String errorMessage = t.isArabic
        ? 'حدث خطأ. حاول مرة أخرى.'
        : 'Something went wrong. Please try again.';
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final TaskDraft draft = TaskDraft(
      title: _titleController.text,
      description: _descriptionController.text,
      category: _category,
      priority: _priority,
      status: _status,
      dueAt: combineDateAndTime(_selectedDate, _selectedTime),
    );

    if (isEditing) {
      final bool ok = await context.store.updateTask(widget.task!.id, draft);
      if (!mounted) {
        return;
      }
      context.showMessage(ok ? t.taskUpdatedMessage : errorMessage);
      return;
    }

    final bool ok = await context.store.addTask(draft);
    if (!mounted) {
      return;
    }
    context.showMessage(ok ? t.taskAddedMessage : errorMessage);
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
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: context.store.pop,
                    borderRadius: BorderRadius.circular(999),
                    child: const SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      isEditing ? 'Edit Task' : 'Add Task',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (isEditing)
                    _DeletePill(onTap: () => unawaited(_deleteTask()))
                  else
                    const SizedBox(width: 72),
                ],
              ),
              const SizedBox(height: 16),
              if (!isEditing) ...<Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    flagIllustrationAsset,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 14),
              ] else ...<Widget>[
                Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Image.asset(
                        flagIllustrationAsset,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _status == TaskStatus.done ? 'Done' : 'In Progress',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _status == TaskStatus.done
                                ? 'Congrats!'
                                : "Believe you can, and you're halfway there.",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
              _FormFieldContainer(
                child: DropdownButtonFormField<String>(
                  initialValue: _categoryValue,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: <String>['Home', 'Personal', 'Work']
                      .map(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                switch (value) {
                                  'Work' => Icons.work_outline_rounded,
                                  'Personal' => Icons.person_outline_rounded,
                                  _ => Icons.home_rounded,
                                },
                                size: 18,
                                color: value == 'Home'
                                    ? const Color(0xFFFF4DB8)
                                    : (value == 'Personal'
                                          ? const Color(0xFF18A95D)
                                          : Colors.black),
                              ),
                              const SizedBox(width: 10),
                              Text(value, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _category = switch (value) {
                        'Work' => TaskCategory.work,
                        'Personal' => TaskCategory.personal,
                        _ => TaskCategory.study,
                      };
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Priority Level',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  _PriorityButton(
                    label: 'Low',
                    color: const Color(0xFF18A95D),
                    isSelected: _priority == TaskPriority.low,
                    onTap: () {
                      setState(() {
                        _priority = TaskPriority.low;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _PriorityButton(
                    label: 'Medium',
                    color: const Color(0xFFF5A623),
                    isSelected: _priority == TaskPriority.medium,
                    onTap: () {
                      setState(() {
                        _priority = TaskPriority.medium;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _PriorityButton(
                    label: 'High',
                    color: const Color(0xFFE45858),
                    isSelected: _priority == TaskPriority.high,
                    onTap: () {
                      setState(() {
                        _priority = TaskPriority.high;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _FormFieldContainer(
                child: DropdownButtonFormField<String>(
                  initialValue: _categoryValue,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: <String>['Home', 'Personal', 'Work']
                      .map(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                switch (value) {
                                  'Work' => Icons.work_outline_rounded,
                                  'Personal' => Icons.person_outline_rounded,
                                  _ => Icons.home_rounded,
                                },
                                size: 18,
                                color: value == 'Home'
                                    ? const Color(0xFFFF4DB8)
                                    : (value == 'Personal'
                                          ? const Color(0xFF18A95D)
                                          : Colors.black),
                              ),
                              const SizedBox(width: 10),
                              Text(value, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _category = switch (value) {
                        'Work' => TaskCategory.work,
                        'Personal' => TaskCategory.personal,
                        _ => TaskCategory.study,
                      };
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              _FormFieldContainer(
                child: TextFormField(
                  controller: _titleController,
                  validator: (String? value) =>
                      (value == null || value.trim().isEmpty)
                      ? t.fillRequiredFields
                      : null,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _FormFieldContainer(
                child: TextFormField(
                  controller: _descriptionController,
                  validator: (String? value) =>
                      (value == null || value.trim().isEmpty)
                      ? t.fillRequiredFields
                      : null,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _FormFieldContainer(
                onTap: () => unawaited(_pickDate().then((_) => _pickTime())),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Color(0xFF18A95D),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${formatLongDate(_selectedDate, t.language)}    ${formatClock(_selectedTime, t.language)}',
                      style: const TextStyle(fontSize: 11, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (!isEditing) ...<Widget>[
                SizedBox(
                  height: 46,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF18A95D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => unawaited(_submit()),
                    child: const Text(
                      'Add Task',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ] else ...<Widget>[
                SizedBox(
                  height: 46,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF18A95D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _status = TaskStatus.done;
                      });
                      unawaited(_submit());
                    },
                    child: const Text(
                      'Mark as Done',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF18A95D),
                      side: const BorderSide(color: Color(0xFF18A95D)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => unawaited(_submit()),
                    child: const Text('Update'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FormFieldContainer extends StatelessWidget {
  const _FormFieldContainer({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content = Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: content,
    );
  }
}

class _DeletePill extends StatelessWidget {
  const _DeletePill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE64545),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.delete_outline_rounded, size: 16, color: Colors.white),
            SizedBox(width: 6),
            Text(
              'Delete',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
