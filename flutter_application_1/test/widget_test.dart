import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('shows splash then welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());

    expect(find.byType(SplashLogo), findsOneWidget);
    expect(find.text('TODO'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Welcome To Do It !'), findsOneWidget);
    expect(find.text("Let's Start"), findsOneWidget);
  });
}
