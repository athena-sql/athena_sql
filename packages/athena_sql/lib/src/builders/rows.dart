part of 'builders.dart';

abstract class AthenaRowResponse implements Map<String, dynamic> {}

abstract class AthenaQueryResponse implements List<AthenaRowResponse> {
  const AthenaQueryResponse();
}

class QueryRow extends UnmodifiableMapView<String, dynamic>
    implements AthenaRowResponse {
  QueryRow(super.map);
}

class QueryResponse extends UnmodifiableListView<AthenaRowResponse>
    implements AthenaQueryResponse {
  QueryResponse(super.row);
}
