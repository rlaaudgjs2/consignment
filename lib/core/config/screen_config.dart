import 'package:flutter/widgets.dart';

///피그마 기준 해상도 (375 x 812)를 비율로 전환
///
///  - 디자인 기준 : 375 x 812
///  - 디자인에서 상태바로 잡은 높이 : 44 (실기기 상태바 높이는 아님, 비율 계산용 상수)
///
///  - 상단 탭 높이 : 68


class ScreenConfig {

  ///Figma 기준 화면 크기
  static const double designWidth = 375.0;
  static const double designHeight = 812.0;

  ///디자인 상에서의 상태바 높이 (고정값, 실제 기기의 상태바 높이와 무관)
  static const double designStatusBarHeight = 44.0;

  ///디자인 기준에서의 SafeArea 높이
  static const double designSafeHeight =
      designHeight - designStatusBarHeight; //812 - 44 = 768

  // ─────────────────────── 기본 치수/패딩 정보 ───────────────────────


  /// 전체 화면 크기 (상태바/홈바 포함)
  static Size screenSize(BuildContext context){
    return MediaQuery.of(context).size;
  }

  /// 실제 기기 상태바 높이
  static double statusBarHeight(BuildContext context){
    return MediaQuery.of(context).padding.top;
  }

  /// 실제 기기 하단 인셋(홈 인디케이터 등)
  static double bottomInset(BuildContext context){
    return MediaQuery.of(context).padding.bottom;
  }

  /// 실제 기기 SafeArea 높이 (상단/하단 인셋 제외)
  static double safeHeight(BuildContext context){
    final size = screenSize(context);
    return size.height - statusBarHeight(context) - bottomInset(context);
  }

  // ───────────────────────── 스케일 유틸 ─────────────────────────

  ///가로 비율 변환 (디자인 width 기준 375)
  ///
  /// 예) 피그마에서 100px -> w(context, 100)
  static double w(BuildContext context, double designPx){
    final width = screenSize(context).width;
    return width * designPx / designWidth;
  }

  ///세로 비율 변환 (전체 height 기준 812)
  static double h(BuildContext context, double designPx){
    final height = screenSize(context).height;
    return height * designPx / designHeight;
  }

  ///세로 비율 변환 (SafeArea 기준)
  ///
  ///피그마에서 812 중 44를 상태바로 두고, 나머지 768 영역에서
  ///컴포넌트를 배치했다는 가정 하에 사용하는 함수
  static double safeH(BuildContext context, double designPx){
    final realSafeHeight = safeHeight(context);
    return realSafeHeight * designPx / designSafeHeight;
  }

  ///폰트 크기 비율 변환 (가로 비율 기준)
  /// 예) 피그마 폰트 14 -> font(context, 14)
  static double font(BuildContext context, double designFontSize){
    final scale = screenSize(context).width / designWidth;
    return designFontSize * scale;
  }

}