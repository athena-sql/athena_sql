import '../../utils/query_string.dart';

enum Locale { global, local }

enum CompressionMethod { pglz, zstd }

abstract class CreateTableClause extends QueryBuilder {}
