import 'package:async_playground_flutter/app.dart';
import 'package:async_playground_flutter/mocks/mock_bank_statements.dart';
import 'package:async_playground_flutter/mocks/mock_products.dart';
import 'package:flutter/material.dart';

void main() {
  initMockProductChanges();
  initMockBankExpensesGenerator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Async Playground',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}
