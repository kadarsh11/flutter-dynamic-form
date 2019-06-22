import 'package:flutter/material.dart';

List chunkList({@required List array, @required int size}) {
  List result = [];
  if (array.isEmpty || size <= 0) {
    return result;
  }
  int first = 0;
  int last = size;
  int totalLoop = array.length % size == 0
      ? array.length ~/ size
      : array.length ~/ size + 1;
  for (int i = 0; i < totalLoop; i++) {
    if (last > array.length) {
      result.add(array.sublist(first, array.length));
    } else {
      result.add(array.sublist(first, last));
    }
    first = last;
    last = last + size;
  }
  return result;
}

List<List<Widget>> chunkWidgets(
    {@required List<Widget> array, @required int size}) {
  List<List<Widget>> result = [];
  if (array.isEmpty || size <= 0) {
    return result;
  }
  int first = 0;
  int last = size;
  int totalLoop = array.length % size == 0
      ? array.length ~/ size
      : array.length ~/ size + 1;
  for (int i = 0; i < totalLoop; i++) {
    if (last > array.length) {
      result.add(array.sublist(first, array.length));
    } else {
      result.add(array.sublist(first, last));
    }
    first = last;
    last = last + size;
  }
  return result;
}
