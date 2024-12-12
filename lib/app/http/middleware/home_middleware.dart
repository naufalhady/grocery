import 'package:vania/vania.dart';

class HomeMiddleware extends Middleware {
  @override
  handle(Request req) async {
    print("Home Middleware is Activated");
    return req;
  }
}
