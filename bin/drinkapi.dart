library drinkapi;

import 'dart:async';
import 'package:rpc/api.dart';
import 'mongodb_api.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:convert';

///Defines the [UserResponse] returned on the REST API 
class UserResponse{
  String id;
  String login;
  String firstName;
  String lastName;
  String email;
  DateTime lastActivity;
  List<String> tags;
  
  UserResponse();
  
  ///used to create userResponse Objects based on MongoDB data
  UserResponse.fromJson(Map json) {
      ObjectId _objectId = json["_id"]; 
      id = _objectId.toHexString();
      login = json["login"];
      firstName = json["firstName"];
      lastName = json["lastName"];
      email = json["email"];
      lastActivity = json["lastActivity"];
      tags = json["tags"];
  }

  
}

class UserRequest{
  @ApiProperty(required:true)
  String login;
  
  String firstName;
  String lastName;
  String email;
  DateTime lastActivity;
  
  @ApiProperty(required:false)
  List<String> tags;
  
  //this is automatically called by JSON.encode
  Map toJson() {
    return {
        "login" : login,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "lastActivity": new DateTime.now(),
        "tags":tags
    };
  }
  
  
  
  
}


class DrinkLogRequest{
  String id;
  DateTime logDate;
  String user_id;
  List<Drink> drinks;
  String comment; 
  
  DrinkLogRequest();
  
  
  Map toBson(){ 
    
    List drinkJson = new List();
    drinks.forEach((d)=>drinkJson.add(d.toJson()));
    //print(drinkJson);
    
    Map response =     
    {
      "_id":new ObjectId.fromHexString(id),
      "logDate": logDate,
      "user_id":new ObjectId.fromHexString(user_id),
      "comment":comment,
      "drinks": drinkJson
        //JSON.encode(drinks) //drinks.forEach((d)=>d.toJson()),
      
    };
    return response;
  }
  
  /*
  Map toJson(){    
      return{
        "_id":id,
        "logDate": logDate,
        "user_id":user_id,
        "comment":comment,
        "drinks":[ {"drinktype":"Bier","count":4 }, {"drinktype":"Wein","count":2 }]
      };
   }
  */
  ///used to create DrinkLog Response Objects based on MongoDB data
  DrinkLogRequest.fromBson(Map json) {
      ObjectId _objectId = json["_id"]; 
      id = _objectId.toHexString();
      logDate = json["logDate"];
      ObjectId _userId = json["user_id"];
      user_id = _userId.toHexString();
      comment = json["comment"];
      
      drinks = new List<Drink>();//json["drinks"];
      
      List drinkList = json["drinks"];
      drinkList.forEach((d)=> drinks.add(new Drink.fromBson(d)));
      
      
      //[{"drinktype":"Bier","count":4}];
      //drinks = {"drinks":json["drinks"]};
  }
}


class Drink{
  //static const List<String> DRINKTYPES = const['Bier','Wein','Sekt','Schnaps'];
  
  int count;
  String drinktype;
  
  Drink();
  
  Map toJson(){
      return{
        "count": count,
        "drinktype": drinktype
      };
   }
  
  
    Drink.fromBson(Map json) {
      count = json["count"];
      drinktype = json["drinktype"];
    }
  
}


@ApiClass(
  name: 'drinks',
  version:'v1',
  description:'My DrinkLogger server side API'
)
class DrinkApi{
  
  final Dao _Dao;
  
  DrinkApi(this._Dao);

  ///get all users 
  @ApiMethod(method:'GET', path:'users/')
  Future<List<UserResponse>> getUsers() async{
    List<UserResponse> allUsers = await _Dao.getAll();
    return allUsers;
  }
  
  @ApiMethod(method:'POST', path:'users/')
  Future<UserResponse> addUser(UserRequest userReq) async{
    //datavalidation logic should come here
    UserResponse user = await _Dao.addUser(userReq);
    return user;
  }
  
  
  @ApiMethod(method:'GET', path:'drinks/{userLogin}')
    Future<List<DrinkLogRequest>> getDrinksFromUser(String userLogin) async{
      //datavalidation logic should come here
      List<DrinkLogRequest> drinkLog = await _Dao.getDrinksFromUser(userLogin);
      return drinkLog;
    }
  
  @ApiMethod(method:'POST', path:'drinks/')
    Future<DrinkLogRequest> addDrink(DrinkLogRequest req) async{
      //datavalidation logic should come here
      DrinkLogRequest drinkLog = await _Dao.addDrink(req);
      return drinkLog;
    }
  
  
}



//    List<UserResponse> x = new List<UserResponse>();
//    if (name == null || name.isEmpty){
//      return {'Users':x};  
//    }
//    else{
//      List<UserResponse> x = new List<UserResponse>();
//      List<String> tags = new List<String>();
//      tags.add("tag a");
//      tags.add("tag b");
//      x.add(new UserResponse()
//                      ..id = 1
//                      ..firstName = "peter"
//                      ..lastName = "hofmann"
//                      ..username = name
//                      ..lastActivity = new DateTime.utc(2015,5,6)
//                      ..tags = tags 
//      );
//      x.add(new UserResponse()
//                      ..id = 2
//                      ..firstName = "peter"
//                      ..lastName = "hofmann"
//                      ..username = name
//                      ..lastActivity = new DateTime.now()
//                      ..tags = tags 
//      );
//      return {'Users':x};
//    }
