import 'dart:async';

import 'package:async_playground_flutter/mocks/mock_orders.dart';
import 'package:async_playground_flutter/mocks/mock_users.dart';
import 'package:async_playground_flutter/models/bank_statement.dart';
import 'package:async_playground_flutter/models/expense.dart';
import 'package:async_playground_flutter/utils/constants.dart';
import 'package:async_playground_flutter/utils/list_extension.dart';
import 'package:rxdart/rxdart.dart';

final mockBalances = {
  '1': 1000.0,
  '2': 2000.0,
};

final mockBankStatementsSubject = BehaviorSubject.seeded(_mockBankStatements);

final _mockBankStatements = mockUsers
    .map(
      (user) => BankStatement(
          id: 'statement_${user.id}',
          userId: user.id,
          balance: mockBalances[user.id] ?? 0,
          expenses: mockOrdersSubject.value
              .where((order) => order.userId == user.id)
              .map((order) => Expense(
                  id: 'expense_${order.id}',
                  amount: order.total,
                  description: 'Order ${order.id}',
                  date: DateTime.now()
                      .subtract(const Duration(days: 1, minutes: 30))))
              .toList()),
    )
    .toList();

/// periodically add a new expense to each user
final mockBankStatementsUpdater = Timer.periodic(
  expenseGeneratorInterval,
  (timer) {
    final updatedStatements = _mockBankStatements.map((statement) {
      final newExpense = _usualExpenses.randomElement;
      return statement.copyWith(expenses: [...statement.expenses, newExpense]);
    }).toList();
    mockBankStatementsSubject.add(updatedStatements);
  },
);

final _usualExpenses = [
  Expense(
    id: 'parking',
    amount: 2,
    description: 'Parking Fee',
    date: DateTime.now(),
  ),
  Expense(
    id: 'Coffee',
    amount: 3,
    description: 'Cup of Coffee',
    date: DateTime.now(),
  ),
  Expense(
    id: 'snacks',
    amount: 1,
    description: 'Snacks',
    date: DateTime.now(),
  ),
  Expense(
    id: 'lunch',
    amount: 10,
    description: 'Lunch',
    date: DateTime.now(),
  ),
  Expense(
    id: 'dinner',
    amount: 20,
    description: 'Dinner',
    date: DateTime.now(),
  ),
  Expense(
    id: 'groceries',
    amount: 50,
    description: 'Groceries',
    date: DateTime.now(),
  ),
  Expense(
    id: 'fuel',
    amount: 40,
    description: 'Fuel',
    date: DateTime.now(),
  ),
  Expense(
    id: 'clothes',
    amount: 100,
    description: 'Clothes',
    date: DateTime.now(),
  ),
  Expense(
    id: 'shoes',
    amount: 80,
    description: 'Shoes',
    date: DateTime.now(),
  ),
];
