import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TimeChange extends StatefulWidget {
  const TimeChange({super.key});

  @override
  State<TimeChange> createState() => _TimeChangeState();
}

class _TimeChangeState extends State<TimeChange> {



  final box = GetStorage();

  String? stDateString;
  String? fnDateString;

  late DateTime stDateTime;
  late DateTime fnDateTime;

  late bool stTimebool;
  late bool fnTimebool;

  @override
  void initState() {
    super.initState();

    stDateString = box.read('stDateTime');
    fnDateString = box.read('fnDateTime');

    print("메롱메롱 $stDateString");

    stDateTime = stDateString ==null ? DateTime.now() : DateTime.parse(stDateString!); 
    fnDateTime = fnDateString ==null ? DateTime.now() : DateTime.parse(fnDateString!);

    

    stTimebool = stDateString !=null; 
    fnTimebool = fnDateString !=null;


  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('시간 바꾸기!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: stTimebool, 
                  onChanged: (value){
                    stTimebool = value!;
                    setState(() {});
                  }
                ),
                const Text("시작"),
                SizedBox(
                  height: 100,
                  width: 200,
                  child: IgnorePointer(
                    ignoring: !stTimebool, // 체크박스가 비활성화면 true로 입력을 무시
                    child: CupertinoDatePicker(
                      initialDateTime: stDateTime,
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      onDateTimeChanged: (value) {
                        stDateTime = value;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 100,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: fnTimebool, 
                  onChanged: (value){
                    fnTimebool = value!;
                    setState(() {});
                  }
                ),
                const Text("종료"),
                SizedBox(
                  height: 100,
                  width: 200,
                  child: IgnorePointer(
                    ignoring: !fnTimebool, // 체크박스가 비활성화면 true로 입력을 무시
                    child: CupertinoDatePicker(
                      initialDateTime: fnDateTime,
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      onDateTimeChanged: (value) {
                        fnDateTime = value;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: (){
                if(stTimebool && fnTimebool && stDateTime.isAfter(fnDateTime)){
                  buttonSnackBar();
                  return ;
                }
                if(stTimebool){
                  box.write('stDateTime', stDateTime.toString());
                } else{
                  box.remove("stDateTime");
                }
                if(fnTimebool){
                  box.write('fnDateTime', fnDateTime.toString());
                } else{
                  box.remove("fnDateTime");
                }
                Get.back();
              }, 
              child: const Text('확인')
            )
          ],
        ),
      ),
    );
  }



	buttonSnackBar(){
    Get.snackbar(
      '경고', 
      '시작시간이 종료시간보다 뒤에 있습니다. \n 시간을 조정해주세요.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red,
      colorText: Colors.amber
    );
	}





}// End

