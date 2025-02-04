


import 'package:weather_sasat/helper/format.dart';

class GeneralResponse {
  final num responseStatus;
  final String responseMessage;

  GeneralResponse({
    required this.responseStatus,
    required this.responseMessage,
  });

  factory GeneralResponse.fromJson(Map<String, dynamic> json) => GeneralResponse(
    responseStatus: Formats.tryParseNumber(json["ST"]),
    responseMessage: json["M"] ?? "",
  );
}
