import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_app_02/model/accounts.dart';
import 'package:todolist_app_02/vm/database_handler.dart';





class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  late TextEditingController idContoller;
  late TextEditingController nameContoller;
  late TextEditingController passwordController;
  late TextEditingController pConfirmController;
  late DatabaseHandler handler;


  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    idContoller = TextEditingController();
    passwordController = TextEditingController();
    pConfirmController = TextEditingController();
    nameContoller = TextEditingController();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : const Text('회원 가입')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                controller: idContoller,
                decoration: const InputDecoration(
                  label: Text('id')
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  label: Text('password')
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: pConfirmController,
                decoration: const InputDecoration(
                  label: Text('password confirm')
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: nameContoller,
                decoration: const InputDecoration(
                  label: Text('name')
                ),
              ),
            ),
            ElevatedButton(
              onPressed: (){
                signUpButtonPressed();
              }, 
              child: const Text('회원 가입')
            )
          ],
        ),
      ),
    );
  }

signUpButtonPressed()async{
  int idCnt = await handler.queryUserById(idContoller.text.trim());
  if(idContoller.text.trim().length >3 
    && pConfirmController.text.trim() == passwordController.text.trim()
    && nameContoller.text.trim().isNotEmpty
    && idCnt == 0
  ){
    print('회원가입 완료');
    handler.insertAccounts(
      Accounts(
        id: idContoller.text.trim(), 
        password: pConfirmController.text.trim(), 
        name: nameContoller.text.trim()
      )
    );
    Get.back();
  }else{

  }
}




}//End