import 'package:athena_sql/athena_sql.dart';
import 'package:athena_sql/query_printable.dart';
import 'package:athena_sql/schemas.dart';

/// Column Builder for Postgres
typedef CSBuilder<D extends AthenaDriver> = AthenaQueryBuilder<D, ColumnSchema>;

/// Column Options Builder for Postgres
extension ColumnOptionsBuilder<D extends AthenaDriver> on CSBuilder<D> {
  /// set compression to column
  CSBuilder<D> compression(String compression) {
    return $addingPreContrains(
        QueryString().keyword('COMPRESSION ').userInput(compression));
  }

  /// set collate to column
  CSBuilder<D> collate(String collate) {
    return $addingPreContrains(
        QueryString().keyword('COLLATE ').userInput(collate));
  }
}
