import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyber_portfolio/main.dart';

void main() {
  testWidgets('Portfolio smoke test', (WidgetTester tester) async {
    // Build our app inside a ProviderScope since we use Riverpod state management
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that our app initializes the framework without throwing a crash
    expect(find.byType(ProviderScope), findsOneWidget);
  });
}
