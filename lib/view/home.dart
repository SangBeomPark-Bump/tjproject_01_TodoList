import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist_app_02/model/accounts.dart';
import 'package:todolist_app_02/model/large_todo.dart';
import 'package:todolist_app_02/view/insert.dart';
import 'package:todolist_app_02/vm/database_handler.dart';

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

    @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    id = (box.read('id')) ?? '';
    print(id);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id),
        actions: [
          IconButton(
            onPressed: (){
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
            FutureBuilder(
              future: largeTodosLoader(), 
              builder: (context, snapshot) {
                return
                snapshot.hasData? 
                  ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    return Card(
                      child: Text(snapshot.data![index].title),
                    );
                  }
                )
                : const CircularProgressIndicator();
              },
            )
          ],
        )
      ),
    );
  }

Future<List<LargeTodo>> largeTodosLoader()async{
  Future<List<LargeTodo>> largeTodoes = handler.queryLargeTodo(id);
  print("랄랄라");
  print(largeTodoes);
  return largeTodoes;
}




}//End