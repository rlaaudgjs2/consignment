import 'package:flutter/material.dart';

import '../widgets/step_item.dart';

class OfficeRegistrationGuidePage extends StatelessWidget {
  const OfficeRegistrationGuidePage({super.key});

  static const _bg = Color(0xFFFFFFFF);
  static const _text = Color(0xFF333333);
  static const _sub = Color(0xFF828282);
  static const _primary = Color(0xFFF2B36A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _text),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '이전 화면',
          style: TextStyle(
            color: _text,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '사무실 등록 방법',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: _text,
                ),
              ),
              const SizedBox(height: 16),

              StepItem(
                stepLabel: 'STEP 1',
                content: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: _text,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(text: '상단 탭 → 설정 → '),
                      TextSpan(text: '내 정보', style: TextStyle(color: _primary)),
                      TextSpan(text: '로 이동'),
                    ],
                  ),
                ),
              ),

              StepItem(
                stepLabel: 'STEP 2',
                content: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: _text,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(text: "‘기사 정보’ 섹션에 있는 본인의 "),
                      TextSpan(text: '기사 코드', style: TextStyle(color: _primary)),
                      TextSpan(text: '\n((예)MOBI-XXXX-XXXX)를 확인'),
                    ],
                  ),
                ),
              ),

              StepItem(
                stepLabel: 'STEP 3',
                content: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: _text,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(text: '소속 사무실에 '),
                      TextSpan(text: '문의', style: TextStyle(color: _primary)),
                      TextSpan(text: '해서 앱 등록을 원한다고 전달'),
                    ],
                  ),
                ),
              ),

              StepItem(
                stepLabel: 'STEP 4',
                content: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: _text,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(text: '소속 사무실에 '),
                      TextSpan(text: '기사 코드 전달', style: TextStyle(color: _primary)),
                    ],
                  ),
                ),
              ),

              StepItem(
                stepLabel: 'STEP 5',
                content: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: _text,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(text: '사무실에서 안내하는 사무실 가상계좌에\n'),
                      TextSpan(text: '15,000원 입금', style: TextStyle(color: _primary)),
                      TextSpan(text: ' 후 이용 시작'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 6),
              const Text(
                '※ 사무실 승인/등록 처리 시간에 따라 이용 시작 시점이 달라질 수 있습니다.',
                style: TextStyle(
                  fontSize: 12,
                  color: _sub,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
