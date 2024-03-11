import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tx_tx/models/home_list_item.dart';
import 'package:tx_tx/models/word_list_notifier.dart';

class WordPage extends ConsumerWidget {
  const WordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final homeItem = ModalRoute.of(context)!.settings.arguments as HomeListItem;
    final uuid = homeItem.uuid;
    final wordList = ref.watch(wordListProvider(uuid));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Word Page"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ), // 返回箭头
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter something',
              ),
              onSubmitted: (value) {
                ref
                    .read(wordListProvider(uuid).notifier)
                    .addWord(controller.text);
                controller.clear();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: wordList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(wordList[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => ref
                        .read(wordListProvider(uuid).notifier)
                        .removeWord(index),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
