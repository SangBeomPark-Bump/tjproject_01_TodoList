import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist_app_02/model/accounts.dart';
import 'package:todolist_app_02/model/large_todo.dart';
import 'package:todolist_app_02/model/small_todo.dart';
import 'package:todolist_app_02/vm/database_handler.dart';

class Insert extends StatefulWidget {
  const Insert({super.key});

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {


  final box = GetStorage();

  late String id;
  late DatabaseHandler handler;
  late List<Accounts> accounts;

  late TextEditingController largeTitleController;
  late TextEditingController smallTitleController;
  late int largeTodoSeq;
  late int hierarchy;

  late List<SmallTodo> smallTodoList;


  String? largeTodoTitle;

    @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    id = (box.read('id')) ?? '';
    largeTitleController = TextEditingController();
    smallTitleController = TextEditingController();

    largeTodoSeq = 0;
    hierarchy = 0;
    smallTodoList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: largeTitleController,
          decoration: const InputDecoration(
            label: Text("할 일을 입력하세요!")
          ),
          onSubmitted: (value) {
            largeTodoTitle = value;
            setState(() {});
          },
        )
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 600,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: smallTodoList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        listTabbed();
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Checkbox(
                              value: smallTodoList[index].checked, 
                              onChanged: (value){
                                smallTodoList[index].checked == value;
                                setState(() {});
                              }
                            ),
                            Text(
                              smallTodoList[index].title
                            ),
                            TextButton(
                              onPressed: (){
                                xButtonPressed();
                              }, 
                              child: const Text("X", style: TextStyle(color: Colors.red),)
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      upButtonPressed();
                    }, 
                    icon: Icon(Icons.arrow_upward)
                  ),
                  IconButton(
                    onPressed: (){
                      downButtonPressed();
                    }, 
                    icon: Icon(Icons.arrow_downward)
                  ),
                  IconButton(
                    onPressed: (){
                      editButtonPressed();
                    }, 
                    icon: Icon(Icons.edit)
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      timeButtonPressed();
                    }, 
                    icon: Icon(Icons.more_time)
                  ),
                  IconButton(
                    onPressed: (){
                      deleteButtonPressed();
                    }, 
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )
                  ),
                  IconButton(
                    onPressed: (){
                      returnButtonPressed();
                    }, 
                    icon: Icon(Icons.subdirectory_arrow_left_sharp)
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width-16,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 66,
                      child: TextField(
                        controller: smallTitleController,
                        decoration: InputDecoration(
                      
                          hoverColor: Colors.white
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        addButtonPressed();
                      }, 
                      icon: Icon(Icons.add)
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //F

  upButtonPressed(){
    
  }

  downButtonPressed(){

  }

  editButtonPressed(){

  }

  timeButtonPressed(){
    
  }

  deleteButtonPressed(){

  }

  returnButtonPressed()async{
    LargeTodo temp = LargeTodo(
      hierarchy: hierarchy, 
      id: id, 
      title: largeTitleController.text.trim(), 
      checked: false, 
      editTime: DateTime.now()
    );
    await handler.insertLargeTodo(temp);
    for(SmallTodo i in smallTodoList){
      await handler.insertSmallTodo(i);
    }
    Get.back();
    setState(() {});
  }


  addButtonPressed(){
    if (smallTitleController.text.trim().isNotEmpty){
      SmallTodo _new = SmallTodo(
        hierarchy: hierarchy, 
        id: id, 
        largeTodoSeq: largeTodoSeq, 
        title: smallTitleController.text.trim(), 
        checked: false
      );
      hierarchy +=1;

      smallTodoList.add(_new);
      setState(() {});
    }
  }

  xButtonPressed(){

  }

  listTabbed(){

  }

}//End