import 'package:earthquake/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EarthquakeApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EarthquakeApp());
    expect(find.byType(EarthquakeApp), findsOneWidget);
  });
}
