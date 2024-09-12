class LargeTodo{

  int? seq;
  final int hierarchy;
  final String id;
  final String title;
  final bool checked;
  final DateTime editTime;
  DateTime? stTime;
  DateTime? fnTime;
  DateTime? rmTime;

  LargeTodo({
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
    editTime =  DateTime.parse(res['stTime']),
    stTime = res['stTime'] != null ? DateTime.parse(res['stTime']) : null,
    fnTime = res['fnTime'] != null ? DateTime.parse(res['fnTime']) : null,
    rmTime = res['rmTime'] != null ? DateTime.parse(res['rmTime']) : null
    ;

}