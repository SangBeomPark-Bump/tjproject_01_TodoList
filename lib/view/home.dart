import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist_app_02/model/accounts.dart';
import 'package:todolist_app_02/model/large_todo.dart';
import 'package:todolist_app_02/view/insert.dart';
import 'package:todolist_app_02/vm/database_handler.dart';
import 'package:todolist_app_02/view/update.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final box = GetStorage();

  late String id;
  late DatabaseHandler handler;
  late List<Accounts> accounts;
  late List largeTodos;

  int? insertSeq;

    @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    id = (box.read('id')) ?? '';
    insertSeqLoader();
  }

  insertSeqLoader()async{
    insertSeq = await handler.queryLargeTodoInsertSeq() +1;
    box.write('largeSeq', insertSeq);
    print(insertSeq);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id),
        actions: [
          IconButton(
            onPressed: (){
              insertSeqLoader();
              Get.to(() => const Insert())!.then((value) {
                setState(() {});
              },);
            }, 
            icon: const Icon(Icons.add)
          )
        ],
      ),
      body: Center(
        child :Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: largeTodosLoader(), 
                builder: (context, snapshot) {
                  return
                  snapshot.hasData? 
                    ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: (){
                          cardTabbed(index, snapshot.data!);
                        },
                        child: Card(
                          child: Text(snapshot.data![index].title),
                        ),
                      );
                    }
                  )
                  : const CircularProgressIndicator();
                },
              ),
            ),
            ElevatedButton(
              onPressed: (){
                testButtonPressed();
              }, 
              child: const Text("Test")
            )
          ],
        )
      ),
    );
  }

Future<List<LargeTodo>> largeTodosLoader()async{
  List<LargeTodo> largeTodoes = await handler.queryLargeTodo(id);
  return largeTodoes;
}

  testButtonPressed()async{
    List<LargeTodo> largeTodoes = await handler.queryLargeTodo(id);
    print(largeTodoes[0].title);
  }


  cardTabbed(int index, List<LargeTodo> largeTodoList){
    box.write('largeSeq', largeTodoList[index].seq);
    Get.to(() => const Update());
  }

}//End