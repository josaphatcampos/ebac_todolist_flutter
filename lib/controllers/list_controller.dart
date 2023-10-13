import 'package:ebac_todolist/models/item.dart';
import 'package:flutter/cupertino.dart';

class ListController extends ValueNotifier<List<Item>> {
  List<Item> list = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ListController() : super([]);

  void addItem(
      {required String title, required String description, int id = 0}) {
    if (title.isNotEmpty && description.isNotEmpty) {
      final item = Item(
          id: _generateid(id),
          title: title,
          description: description,
          isDone: false);

      insertEdit(item);
    }
    _clearControllers();
    notifyListeners();
  }

  insertEdit(Item item) {
    final oldItem = list.where((element) => element.id == item.id).toList();

    if (oldItem.isEmpty) {
      list.add(item);
    } else {
      final index = list.indexOf(oldItem[0]);
      list.removeAt(index);
      list.insert(index, item);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    list.removeAt(index);
    notifyListeners();
  }

  int _generateid(int id) {
    if (id == 0) {
      return list.length > 0 ? list.last.id + 1 : list.length + 1;
    } else {
      return id;
    }
  }

  _clearControllers() {
    titleController.clear();
    descriptionController.clear();
  }
}
