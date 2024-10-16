import 'expense.dart';

/// BankStatement has id, userId, balance and list of expenses
class BankStatement {
  final String id;
  final String userId;
  final double balance;
  final List<Expense> expenses;

  BankStatement({
    String? id,
    required this.userId,
    required this.balance,
    required this.expenses,
  }) : id = id ?? 'statement_$userId';

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

  BankStatement copyWith({
    String? id,
    String? userId,
    double? balance,
    List<Expense>? expenses,
  }) {
    return BankStatement(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      expenses: expenses ?? this.expenses,
    );
  }
}
