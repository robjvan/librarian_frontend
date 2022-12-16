// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

@immutable
abstract class Entity<T> {
  Entity();
  Entity<T> copyWith();
  bool get isValid;
  bool get isNotValid;
  Entity.fromJson(final Map<String, dynamic> json);
  Map<String, dynamic> toJson();
  Entity.createEmpty();

  static bool? parseJsonBool(final dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return null;
  }

  static DateTime? parseJsonDate(final dynamic value) {
    if (value is DateTime) return value;
    if (value is num) return DateTime.fromMillisecondsSinceEpoch(value as int);
    if (value is String) return DateTime.parse(value);
    return null;
  }

  static num? parseJsonNum(final dynamic value) {
    if (value is num) return value;
    if (value is String) return num.parse(value);
    if (value is bool) return value ? 1 : 0;
    return null;
  }

  static double? parseJsonDouble(final dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    if (value is bool) return value ? 1.0 : 0.0;
    return null;
  }

  static int? parseJsonInt(final dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.parse(value);
    if (value is bool) return value ? 1 : 0;
    return null;
  }

  static String? asString(final dynamic value) => value?.toString();
}
