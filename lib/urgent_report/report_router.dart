import 'package:flutter/material.dart';
import 'package:we_pei_yang_flutter/urgent_report/domain_page.dart';
import 'package:we_pei_yang_flutter/urgent_report/main_page.dart';

class ReportRouter {
  static const String main = 'report/main';
  static const String domain = 'report/domain';

  static final Map<String, Widget Function(Object arguments)> routers = {
    main: (arguments) => ReportMainPage(),
    domain: (arguments) => NucPassportPage(),
  };
}
