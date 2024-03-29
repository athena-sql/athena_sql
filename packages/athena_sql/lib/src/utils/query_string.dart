import 'package:athena_utils/athena_utils.dart';

abstract class QueryBuilder extends QueryPrintable {
  const QueryBuilder();
  QueryPrintable build();

  @override
  String printable() {
    return build().printable();
  }

  @override
  String plain() {
    return build().plain();
  }

  @override
  bool get isEmpty => build().isEmpty;
}

abstract class QueryPrintable {
  const QueryPrintable();
  String printable();
  String plain();

  bool get isEmpty;
}

class QueryStringSection extends QueryPrintable {
  String value;
  TokensColor? color;
  QueryStringSection(this.value, {this.color});

  @override
  String printable() {
    if (color == null) {
      return value;
    }
    return '\x1B[${color!.code}m$value\x1B[0m';
  }

  @override
  String plain() {
    return value;
  }

  QueryString operator +(QueryPrintable value) {
    return QueryString._sections([this, value]);
  }

  @override
  bool get isEmpty => value.isEmpty;
}

typedef FunctionQueryBuilder = QueryPrintable Function(QueryString);

class QueryString extends QueryPrintable {
  final List<QueryPrintable> sections;
  QueryString() : sections = <QueryPrintable>[];

  QueryString.keyword(String value)
      : sections = value.isEmpty
            ? <QueryStringSection>[]
            : [QueryStringSection(value, color: TokensColor.blue)];

  QueryString.user(String value)
      : sections = value.isEmpty
            ? <QueryStringSection>[]
            : [QueryStringSection(value, color: TokensColor.blue)];

  QueryString.special(String value)
      : sections = value.isEmpty
            ? <QueryStringSection>[]
            : [QueryStringSection(value, color: TokensColor.blue)];

  QueryString._sections([this.sections = const <QueryStringSection>[]]);

  @override
  String printable() {
    return sections.map((e) => e.printable()).join();
  }

  @override
  String toString() {
    return sections.map((e) => e.toString()).join();
  }

  void add(QueryPrintable value) {
    sections.add(value);
  }

  QueryString adding(QueryPrintable value) {
    return QueryString._sections([...sections, value]);
  }

  QueryString operator +(QueryStringSection value) {
    sections.add(value);
    return this;
  }

  QueryStringSection _new(String value, [TokensColor? color]) {
    return QueryStringSection(value, color: color);
  }

  QueryString keyword(String value) {
    return adding(_new(value, TokensColor.blue));
  }

  QueryString condition(bool? compare, FunctionQueryBuilder fn,
      {FunctionQueryBuilder? elseClause}) {
    if (compare == true) {
      return adding(fn(QueryString()));
    } else {
      return elseClause == null ? this : adding(elseClause(QueryString()));
    }
  }

  QueryString notNull<T>(T? compare, QueryPrintable Function(QueryString, T) fn,
      {FunctionQueryBuilder? elseClause}) {
    if (compare != null) {
      return adding(fn(QueryString(), compare));
    } else {
      return elseClause == null ? this : adding(elseClause(QueryString()));
    }
  }

  QueryString userInput(String value) {
    return adding(_new(value, TokensColor.white));
  }

  QueryString userFunction(String value) {
    return adding(_new(value, TokensColor.green));
  }

  QueryString column(String value) {
    return adding(_new(value, TokensColor.white));
  }

  QueryString special(String value) {
    return adding(_new(value, TokensColor.yellow));
  }

  QueryString space() {
    return adding(_new(' '));
  }

  QueryString parentheses(FunctionQueryBuilder fn) {
    return special("(").adding(fn(QueryString())).special(")");
  }

  QueryString join(Iterable<QueryPrintable> values,
      [QueryPrintable? separator]) {
    Iterator<QueryPrintable> iterator = values.iterator;
    if (!iterator.moveNext()) return this;
    final sections = <QueryPrintable>[];

    if (separator == null || separator.isEmpty) {
      do {
        sections.add(iterator.current);
      } while (iterator.moveNext());
    } else {
      sections.add(iterator.current);
      while (iterator.moveNext()) {
        sections.add(separator);
        sections.add(iterator.current);
      }
    }
    return adding(QueryString._sections(sections));
  }

  QueryString commaSeparated(Iterable<QueryPrintable> values) {
    return join(values, QueryString.special(","));
  }

  QueryString spaceSeparated(Iterable<QueryPrintable> values) {
    return join(values, QueryString.special(" "));
  }

  QueryString comaSpaceSeparated(Iterable<QueryPrintable> values) {
    return join(values, QueryString.special(", "));
  }

  @override
  bool get isEmpty => sections.isEmpty;

  @override
  String plain() {
    return sections.map((e) => e.plain()).join();
  }
}

extension Exten on List<QueryPrintable> {
  QueryString build() {
    return QueryString._sections(this);
  }
}
