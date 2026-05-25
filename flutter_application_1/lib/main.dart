import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/auth/cubit/login_cubit.dart';
import 'features/tasks/cubit/tasks_cubit.dart';
import 'models/models.dart';
import 'state/todo_store.dart';
import 'utils/colors.dart';
import 'utils/formatters.dart';
import 'utils/l10n.dart';
import 'utils/theme.dart';

part 'app/todo_scope.dart';
part 'app/todo_app.dart';
part 'features/auth/auth_screens.dart';
part 'features/profile/profile_screens.dart';
part 'features/tasks/task_screens.dart';
part 'ui/components.dart';
part 'ui/page_scaffold.dart';
part 'ui/painters.dart';
