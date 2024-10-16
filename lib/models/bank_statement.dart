import 'expense.dart';

/// BankStatement has id, userId, balance and list of expenses
class BankStatement {
  final String id;
  final String userId;
  final double balance;
  final List<Expense> expenses;

  BankStatement({
    required this.id,
    required this.userId,
    required this.balance,
    required this.expenses,
  });

  factory BankStatement.fromJson(Map<String, dynamic> json) {
    return BankStatement(
      id: json['id'],
      userId: json['userId'],
      balance: json['balance'],
      expenses: List<Expense>.from(
        json['expenses'].map((expense) => Expense.fromJson(expense)),
      ),
    );
  }
}
