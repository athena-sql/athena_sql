import 'package:athena_sql/src/builders/builders.dart';

class TestDriver extends AthenaStringDriver {}

String normalizeSql(String sql) {
  return sql
      .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with a single space
      .replaceAll('\n', ' ') // Remove line breaks
      .trim(); // Remove leading and trailing spaces
}