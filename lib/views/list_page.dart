import 'package:ebac_todolist/controllers/list_controller.dart';
import 'package:ebac_todolist/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});

  final String title;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late ListController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ListController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<dynamic> callDialog(BuildContext context, {Item? item}) {
    if (item != null) {
      _controller.titleController.text = item!.title;
      _controller.descriptionController.text = item!.description;
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text("To Do")),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller.titleController,
                decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    label: Text("Título"),
                    hintText: 'Titulo',
                    hintStyle:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _controller.descriptionController,
                decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    label: Text("Descrição"),
                    hintText: 'Descrição',
                    hintStyle:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
              )
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          int id = item != null ? item!.id : 0;
                          _controller.addItem(
                              title: _controller.titleController.text,
                              description:
                                  _controller.descriptionController.text,
                              id: id);
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.check,
                          color: Colors.red,
                          size: 32,
                        ))),
              ],
            )
          ],
          contentPadding: const EdgeInsets.all(16),
          actionsOverflowButtonSpacing: 50,
          titlePadding: const EdgeInsets.only(top: 32, bottom: 16),
          titleTextStyle: const TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24),
        );
      },
    );
  }

  Future<bool?> _canDelete(BuildContext context, Item item)async{

    return await showDialog(context: context, builder:(context) {
      return AlertDialog(
        title: const Center(child: Text("Deletar")),
        content:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Tem certeza que deseja deletar o registro ${item.title}?")
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Deletar", style: TextStyle(color: Colors.red),))),
              Expanded(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("Cancel", style: TextStyle(color: Colors.red),))),
            ],
          )
        ],
        contentPadding: const EdgeInsets.all(16),
        actionsOverflowButtonSpacing: 50,
        titlePadding: const EdgeInsets.only(top: 32, bottom: 16),
        titleTextStyle: const TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24),
      );
    },);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return ListView.builder(
            itemCount: _controller.list.length,
            itemBuilder: (context, index) {
              Item item = _controller.list[index];
              return Column(
                children: [
                  Slidable(
                    key: Key(item.toString()),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      dismissible: DismissiblePane(
                        closeOnCancel: true,
                        confirmDismiss: () async {
                          return await _canDelete(context, item) ?? false;
                        },
                        onDismissed: (){
                          _controller.removeItem(index);
                        },
                      ),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            callDialog(context, item: item);
                          },
                          backgroundColor: Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Editar',
                        ),
                        SlidableAction(
                          onPressed: (context)async{
                            bool? remover = await _canDelete(context, item);
                            if(remover == true){
                              _controller.removeItem(index);
                            }
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    startActionPane: ActionPane(
                      dismissible: DismissiblePane(
                        closeOnCancel: true,
                        confirmDismiss: () async {
                          return await _canDelete(context, item) ?? false;
                        },
                        onDismissed: (){
                          _controller.removeItem(index);
                        },
                      ),
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context)async{
                            bool? remover = await _canDelete(context, item);
                            if(remover == true){
                              _controller.removeItem(index);
                            }
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: item.isDone,
                      title: Text(
                        item.title,
                        style: TextStyle(
                            decoration: item.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            fontWeight: FontWeight.bold, color: item.isDone ? Colors.red:Colors.black),
                      ),
                      subtitle: Text(item.description,
                          style: TextStyle(
                              decoration: item.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,  color: item.isDone ? Colors.red:Colors.black)),
                      // secondary: Container(
                      //   width: 80,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       GestureDetector(
                      //         child: const Icon(Icons.edit),
                      //         onTap: () {
                      //           callDialog(context, item: item);
                      //         },
                      //       ),
                      //       GestureDetector(
                      //         child: const Icon(
                      //           Icons.delete,
                      //           color: Colors.red,
                      //         ),
                      //         onTap: () async {
                      //           bool? remover = await _canDelete(context, item);
                      //           if(remover == true){
                      //             _controller.removeItem(index);
                      //           }
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      onChanged: (value) {
                        _controller.insertEdit(Item(
                            id: item.id,
                            title: item.title,
                            description: item.description,
                            isDone: value ?? false));
                      },
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.withOpacity(0.2),)
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          callDialog(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
