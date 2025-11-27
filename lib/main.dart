import 'package:flutter/material.dart';
import 'package:consignment/features/root/presentation/pages/root_tab_page.dart';

void main() {
  runApp(const ConsignmentApp());
}

class ConsignmentApp extends StatelessWidget {
  const ConsignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 우측 상단 DEBUG 배너 제거
      title: 'Consignment Driver',
      theme: ThemeData(
        // 나중에 core/theme 쪽이랑 연결
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8A00)),
        useMaterial3: true,
      ),
      home: const RootTabPage(),
    );
  }
}
