class SmallTodo{
  int? seq;
  final int hierarchy;
  final String id;
  final int largeTodoSeq;
  final String title;
  final bool checked;
  DateTime? rmTime;

  SmallTodo({
    required this.hierarchy,
    required this.id,
    required this.largeTodoSeq,
    required this.title,
    required this.checked,
  });

  SmallTodo.fromMap(Map<String, dynamic> res)
  : seq = res['seq'],
    hierarchy = res['hierarchy'],
    id = res['id'],
    largeTodoSeq = res['largeTodoSeq'],
    title = res['title'],
    checked = res['checked'] == 1,
    rmTime = res['rmTime'] != null ? DateTime.parse(res['rmTime']) : null
    ;
}