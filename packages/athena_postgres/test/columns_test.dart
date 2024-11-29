import 'package:athena_postgres/athena_postgres.dart';
import 'package:test/test.dart';

import 'docker.dart';

void main() {
  usePostgresDocker();
  group('Columns', () {
    late AthenaPostgresql athena;

    setUp(() async {
      print('open');

      athena = await AthenaPostgresql.open(AthenaPostgresqlEndpoint(
        host: 'localhost',
        databaseName: 'dart_test',
        username: 'postgres',
        password: 'dart',
      ));
      print('opened');
      // Additional setup goes here.
    });
    tearDown(() async => await athena.close());

    test('execute query', () async {
      print('testing');
      final completed = await athena.create
          .table('products')
          .column((t) => t.bigint('t_bigint'))
          .column((t) => t.bigserial('t_bigserial'))
          .column((t) => t.bit('t_bit', 1))
          .column((t) => t.bitVarying('t_bitVarying', 1))
          .column((t) => t.bool('t_bool'))
          .column((t) => t.boolean('t_boolean'))
          .column((t) => t.box('t_box'))
          .column((t) => t.bytea('t_bytea'))
          .column((t) => t.char('t_char', 1))
          .column((t) => t.character('t_character', 1))
          .column((t) => t.characterVarying('t_characterVarying', 1))
          .column((t) => t.cidr('t_cidr'))
          .column((t) => t.circle('t_circle'))
          .column((t) => t.date('t_date'))
          .column((t) => t.decimal('t_decimal', 1, 1))
          .column((t) => t.doublePrecision('t_doublePrecision'))
          .column((t) => t.float4('t_float4'))
          .column((t) => t.float8('t_float8'))
          .column((t) => t.inet('t_inet'))
          .column((t) => t.int2('t_int2'))
          .column((t) => t.int4('t_int4'))
          .column((t) => t.int8('t_int8'))
          .column((t) => t.int_('t_int'))
          .column((t) => t.integer('t_integer'))
          .column((t) => t.interval('t_interval', IntervalPhrases.day))
          .column((t) => t.json('t_json'))
          .column((t) => t.jsonb('t_jsonb'))
          .column((t) => t.line('t_line'))
          .column((t) => t.lseg('t_lseg'))
          .column((t) => t.macaddr('t_macaddr'))
          .column((t) => t.macaddr8('t_macaddr8'))
          .column((t) => t.money('t_money'))
          .column((t) => t.numeric('t_numeric', 1, 2))
          .column((t) => t.path('t_path'))
          .column((t) => t.pgLsn('t_pgLsn'))
          .column((t) => t.pgSnapshot('t_pgSnapshot'))
          .column((t) => t.point('t_point'))
          .column((t) => t.polygon('t_polygon'))
          .column((t) => t.real('t_real'))
          .column((t) => t.serial('t_serial'))
          .column((t) => t.serial2('t_serial2'))
          .column((t) => t.serial4('t_serial4'))
          .column((t) => t.serial8('t_serial8'))
          .column((t) => t.smallint('t_smallint'))
          .column((t) => t.smallserial('t_smallserial'))
          .column((t) => t.text('t_text'))
          .column((t) => t.time('t_time', p: 1))
          .column((t) => t.time('t_time_no_p'))
          .column((t) =>
              t.time('t_time_with_tinezone', option: TimeOption.withTimeZone))
          .column((t) => t.timestamp('t_timestamp'))
          .column((t) => t.timestamp('t_timestamp_with_options',
              p: 1, option: TimeOption.withoutTimeZone))
          .column((t) => t.timetz('t_timetz'))
          .column((t) => t.timetz('t_timetz_p', p: 1))
          .column((t) => t.timestamptz('t_timestamptz'))
          .column((t) => t.tsquery('t_tsquery'))
          .column((t) => t.tsvector('t_tsvector'))
          .column((t) => t.txidSnapshot('t_txidSnapshot'))
          .column((t) => t.uuid('t_uuid'))
          .column((t) => t.varbit('t_varbit', 1))
          .column((t) => t.varchar('t_varchar', 20))
          .column((t) => t.xml('t_xml'))
          .run();
      expect(completed, equals([]));
      expect(completed.affectedRows, equals(0));
    });
  });
}
