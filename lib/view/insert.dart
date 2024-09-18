import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist_app_02/model/accounts.dart';
import 'package:todolist_app_02/model/large_todo.dart';
import 'package:todolist_app_02/model/small_todo.dart';
import 'package:todolist_app_02/view/home.dart';
import 'package:todolist_app_02/view/time_change.dart';
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
  late int largeHierarchy;

  late int smallHierarchy;

  DateTime? stDateTime;
  DateTime? fnDateTime;

  late List<SmallTodo> smallTodoList;

  int? selected;


  String? largeTodoTitle;

    @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    id = (box.read('id')) ?? '';
    largeTodoSeq = box.read('largeSeq');
    print(largeTodoSeq);
    largeTitleController = TextEditingController();
    smallTitleController = TextEditingController();
    largeHierarchy = box.read('insertLargeHi');
    print("Insert Page , hi: $largeHierarchy");
    smallTodoList = [];
    smallHierarchy = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextField(
            controller: largeTitleController,
            decoration: InputDecoration(
              label: const Text(" 할일 이름을 입력해보세요! ")
            ),
          ),
          leading: IconButton(
            onPressed: (){
              box.remove('stDateTime');
              box.remove('fnDateTime');
              Get.off(() => const Home());
            }, 
            icon: Icon(Icons.arrow_back_ios)
          ),
        ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: timeText()
              ),
              SizedBox(
                height: 500,
                width: MediaQuery.of(context).size.width-8,
                child: ListView.builder(
                  itemCount: smallTodoList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        listTabbed(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: 
                          index == selected
                            ?Border.all(
                              width: 2,
                              color: Colors.red
                            )
                            :null
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: Checkbox(
                                value: smallTodoList[index].checked, 
                                onChanged: (value){
                                  smallTodoList[index].checked == value;
                                  setState(() {});
                                }
                              ),
                            ),
                            SizedBox(
                              width:MediaQuery.of(context).size.width - 112,
                              child: Text(
                                smallTodoList[index].title
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextButton(
                                onPressed: (){
                                  xButtonPressed(index);
                                }, 
                                child: const Text("X", style: TextStyle(color: Colors.red),)
                              ),
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
                        if (selected != null){
                        upButtonPressed(selected!);}
                      }, 
                    icon: Icon(Icons.arrow_upward)
                  ),
                  IconButton(
                    onPressed: (){
                        if (selected != null){
                        downButtonPressed(selected!);}
                      }, 
                    icon: Icon(Icons.arrow_downward)
                  ),
                  IconButton(
                    onPressed: (){
                        if(selected != null){
                        editButtonPressed(selected!);}
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

  upButtonPressed(int index){
    if(index != 0){
      SmallTodo temp = smallTodoList[index-1];
      smallTodoList[index-1] = smallTodoList[index];
      smallTodoList[index] = temp;


      setState(() {});
    }
  }

void downButtonPressed(int index) {
  if (index != smallTodoList.length - 1) {
    // 인덱스를 하나 내리는 방향으로 스왑
    SmallTodo temp = smallTodoList[index + 1];

    smallTodoList[index + 1] = smallTodoList[index];
    smallTodoList[index] = temp;

    setState(() {});
  }
}

  editButtonPressed(int index){
    TextEditingController editcontroller = TextEditingController();
    editcontroller.text = smallTodoList[index].title;
    Get.defaultDialog(
      title: "수정하기",
      barrierDismissible: false,
      content: TextField(
        controller: editcontroller,
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            if(editcontroller.text.trim().isNotEmpty){
              smallTodoList[index].title = editcontroller.text.trim();
            }
            Get.back();
            setState(() {});
          }, 
          child: const Text("수정")
        ),
        ElevatedButton(
          onPressed: (){
            Get.back();
          }, 
          child: const Text("취소")
        )
      ]
    );
  }

  timeButtonPressed(){

    if(stDateTime != null){
      box.write('stDateTime', stDateTime.toString());
    }
    if(fnDateTime != null){
      box.write('fnDateTime', fnDateTime.toString());
    }

    Get.to(() => TimeChange())!.then(
      (value) {
        String? stDateString = box.read('stDateTime');
        String? fnDateString = box.read('fnDateTime');

        stDateTime = stDateString ==null ? null : DateTime.parse(stDateString); 
        fnDateTime = fnDateString ==null ? null : DateTime.parse(fnDateString);
        print(stDateTime);
        print(fnDateTime);
        setState(() {});
      },
    );
  }

  returnButtonPressed()async{
    LargeTodo temp = LargeTodo(
      hierarchy: largeHierarchy, 
      id: id, 
      title: largeTitleController.text.trim(), 
      checked: false, 
      editTime: DateTime.now(),
      stTime: stDateTime,
      fnTime: fnDateTime,
    );
    await handler.insertLargeTodo(temp);
    smallTodoList.asMap().forEach((index, smallTodo)
      {
        smallTodo.hierarchy = index;
        handler.insertSmallTodo(smallTodo);
      }
    );

    
    box.remove('stDateTime');
    box.remove('fnDateTime');

    Get.off(() => const Home());
    setState(() {});
  }


  addButtonPressed(){
    if (smallTitleController.text.trim().isNotEmpty){
      print(largeTodoSeq);
      SmallTodo _new = SmallTodo(
        hierarchy: smallHierarchy, 
        id: id, 
        largeTodoSeq: largeTodoSeq, 
        title: smallTitleController.text.trim(), 
        checked: false
      );
      smallHierarchy +=1;

      smallTodoList.add(_new);
      setState(() {});
      smallTitleController.clear();
    }
  }

  listTabbed(int index){
    if(index != selected){
      selected = index;
    }else{
      selected = null;
    }
    setState(() {});
  }


  xButtonPressed(index){    
    SmallTodo temp = smallTodoList[index];
    temp.rmTime = DateTime.now();
    temp.hierarchy = -1;
    smallTodoList.removeAt(index);
    setState(() {});
  }


  Text timeText(){
    String stresult = stDateTime == null ?'     ' : stDateTime.toString().substring(11, 16);
    String fnresult = fnDateTime == null ?'     ' : fnDateTime.toString().substring(11, 16);

    String resultText = stDateTime == null && fnDateTime == null
                        ?"하루 종일"
                        :"$stresult  ~  $fnresult";
    return Text(
      resultText,
      style: TextStyle(
        fontSize: 20
      )
      );
  }


}//End