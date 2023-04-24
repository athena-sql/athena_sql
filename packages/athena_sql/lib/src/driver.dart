abstract class AthenaDriver {
  const AthenaDriver();
}
abstract class AthenaDatabaseDriver extends AthenaDriver {
  const AthenaDatabaseDriver();

  T execute<T>(String query);
}

abstract class AthenaStringDriver extends AthenaDriver {
  const AthenaStringDriver();
}

