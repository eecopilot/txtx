import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tx_tx/components/tag_date_input_dialog.dart';
import 'package:tx_tx/models/home_list_item.dart';
import 'package:tx_tx/models/home_list_notifier.dart';
import 'package:intl/intl.dart';
import 'package:tx_tx/models/word_list_notifier.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> clearAllHiveBoxes() async {
    final boxNames = ['myBox'];
    for (final boxName in boxNames) {
      final box = await Hive.openBox(boxName);
      await box.clear();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void removeItem(BuildContext content, HomeListItem item) {
      ref.watch(homeListProvider.notifier).removeItem(item);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        leading: const Icon(Icons.menu),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: ref.read(homeListProvider).isNotEmpty,
                child: const Text('Clear Hive Data'),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Clear Hive Data'),
                      content: const Text(
                          'Are you sure you want to clear all Hive data?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await clearAllHiveBoxes().then((value) {
                              ref
                                  .watch(homeListProvider.notifier)
                                  .removeAllItems();
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Hive data cleared'),
                                ),
                              );
                            });
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushNamed(context, "/word_page");
          showDialog(
            context: context,
            builder: (context) => const TagDateInputDialog(),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.add,
        ),
      ),
      body: ListView.builder(
        itemCount: ref.watch(homeListProvider).length,
        itemBuilder: (context, index) {
          final String formattedDate = DateFormat('yy/MM HH:mm')
              .format(ref.watch(homeListProvider)[index].date);
          final item = ref.watch(homeListProvider)[index];
          return Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    removeItem(context, item);
                    // 删除wordList中的单词
                    ref
                        .read(wordListProvider(item.uuid).notifier)
                        .removeAllWords();
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
              ],
            ),
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/word_page", arguments: item);
              },
              title: Text(
                "标题:${item.title}",
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                formattedDate,
                style: TextStyle(color: Colors.grey.shade500),
              ),
              trailing: Text(item.uuid.substring(0, 8)),
            ),
          );
        },
      ),
    );
  }
}
