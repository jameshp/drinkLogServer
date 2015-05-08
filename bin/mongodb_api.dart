library mongodb_api;

import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';

import 'drinkapi.dart';

/// Interface for reading and writing [User] and [Drink] objects to the persistence layers.
abstract class Dao {

  /// Get all [User]s.
  Future<List<UserResponse>> getAll() ;
  
  /// Store a [User]
  Future<UserResponse> addUser(UserRequest user);

  
  Future<DrinkLogRequest> addDrink(DrinkLogRequest drinkLog);
  
  //getAllDrinks from User
  Future<List<DrinkLogRequest>> getDrinksFromUser(String user);
  

}


/// Handles reading and writing [User] objects to the MongoDB.
class DaoMongoDBImpl implements Dao {
    
  
  @override
  Future<List<UserResponse>> getAll() async {
    DbCollection usersCollection;
    List<UserResponse> users = new List<UserResponse>();    
    Db db =await new Db("mongodb://127.0.0.1/drinklog");
    await db.open();
    print(">> Adding Users");
    usersCollection = db.collection("users");
    //await db.dropCollection("users");
    //await usersCollection.insertAll([{'login':'mpolt', 'firstName':'Michael','lastName':'Polt','email':'michael.polt@gmail.com','lastActivity':new DateTime.now(),'tags':["aTag","bTag","anotherTag"]},
    //  {'login':'mschoef', 'firstName':'Michael','lastName':'Schöfmann','email':'m.shoff@polizei.gv.at','lastActivity':new DateTime.now(),'tags':["poli","tag","superTag"]}]);
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
  Future<DrinkLogRequest> addDrink(DrinkLogRequest drinkLog) async {
    DbCollection usersCollection;
    DbCollection drinksCollection;
    Db db =await new Db("mongodb://127.0.0.1/drinklog");
    await db.open();
    print(">> Adding {$drinkLog}");
    drinksCollection = db.collection("drinklog");
    usersCollection = db.collection("users");
    
    Map storedUser = await usersCollection.findOne({'_id':ObjectId.parse(drinkLog.user_id)});
    print(">> User {$storedUser} found");
    
    //cance if user is not valid in request
    
    //set an ID for the item, to find it again
    ObjectId id = new ObjectId();
    drinkLog.id = id.toHexString();
    var createdDrinkLog = await drinksCollection.insert(drinkLog.toBson());
    
    Map storedDrinkLog = await drinksCollection.findOne({'_id':ObjectId.parse(drinkLog.id)});
    DrinkLogRequest response = await new DrinkLogRequest.fromBson(storedDrinkLog);
    return response;
  }

  @override
  Future<List<DrinkLogRequest>> getDrinksFromUser(String UserLogin) async {
    DbCollection usersCollection;
    DbCollection drinksCollection;
    Db db =await new Db("mongodb://127.0.0.1/drinklog");
    await db.open();
    print(">> Fetching Drinks for {$UserLogin}");
    drinksCollection = db.collection("drinklog");
    usersCollection = db.collection("users");
    
    Map storedUser = await usersCollection.findOne({'login':UserLogin});
    print(">> User {$storedUser} found");
    
    //cance if user is not valid in request
    
    //set an ID for the item, to find it again
   
    List<DrinkLogRequest> response = new List<DrinkLogRequest>();
    await drinksCollection.find({'user_id':storedUser["_id"]}).forEach((d)=>response.add(new DrinkLogRequest.fromBson(d)));
    print(">> Drinklog entries found {$response}");    
    return response;
  }
}