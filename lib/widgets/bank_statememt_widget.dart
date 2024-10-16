import 'package:async_playground_flutter/models/bank_statement.dart';
import 'package:flutter/material.dart';

/// Bank statement widget is a stateless widget which is used to display
/// the bank statement details.
/// The balance on top with big letters and the list of expenses below it.
class BankStatementWidget extends StatelessWidget {
  final BankStatement bankStatement;

  const BankStatementWidget({super.key, required this.bankStatement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Balance: ${bankStatement.balance}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            const Text(
              'Expenses:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            ListView(
              children: bankStatement.expenses
                  .map((expense) => ListTile(
                        title: Text(expense.description),
                        subtitle: Text(expense.amount.toString()),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
