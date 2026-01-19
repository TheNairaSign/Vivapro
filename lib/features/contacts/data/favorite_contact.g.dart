// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_contact.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavoriteContactCollection on Isar {
  IsarCollection<FavoriteContact> get favoriteContacts => this.collection();
}

const FavoriteContactSchema = CollectionSchema(
  name: r'FavoriteContact',
  id: -7511673998165572600,
  properties: {
    r'callFrequency': PropertySchema(
      id: 0,
      name: r'callFrequency',
      type: IsarType.string,
      enumMap: _FavoriteContactcallFrequencyEnumValueMap,
    ),
    r'contactDetailsJson': PropertySchema(
      id: 1,
      name: r'contactDetailsJson',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'inAppUserId': PropertySchema(
      id: 4,
      name: r'inAppUserId',
      type: IsarType.string,
    ),
    r'lastInteractionAt': PropertySchema(
      id: 5,
      name: r'lastInteractionAt',
      type: IsarType.dateTime,
    ),
    r'priority': PropertySchema(
      id: 6,
      name: r'priority',
      type: IsarType.string,
      enumMap: _FavoriteContactpriorityEnumValueMap,
    )
  },
  estimateSize: _favoriteContactEstimateSize,
  serialize: _favoriteContactSerialize,
  deserialize: _favoriteContactDeserialize,
  deserializeProp: _favoriteContactDeserializeProp,
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
  getId: _favoriteContactGetId,
  getLinks: _favoriteContactGetLinks,
  attach: _favoriteContactAttach,
  version: '3.1.0+1',
);

int _favoriteContactEstimateSize(
  FavoriteContact object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.callFrequency.name.length * 3;
  bytesCount += 3 + object.contactDetailsJson.length * 3;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.inAppUserId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.priority.name.length * 3;
  return bytesCount;
}

void _favoriteContactSerialize(
  FavoriteContact object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.callFrequency.name);
  writer.writeString(offsets[1], object.contactDetailsJson);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.id);
  writer.writeString(offsets[4], object.inAppUserId);
  writer.writeDateTime(offsets[5], object.lastInteractionAt);
  writer.writeString(offsets[6], object.priority.name);
}

FavoriteContact _favoriteContactDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavoriteContact(
    callFrequency: _FavoriteContactcallFrequencyValueEnumMap[
            reader.readStringOrNull(offsets[0])] ??
        CallFrequency.daily,
    contactDetailsJson: reader.readString(offsets[1]),
    createdAt: reader.readDateTimeOrNull(offsets[2]),
    id: reader.readString(offsets[3]),
    inAppUserId: reader.readStringOrNull(offsets[4]),
    isarId: id,
    lastInteractionAt: reader.readDateTimeOrNull(offsets[5]),
    priority: _FavoriteContactpriorityValueEnumMap[
            reader.readStringOrNull(offsets[6])] ??
        CallPriority.high,
  );
  return object;
}

P _favoriteContactDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_FavoriteContactcallFrequencyValueEnumMap[
              reader.readStringOrNull(offset)] ??
          CallFrequency.daily) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (_FavoriteContactpriorityValueEnumMap[
              reader.readStringOrNull(offset)] ??
          CallPriority.high) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _FavoriteContactcallFrequencyEnumValueMap = {
  r'daily': r'daily',
  r'weekly': r'weekly',
  r'monthly': r'monthly',
  r'yearly': r'yearly',
  r'custom': r'custom',
};
const _FavoriteContactcallFrequencyValueEnumMap = {
  r'daily': CallFrequency.daily,
  r'weekly': CallFrequency.weekly,
  r'monthly': CallFrequency.monthly,
  r'yearly': CallFrequency.yearly,
  r'custom': CallFrequency.custom,
};
const _FavoriteContactpriorityEnumValueMap = {
  r'high': r'high',
  r'medium': r'medium',
  r'low': r'low',
};
const _FavoriteContactpriorityValueEnumMap = {
  r'high': CallPriority.high,
  r'medium': CallPriority.medium,
  r'low': CallPriority.low,
};

