import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist_app_02/model/large_todo.dart';
import 'package:todolist_app_02/model/small_todo.dart';
import 'package:todolist_app_02/view/home.dart';
import 'package:todolist_app_02/view/time_change.dart';
import 'package:todolist_app_02/vm/database_handler.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

  final box = GetStorage();

  late String id;

  LargeTodo? curLargeTodo;
  late List<SmallTodo> curSmallTodoList;
  late int smallHierarchy;


  late int largeTodoSeq;
  late DatabaseHandler handler;

  late TextEditingController titleController;
  late TextEditingController smallTitleController;

  DateTime? stDateTime;
  DateTime? fnDateTime;
  
  late double todoWidth;
  late double todoheight;
  late bool sizeSet;

  int? selected;


  late List<SmallTodo> _removedSmallTodoList;


  @override
  void initState() {
    super.initState();
    sizeSet = false;
    handler = DatabaseHandler();
    titleController = TextEditingController();
    smallTitleController = TextEditingController();
    largeTodoSeq = box.read("largeSeq");
    id = box.read('id');

    curSmallTodoList = [];
    _removedSmallTodoList = [];

    print(largeTodoSeq);
    dataLoader();
    
  }

  dataLoader()async{
    List<LargeTodo> curLargeTodo_list = await handler.queryLargeTodoBySeq(largeTodoSeq);
    curLargeTodo = curLargeTodo_list[0];

    stDateTime = curLargeTodo!.stTime;
    fnDateTime = curLargeTodo!.fnTime;

    print('불러올때 st: $stDateTime');
    print('불러올때 fn: $fnDateTime');
    
    // curSmallTodoList = await handler.querySmallTodoByLargeTodoSeq(seq);
    curSmallTodoList = await handler.querySmallTodoByLargeTodoSeq(largeTodoSeq);

    smallHierarchy = curSmallTodoList.length; 


    titleController.text = curLargeTodo!.title;





    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!sizeSet){
      sizeSet = true;
      todoheight = MediaQuery.of(context).size.height * 0.05;
      todoWidth = MediaQuery.of(context).size.width-16;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: curLargeTodo != null
        ?AppBar(
          title: TextField(
            controller: titleController,
            decoration: InputDecoration(
              label: const Text(" 할일 이름을 수정해보세요! ")
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
        )
        :null,
      body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: timeText()
              ),
              SizedBox(
                height: 500,
                child: Center(
                  child:curSmallTodoList.isEmpty
                  ? const Center(
                  )
                  : 
                  Column(
                    children: [
                      SizedBox(
                        height: 500,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: curSmallTodoList.length,
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
                                        value: curSmallTodoList[index].checked, 
                                        onChanged: (value){
                                          curSmallTodoList[index].checked = value!;
                                          setState(() {});
                                        }
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width-100,
                                      child: Text(
                                        curSmallTodoList[index].title
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
                    ],
                  ),
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

    );
  }

  upButtonPressed(int index){
    if(index != 0){
      SmallTodo temp = curSmallTodoList[index-1];
      curSmallTodoList[index-1] = curSmallTodoList[index];
      curSmallTodoList[index] = temp;
      selected = index-1;

      setState(() {});
    }
  }

void downButtonPressed(int index) {
  if (index != curSmallTodoList.length - 1) {
    // 인덱스를 하나 내리는 방향으로 스왑
    SmallTodo temp = curSmallTodoList[index + 1];

    curSmallTodoList[index + 1] = curSmallTodoList[index];

    curSmallTodoList[index] = temp;

    selected = index+1;

    setState(() {});
  }
}

  editButtonPressed(int index){
    TextEditingController editcontroller = TextEditingController();
    editcontroller.text = curSmallTodoList[index].title;
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
              curSmallTodoList[index].title = editcontroller.text.trim();
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


  returnButtonPressed()async{
    LargeTodo temp = LargeTodo(
      seq : curLargeTodo!.seq,
      hierarchy: curLargeTodo!.hierarchy, 
      id: id, 
      title: titleController.text.trim(), 
      checked: curLargeTodo!.checked, 
      editTime: DateTime.now(),
      stTime: stDateTime,
      fnTime: fnDateTime,
    );
    print("리턴버튼 눌렀을때 fnTime ; ${temp.fnTime}");
    handler.updateLargeTodo(temp);
    curSmallTodoList.asMap().forEach((index, smallTodo)
      {
        smallTodo.hierarchy = index;
        print('${smallTodo.hierarchy}, ${smallTodo.title}, ${smallTodo.insert}');
        if(smallTodo.insert!){
          handler.insertSmallTodo(smallTodo);
        } else{
          handler.updateSmallTodo(smallTodo);
        }
      }
    );
    for(SmallTodo smallTodo in _removedSmallTodoList){
      if (!smallTodo.insert!){
        handler.updateSmallTodo(smallTodo);
      }
    }
    box.remove('stDateTime');
    box.remove('fnDateTime');

    Get.off(() => const Home());
    setState(() {});
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


    addButtonPressed(){
    if (smallTitleController.text.trim().isNotEmpty){
      print(largeTodoSeq);
      SmallTodo _new = SmallTodo(
        hierarchy: smallHierarchy, 
        id: id, 
        largeTodoSeq: largeTodoSeq, 
        title: smallTitleController.text.trim(), 
        checked: false,
        insert: true
      );
      smallHierarchy +=1;
      curSmallTodoList.add(_new);
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
    SmallTodo temp = curSmallTodoList[index];
    temp.rmTime = DateTime.now();
    temp.hierarchy = -1;
    _removedSmallTodoList.add(temp);
    print(" X버튼 눌렀을때:  $_removedSmallTodoList");
    curSmallTodoList.removeAt(index);
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
      ),
    );
  }




}// End


