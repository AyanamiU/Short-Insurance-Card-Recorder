import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:short_insurance_card/app/app.dart';

void main() {
  testWidgets('应用启动后显示记录与设置底栏', (WidgetTester tester) async {
    await tester.pumpWidget(const ShortInsuranceApp());
    await tester.pumpAndSettle();

    expect(find.text('记录'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
    expect(find.text('短险卡记录'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
