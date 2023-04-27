part of 'builders.dart';

abstract class AthenaDriver {
  const AthenaDriver();
}

abstract class AthenaDatabaseDriver extends AthenaDriver {
  const AthenaDatabaseDriver();

  Future<int> execute(String query);

  Future<void> open();
}

abstract class AthenaStringDriver extends AthenaDriver {
  const AthenaStringDriver();
}
