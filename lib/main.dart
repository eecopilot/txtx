import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tx_tx/pages/home_page.dart';
import 'package:tx_tx/pages/word_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tx_tx/utils/home_list_item.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HomeListItemAdapter());
// 打开 Hive 盒子
  await Hive.openBox('myBox');
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const HomePage(),
        "/word_page": (context) => const WordPage(),
      },
      initialRoute: '/',
      // home: const Scaffold(
      //   body: HomePage(),
      // ),
    );
  }
}
