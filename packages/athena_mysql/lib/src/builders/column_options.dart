import 'package:athena_sql/athena_sql.dart';
import 'package:athena_sql/query_printable.dart';
import 'package:athena_sql/schemas.dart';

/// Column options for Athena
typedef CSBuilder<D extends AthenaDriver> = AthenaQueryBuilder<D, ColumnSchema>;

/// Column options for Athena
extension ColumnOptionsBuilder<D extends AthenaDriver> on CSBuilder<D> {
  /// Set Compression for the column
  CSBuilder<D> compression(String compression) {
    return $addingPreContrains(
        QueryString().keyword('COMPRESSION ').userInput(compression));
  }

  /// Set Collate for the column
  CSBuilder<D> collate(String collate) {
    return $addingPreContrains(
        QueryString().keyword('COLLATE ').userInput(collate));
  }
}
