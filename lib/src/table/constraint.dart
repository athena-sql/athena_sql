import 'package:athena_sql/query_string.dart';

abstract class ColumnConstrains {
  final String? name;
  const ColumnConstrains({this.name});
  QueryString get _value;
  QueryString printable() => QueryString()
      .condition(name != null,
          (q) => q.keyword('CONSTRAINT').space().userInput('$name').space())
      .adding(_value);
}

class NotNullContraint extends ColumnConstrains {
  const NotNullContraint({
    super.name,
  });
  @override
  QueryString get _value => QueryString.keyword('NOT NULL');
}

class PrimaryKeyContraint extends ColumnConstrains {
  const PrimaryKeyContraint({
    super.name,
  });

  @override
  QueryString get _value => QueryString.keyword('PRIMARY KEY');
}

class CheckContraint extends ColumnConstrains {
  final String _expression;
  const CheckContraint(
    this._expression, {
    super.name,
  });

  @override
  QueryString get _value => QueryString()
      .keyword('CHECK')
      .space()
      .parentesis((q) => q.userInput(_expression));
}

class UniqueContraint extends ColumnConstrains {
  final bool? nullsNotDistinct;
  const UniqueContraint({super.name, this.nullsNotDistinct});
  @override
  QueryString get _value => QueryString().keyword('UNIQUE').condition(
      nullsNotDistinct != null,
      (q) => q
          .keyword('NULLS ')
          .condition(nullsNotDistinct!, (q) => q.keyword('NOT '))
          .keyword('DISTINCT'));
}

class DefaultContraint extends ColumnConstrains {
  final String _expression;
  const DefaultContraint(
    this._expression, {
    super.name,
  });

  @override
  QueryString get _value =>
      QueryString().keyword('DEFAULT ').userFunction(_expression);
}

class ReferencialActionAction {
  final String _action;
  final List<String> _columns;
  const ReferencialActionAction._(this._action) : _columns = const <String>[];
  static const ReferencialActionAction cascade =
      ReferencialActionAction._('CASCADE');
  static const ReferencialActionAction restrict =
      ReferencialActionAction._('RESTRICT');
  static const ReferencialActionAction noAction =
      ReferencialActionAction._('NO ACTION');

  ReferencialActionAction.setNull([this._columns = const <String>[]])
      : _action = 'SET NULL';
  ReferencialActionAction.setDefault([this._columns = const <String>[]])
      : _action = 'SET DEFAULT';
  QueryString get _value => QueryString().keyword(_action).condition(
      _columns.isNotEmpty,
      (q) => q.parentesis(
          (q) => q.comaSeparated(_columns.map((e) => QueryString.user(e)))));
}

enum ReferencialActionRule {
  onUpdate,
  onDelete;

  String get _value {
    switch (this) {
      case ReferencialActionRule.onUpdate:
        return 'ON UPDATE';
      case ReferencialActionRule.onDelete:
        return 'ON DELETE';
    }
  }
}

class ReferencialAction {
  final ReferencialActionRule _rule;
  final ReferencialActionAction _action;
  const ReferencialAction(this._rule, this._action);
  QueryString get _value =>
      QueryString().keyword('ON ${_rule._value} ').adding(_action._value);
}

class ReferencialActionBuilder {
  final ReferencialActionRule _rule;
  ReferencialActionBuilder(this._rule);
  ReferencialAction cascade() =>
      ReferencialAction(_rule, ReferencialActionAction.cascade);
  ReferencialAction restrict() =>
      ReferencialAction(_rule, ReferencialActionAction.restrict);
  ReferencialAction noAction() =>
      ReferencialAction(_rule, ReferencialActionAction.noAction);
  ReferencialAction setNull({List<String> columns = const <String>[]}) =>
      ReferencialAction(_rule, ReferencialActionAction.setNull(columns));
  ReferencialAction setDefault({List<String> columns = const <String>[]}) =>
      ReferencialAction(_rule, ReferencialActionAction.setDefault(columns));
}

class ReferencialActionRuleBuilder {
  ReferencialActionBuilder onUpdate() =>
      ReferencialActionBuilder(ReferencialActionRule.onUpdate);
  ReferencialActionBuilder onDelete() =>
      ReferencialActionBuilder(ReferencialActionRule.onDelete);
}

class ReferencesContraint extends ColumnConstrains {
  final String _table;
  final String? _column;
  final ReferencialAction? _action;
  ReferencesContraint({
    super.name,
    required String table,
    String? column,
    ReferencialAction Function(ReferencialActionRuleBuilder)? on,
  })  : _table = table,
        _column = column,
        _action = on?.call(ReferencialActionRuleBuilder());

  @override
  QueryString get _value => QueryString()
      .keyword('REFERENCES ')
      .userInput('$_table ')
      .condition(
          _column != null, (q) => q.parentesis((q) => q.userInput(_column!)))
      .condition(_action != null, (q) => q.space().adding(_action!._value));
}
