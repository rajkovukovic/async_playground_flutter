import 'package:async_playground_flutter/models/bank_statement.dart';
import 'package:async_playground_flutter/widgets/list_tile_with_price.dart';
import 'package:async_playground_flutter/widgets/sandwich_view.dart';
import 'package:flutter/material.dart';

/// Bank statement view is a stateless widget which is used to display
/// the bank statement details.
/// The balance on top with big letters and the list of expenses below it.
class BankStatementView extends StatelessWidget {
  final BankStatement bankStatement;

  const BankStatementView({super.key, required this.bankStatement});

  @override
  Widget build(BuildContext context) {
    return SandwichView.withList(
      header: ListTileWithPrice(
        title: 'Bank',
        price: bankStatement.balance,
        tileColor: Colors.deepPurple.shade100,
      ),
      items: bankStatement.expenses,
      itemBuilder: (context, expense, index) => ListTileWithPrice(
        title: expense.description,
        price: expense.amount,
        onTap: () {},
      ),
    );
  }
}
