import 'package:async_playground_flutter/utils/random_range.dart';

Duration apiCallDuration() => Duration(milliseconds: randomRangeInt(400, 1200));
Duration loginDuration() => Duration(milliseconds: randomRangeInt(300, 500));

Duration expenseGeneratorInterval() =>
    Duration(milliseconds: randomRangeInt(5000, 20000));

Duration productUpdateInterval() =>
    Duration(milliseconds: randomRangeInt(5000, 20000));
