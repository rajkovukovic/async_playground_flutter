/// Expense model has id, userId, amount, description and date
class Expense {
  final String id;
  final double amount;
  final String description;
  final DateTime date;

  Expense({
    String? id,
    required this.amount,
    required this.description,
    required this.date,
  }) : id = id ?? 'expense_${++_counter}';

  static var _counter = 0;
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: json['amount'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }

  /// makes a clone with new id
  clone() => Expense(
        amount: amount,
        description: description,
        date: date,
      );
}
