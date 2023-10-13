
import 'dart:math';

import 'package:ebac_todolist/models/item.dart';
import 'package:flutter/cupertino.dart';


class ListController extends ValueNotifier<List<Item>>{
  List<Item> list = [];

  ListController() : super([]) ;

  void addItem(){
    int id = list.length + 1;
    final item = Item(id: id, title: "item $id", description: 'decrição', isDone: false);

    list.add(item);
    notifyListeners();
  }
}