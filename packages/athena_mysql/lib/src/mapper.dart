enum _TokeType { text, variable }

class _TokenConent {
  _TokenConent(this.type);
  _TokenConent.variable(int char) : type = _TokeType.variable {
    addChar(char);
  }
  _TokenConent.text(int char) : type = _TokeType.text {
    addChar(char);
  }
  _TokeType type;
  StringBuffer content = StringBuffer();

  void addChar(int char) {
    content.writeCharCode(char);
  }
}

class _TokenIdentifier {
  _TokenIdentifier(this.name, this.typeCast);
  final String name;
  final String? typeCast;
}

class _QueryNameArguments {
  _QueryNameArguments(this.query, this.argsMap);
  final String query;
  final List<String> argsMap;
}

/// Represents a query to execute
class QueryToExecute {
  /// Creates a query to execute
  const QueryToExecute(this.query, this.args);

  /// The query to execute
  final String query;

  /// The arguments to pass to the query
  final List<dynamic> args;
}

/// Maps a query to a query to execute
class QueryMapper {
  /// Creates a query mapper
  QueryMapper({String? signCode, bool numered = false, String? prefixQuery})
      : _prefixCode = (signCode ?? '@').codeUnitAt(0),
        _numered = numered,
        _prefixQuery = prefixQuery ?? r'$';
  final int _prefixCode;
  final bool _numered;
  final String _prefixQuery;

  static bool _isIdentifier(int charCode) {
    return (charCode >= _lowercaseACodeUnit &&
            charCode <= _lowercaseZCodeUnit) ||
        (charCode >= _uppercaseACodeUnit && charCode <= _uppercaseZCodeUnit) ||
        (charCode >= _codeUnit0 && charCode <= _codeUnit9) ||
        (charCode == _underscoreCodeUnit) ||
        (charCode == _colonCodeUnit);
  }

  static final int _lowercaseACodeUnit = 'a'.codeUnitAt(0);
  static final int _uppercaseACodeUnit = 'A'.codeUnitAt(0);
  static final int _lowercaseZCodeUnit = 'z'.codeUnitAt(0);
  static final int _uppercaseZCodeUnit = 'Z'.codeUnitAt(0);
  static final int _codeUnit0 = '0'.codeUnitAt(0);
  static final int _codeUnit9 = '9'.codeUnitAt(0);
  static final int _underscoreCodeUnit = '_'.codeUnitAt(0);
  static final int _colonCodeUnit = ':'.codeUnitAt(0);

  List<_TokenConent> _getTokenized(String query) {
    final iter = RuneIterator(query);

    final items = <_TokenConent>[];
    _TokenConent? currentPtr;
    while (iter.moveNext()) {
      if (currentPtr == null) {
        if (iter.current == _prefixCode) {
          print('found @');
          currentPtr = _TokenConent.variable(iter.current);
          items.add(currentPtr);
        } else {
          currentPtr = _TokenConent.text(iter.current);
          items.add(currentPtr);
        }
      } else if (currentPtr.type == _TokeType.text) {
        if (iter.current == _prefixCode) {
          currentPtr = _TokenConent.variable(iter.current);
          items.add(currentPtr);
        } else {
          currentPtr.addChar(iter.current);
        }
      } else if (currentPtr.type == _TokeType.variable) {
        if (iter.current == _prefixCode) {
          iter.movePrevious();
          if (iter.current == _prefixCode) {
            currentPtr
              ..addChar(iter.current)
              ..type = _TokeType.text;
          } else {
            currentPtr = _TokenConent.variable(iter.current);
            items.add(currentPtr);
          }
          iter.moveNext();
        } else if (_isIdentifier(iter.current)) {
          currentPtr.addChar(iter.current);
        } else {
          currentPtr = _TokenConent.text(iter.current);
          items.add(currentPtr);
        }
      }
    }
    return items;
  }

  static _TokenIdentifier _getIdentifier(String t) {
    String name;
    String? typeCast;

    final components = t.split('::');
    if (components.length > 1) {
      typeCast = components.sublist(1).join();
    }

    final variableComponents = components.first.split(':');
    if (variableComponents.length == 1) {
      name = variableComponents.first;
    } else if (variableComponents.length == 2) {
      name = variableComponents.first;
    } else {
      throw FormatException(
          // ignore: lines_longer_than_80_chars
          "Invalid format string identifier, must contain identifier name and optionally one data type in format '@identifier:dataType' (offending identifier: $t)");
    }

    // Strip @
    name = name.substring(1, name.length);
    return _TokenIdentifier(name, typeCast);
  }

  _QueryNameArguments _generateBuilder(List<_TokenConent> items) {
    final args = <String>[];
    final content = items.map((t) {
      if (t.type == _TokeType.text) {
        return t.content;
      } else if (t.content.length == 1 && t.content.toString() == '@') {
        return t.content;
      } else {
        final identifier = _getIdentifier(t.content.toString());

        var val = '$_prefixQuery${_numered ? args.length : ''}';
        final indexOfContent = args.indexOf(identifier.name);
        if (indexOfContent == -1 || !_numered) {
          args.add(identifier.name);
        } else {
          val = '$_prefixQuery$indexOfContent';
        }
        if (identifier.typeCast != null) {
          return '$val::${identifier.typeCast}';
        }
        return val;
      }
    }).join();

    return _QueryNameArguments(content, args);
  }

  /// Gets the values of a query
  QueryToExecute getValues(String query, Map<String, dynamic> values) {
    final tokens = _getTokenized(query);
    final built = _generateBuilder(tokens);

    final args = built.argsMap.map((key) => values[key]);

    return QueryToExecute(built.query, args.toList());
  }
}
