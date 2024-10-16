import 'package:async_playground_flutter/mocks/mock_bank_statements.dart';
import 'package:async_playground_flutter/models/bank_statement.dart';
import 'package:async_playground_flutter/types/callback.dart';
import 'package:async_playground_flutter/utils/delays.dart';

class BankService {
  /// Returns the orders for the user (without items)
  static void getStatementCallback(
    String userId,
    Callback<BankStatement> callback,
  ) {
    Future.delayed(apiCallDuration(), () {
      callback(null, mockBankStatementsSubject.value[userId]);
    });
  }
}
