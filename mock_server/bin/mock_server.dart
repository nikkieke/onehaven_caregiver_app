import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

Future<void> main() async {
  final router = Router();

  // PUT /toggleScreenTime
  router.put('/toggleScreenTime/<id>', updateRequestHandler);

  // GET /members
  router.get('/members', (Request request) async {
    // get members from file
    final file = File('bin/members.json');
    final data = jsonDecode(await file.readAsString());

    return Response.ok(
      jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // add logging middleware
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  // serve
  final server = await serve(handler, InternetAddress.anyIPv4, 8080);

  print('Mock server running on http://localhost:${server.port}');
}

Future<Response> updateRequestHandler(Request request, String id) async {
  // get members from file
  final file = File('bin/members.json');
  final memberList = jsonDecode(await file.readAsString());

  final index = memberList.indexWhere((e) => e['id'] == id);

  if (index == -1) {
    return Response.notFound(
      jsonEncode(({'status': 'Member not found'})),
      headers: {'Content-Type': 'application/json'},
    );
  }

  final member = memberList[index];
  member['screenTimeEnabled'] = !member['screenTimeEnabled'];

  //update status
  if (member['status'] == 'active') {
    member['status'] = 'inactive';
  } else if (member['status'] == 'inactive') {
    member['status'] = 'active';
  }

  memberList[index] = member;

  await file.writeAsString(jsonEncode(memberList));

  return Response.ok(
    jsonEncode(({'status': 'success'})),
    headers: {'Content-Type': 'application/json'},
  );
}
