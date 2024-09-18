class LargeTodo{

  int? seq;
  int hierarchy;
  final String id;
  final String title;
  bool checked;
  final DateTime editTime;
  DateTime? stTime;
  DateTime? fnTime;
  DateTime? rmTime;

  LargeTodo({
    this.seq,
    required this.hierarchy,
    required this.id,
    required this.title,
    required this.checked,
    required this.editTime,
    this.stTime,
    this.fnTime,
    this.rmTime
  });

  LargeTodo.fromMap(Map<String, dynamic> res)
  : seq = res['seq'],
    hierarchy = res['hierarchy'],
    id = res['id'],
    title = res['title'],
    checked = res['checked'] == 1,
    editTime =  DateTime.parse(res['editTime']),
    stTime = (res['stTime'] == 'null' )   ? null :  DateTime.parse(res['stTime']) ,
    fnTime = (res['fnTime'] == 'null' )  ? null :  DateTime.parse(res['fnTime']) ,
    rmTime = res['rmTime'] == 'null' ? null :  DateTime.parse(res['rmTime'])
    ;

    changeHie(int newHie){
      hierarchy = newHie;
    }

}