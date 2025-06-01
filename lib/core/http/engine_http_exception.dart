import 'package:get/get_connect/http/src/exceptions/exceptions.dart';

class EngineHttpGraphQLError extends GraphQLError {}

class EngineHttpUnauthorizedException extends UnauthorizedException {}

class EngineHttpGetException extends GetHttpException {
  EngineHttpGetException(super.message);
}

class EngineHttpUnexpectedFormat extends UnexpectedFormat {
  EngineHttpUnexpectedFormat(super.message);
}
