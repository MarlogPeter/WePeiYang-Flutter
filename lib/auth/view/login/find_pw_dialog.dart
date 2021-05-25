import 'package:flutter/material.dart';
import 'package:wei_pei_yang_demo/home/model/home_model.dart';
import 'package:wei_pei_yang_demo/generated/l10n.dart';
import 'package:wei_pei_yang_demo/commons/util/font_manager.dart';

class FindPwDialog extends Dialog {
  static final _hintStyle = FontManager.YaHeiRegular.copyWith(
      fontSize: 12,
      color: Color.fromRGBO(79, 88, 107, 1),
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: GlobalModel().screenWidth - 40,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromRGBO(237, 240, 244, 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 18, top: 30, right: 5),
                    child: Text(S.current.has_not_bind_hint1,
                        style: _hintStyle, textAlign: TextAlign.center),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 18, top: 2, right: 5),
                    child: Text(S.current.has_not_bind_hint2,
                        style: _hintStyle, textAlign: TextAlign.center),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close,
                    color: Color.fromRGBO(210, 210, 210, 1), size: 25),
              ),
            )
          ],
        ),
      ),
    );
  }
}
