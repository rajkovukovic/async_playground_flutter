import 'package:async_playground_flutter/mocks/mock_bank_statements.dart';
import 'package:async_playground_flutter/models/bank_statement.dart';
import 'package:async_playground_flutter/models/coming_soon.dart';
import 'package:async_playground_flutter/utils/delays.dart';

class BankService {
  static ComingSoon<BankStatement> getStatementCallback(String userId) {
    return ComingSoon<BankStatement>((resolve, reject) {
      // Simulate the delay for an API call
      Future.delayed(apiCallDuration(), () {
        final statement = mockBankStatementsSubject.value[userId];
        if (statement != null) {
          resolve(statement);
        } else {
          reject('Statement not found for user: $userId');
        }
      });
    });
  }
}
