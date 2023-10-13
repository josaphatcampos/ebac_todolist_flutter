import 'package:ebac_todolist/controllers/list_controller.dart';
import 'package:ebac_todolist/models/item.dart';
import 'package:flutter/material.dart';

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


  Future<dynamic> callDialog(BuildContext context, {Item? item}){

    return Future(() => null);
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
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: item.isDone,
                title: Text(item.title),
                subtitle: Text(item.description),
                secondary: Container(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.edit),
                        onTap: () {
                          callDialog(context, item: item);
                        },
                      ),
                      GestureDetector(
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onTap: () {
                          debugPrint('delete $index');
                        },
                      ),
                    ],
                  ),
                ),
                onChanged: (bool? value) {},
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          callDialog(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
