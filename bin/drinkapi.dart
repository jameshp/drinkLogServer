library drinkapi;

import 'dart:async';
import 'package:rpc/api.dart';
import 'mongodb_api.dart';
import 'package:mongo_dart/mongo_dart.dart';

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

@ApiClass(
  name: 'drinks',
  version:'v1',
  description:'My DrinkLogger server side API'
)
class DrinkApi{
  
  final UserDao _userDao;
  
  DrinkApi(this._userDao);

  ///get all users 
  @ApiMethod(method:'GET', path:'users/{name}')
  Future<List<UserResponse>> getUsers(String name) async{
    List<UserResponse> allUsers = await _userDao.getAll();
    return allUsers;
  }
  
  @ApiMethod(method:'POST', path:'users/')
  Future<UserResponse> addUser(UserRequest userReq) async{
    //datavalidation logic should come here
    UserResponse user = await _userDao.addUser(userReq);
    return user;
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
