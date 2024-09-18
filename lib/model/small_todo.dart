class SmallTodo{
  int? seq;
  int hierarchy;
  final String id;
  final int largeTodoSeq;
  String title;
  bool checked;
  DateTime? rmTime;

  bool? insert;

  SmallTodo({
    required this.hierarchy,
    required this.id,
    required this.largeTodoSeq,
    required this.title,
    required this.checked,
    this.insert
  });

  SmallTodo.fromMap(Map<String, dynamic> res)
  : seq = res['seq'],
    hierarchy = res['hierarchy'],
    id = res['id'],
    largeTodoSeq = res['largeTodoSeq'],
    title = res['title'],
    checked = res['checked'] == 1,
    rmTime = res['rmTime'] != null ? DateTime.parse(res['rmTime']) : null,
    insert = false
    ;

    changeHie(int newHie){
      hierarchy = newHie;
    }



}