import 'package:get/get.dart';

class HelpFAQModel {
  final String title;
  final String subTitle;
  final RxBool isExpanded;

  HelpFAQModel({
    required this.title,
    required this.subTitle,
    bool expanded = false,
  }) : isExpanded = RxBool(expanded);
}
