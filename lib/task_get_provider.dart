import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'data/database.dart';
import 'main.dart';

final taskGetProvider = FutureProvider.family<Task?, String>((ref, id) async {
  return await (database.select(database.tasks)..where((task) => task.id.isValue(id))).getSingleOrNull();
});