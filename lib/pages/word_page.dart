import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tx_tx/models/home_list_item.dart';
import 'package:tx_tx/models/speech_to_text_service.dart';
import 'package:tx_tx/models/word_list_notifier.dart';
import 'package:tx_tx/utils/tts.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class WordPage extends ConsumerWidget {
  const WordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final homeItem = ModalRoute.of(context)!.settings.arguments as HomeListItem;
    final uuid = homeItem.uuid;
    final wordList = ref.watch(wordListProvider(uuid));
    final textToSpeech = TextToSpeech();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Word Page"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 结束语音监听
            final speechToTextService = ref.read(speechToTextServiceProvider);
            speechToTextService.stopListening();
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
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => {
                      // 增加一个alertDialog
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Delete'),
                          content:
                              const Text('Are you sure to delete this item?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                ref
                                    .read(wordListProvider(uuid).notifier)
                                    .removeWord(index);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // 开始
          final index = ref.read(currentIndexProvider);
          await textToSpeech.speak(wordList[index]);
          final notifier = ref.read(speechToTextServiceProvider);
          // 开始监听
          await notifier.initialize();
          if (await notifier.hasPermission()) {
            await notifier.startListening((result) async {
              // print(result);
              Timer(const Duration(seconds: 2), () {
                // 获取结果的最后4个字符
                if (result.recognizedWords.length > 4) {
                  String lastFourChars = result.recognizedWords
                      .substring(result.recognizedWords.length - 4);
                  print(lastFourChars);
                }
              });
            });
          }
          // await notifier.startListening((result) async {
          //   if (result.recognizedWords.contains('下一个')) {
          //     ref.read(currentIndexProvider.notifier).state++;
          //     if (index < wordList.length - 1) {
          //       await textToSpeech.speak(wordList[index]);
          //     } else {
          //       await notifier.stopListening();
          //       // 所有单词朗读完毕,可以在这里添加相应的逻辑
          //     }
          //   }
          // });
        },
        label: const Text(
          '听写',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.mic, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
