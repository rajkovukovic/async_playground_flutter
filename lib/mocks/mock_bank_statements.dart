import 'package:async_playground_flutter/mocks/mock_orders.dart';
import 'package:async_playground_flutter/mocks/mock_users.dart';
import 'package:async_playground_flutter/models/bank_statement.dart';
import 'package:async_playground_flutter/models/expense.dart';
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
                  userId: user.id,
                  amount: order.total,
                  description: 'Order ${order.id}',
                  date: DateTime.now()
                      .subtract(const Duration(days: 1, minutes: 30))))
              .toList()),
    )
    .toList();
