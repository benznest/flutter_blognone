import 'dart:convert';

import 'package:flutter/material.dart';

void printPrettyJson(Map map) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(map);
  debugPrint(pretty);
}

void printPrettyJsonList(List<Map> list) {
  for(Map map in list){
    printPrettyJson(map);
  }
}
