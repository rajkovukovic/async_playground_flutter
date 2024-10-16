import 'package:async_playground_flutter/models/order.dart';
import 'package:rxdart/rxdart.dart';

final mockBasketSubject = BehaviorSubject.seeded(<String, Order>{});
