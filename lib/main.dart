import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:consignment/src/features/login/pages/login_page.dart';
import 'package:consignment/core/di/app_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env 로드 (pubspec.yaml assets에 - .env 추가되어 있어야 함)
  await dotenv.load(fileName: '.env');

  runApp(const ConsignmentApp());
}

class ConsignmentApp extends StatelessWidget {
  const ConsignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Consignment Driver',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8A00)),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
