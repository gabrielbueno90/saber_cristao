import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/app/app.dart';

void main() {
  testWidgets('renders splash title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SaberCristaoApp()));

    expect(find.text('Saber Cristao'), findsOneWidget);
  });
}
