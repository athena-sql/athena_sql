import '../../query_string.dart';

enum Locale { global, local }

enum CompressionMethod { pglz, zstd }

abstract class TablePosibleAddition extends QueryBuilder {}
