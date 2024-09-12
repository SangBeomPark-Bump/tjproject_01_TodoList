
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist_app_02/model/accounts.dart';
import 'package:todolist_app_02/model/large_todo.dart';
import 'package:todolist_app_02/model/small_todo.dart';



class DatabaseHandler{

  Future<Database>initalizeDB() async{
    
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'Todolist.db'),
      onCreate: (db, version) async {
        await db.execute(
          """
              create table largeTodo
              (
                seq INTEGER primary key autoincrement,
                hierarchy INTEGER,
                id TEXT,
                title TEXT,
                checked INTEGER,
                editTime TEXT,
                stTime TEXT,
                fnTime TEXT,
                rmTime TEXT
              )
          """
        );
        await db.execute(
          """
              create table smallTodo
              (
                seq INTEGER primary key autoincrement,
                hierarchy INTEGER,
                id TEXT,
                largeTodoSeq INTEGER,
                title TEXT,
                checked INTEGER,
                rmtime TEXT
              )
          """
        );
        await db.execute(
          """
              create table accounts
              (
                seq INTEGER primary key autoincrement,
                id TEXT,
                password TEXT,
                name TEXT
              )
          """
        );
      },
      version: 1,
    );
  }

  Future<int> insertLargeTodo(LargeTodo largeTodo)async{
    int result = 0;
    final Database db = await initalizeDB();
    result = await db.rawInsert(
      """
        insert into largeTodo
        (hierarchy, id, title, checked, editTime, stTime, fnTime, rmTime)
        values 
        (?        ,?     ,?      ,?       ,?      ,?,       ?,      ?)
      """,
      [
        largeTodo.hierarchy,
        largeTodo.id, 
        largeTodo.title, 
        largeTodo.checked ? 1 : 0, 
        largeTodo.editTime.toString(),
        largeTodo.stTime == null ? largeTodo.stTime.toString(): null,
        largeTodo.fnTime == null ? largeTodo.fnTime.toString(): null,
        largeTodo.rmTime == null ? largeTodo.rmTime.toString(): null,
      ]);
    return result;
  }

  Future<int> insertSmallTodo(SmallTodo smallTodo)async{
    int result = 0;
    final Database db = await initalizeDB();
    result = await db.rawInsert(
      """
        insert into smallTodo
        (hierarchy, id   ,largeTodoSeq, title, checked, rmtime )
        values 
        (?        ,?     ,?           ,?       ,?     ,? )
      """,
      [
        smallTodo.hierarchy,
        smallTodo.id,
        smallTodo.largeTodoSeq,
        smallTodo.title, 
        smallTodo.checked ? 1 : 0, 
        smallTodo.rmTime == null ? smallTodo.rmTime.toString(): null,
      ]);
    return result;
  }

  Future<int> insertAccounts(Accounts accounts)async{
    int result = 0;
    final Database db = await initalizeDB();
    result = await db.rawInsert(
      """
        insert into accounts
        (name, id, password)
        values 
        (?    , ?   ,?    )
      """,
      [
        accounts.name,
        accounts.id,
        accounts.password
      ]);
    return result;
  }

  Future<List<Accounts>> queryUser()async{
    final Database db = await initalizeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(
          'select * from accounts'
        );
    List<Accounts> result = queryResult.map((e) => Accounts.fromMap(e),).toList();
    return result;
  }
  
  Future<int> queryUserById(String id)async{
    final Database db = await initalizeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(
          'select count(id) as cnt from accounts WHERE id = ?' , [id]
        );
    int result =queryResult.first['cnt'] as int ;
    return result;
  }
  
  Future<int> queryCountid(String id, String password)async{
    final Database db = await initalizeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(
          """
              SELECT COUNT(id) as cnt
              FROM accounts
              WHERE id = ?
                AND password = ?
          """,
          [id, password]
        );
    int result = queryResult.first['cnt'] as int;
    return result;
  }












  Future<List<LargeTodo>> queryLargeTodo(String id)async{
    final Database db = await initalizeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(
          """
            SELECT * 
            FROM largeTodo
            WHERE id = ?
          """,[id]
        );
        if (queryResult[0]['stTime'] == null){
          print('야호');
        }
        print(queryResult[0]['stTime']);      
    List<LargeTodo> result = queryResult.map((e) => LargeTodo.fromMap(e),).toList();
    return result;
  }

  // Future<List<LargeTodo>> queryResInfoBySeq(int seq)async{
  //   final Database db = await initalizeDB();
  //   final List<Map<String, Object?>> queryResult =
  //       await db.rawQuery(
  //         'select * from resInfo WHERE seq = ?'
  //         ,[seq]
  //       );
  //   List<LargeTodo> result = queryResult.map((e) => LargeTodo.fromMap(e),).toList();
  //   return result;
  // }
  

  // Future<List<ResInfo>> queryResInfoByUser(String id)async{
  //   print('메롱메롱');
  //   final Database db = await initalizeDB();
  //   final List<Map<String, Object?>> queryResult =
  //       await db.rawQuery(
  //         'select * from resInfo WHERE userId = ?', [id]
  //       );
  //   List<ResInfo> result = queryResult.map((e) => ResInfo.fromMap(e),).toList();
  //   return result;
  // }












  // Future<int> updateResInfo(ResInfo resInfo)async{
  //   int result = 0;
  //   final Database db = await initalizeDB();
  //   result = await db.rawUpdate(
  //     """
  //       update resInfo
  //       set name = ?, phone = ?, comment = ?, privates = ?
  //       where seq = ?
  //     """,
  //     [
  //       resInfo.name, 
  //       resInfo.phone, 
  //       resInfo.comment,
  //       resInfo.privates,
  //       resInfo.seq, 
  //     ]);
  //   return result;
  // }

  // Future<int> updateResInfoAll(ResInfo resInfo)async{
  //   int result = 0;
  //   final Database db = await initalizeDB();
  //   result = await db.rawUpdate(
  //     """
  //       UPDATE resInfo
  //       SET image = ?, name = ?, phone = ?, comment = ?, privates = ?
  //       WHERE seq = ?
  //     """,
  //     [
  //       resInfo.image,
  //       resInfo.name, 
  //       resInfo.phone, 
  //       resInfo.comment,
  //       resInfo.privates,
  //       resInfo.seq,
  //     ]);
  //   return result;
  // }

  // Future<int> deleteResInfo(int seq)async{
  //   int result = 0;
  //   final Database db = await initalizeDB();
  //   result = await db.rawDelete(
  //     """
  //       delete from resInfo
  //       where seq = ?
  //     """,
  //     [
  //       seq
  //     ]);
  //   return result;
  // }

  // Future<int> updateResInfoLatLng(ResInfo resInfo)async{
  //   int result = 0;
  //   final Database db = await initalizeDB();
  //   result = await db.rawUpdate(
  //     """
  //       update resInfo
  //       set lat = ?, long = ?
  //       where seq = ?
  //     """,
  //     [
  //       resInfo.lat, 
  //       resInfo.long, 
  //       resInfo.seq, 
  //     ]);
  //   return result;
  // }
  

  // Future<List<ResInfo>> queryRecResInfo({
  //   required double latData,
  //   required double longData
  // })
  // async{
  //   final Database db = await initalizeDB();
  //   final List<Map<String, Object?>> queryResult =
  //       await db.rawQuery(
  //         """
  //             SELECT *
  //             FROM resInfo
  //             WHERE privates = 1
  //               AND ((lat - ?) * (lat - ?) + (long - ?) * (long - ?)) < 0.002
  //         """,
  //         [latData, latData, longData, longData]
  //       );
  //   List<ResInfo> result = queryResult.map((e) => ResInfo.fromMap(e),).toList();
  //   return result;
  // }

  // Future<List<ResInfo>> queryRecResInfoTest({
  //   required double latData,
  //   required double longData
  // })
  // async{
  //   final Database db = await initalizeDB();
  //   final List<Map<String, Object?>> queryResult =
  //   await db.rawQuery(
  //     """
  //         SELECT (lat - ?) * (lat - ?) + (long - ?) * (long - ?) as dist,
  //                 0.002 as kil5,
  //                 *
  //         FROM resInfo
  //         WHERE privates = 1
  //         AND dist < kil5
  //     """,
  //     [latData, latData, longData, longData]
  //   );
    
  //   List<ResInfo> result = queryResult.map((e) => ResInfo.fromMap(e),).toList();
  //   return result;
  // }

// """
//               SELECT (lat - ?) * (lat - ?) + (long - ?) * (long - ?) as distance,
//                       0.002 as kilo5,
//                       seq
//               FROM resInfo
//               WHERE privates = 1
//               AND dist < kilo5
// """



} // DatabaseHandler