import 'dart:convert';

import 'package:flutter/services.dart';
///
/// Created by Kanjiu Akuma on 8/27/2020.
///

import 'package:intl/intl.dart';

import '../models/models.dart' as Model;


class Locale {

  final DateFormat dateFormat, timeFormat;
  final Map<String, dynamic> monsters;

  Locale(this.dateFormat, this.timeFormat, this.monsters);

  String formatDate(DateTime date) {
    return dateFormat.format(date);
  }

  String formatTime(DateTime time) {
    return timeFormat.format(time);
  }

  String formatDateAndTime(DateTime date) {
    DateTime now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      // is today return only time
      return formatTime(date);
    }

    return '${formatDate(date)}: ${formatTime(date)}';
  }

  String formatBossId(Model.Boss boss) {
    assert(boss.version == monsters[boss.zoneId]['version'], 'Boss version mismatch');
    return monsters[boss.zoneId]['monsters'][boss.bossId];
  }

  String formatZoneId(Model.Boss boss) {
    assert(boss.version == monsters['${boss.zoneId}']['version'], 'Boss version mismatch');
    return monsters['${boss.zoneId}']['name'];
  }

  String formatDps(int dps) {
    if (1e9 < dps) {
      return (dps / 1e9).toStringAsFixed(2) + 'B/s';
    }
    else if (1e6 < dps) {
      return (dps / 1e6).toStringAsFixed(2) + 'M/s';
    }
    else if (1e3 < dps) {
      return (dps / 1e3).toStringAsFixed(2) + 'k/s';
    }
    else {
      return '$dps/s';
    }
  }

  String formatFightDuration(int fightDuration) {
    int seconds = fightDuration % 60;
    int minutes = fightDuration ~/ 60;
    if (minutes != 0) {
      return '$minutes:${seconds < 10 ? '0$seconds' : '$seconds'}';
    }
    return '$seconds sec';
  }

  static Future<Locale> fromName(String localeName) async {
    Map<String, dynamic> monsters = json.decode(await rootBundle.loadString('assets/data/monsters.json'));
    return Locale(DateFormat('MMM dd. yyyy'), DateFormat('HH:mm'), monsters);
  }

}