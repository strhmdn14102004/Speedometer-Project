
import "package:dio/dio.dart";
import "package:weather_sasat/api/common/general_response.dart";
import "package:weather_sasat/overlay/overlays.dart";


class AuthorizationInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        GeneralResponse generalResponse = GeneralResponse.fromJson(response.data);

        if (generalResponse.responseStatus != 0) {
          Overlays.error(message: generalResponse.responseMessage);
        } else {
          response.headers.add("PASSED", "true");
        }
      }
    }

    return handler.next(response);
  }
}
