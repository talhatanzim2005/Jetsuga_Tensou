import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon/main.dart';

void main() {
  testWidgets('CampusOSApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusOSApp());
    expect(find.text('CampusOS Design System'), findsOneWidget);
  });
}
