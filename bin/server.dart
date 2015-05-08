// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:async';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_rpc/shelf_rpc.dart' as shelf_rpc;
import 'package:shelf_route/shelf_route.dart' as shelf_route;
import 'package:rpc/rpc.dart';

import 'drinkapi.dart';
import 'mongodb_api.dart';

const _API_PREFIX = '/api';
final ApiServer _apiServer = new ApiServer(apiPrefix:_API_PREFIX, prettyPrint:true);

///Main Function running the Server
Future main(List<String> args) async {
  var parser = new ArgParser()
      ..addOption('port', abbr: 'p', defaultsTo: '8080');

  var result = parser.parse(args);

  var port = int.parse(result['port'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });

  _apiServer.addApi(new DrinkApi(new DaoMongoDBImpl()));
  _apiServer.enableDiscoveryApi();
  
  var apiHandler = shelf_rpc.createRpcHandler(_apiServer);
  
  var apiRouter = shelf_route.router();
  apiRouter.add(_API_PREFIX,null,apiHandler,exactMatch:false);
  
  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(apiRouter.handler);
      //.addHandler(_echoRequest);

  var server = await shelf_io.serve(handler, 'localhost', port); 
  print('Serving at http://${server.address.host}:${server.port}');
 
}

//shelf.Response _echoRequest(shelf.Request request) {
//  return new shelf.Response.ok('Request for "${request.url}"');
//}
