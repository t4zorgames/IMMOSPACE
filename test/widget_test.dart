import 'package:flutter_test/flutter_test.dart';
import 'package:immospace/main.dart';

void main() {
  testWidgets('ImmoSpace app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ImmoSpaceApp());

    // Verify that the HomeScreen renders.
    expect(find.text('ImmoSpace'), findsWidgets);
  });
}
