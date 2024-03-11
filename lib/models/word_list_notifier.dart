import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final wordListProvider =
    StateNotifierProvider.family<WordListNotifier, List<String>, String>(
        (ref, uuid) => WordListNotifier(uuid));

class WordListNotifier extends StateNotifier<List<String>> {
  final String uuid;

  WordListNotifier(this.uuid) : super([]) {
    // 从 Hive 加载数据
    final box = Hive.box('myBox');
    final wordListItems =
        box.get('wordList_$uuid', defaultValue: <String>[])?.cast<String>();
    state = wordListItems ?? [];
  }

  void addWord(String word) {
    state = [...state, word];
    // 保存到 Hive
    final box = Hive.box('myBox');
    box.put('wordList_$uuid', state);
  }

  void removeWord(int index) {
    List<String> newWordList =
        state.where((word) => state.indexOf(word) != index).toList();
    state = newWordList;
    // 保存到 Hive
    final box = Hive.box('myBox');
    box.put('wordList_$uuid', newWordList);
  }

  void removeAllWords() {
    state = [];
    // 保存到 Hive
    final box = Hive.box('myBox');
    box.put('wordList_$uuid', state);
  }
}
