import 'dart:convert';

import 'package:equatable/equatable.dart';

class QueryCondition extends Equatable {
  final String attribute, relation;
  final dynamic target;

  const QueryCondition(this.attribute, this.relation, this.target);

  factory QueryCondition.fromJson(Map<String, dynamic> map) {
    return QueryCondition(map['attribute'], map['relation'], map['target']);
  }

  factory QueryCondition.fromJsonString(String json) => QueryCondition.fromJson(jsonDecode(json));

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['attribute'] = attribute;
    map['relation'] = relation;
    map['target'] = target;
    return map;
  }

  String toJsonString() => jsonEncode(toJson());

  @override
  List<Object> get props => [attribute, relation, target];
}

class Query extends Equatable {
  final String _collection;
  final List<QueryCondition> _conditions = <QueryCondition>[];

  Query(String collection) : _collection = collection;

  factory Query.fromJson(Map<String, dynamic> map) {
    final query = Query(map['collection']);
    (jsonDecode(map['conditions']) as List).map((c) => query._conditions.add(QueryCondition.fromJson(map)));
    return query;
  }

  factory Query.fromJsonString(String json) => Query.fromJson(jsonDecode(json));

  void where(String attribute, String relation, dynamic target) {
    _conditions.add(QueryCondition(attribute, relation, target));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['collection'] = _collection;
    map['conditions'] = _conditions.map((condition) => condition.toJsonString()).toList();
    return map;
  }

  String toJsonString() => jsonEncode(toJson());

  @override
  // TODO: implement props
  List<Object> get props => [_collection, _conditions];
}
