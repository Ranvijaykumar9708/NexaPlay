import 'package:flutter_test/flutter_test.dart';
import 'package:nexaplay/main.dart';

void main() {
  testWidgets('NexaPlay app launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NexaPlayApp());
    expect(find.byType(NexaPlayApp), findsOneWidget);
  });
}
