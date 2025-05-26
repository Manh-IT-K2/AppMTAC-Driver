import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/configs/api_config.dart';
import 'package:mtac_driver/model/schedule_model.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailScheduleHistoryScreen extends StatelessWidget {
  const DetailScheduleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
     //
    final l10n = AppLocalizations.of(context)!;

    final Datum datum = Get.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCommon(hasMenu: false, title:  l10n.txtTitleDSH),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${l10n.txtDayDSH} ${DateFormat('yyyy-MM-dd').format(datum.collectionDate)}",
                    style: PrimaryFont.bodyTextThin(),
                  ),
                  const Spacer(),
                  Text(
                    "${l10n.txtCodeDSH} ${datum.code}",
                    style:
                        PrimaryFont.bodyTextBold().copyWith(color: Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: 3.w,
              ),
              Container(
                width: 100.w,
                height: 15.h,
                margin: EdgeInsets.only(bottom: 5.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Column(
                  children: [
                    _itemCollectionDetail(
                      icon: HugeIcons.strokeRoundedOffice,
                      title: l10n.txtNameCompanyDSH,
                      content: datum.companyName,
                      styleContent: PrimaryFont.bodyTextBold(),
                    ),
                    _itemCollectionDetail(
                      icon: HugeIcons.strokeRoundedLocation04,
                      title: l10n.txtAddressDSH,
                      content: datum.locationDetails,
                      styleContent: PrimaryFont.bodyTextMedium(),
                    ),
                    _itemCollectionDetail(
                      icon: HugeIcons.strokeRoundedWaste,
                      title: l10n.txtWasteTypeDSH,
                      content: datum.wasteType,
                      styleContent: PrimaryFont.bodyTextMedium()
                          .copyWith(color: Colors.green),
                    ),
                  ],
                ),
              ),
              Text(
                l10n.txtDetailTruckDSH,
                style: PrimaryFont.titleTextBold(),
              ),
              Container(
                width: 100.w,
                height: 10.h,
                margin: EdgeInsets.only(top: 2.w, bottom: 5.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Column(
                  children: [
                    _itemCollectionDetail(
                      icon: HugeIcons.strokeRoundedShippingTruck01,
                      title: l10n.txtNameTruckDSH,
                      content: datum.truck.name,
                      styleContent: PrimaryFont.bodyTextMedium(),
                    ),
                    _itemCollectionDetail(
                      icon: HugeIcons.strokeRoundedEdgeStyle,
                      title: l10n.txtPlateNumberDSH,
                      content: datum.truck.plateNumber,
                      styleContent: PrimaryFont.bodyTextMedium(),
                    ),
                  ],
                ),
              ),
              Text(
                l10n.txtDetailGoodsDSH,
                style: PrimaryFont.titleTextBold(),
              ),
              SizedBox(
                height: 5.w,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        l10n.txtNameWasteDSH,
                        style: PrimaryFont.bodyTextBold(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        l10n.txtNumberWasteDSH,
                        style: PrimaryFont.bodyTextBold(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.w),
              SizedBox(
                width: 100.w,
                height: 20.h,
                child: ListView.builder(
                  itemCount: datum.goods.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin:
                          EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.w),
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: kPrimaryColor.withOpacity(0.3), width: 1),
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      height: 10.w,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              datum.goods[index].name,
                              style: PrimaryFont.bodyTextMedium(),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              datum.goods[index].quantity,
                              style: PrimaryFont.bodyTextMedium(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 5.w,
              ),
              Text(
                l10n.txtDetailImageDSH,
                style: PrimaryFont.titleTextBold(),
              ),
              SizedBox(
                width: 100.w,
                height: 30.w,
                child: CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (contex, index) {
                          return Padding(
                            padding: EdgeInsets.all(2.w),
                            child: Image.network(
                              "${ApiConfig.urlImage}${datum.images[index]}",
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        childCount: datum.images.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _itemCollectionDetail extends StatelessWidget {
  const _itemCollectionDetail({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    this.styleContent,
  });
  final IconData icon;
  final TextStyle? styleContent;
  final String title, content;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 5.w,
            color: Colors.black,
          ),
          SizedBox(
            width: 2.w,
          ),
          Text(
            title,
            style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
          ),
          Expanded(
            child: Text(
              content,
              style: styleContent,
            ),
          ),
        ],
      ),
    );
  }
}
