part of 'builders.dart';

abstract class AthenaRowResponse implements Map<String, dynamic> {}

abstract class AthenaQueryResponse implements List<AthenaRowResponse> {
  final int affectedRows;

  AthenaQueryResponse(this.affectedRows);
}

class QueryRow extends UnmodifiableMapView<String, dynamic>
    implements AthenaRowResponse {
  QueryRow(super.map);
}

class QueryResponse extends UnmodifiableListView<AthenaRowResponse>
    implements AthenaQueryResponse {
  @override
  final int affectedRows;
  QueryResponse(super.row, {this.affectedRows = 0});
}