Id _favoriteContactGetId(FavoriteContact object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _favoriteContactGetLinks(FavoriteContact object) {
  return [];
}

void _favoriteContactAttach(
    IsarCollection<dynamic> col, Id id, FavoriteContact object) {
  object.isarId = id;
}

extension FavoriteContactByIndex on IsarCollection<FavoriteContact> {
  Future<FavoriteContact?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  FavoriteContact? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<FavoriteContact?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<FavoriteContact?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(FavoriteContact object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(FavoriteContact object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<FavoriteContact> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<FavoriteContact> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension FavoriteContactQueryWhereSort
    on QueryBuilder<FavoriteContact, FavoriteContact, QWhere> {
  QueryBuilder<FavoriteContact, FavoriteContact, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FavoriteContactQueryWhere
    on QueryBuilder<FavoriteContact, FavoriteContact, QWhereClause> {
  QueryBuilder<FavoriteContact, FavoriteContact, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterWhereClause>
      isarIdBetween(
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterWhereClause>
      idNotEqualTo(String id) {
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

extension FavoriteContactQueryFilter
    on QueryBuilder<FavoriteContact, FavoriteContact, QFilterCondition> {
  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      callFrequencyEqualTo(
    CallFrequency value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'callFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      callFrequencyGreaterThan(
    CallFrequency value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'callFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      callFrequencyLessThan(
    CallFrequency value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'callFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      callFrequencyBetween(
    CallFrequency lower,
    CallFrequency upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'callFrequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      callFrequencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'callFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      callFrequencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'callFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      callFrequencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'callFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      callFrequencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'callFrequency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      callFrequencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'callFrequency',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      callFrequencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'callFrequency',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      contactDetailsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contactDetailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      contactDetailsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contactDetailsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      contactDetailsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactDetailsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      contactDetailsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contactDetailsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      idEqualTo(
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      idStartsWith(
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      idEndsWith(
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      inAppUserIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'inAppUserId',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      inAppUserIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'inAppUserId',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      inAppUserIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inAppUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      inAppUserIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inAppUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      inAppUserIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inAppUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      inAppUserIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inAppUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      inAppUserIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'inAppUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      inAppUserIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'inAppUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      inAppUserIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'inAppUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      inAppUserIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'inAppUserId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      inAppUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inAppUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      inAppUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'inAppUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      isarIdBetween(
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

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      lastInteractionAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastInteractionAt',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      lastInteractionAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastInteractionAt',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      lastInteractionAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastInteractionAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      lastInteractionAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastInteractionAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      lastInteractionAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastInteractionAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      lastInteractionAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastInteractionAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      priorityEqualTo(
    CallPriority value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      priorityGreaterThan(
    CallPriority value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      priorityLessThan(
    CallPriority value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      priorityBetween(
    CallPriority lower,
    CallPriority upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      priorityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      priorityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      priorityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      priorityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'priority',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      priorityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterFilterCondition>
      priorityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'priority',
        value: '',
      ));
    });
  }
}

extension FavoriteContactQueryObject
    on QueryBuilder<FavoriteContact, FavoriteContact, QFilterCondition> {}

extension FavoriteContactQueryLinks
    on QueryBuilder<FavoriteContact, FavoriteContact, QFilterCondition> {}

extension FavoriteContactQuerySortBy
    on QueryBuilder<FavoriteContact, FavoriteContact, QSortBy> {
  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      sortByCallFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'callFrequency', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      sortByCallFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'callFrequency', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      sortByContactDetailsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactDetailsJson', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      sortByContactDetailsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactDetailsJson', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      sortByInAppUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inAppUserId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      sortByInAppUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inAppUserId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      sortByLastInteractionAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInteractionAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      sortByLastInteractionAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInteractionAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }
}

extension FavoriteContactQuerySortThenBy
    on QueryBuilder<FavoriteContact, FavoriteContact, QSortThenBy> {
  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByCallFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'callFrequency', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByCallFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'callFrequency', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByContactDetailsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactDetailsJson', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByContactDetailsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactDetailsJson', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByInAppUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inAppUserId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByInAppUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inAppUserId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByLastInteractionAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInteractionAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByLastInteractionAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInteractionAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QAfterSortBy>
      thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }
}

extension FavoriteContactQueryWhereDistinct
    on QueryBuilder<FavoriteContact, FavoriteContact, QDistinct> {
  QueryBuilder<FavoriteContact, FavoriteContact, QDistinct>
      distinctByCallFrequency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'callFrequency',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QDistinct>
      distinctByContactDetailsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contactDetailsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QDistinct>
      distinctByInAppUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inAppUserId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QDistinct>
      distinctByLastInteractionAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastInteractionAt');
    });
  }

  QueryBuilder<FavoriteContact, FavoriteContact, QDistinct> distinctByPriority(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority', caseSensitive: caseSensitive);
    });
  }
}

extension FavoriteContactQueryProperty
    on QueryBuilder<FavoriteContact, FavoriteContact, QQueryProperty> {
  QueryBuilder<FavoriteContact, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<FavoriteContact, CallFrequency, QQueryOperations>
      callFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'callFrequency');
    });
  }

  QueryBuilder<FavoriteContact, String, QQueryOperations>
      contactDetailsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contactDetailsJson');
    });
  }

  QueryBuilder<FavoriteContact, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FavoriteContact, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FavoriteContact, String?, QQueryOperations>
      inAppUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inAppUserId');
    });
  }

  QueryBuilder<FavoriteContact, DateTime?, QQueryOperations>
      lastInteractionAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastInteractionAt');
    });
  }

  QueryBuilder<FavoriteContact, CallPriority, QQueryOperations>
      priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }
}
