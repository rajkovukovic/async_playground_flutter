import 'package:async_playground_flutter/models/bank_statement.dart';
import 'package:async_playground_flutter/widgets/list_tile_with_price.dart';
import 'package:async_playground_flutter/widgets/sandwich_view.dart';
import 'package:flutter/material.dart';

/// A stateless widget that displays bank statement details.
/// Shows the balance at the top and a list of expenses below.
class BankStatementView extends StatelessWidget {
  final BankStatement? bankStatement;
  final bool pending;

  const BankStatementView({
    super.key,
    required this.bankStatement,
    this.pending = false,
  });

  @override
  Widget build(BuildContext context) {
    return SandwichView.withList(
      header: ListTileWithPrice(
        title: 'Bank balance',
        price: bankStatement?.balance,
        tileColor: Colors.deepPurple.shade100,
        pending: pending,
      ),
      items: bankStatement?.expenses ?? [],
      itemBuilder: (context, expense, index) => ListTileWithPrice(
        title: expense.description,
        price: expense.amount,
        onTap: () {},
      ),
    );
  }
}
