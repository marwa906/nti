import 'app_enums.dart';

class AppRouteState {
  const AppRouteState(this.screen, {this.taskId});

  final AppScreen screen;
  final String? taskId;
}
