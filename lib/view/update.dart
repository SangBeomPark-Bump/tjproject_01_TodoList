import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist_app_02/model/large_todo.dart';
import 'package:todolist_app_02/model/small_todo.dart';
import 'package:todolist_app_02/vm/database_handler.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

  final box = GetStorage();
  LargeTodo? curLargeTodo;
  List<SmallTodo>? curSmallTodoList;
  late int seq;
  late DatabaseHandler handler;

  late TextEditingController titleController;
  late TextEditingController smallTodoController;
  

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    titleController = TextEditingController();
    smallTodoController = TextEditingController();
    seq = box.read("largeSeq");
    print(seq);
    dataLoader();
    
  }

  dataLoader()async{
    List<LargeTodo> curLargeTodo_list = await handler.queryLargeTodoBySeq(seq);
    curLargeTodo = curLargeTodo_list[0];
    // curSmallTodoList = await handler.querySmallTodoByLargeTodoSeq(seq);
    curSmallTodoList = await handler.querySmallTodoByLargeTodoSeq(seq);
    titleController.text = curLargeTodo!.title;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: curLargeTodo != null
        ?AppBar(
          title: TextField(
            controller: titleController,
          ),
        )
        :null
      ,body: curSmallTodoList == null
      ? CircularProgressIndicator()
      : ListView.builder(
        itemCount: curSmallTodoList!.length,
        itemBuilder: (context, index) {
          return Card(
            child: Text(
              curSmallTodoList![index].title
            ),
          );
        },
      )
    );
  }
}