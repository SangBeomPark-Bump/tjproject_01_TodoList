class Accounts{

  int? seq;

  final String id;
  final String password;
  final String name;

  Accounts({
    required this.id,
    required this.password,
    required this.name
  });

  Accounts.fromMap(Map<String, dynamic> res)
  : seq = res['seq'],
    id = res['id'],
    password = res['password'],
    name = res['name'];

}