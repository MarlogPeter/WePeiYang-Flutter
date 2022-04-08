import 'package:flutter/material.dart';
import 'package:we_pei_yang_flutter/auth/network/theme_service.dart';

import 'package:we_pei_yang_flutter/commons/preferences/common_prefs.dart';
import 'package:we_pei_yang_flutter/commons/util/font_manager.dart';
import 'package:we_pei_yang_flutter/commons/util/toast_provider.dart';
import 'package:we_pei_yang_flutter/commons/widgets/loading.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/round_taggings.dart';
import 'package:we_pei_yang_flutter/main.dart';

import '../../skin_utils.dart';

class ThemeChangePage extends StatefulWidget {
  @override
  _ThemeChangePageState createState() => _ThemeChangePageState();
}

class _ThemeChangePageState extends State<ThemeChangePage> {
  var pref = CommonPreferences();
  List<Skin> skins = [];
  bool isReady = false;
  int selected;

  Widget ThemeCard(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selected = skins[index].id;
        });
      },
      child: AnimatedContainer(
        height: selected == skins[index].id ? (WePeiYangApp.screenWidth - 28) * 0.5 : (WePeiYangApp.screenWidth - 28) * 0.3,
        margin: EdgeInsets.fromLTRB(14, 12, 14, 2),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutBack,
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(skins[index].selfPageImage, fit: BoxFit.fitWidth),
                Positioned(
                    bottom: 4, right: 8, child: TextPod(skins[index].name)),
              ],
            )),
      ),
    );
  }

  Widget DefaultThemeCard(int ind) {
    return InkWell(
      onTap: () => setState(() => selected = ind),
      child: AnimatedContainer(
          height: selected == ind ? (WePeiYangApp.screenWidth - 28) * 0.5 : (WePeiYangApp.screenWidth - 28) * 0.3,
          margin: EdgeInsets.fromLTRB(14, 12, 14, 2),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutBack,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/user_back.png',
                      fit: BoxFit.fitWidth),
                  ColoredBox(color: ind == -1 ? Colors.white54 : Colors.black12),
                  Positioned(
                    bottom: 4,
                    right: 8,
                    child: TextPod(ind == -1 ? '默认-白' : '默认-黑'),
                  )
                ],
              ))),
    );
  }

  @override
  void initState() {
    ThemeService.loginFromClient(onSuccess: () async {
      ToastProvider.success('登录成功' + CommonPreferences().themeToken.value);
      await ThemeService.getSkins().then((list) {
        skins.clear();
        skins.addAll(list);
        setState(() {
          isReady = true;
        });
      });
    }, onFailure: () {
      ToastProvider.success('登陆失败' + CommonPreferences().themeToken.value);
    });
    //onFailure: ToastProvider.error('皮肤界面登录失败'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('主题皮肤',
                style: FontManager.YaHeiRegular.copyWith(
                    fontSize: 16,
                    color: Color.fromRGBO(36, 43, 69, 1),
                    fontWeight: FontWeight.bold)),
            elevation: 0,
            brightness: Brightness.light,
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: GestureDetector(
                  child: Icon(Icons.arrow_back,
                      color: Color.fromRGBO(53, 59, 84, 1.0), size: 32),
                  onTap: () => Navigator.pop(context)),
            )),
        body: isReady
            ? ListView.builder(
                itemCount: skins.length + 1,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) return Column(
                    children: [
                      DefaultThemeCard(-1),
                      DefaultThemeCard(-2)
                    ],
                  );
                  index--;
                  return ThemeCard(index);
                },
              )
            : Center(child: Loading()));
  }
}
