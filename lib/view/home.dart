import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist_app_02/model/accounts.dart';
import 'package:todolist_app_02/model/large_todo.dart';
import 'package:todolist_app_02/model/small_todo.dart';
import 'package:todolist_app_02/view/insert.dart';
import 'package:todolist_app_02/view/sign_in.dart';
import 'package:todolist_app_02/vm/database_handler.dart';
import 'package:todolist_app_02/view/update.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final box = GetStorage();

  late String titleTime;

  Timer? timer;

  late String id;
  late DatabaseHandler handler;
  late List<Accounts> accounts;
  late List<LargeTodo> largeTodos;
  late List<SmallTodo> cursmallTodos;
  late double todoWidth;
  late double todoheight;
  late bool sizeSet;


  int? insertSeq;

    @override
  void initState() {
    super.initState();
    sizeSet = false;
    handler = DatabaseHandler();
    id = (box.read('id')) ?? '';
    largeTodos = [];
    cursmallTodos = [];
    largeTodosLoader();
    insertSeqLoader();
    titleTime = DateTime.now().toString().substring(5,16);
    titleTime = DateTime.now().toString().substring(5, 16); // 초깃값 설정
    startTimer(); // 타이머 시작
  }

  // 타이머 설정 함수
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      DateTime now = DateTime.now();
      String currentMinutes = now.toString().substring(5, 16); // 현재 시간의 "MM-dd HH:mm" 형식
      if (currentMinutes != titleTime) {
        setState(() {
          titleTime = currentMinutes; // titleTime 갱신
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // 타이머를 꼭 정리해야 함
    super.dispose();
  }

  insertSeqLoader()async{
    insertSeq = await handler.queryLargeTodoInsertSeq() +1;
    box.write('largeSeq', insertSeq);
    box.write('insertLargeHi', largeTodos.length);
    print("insert Seq : $insertSeq, insertLargeHi : ${largeTodos.length}");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!sizeSet){
      sizeSet = true;
      todoheight = MediaQuery.of(context).size.height * 0.1;
      todoWidth = MediaQuery.of(context).size.width-16;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id),
        actions: [
          IconButton(
            onPressed: (){
              updateIfChanged();
              insertSeqLoader();
              Get.off(() => const Insert())!;
            }, 
            icon: const Icon(Icons.add)
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            showLogoutDialog();
          },
        ),
      ),
      body: Center(
        child :Column(
          children: [
            SizedBox(
              height: todoheight * 0.7,
              child: Text(
                titleTime,
                style: TextStyle(
                  fontSize: 30
                ),
              ),
            ),
            SizedBox(
              height: (todoheight + 10 +2)*5-5 + todoheight/2 ,
              width: todoWidth,
              child: largeTodos.isNotEmpty? 
                ListView.builder(
                itemCount: largeTodos.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0,5,0,5),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1+2,
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: Colors.black,
                            width: 1
                          )
                        )
                      ),
                      child: SizedBox(
                        width: todoWidth,
                        child: Column(
                          children: [
                            SizedBox(
                              height: todoheight * 0.5,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: todoWidth*0.05,
                                    child: Checkbox(
                                      value: largeTodos[index].checked, 
                                      onChanged: (value) {
                                        largeTodos[index].checked = value!;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0, 0,8,0),
                                    child: GestureDetector(
                                      onTap: () {
                                        tabbed(index);
                                      },
                                      child: SizedBox(
                                        width: todoWidth * 0.8,
                                        child: Text(
                                          largeTodos[index].title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: largeTodos[index].checked ? Colors.grey : Colors.black,
                                            decoration: largeTodos[index].checked
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                          ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: todoWidth * 0.05,
                                    child: IconButton(
                                      onPressed: (){
                                        upButtonPressed(index);
                                      }, 
                                      icon: Icon(Icons.arrow_upward)
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: todoheight * 0.5,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: todoWidth*0.05,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0, 0,8,0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: todoWidth * 0.8,
                                      child: GestureDetector(
                                        onTap: () {
                                          tabbed(index);
                                        },
                                        child: timeText(index)
                                      )
                                    ),
                                  ),
                                  SizedBox(
                                    width: todoWidth * 0.05,
                                    child: IconButton(
                                      onPressed: (){
                                        downButtonPressed(index);
                                      }, 
                                      icon: Icon(Icons.arrow_downward)
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              )
              : null,
            ),
          ],
        )
      ),
    );
  }

largeTodosLoader()async{
  largeTodos = await handler.queryLargeTodo(id);
  setState(() {});
}

  testButtonPressed()async{
    List<LargeTodo> largeTodoes = await handler.queryLargeTodo(id);
    print(largeTodoes[0].title);
  }


  tabbed(int index){
    smallTodoLoader(index);
  }

  buttonTapped(int seq,){
    box.write('largeSeq', seq);
    Get.off(() => const Update());
  }


  upButtonPressed(int index){
    if(index != 0){
      LargeTodo temp = largeTodos[index-1];

      largeTodos[index-1] = largeTodos[index];



      largeTodos[index] = temp;
      setState(() {});
    }
  }

void downButtonPressed(int index) {
  if (index != largeTodos.length - 1) {
    // 인덱스를 하나 내리는 방향으로 스왑
    LargeTodo temp = largeTodos[index + 1];

    largeTodos[index + 1] = largeTodos[index];

    largeTodos[index] = temp;

    setState(() {});
  }
}


  smallTodoLoader(int index)async{
    int largeTodoSeq = largeTodos[index].seq!;
    await handler.querySmallTodoByLargeTodoSeq(largeTodoSeq).then(
      (value){
        List<SmallTodo> smallTodo = value.length >4 ?value.sublist(1,4) : value;
        buttonDialog(smallTodo, largeTodoSeq, index);
      },
    );
  }



  buttonDialog(List<SmallTodo> smallTodo, int largeTodoSeq, int idx){
    Get.defaultDialog(
      title: "로그인",
      middleText: "환영합니다.",
      backgroundColor: Colors.white,
      barrierDismissible: false,
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: List.generate(
              smallTodo.length, 
              (index) {
                return SizedBox(
                  height: todoheight * 0.5,
                  child: Row(
                    children: [
                      Checkbox(
                        value: smallTodo[index].checked, 
                        onChanged: (value) {
                          smallTodo[index].checked = value!;
                          setState(() {});
                        },
                      ),
                      Text(
                        smallTodo[index].title
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            updateIfChanged();
            buttonTapped(largeTodoSeq);
          }, 
          child: const Text('수정')
        ),

        TextButton(
          onPressed: () {
            deleteButtonPressed(idx);
            Get.back();
          }, 
          child: const Text('삭제')
        ),
        TextButton(
          onPressed: () {
            Get.back();
          }, 
          child: const Text('취소')
        ),
      ]
    );
  }


  Text timeText(int index){

    DateTime? stDateTime = largeTodos[index].stTime;
    DateTime? fnDateTime = largeTodos[index].fnTime;


    String stresult = stDateTime == null ?'     ' : stDateTime.toString().substring(11, 16);
    String fnresult = fnDateTime == null ?'     ' : fnDateTime.toString().substring(11, 16);

    String resultText = stDateTime == null && fnDateTime == null
                        ?"하루 종일"
                        :"$stresult  ~  $fnresult";
    return Text(
      resultText,
      style: TextStyle(
        color: largeTodos[index].checked ? Colors.grey : Colors.black,
        decoration: largeTodos[index].checked ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
  }

  updateIfChanged(){
      // print('updated');
    largeTodos.asMap().forEach((i, largeTodo) {
      largeTodo.changeHie(i);
      // print('checked : ${largeTodo.checked}, title : ${largeTodo.title}');
      handler.updateLargeTodo(largeTodo);
    });

  }

  deleteButtonPressed(int index){
    LargeTodo largeTodo = largeTodos[index];
    largeTodo.rmTime = DateTime.now();
    largeTodo.hierarchy = -1;
    handler.updateLargeTodo(largeTodo);    
    largeTodos.removeAt(index);
    setState(() {});
  }


 showLogoutDialog() {
  Get.defaultDialog(
    title: "로그아웃",
    middleText: "정말 로그아웃하시겠습니까?",
    barrierDismissible: false,
    actions: [
      ElevatedButton(
        onPressed: () {
          box.erase();
          Get.back();  // 다이얼로그 닫기
          updateIfChanged();
          Get.off(() => const SignIn());  // 로그인 화면으로 이동
        },
        child: const Text("예"),
      ),
      ElevatedButton(
        onPressed: () {
          Get.back();  // 다이얼로그 닫기
        },
        child: const Text("아니오"),
      ),
    ],
  );
}




}//End