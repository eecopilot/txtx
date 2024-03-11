import 'package:hive/hive.dart';
import 'package:tx_tx/models/home_list_item.dart';

class HomeListItemAdapter extends TypeAdapter<HomeListItem> {
  @override
  final int typeId = 0;

  @override
  HomeListItem read(BinaryReader reader) {
    final title = reader.readString();
    final dateMillis = reader.readInt32();
    final uuid = reader.readString(); // 读取 uuid 字段

    return HomeListItem(
      title: title,
      date: DateTime.fromMillisecondsSinceEpoch(dateMillis),
      uuid: uuid,
    );
  }

  @override
  void write(BinaryWriter writer, HomeListItem obj) {
    writer.writeString(obj.title);
    writer.writeInt32(obj.date.millisecondsSinceEpoch);
    writer.writeString(obj.uuid); // 写入 uuid 字段
  }
}
