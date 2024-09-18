import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist_app_02/model/accounts.dart';
import 'package:todolist_app_02/view/home.dart';
import 'package:todolist_app_02/view/sign_up.dart';
import 'package:todolist_app_02/vm/database_handler.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  late TextEditingController idController;
  late TextEditingController passwordController;
  final box = GetStorage();

  late String idString;
  String? passwordString;
  late DatabaseHandler handler;
  late List<Accounts> accounts;

  late bool checkboxValue;

  

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    idController = TextEditingController();
    passwordController = TextEditingController();

    initStorage();
    idString = (box.read('id')) ?? '';
    idController.text = idString;
  }



  initStorage(){
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                controller: idController,
                decoration: const InputDecoration(
                  label:  Text('id')
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label:  Text('password')
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    fetchUser(idController.text.trim(), passwordController.text.trim());
                  }, 
                  child: const Text('로그인')
                ),
                ElevatedButton(
                  onPressed: (){
                    idController.clear();
                    passwordController.clear();
                    Get.to( () =>const SignUp());
                  }, 
                  child: const Text('회원 가입')
                ),
                ElevatedButton(
                  onPressed: (){
                    testButtonPressed();
                  }, 
                  child: const Text('테스트')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

//Functions
fetchUser(String id, String password)async{
  int result = await handler.queryCountid(id, password);
  if (result ==0){
    buttonSnackBar();
  } else{
    box.write('id', idController.text.trim());
    buttonDialog();
  }
}

	buttonSnackBar(){
    Get.snackbar(
      '경고', 
      '아이디와 비밀번호가 일치하지 않습니다.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red,
      colorText: Colors.amber
    );
	}

  buttonDialog(){
    Get.defaultDialog(
      title: "로그인",
      middleText: "환영합니다. ${idController.text.trim()}님! ",
      backgroundColor: Colors.white,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
              Get.off(() => const Home());
          }, 
          child: const Text('확인')
        ),
      ]
    );
  }

testButtonPressed(){
}


}// End