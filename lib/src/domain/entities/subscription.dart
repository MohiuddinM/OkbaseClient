import 'dart:convert';

import 'package:okbase_client/src/domain/entities/query.dart';

class SubscriptionPriority {
  static const realtime = 0;
  static const high = 1;
  static const moderate = 2;
  static const low = 3;
}

class Subscription {
  final String id, userId, documentId;
  final int priority;
  final Query query;

  Subscription(this.id, this.userId, this.documentId, this.query, this.priority);

  factory Subscription.forDocument(id, userId, documentId, [priority = SubscriptionPriority.moderate]) {
    return Subscription(id, userId, documentId, null, priority);
  }

  factory Subscription.forQuery(id, userId, query, [priority = SubscriptionPriority.moderate]) {
    return Subscription(id, userId, null, query, priority);
  }

  factory Subscription.fromJson(Map<String, dynamic> map) {
    return Subscription(map['id'], map['userId'], map['documentId'], Query.fromJson(map['query']), map['priority']);
  }

  factory Subscription.fromJsonString(String json) => Subscription.fromJson(jsonDecode(json));


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['documentId'] = documentId;
    map['query'] = query.toJsonString();
    map['priority'] = priority;
    return map;
  }

  String toJsonString() => jsonEncode(toJson());
}