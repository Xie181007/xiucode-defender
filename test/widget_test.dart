// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';
import 'package:xiucode_defender/main.dart';

void main() {
  testWidgets('XiuCode Defender smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const XiuCodeDefenderApp());
    expect(find.byType(XiuCodeDefenderApp), findsOneWidget);
  });
}
