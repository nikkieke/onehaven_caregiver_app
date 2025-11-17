import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

Future<void> main() async {
  final router = Router();

  // get members from file
  final file = File('bin/members.json');
  final response = jsonDecode(await file.readAsString());

  // GET /members
  router.get('/members', (Request request) {
    return Response.ok(
      jsonEncode(response),
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
