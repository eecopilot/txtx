// 定义首页列表的状态管理器
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tx_tx/models/home_list_item.dart';
import 'package:uuid/uuid.dart';

final homeListProvider =
    StateNotifierProvider<HomeListNotifier, List<HomeListItem>>((ref) {
  return HomeListNotifier();
});

class HomeListNotifier extends StateNotifier<List<HomeListItem>> {
  HomeListNotifier() : super([]) {
    // 从 Hive 加载数据
    final box = Hive.box('myBox');
    final homeListItems = box
        .get('homeList', defaultValue: <HomeListItem>[])?.cast<HomeListItem>();
    state = homeListItems ?? [];
  }

  void addItem(String title, DateTime date) {
    state = [
      ...state,
      HomeListItem(title: title, date: date, uuid: const Uuid().v4())
    ];
    // 保存到 Hive
    final myBox = Hive.box('myBox');
    myBox.put('homeList', state);
  }

  void removeItem(HomeListItem item) {
    state = state.where((i) => i != item).toList();
    // 保存到 Hive
    final myBox = Hive.box('myBox');
    myBox.put('homeList', state);
  }

  void removeAllItems() {
    state = [];
    // 保存到 Hive
    final myBox = Hive.box('myBox');
    myBox.put('homeList', state);
  }

  void updateItem(HomeListItem oldItem, String newTitle, DateTime newDate) {
    state = state.map((item) {
      if (item == oldItem) {
        return HomeListItem(title: newTitle, date: newDate, uuid: oldItem.uuid);
      }
      return item;
    }).toList();
    // 保存到 Hive
    final myBox = Hive.box('myBox');
    myBox.put('homeList', state);
  }
}
