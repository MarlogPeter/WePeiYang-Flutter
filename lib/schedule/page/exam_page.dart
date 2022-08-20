// @dart = 2.12
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_pei_yang_flutter/commons/util/text_util.dart';
import 'package:we_pei_yang_flutter/main.dart';
import 'package:we_pei_yang_flutter/auth/view/info/tju_rebind_dialog.dart';
import 'package:we_pei_yang_flutter/commons/network/wpy_dio.dart'
    show WpyDioError;
import 'package:we_pei_yang_flutter/commons/preferences/common_prefs.dart';
import 'package:we_pei_yang_flutter/commons/res/color.dart';
import 'package:we_pei_yang_flutter/commons/util/router_manager.dart';
import 'package:we_pei_yang_flutter/commons/util/toast_provider.dart';
import 'package:we_pei_yang_flutter/feedback/util/color_util.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/april_fool_dialog.dart';
import 'package:we_pei_yang_flutter/schedule/model/exam.dart';
import 'package:we_pei_yang_flutter/schedule/model/exam_provider.dart';

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  _ExamPageState() {
    WePeiYangApp.navigatorState.currentContext!
        .read<ExamProvider>()
        .refreshExam();
  }

  get _color {
    return CommonPreferences.isSkinUsed.value
        ? Color(CommonPreferences.skinColorB.value)
        : FavorColors.scheduleTitleColor;
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      elevation: 0,
      leading: GestureDetector(
          child: Icon(Icons.arrow_back, color: _color, size: 32.r),
          onTap: () => Navigator.pop(context)),
      actions: [
        IconButton(
          icon: Icon(Icons.autorenew, color: _color, size: 28.r),
          onPressed: () {
            if (CommonPreferences.isBindTju.value) {
              context.read<ExamProvider>().refreshExam(
                  hint: true,
                  onFailure: (e) {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) => TjuRebindDialog(
                            reason:
                                e is WpyDioError ? e.error.toString() : null));
                  });
            } else {
              ToastProvider.error("请绑定办公网");
              Navigator.pushNamed(context, AuthRouter.tjuBind);
            }
          },
        ),
        SizedBox(width: 10.w),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Consumer<ExamProvider>(
          builder: (context, provider, _) {
            List<Widget> unfinished = provider.unfinished.isEmpty
                ? [
                    Center(
                        child: Text('没有未完成的考试哦',
                            style: TextUtil.base.w300.greyA6.sp(12)))
                  ]
                : provider.unfinished
                    .map((e) => examCard(context, e, false))
                    .toList();
            List<Widget> finished = provider.finished.isEmpty
                ? [
                    Center(
                        child: Text('没有已完成的考试哦',
                            style: TextUtil.base.w300.greyA6.sp(12)))
                  ]
                : provider.finished
                    .map((e) => examCard(context, e, true))
                    .toList();
            return ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: 10.h),
                Text('未完成',
                    style: TextUtil.base.bold.sp(16).customColor(_color)),
                SizedBox(height: 5.h),
                ...unfinished,
                SizedBox(height: 15.h),
                Text('已完成',
                    style: TextUtil.base.bold.sp(16).customColor(_color)),
                SizedBox(height: 5.h),
                ...finished,
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget examCard(BuildContext context, Exam exam, bool finished) {
  int code = exam.name.hashCode + DateTime.now().day;

  ///愚人节配色
  var unfinishedColor = CommonPreferences.isAprilFool.value
      ? ColorUtil.aprilFoolColor[code % ColorUtil.aprilFoolColor.length]
      : CommonPreferences.isSkinUsed.value
          ? FavorColors.homeSchedule[code % FavorColors.homeSchedule.length]
          : FavorColors.scheduleColor[code % FavorColors.scheduleColor.length];
  var name = exam.name;
  if (name.length >= 10) name = name.substring(0, 10) + '...';
  String remain = '';
  if (finished) {
    remain = '';
  } else if (exam.date == '时间未安排') {
    remain = 'Unknown';
  } else {
    var now = DateTime.now();
    var realNow = DateTime(now.year, now.month, now.day);
    var target = DateTime.parse(exam.date);
    var diff = target.difference(realNow).inDays;
    remain = (diff == 0) ? 'today' : '${diff}days';
  }
  var seat = exam.seat;
  if (seat != '地点未安排') seat = '座位' + seat;
  return Padding(
    padding: EdgeInsets.fromLTRB(0, 4.h, 14.w, 4.h),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        decoration: BoxDecoration(
          color: finished ? Color.fromRGBO(236, 238, 237, 1) : unfinishedColor,
        ),
        child: InkWell(
          onTap: () {
            if (CommonPreferences.isAprilFool.value) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AprilFoolDialog(
                    content: '${exam.name}, \n第二天将自动回到正常考表',
                    confirmText: "返回真实考表",
                    cancelText: "这样也挺好",
                    confirmFun: () {
                      CommonPreferences.isAprilFool.value = false;
                      if (CommonPreferences.isBindTju.value) {
                        Provider.of<ExamProvider>(context, listen: false)
                            .refreshExam(
                                hint: true,
                                onFailure: (e) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) =>
                                          TjuRebindDialog(
                                              reason: e is WpyDioError
                                                  ? e.error.toString()
                                                  : null));
                                });
                      } else {
                        ToastProvider.error("请绑定办公网");
                        Navigator.pushNamed(context, AuthRouter.tjuBind);
                      }
                      Navigator.popAndPushNamed(context, HomeRouter.home);
                    },
                  );
                },
              );
            }
          },
          borderRadius: BorderRadius.circular(10.r),
          splashFactory: InkRipple.splashFactory,
          child: Stack(
            children: [
              DefaultTextStyle(
                style: TextStyle(
                    color: finished
                        ? Color.fromRGBO(205, 206, 210, 1)
                        : Colors.white),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextUtil.base.sp(20)),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Spacer(),
                          Text(exam.arrange,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 17.r,
                              color: finished
                                  ? Color.fromRGBO(205, 206, 210, 1)
                                  : Colors.white),
                          SizedBox(width: 3.w),
                          Text('${exam.location}-$seat',
                              overflow: TextOverflow.ellipsis,
                              style: TextUtil.base.w300.sp(14)),
                          Spacer(),
                          Text(exam.date,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 1.h,
                child: Text(remain,
                    style: TextUtil.base.Bauhaus.bold.italic
                        .h(0)
                        .sp(55)
                        .customColor(Colors.white38)),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}