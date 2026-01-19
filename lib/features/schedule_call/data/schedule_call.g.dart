// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_call.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScheduleCallCollection on Isar {
  IsarCollection<ScheduleCall> get scheduleCalls => this.collection();
}

const ScheduleCallSchema = CollectionSchema(
  name: r'ScheduleCall',
  id: -5111594816297621023,
  properties: {
    r'contactDetailsJson': PropertySchema(
      id: 0,
      name: r'contactDetailsJson',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    ),
    r'note': PropertySchema(
      id: 3,
      name: r'note',
      type: IsarType.string,
    ),
    r'timeHour': PropertySchema(
      id: 4,
      name: r'timeHour',
      type: IsarType.long,
    ),
    r'timeMinute': PropertySchema(
      id: 5,
      name: r'timeMinute',
      type: IsarType.long,
    )
  },
  estimateSize: _scheduleCallEstimateSize,
  serialize: _scheduleCallSerialize,
  deserialize: _scheduleCallDeserialize,
  deserializeProp: _scheduleCallDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _scheduleCallGetId,
  getLinks: _scheduleCallGetLinks,
  attach: _scheduleCallAttach,
  version: '3.1.0+1',
);

int _scheduleCallEstimateSize(
  ScheduleCall object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.contactDetailsJson.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.note.length * 3;
  return bytesCount;
}

void _scheduleCallSerialize(
  ScheduleCall object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.contactDetailsJson);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeString(offsets[2], object.id);
  writer.writeString(offsets[3], object.note);
  writer.writeLong(offsets[4], object.timeHour);
  writer.writeLong(offsets[5], object.timeMinute);
}

ScheduleCall _scheduleCallDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScheduleCall(
    contactDetailsJson: reader.readString(offsets[0]),
    date: reader.readDateTime(offsets[1]),
    id: reader.readString(offsets[2]),
    isarId: id,
    note: reader.readString(offsets[3]),
    timeHour: reader.readLong(offsets[4]),
    timeMinute: reader.readLong(offsets[5]),
  );
  return object;
}

P _scheduleCallDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _scheduleCallGetId(ScheduleCall object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _scheduleCallGetLinks(ScheduleCall object) {
  return [];
}

void _scheduleCallAttach(
    IsarCollection<dynamic> col, Id id, ScheduleCall object) {
  object.isarId = id;
}

extension ScheduleCallByIndex on IsarCollection<ScheduleCall> {
  Future<ScheduleCall?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  ScheduleCall? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<ScheduleCall?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<ScheduleCall?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(ScheduleCall object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(ScheduleCall object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<ScheduleCall> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<ScheduleCall> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension ScheduleCallQueryWhereSort
    on QueryBuilder<ScheduleCall, ScheduleCall, QWhere> {
  QueryBuilder<ScheduleCall, ScheduleCall, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ScheduleCallQueryWhere
    on QueryBuilder<ScheduleCall, ScheduleCall, QWhereClause> {
  QueryBuilder<ScheduleCall, ScheduleCall, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterWhereClause> idNotEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ScheduleCallQueryFilter
    on QueryBuilder<ScheduleCall, ScheduleCall, QFilterCondition> {
  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      contactDetailsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactDetailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      contactDetailsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contactDetailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      contactDetailsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contactDetailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      contactDetailsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contactDetailsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      contactDetailsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contactDetailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      contactDetailsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contactDetailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      contactDetailsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contactDetailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      contactDetailsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contactDetailsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      contactDetailsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactDetailsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      contactDetailsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contactDetailsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> noteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      noteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> noteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> noteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> noteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      timeHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      timeHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      timeHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      timeHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      timeMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      timeMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      timeMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterFilterCondition>
      timeMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScheduleCallQueryObject
    on QueryBuilder<ScheduleCall, ScheduleCall, QFilterCondition> {}

extension ScheduleCallQueryLinks
    on QueryBuilder<ScheduleCall, ScheduleCall, QFilterCondition> {}

extension ScheduleCallQuerySortBy
    on QueryBuilder<ScheduleCall, ScheduleCall, QSortBy> {
  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy>
      sortByContactDetailsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactDetailsJson', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy>
      sortByContactDetailsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactDetailsJson', Sort.desc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> sortByTimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeHour', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> sortByTimeHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeHour', Sort.desc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> sortByTimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeMinute', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy>
      sortByTimeMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeMinute', Sort.desc);
    });
  }
}

extension ScheduleCallQuerySortThenBy
    on QueryBuilder<ScheduleCall, ScheduleCall, QSortThenBy> {
  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy>
      thenByContactDetailsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactDetailsJson', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy>
      thenByContactDetailsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactDetailsJson', Sort.desc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> thenByTimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeHour', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> thenByTimeHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeHour', Sort.desc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy> thenByTimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeMinute', Sort.asc);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QAfterSortBy>
      thenByTimeMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeMinute', Sort.desc);
    });
  }
}

extension ScheduleCallQueryWhereDistinct
    on QueryBuilder<ScheduleCall, ScheduleCall, QDistinct> {
  QueryBuilder<ScheduleCall, ScheduleCall, QDistinct>
      distinctByContactDetailsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contactDetailsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QDistinct> distinctByTimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeHour');
    });
  }

  QueryBuilder<ScheduleCall, ScheduleCall, QDistinct> distinctByTimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeMinute');
    });
  }
}

extension ScheduleCallQueryProperty
    on QueryBuilder<ScheduleCall, ScheduleCall, QQueryProperty> {
  QueryBuilder<ScheduleCall, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ScheduleCall, String, QQueryOperations>
      contactDetailsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contactDetailsJson');
    });
  }

  QueryBuilder<ScheduleCall, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<ScheduleCall, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ScheduleCall, String, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<ScheduleCall, int, QQueryOperations> timeHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeHour');
    });
  }

  QueryBuilder<ScheduleCall, int, QQueryOperations> timeMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeMinute');
    });
  }
}
