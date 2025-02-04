// ignore_for_file: empty_catches

import "package:basic_utils/basic_utils.dart";
import "package:jiffy/jiffy.dart";

class Formats {
  static String coalesce(String? value, {String? defaultString}) {
    return StringUtils.isNotNullOrEmpty(value) ? value! : defaultString ?? "N/A";
  }

  static Jiffy? tryParseJiffy(String? value, {String pattern = "yyyy-MM-dd"}) {
    if (StringUtils.isNotNullOrEmpty(value)) {
      try {
        return Jiffy.parse(value!, pattern: pattern);
      } catch (ex) {
        try {
          return Jiffy.parseFromDateTime(DateTime.parse(value!));
        } catch (ex) {}
      }
    }

    return null;
  }

  static num tryParseNumber(dynamic value) {
    if (value != null) {
      if (value is String) {
        return num.tryParse(value) ?? 0;
      } else if (value is int) {
        return value;
      } else if (value is double) {
        return value;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  static bool tryParseBool(dynamic value) {
    if (value != null) {
      if (value is String) {
        return bool.tryParse(value) ?? false;
      } else if (value is int) {
        return value == 1;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static String date(Jiffy? jiffy) {
    if (jiffy != null) {
      return jiffy.format(pattern: "d MMM 'yy");
    } else {
      return "N/A";
    }
  }

  static String dateTime(Jiffy? jiffy) {
    if (jiffy != null) {
      return jiffy.format(pattern: "d MMM 'yy HH:mm");
    } else {
      return "N/A";
    }
  }


  static String dateDetail(Jiffy? jiffy) {
    if (jiffy != null) {
      return jiffy.format(pattern: "dd-MM-yyyy");
    } else {
      return "N/A";
    }
  }

  static String dateMonth(Jiffy? jiffy) {
    if (jiffy != null) {
      return jiffy.format(pattern: "dd MMM ''yy");
    } else {
      return "N/A";
    }
  }

}
