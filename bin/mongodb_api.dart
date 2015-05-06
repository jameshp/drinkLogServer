library mongodb_api;

import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';

import 'drinkapi.dart';

/// Interface for reading and writing [User] objects to the persistence layers.
abstract class UserDao {

  /// Get all [User]s.
  Future<List<UserResponse>> getAll() ;
  
  /// Store a [User]
  Future<UserResponse> addUser(UserRequest user);

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
    DbCollection usersCollection;
    List<UserResponse> users = new List<UserResponse>();    
    Db db =await new Db("mongodb://127.0.0.1/drinklog");
    await db.open();
    print(">> Adding Users");
    usersCollection = db.collection("users");
    //await db.dropCollection("users");
    await usersCollection.insertAll([{'login':'mpolt', 'firstName':'Michael','lastName':'Polt','email':'michael.polt@gmail.com','lastActivity':new DateTime.now(),'tags':["aTag","bTag","anotherTag"]},
      {'login':'mschoef', 'firstName':'Michael','lastName':'Schöfmann','email':'m.shoff@polizei.gv.at','lastActivity':new DateTime.now(),'tags':["poli","tag","superTag"]}]);
    await db.ensureIndex('users', keys: {'login': -1});
    await usersCollection.find().forEach((user)=>users.add(new UserResponse.fromJson(user)));
    await db.close();

    return users;
  }
  
  @override
  Future<UserResponse>addUser(UserRequest user) async {
    DbCollection usersCollection;
    Db db =await new Db("mongodb://127.0.0.1/drinklog");
    await db.open();
    print(">> Adding {$user}");
    usersCollection = db.collection("users");
    var createdUser = await usersCollection.insert(user.toJson());
    Map storedUser = await usersCollection.findOne({'login':user.login});
    UserResponse response = await new UserResponse.fromJson(storedUser);
    return response;
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