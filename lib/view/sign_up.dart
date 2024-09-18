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
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController passwordController;
  late TextEditingController pConfirmController;
  late DatabaseHandler handler;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    idController = TextEditingController();
    passwordController = TextEditingController();
    pConfirmController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 가입'),
      ),
      body: Center(
        child: Form(
          key: _formKey, // Form 상태를 관리하는 키
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'id',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length <= 3) {
                      return '아이디는 4자 이상이어야 합니다.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'password',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 3) {
                      return '비밀번호는 3자 이상이어야 합니다.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: pConfirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'password confirm',
                  ),
                  validator: (value) {
                    if (value != passwordController.text.trim()) {
                      return '비밀번호가 일치하지 않습니다.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '이름을 입력해주세요.';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  signUpButtonPressed();
                },
                child: const Text('회원 가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUpButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      int idCnt = await handler.queryUserById(idController.text.trim());
      if (idCnt == 0) {
        print('회원가입 완료');
        handler.insertAccounts(
          Accounts(
            id: idController.text.trim(),
            password: pConfirmController.text.trim(),
            name: nameController.text.trim(),
          ),
        );
        Get.back();
      } else {
        Get.snackbar(
          '경고',
          '중복된 아이디가 있습니다.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          colorText: Colors.amber,
        );
      }
    }
  }
}
