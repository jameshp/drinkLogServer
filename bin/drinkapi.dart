library drinkapi;

import 'dart:io';

import 'package:rpc/api.dart';
import 'mongo_dbapi.dart';

class UserResponse{
  int id;
  String username;
  String firstName;
  String lastName;
  DateTime lastActivity;
  List<String> tags;
  
  UserResponse();
}

@ApiClass(
  name: 'drinks',
  version:'v1',
  description:'My DrinkLogger server side API'
)
class DrinkApi{
  
  final UserDao _userDao;
  
  DrinkApi(this._userDao);

  @ApiMethod(method:'GET', path:'users/{name}')
  Map<String, List<UserResponse>> getUsers(String name){
    return {'Users':_userDao.getAll()};
    
    
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
  }
  
  
  
}
