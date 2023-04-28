import 'package:athena_sql/athena_sql.dart';
import 'package:athena_sql/schemas.dart';
import 'package:athena_sql/query_printable.dart';

typedef CSBuilder<D extends AthenaDriver> = AthenaQueryBuilder<D, ColumnSchema>;

extension ColumnOptionsBuilder<D extends AthenaDriver> on CSBuilder<D> {
  CSBuilder<D> compression(String compression) {
    return $addingPreContrains(
        QueryString().keyword('COMPRESSION ').userInput(compression));
  }

  CSBuilder<D> collate(String collate) {
    return $addingPreContrains(
        QueryString().keyword('COLLATE ').userInput(collate));
  }
}
