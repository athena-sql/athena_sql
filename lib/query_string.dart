import 'package:athena_sql/src/utils/string.dart';

enum TokensColor {
  black("30"),
  red("31"),
  green("32"),
  yellow("33"),
  blue("34"),
  magenta("35"),
  cyan("36"),
  white("37");

  final String code;
  const TokensColor(this.code);
}

abstract class QueryBuilder {
  QueryPrintable printable();
}

abstract class QueryPrintable {
  List<QueryPrintable> get sections;
  String printable();

  bool get isEmpty => sections.isEmpty;
}

class QueryStringSection extends QueryPrintable {
  String value;
  TokensColor? color;
  QueryStringSection(this.value, {this.color});

  @override
  List<QueryPrintable> get sections => [this];

  @override
  String printable() {
    if (color == null) {
      return value;
    }
    return '\x1B[${color!.code}m$value\x1B[0m';
  }

  @override
  String toString() {
    return value;
  }

  QueryString operator +(QueryStringSection value) {
    return QueryString._sections([this, value]);
  }
}

typedef FunctionQueryBuilder = QueryPrintable Function(QueryString);

class QueryString extends QueryPrintable {
  @override
  final List<QueryPrintable> sections;
  QueryString({String? value, TokensColor? color})
      : sections = value == null
            ? <QueryStringSection>[]
            : [QueryStringSection(value, color: color)];

  QueryString.keyword(String value)
      : sections = value.isEmpty
            ? <QueryStringSection>[]
            : [QueryStringSection(value, color: TokensColor.blue)];

  QueryString.function(String value)
      : sections = value.isEmpty
            ? <QueryStringSection>[]
            : [QueryStringSection(value, color: TokensColor.blue)];

  QueryString.operator(String value)
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

  QueryString.quotation(String value)
      : sections = value.isEmpty
            ? <QueryStringSection>[]
            : [QueryStringSection(value, color: TokensColor.blue)];

  QueryString.userFunction(String value)
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
    sections.addAll(value.sections);
  }

  QueryString adding(QueryPrintable value) {
    return QueryString._sections([...sections, ...value.sections]);
  }

  QueryString operator +(QueryStringSection value) {
    sections.add(value);
    return this;
  }

  QueryString keyword(String value) {
    return adding(QueryStringSection(value, color: TokensColor.blue));
  }

  QueryString condition(bool compare, FunctionQueryBuilder fn,
      {FunctionQueryBuilder? elseClause}) {
    if (compare) {
      return adding(fn(QueryString()));
    } else {
      return elseClause == null ? this : adding(elseClause(QueryString()));
    }
  }

  QueryString userInput(String value) {
    return adding(QueryStringSection(value, color: TokensColor.white));
  }

  QueryString userFunction(String value) {
    return adding(QueryStringSection(value, color: TokensColor.green));
  }
  

  QueryString column(String value) {
    if (value.containsUppercase) {
      if (value.length > 1 &&
          value[0] == '"' &&
          value[value.length - 1] == '"') {
        return adding(QueryStringSection(value, color: TokensColor.white));
      }
      return adding(QueryStringSection('"$value"', color: TokensColor.white));
    }
    return adding(QueryStringSection(value, color: TokensColor.white));
  }

  QueryString special(String value) {
    return adding(QueryStringSection(value, color: TokensColor.yellow));
  }

  QueryString space() {
    return adding(QueryStringSection(' '));
  }

  QueryString parentesis(FunctionQueryBuilder fn) {
    return special("(").adding(fn(QueryString())).special(")");
  }

  QueryString join(Iterable<QueryPrintable> values, QueryPrintable? separator) {
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
  QueryString comaSeparated(Iterable<QueryPrintable> values) {
    final separator = QueryString.special(",");
    return join(values, separator);
  }
  QueryString comaSpaceSeparated(Iterable<QueryPrintable> values) {
    final separator = QueryString.special(", ");
    return join(values, separator);
  }

  void write(String value, {TokensColor? color}) {
    value.isEmpty ? null : add(QueryString(value: value, color: color));
  }

  void addKeyword(String value) {
    add(QueryString.keyword(value));
  }

  void addFunction(String value) {
    add(QueryString.function(value));
  }

  void addOperator(String value) {
    add(QueryString.operator(value));
  }

  void addQuotation(String value) {
    add(QueryString.quotation(value));
  }

  void addSpecial(String value) {
    add(QueryString.special(value));
  }

  void addUser(String value) {
    add(QueryString.user(value));
  }

  void addUserFunction(String value) {
    add(QueryString.userFunction(value));
  }
}

extension QueryList on Iterable<QueryString> {
  QueryString joinQuery(QueryString? separator) {
    Iterator<QueryString> iterator = this.iterator;
    if (!iterator.moveNext()) return QueryString();
    QueryString buffer = QueryString();
    if (separator == null || separator.isEmpty) {
      do {
        buffer.add(iterator.current);
      } while (iterator.moveNext());
    } else {
      buffer.add(iterator.current);
      while (iterator.moveNext()) {
        buffer.add(separator);
        buffer.add(iterator.current);
      }
    }
    return buffer;
  }
}
