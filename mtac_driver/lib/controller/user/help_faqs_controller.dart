import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/model/help_faqs_model.dart';

class HelpFAQController extends GetxController {
  // initial varialbe search help & FQAs
  final PageController pageController = PageController();
  List<String> helpTitles = [
    'Tất cả',
    'Tổng quan',
    'Thu gom',
    'Loại rác',
    'Dịch vụ',
    'Tài khoản'
  ];
  List<String> goodRate = [
    'Lộ trình hiển thị rõ ràng, dễ đi đúng tuyến.',
    'Thông báo nhiệm vụ và điểm thu gom rất chính xác.',
    'Ứng dụng mượt, không bị giật lag khi sử dụng.',
    'Hỗ trợ định vị tốt, dễ tìm đúng địa điểm thu gom.',
    'Quản lý công việc trong ngày tiện lợi và khoa học.',
  ];
  final searchHelpFqas = TextEditingController();
  List<String> rate = ['Rất tệ', 'Tệ', 'Bình thường', 'Tốt', 'Rất Tốt'];
  List<IconData> iconRate = [
    HugeIcons.strokeRoundedAngry,
    HugeIcons.strokeRoundedSad01,
    HugeIcons.strokeRoundedMeh,
    HugeIcons.strokeRoundedRelieved01,
    HugeIcons.strokeRoundedInLove
  ];

  // obs
  final selectedHelpGeneral = 'Tất cả'.obs;
  final isSellectedRate = 0.obs;
  final selectedRateIndices = <int>[].obs;

  // sellected item rate
  void sellectedItemRate(int index) {
    isSellectedRate.value = index;
  }

  // sellected item rate
  void toggleSelectedRateGood(int index) {
    if (selectedRateIndices.contains(index)) {
      selectedRateIndices.remove(index);
    } else {
      selectedRateIndices.add(index);
    }
  }

  // selected item help & FQAs
  void selectedItemHelpFQA(String title) {
    final index = helpTitles.indexOf(title);
    if (index != -1) {
      selectedHelpGeneral.value = title;
      pageController.animateToPage(
        index,
        duration: 300.milliseconds,
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int index) {
    if (index >= 0 && index < helpTitles.length) {
      selectedHelpGeneral.value = helpTitles[index];
    }
  }

  // list FQAs
  final faqList = <HelpFAQModel>[
    HelpFAQModel(
      title: "Làm cách nào để đăng ký tài khoản trên ứng dụng?",
      subTitle:
          "Bạn có thể đăng ký bằng số điện thoại, email hoặc tài khoản Google/Facebook. Sau khi điền đầy đủ thông tin, mã xác nhận OTP sẽ được gửi để xác thực.",
    ),
    HelpFAQModel(
      title: "Tôi quên mật khẩu, phải làm sao?",
      subTitle:
          "Hãy chọn chức năng \"Quên mật khẩu\" tại màn hình đăng nhập và làm theo hướng dẫn để đặt lại mật khẩu mới.",
    ),
    HelpFAQModel(
      title: "Làm sao để biết hôm nay có lịch thu gom hay không?",
      subTitle:
          "Vào mục \"Lịch thu gom\", ứng dụng sẽ hiển thị danh sách các điểm và thời gian thu gom trong ngày hôm nay (theo vị trí của bạn).",
    ),
    HelpFAQModel(
      title: "Tôi có thể yêu cầu thu gom tại nhà không?",
      subTitle:
          "Có. Bạn chỉ cần vào mục \"Yêu cầu thu gom\", điền địa chỉ và chọn thời gian mong muốn, hệ thống sẽ gửi thông tin đến đội thu gom gần nhất.",
    ),
    HelpFAQModel(
      title: "Tôi có thể hủy yêu cầu thu gom đã gửi không?",
      subTitle:
          "Có, bạn có thể hủy yêu cầu thu gom trong phần \"Lịch sử yêu cầu\" nếu tài xế chưa xác nhận nhiệm vụ.",
    ),
    HelpFAQModel(
      title: "Làm sao để biết khi nào tài xế đến gần?",
      subTitle:
          "Khi tài xế bắt đầu nhiệm vụ, bạn có thể theo dõi vị trí của họ theo thời gian thực trong phần chi tiết yêu cầu thu gom.",
    ),
    HelpFAQModel(
      title: "Tôi muốn phản ánh về chất lượng dịch vụ thì làm thế nào?",
      subTitle:
          "Vào mục \"Phản hồi\" hoặc \"Liên hệ hỗ trợ\", điền ý kiến của bạn hoặc gửi phản ánh kèm ảnh. Bộ phận CSKH sẽ phản hồi trong vòng 24 giờ.",
    ),
    HelpFAQModel(
      title: "Tôi có thể xem lịch sử các lần thu gom không?",
      subTitle:
          "Có. Trong mục \"Lịch sử\", bạn sẽ thấy danh sách các yêu cầu thu gom trước đó, bao gồm thời gian, địa điểm và trạng thái.",
    ),
    HelpFAQModel(
      title: "Tôi có thể sử dụng ứng dụng nếu không bật định vị không?",
      subTitle:
          "Một số tính năng như định tuyến hoặc tìm điểm thu gom gần nhất yêu cầu bật GPS. Tuy nhiên, bạn vẫn có thể sử dụng ứng dụng thủ công nếu biết địa chỉ.",
    ),
    HelpFAQModel(
      title: "Có thu phí khi sử dụng dịch vụ thu gom qua ứng dụng không?",
      subTitle:
          "Tùy loại rác (tái chế, cồng kềnh, nguy hại…), có thể sẽ có mức phí tương ứng. Thông tin chi tiết về phí sẽ được hiển thị rõ ràng trước khi bạn xác nhận yêu cầu.",
    ),
  ].obs;

  void toggleExpand(int index) {
    faqList[index].isExpanded.value = !faqList[index].isExpanded.value;
  }
}
