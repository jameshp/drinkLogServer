import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';

import 'drinkapi.dart';

/// Interface for reading and writing [User] objects to the persistence layers.
abstract class UserDao {

  /// Get all [User]s.
  Future<List<UserResponse>> getAll() ;

  /// Get the [User] with the given [id].
  Future<UserResponse> get(int id);

  /// Create a [User] if the ID is `null` otherwise modify the given [Todo].
  //Future<UserResponse> write(UserRequest todo);

  /// Deleted all completed [User]s.
  Future deleteCompleted();

  /// Delete the [User] with the given [id].
  Future delete(int id);

}


/// Handles reading and writing [User] objects to the MongoDB.
class UserDaoMongoDBImpl implements UserDao {
  
  @override
    Future<List<UserResponse>> getAll() async {
      // TODO: implement getAll
      Db db = new Db("mongodb://127.0.0.1/drinklog");
      DbCollection collection;
      DbCollection usersCollection;
      DbCollection articlesCollection;
      Map<String,Map> authors = new Map<String,Map>();
      Map<String,Map> users = new Map<String,Map>();
      
      var connection = await db.open();
      print(">> Adding Users");
      usersCollection = db.collection("users");
      await usersCollection.insertAll([{'login':'jdoe', 'name':'John Doe', 'email':'john@doe.com'},
             {'login':'lsmith', 'name':'Lucy Smith', 'email':'lucy@smith.com'}]);
      await db.ensureIndex('users', keys: {'login': -1});
      await usersCollection.find().forEach((user)=>users[user["login"]] = user);
      await db.close();
      return new List<UserResponse>();
    }
  
  @override
  Future delete(int id) {
    // TODO: implement delete
  }

  @override
  Future deleteCompleted() {
    // TODO: implement deleteCompleted
  }

  @override
  Future<UserResponse> get(int id) {
    // TODO: implement get
  }

  
}