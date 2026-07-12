// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _employeeNameMeta = const VerificationMeta(
    'employeeName',
  );
  @override
  late final GeneratedColumn<String> employeeName = GeneratedColumn<String>(
    'employee_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobTitleMeta = const VerificationMeta(
    'jobTitle',
  );
  @override
  late final GeneratedColumn<String> jobTitle = GeneratedColumn<String>(
    'job_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalRegularLeavesMeta =
      const VerificationMeta('totalRegularLeaves');
  @override
  late final GeneratedColumn<int> totalRegularLeaves = GeneratedColumn<int>(
    'total_regular_leaves',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCasualLeavesMeta = const VerificationMeta(
    'totalCasualLeaves',
  );
  @override
  late final GeneratedColumn<int> totalCasualLeaves = GeneratedColumn<int>(
    'total_casual_leaves',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeName,
    jobTitle,
    totalRegularLeaves,
    totalCasualLeaves,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_name')) {
      context.handle(
        _employeeNameMeta,
        employeeName.isAcceptableOrUnknown(
          data['employee_name']!,
          _employeeNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_employeeNameMeta);
    }
    if (data.containsKey('job_title')) {
      context.handle(
        _jobTitleMeta,
        jobTitle.isAcceptableOrUnknown(data['job_title']!, _jobTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_jobTitleMeta);
    }
    if (data.containsKey('total_regular_leaves')) {
      context.handle(
        _totalRegularLeavesMeta,
        totalRegularLeaves.isAcceptableOrUnknown(
          data['total_regular_leaves']!,
          _totalRegularLeavesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalRegularLeavesMeta);
    }
    if (data.containsKey('total_casual_leaves')) {
      context.handle(
        _totalCasualLeavesMeta,
        totalCasualLeaves.isAcceptableOrUnknown(
          data['total_casual_leaves']!,
          _totalCasualLeavesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCasualLeavesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      employeeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_name'],
      )!,
      jobTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_title'],
      )!,
      totalRegularLeaves: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_regular_leaves'],
      )!,
      totalCasualLeaves: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_casual_leaves'],
      )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingModel extends DataClass implements Insertable<SettingModel> {
  final int id;
  final String employeeName;
  final String jobTitle;
  final int totalRegularLeaves;
  final int totalCasualLeaves;
  const SettingModel({
    required this.id,
    required this.employeeName,
    required this.jobTitle,
    required this.totalRegularLeaves,
    required this.totalCasualLeaves,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['employee_name'] = Variable<String>(employeeName);
    map['job_title'] = Variable<String>(jobTitle);
    map['total_regular_leaves'] = Variable<int>(totalRegularLeaves);
    map['total_casual_leaves'] = Variable<int>(totalCasualLeaves);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      id: Value(id),
      employeeName: Value(employeeName),
      jobTitle: Value(jobTitle),
      totalRegularLeaves: Value(totalRegularLeaves),
      totalCasualLeaves: Value(totalCasualLeaves),
    );
  }

  factory SettingModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingModel(
      id: serializer.fromJson<int>(json['id']),
      employeeName: serializer.fromJson<String>(json['employeeName']),
      jobTitle: serializer.fromJson<String>(json['jobTitle']),
      totalRegularLeaves: serializer.fromJson<int>(json['totalRegularLeaves']),
      totalCasualLeaves: serializer.fromJson<int>(json['totalCasualLeaves']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeName': serializer.toJson<String>(employeeName),
      'jobTitle': serializer.toJson<String>(jobTitle),
      'totalRegularLeaves': serializer.toJson<int>(totalRegularLeaves),
      'totalCasualLeaves': serializer.toJson<int>(totalCasualLeaves),
    };
  }

  SettingModel copyWith({
    int? id,
    String? employeeName,
    String? jobTitle,
    int? totalRegularLeaves,
    int? totalCasualLeaves,
  }) => SettingModel(
    id: id ?? this.id,
    employeeName: employeeName ?? this.employeeName,
    jobTitle: jobTitle ?? this.jobTitle,
    totalRegularLeaves: totalRegularLeaves ?? this.totalRegularLeaves,
    totalCasualLeaves: totalCasualLeaves ?? this.totalCasualLeaves,
  );
  SettingModel copyWithCompanion(SettingsTableCompanion data) {
    return SettingModel(
      id: data.id.present ? data.id.value : this.id,
      employeeName: data.employeeName.present
          ? data.employeeName.value
          : this.employeeName,
      jobTitle: data.jobTitle.present ? data.jobTitle.value : this.jobTitle,
      totalRegularLeaves: data.totalRegularLeaves.present
          ? data.totalRegularLeaves.value
          : this.totalRegularLeaves,
      totalCasualLeaves: data.totalCasualLeaves.present
          ? data.totalCasualLeaves.value
          : this.totalCasualLeaves,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingModel(')
          ..write('id: $id, ')
          ..write('employeeName: $employeeName, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('totalRegularLeaves: $totalRegularLeaves, ')
          ..write('totalCasualLeaves: $totalCasualLeaves')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employeeName,
    jobTitle,
    totalRegularLeaves,
    totalCasualLeaves,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingModel &&
          other.id == this.id &&
          other.employeeName == this.employeeName &&
          other.jobTitle == this.jobTitle &&
          other.totalRegularLeaves == this.totalRegularLeaves &&
          other.totalCasualLeaves == this.totalCasualLeaves);
}

class SettingsTableCompanion extends UpdateCompanion<SettingModel> {
  final Value<int> id;
  final Value<String> employeeName;
  final Value<String> jobTitle;
  final Value<int> totalRegularLeaves;
  final Value<int> totalCasualLeaves;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.employeeName = const Value.absent(),
    this.jobTitle = const Value.absent(),
    this.totalRegularLeaves = const Value.absent(),
    this.totalCasualLeaves = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String employeeName,
    required String jobTitle,
    required int totalRegularLeaves,
    required int totalCasualLeaves,
  }) : employeeName = Value(employeeName),
       jobTitle = Value(jobTitle),
       totalRegularLeaves = Value(totalRegularLeaves),
       totalCasualLeaves = Value(totalCasualLeaves);
  static Insertable<SettingModel> custom({
    Expression<int>? id,
    Expression<String>? employeeName,
    Expression<String>? jobTitle,
    Expression<int>? totalRegularLeaves,
    Expression<int>? totalCasualLeaves,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeName != null) 'employee_name': employeeName,
      if (jobTitle != null) 'job_title': jobTitle,
      if (totalRegularLeaves != null)
        'total_regular_leaves': totalRegularLeaves,
      if (totalCasualLeaves != null) 'total_casual_leaves': totalCasualLeaves,
    });
  }

  SettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? employeeName,
    Value<String>? jobTitle,
    Value<int>? totalRegularLeaves,
    Value<int>? totalCasualLeaves,
  }) {
    return SettingsTableCompanion(
      id: id ?? this.id,
      employeeName: employeeName ?? this.employeeName,
      jobTitle: jobTitle ?? this.jobTitle,
      totalRegularLeaves: totalRegularLeaves ?? this.totalRegularLeaves,
      totalCasualLeaves: totalCasualLeaves ?? this.totalCasualLeaves,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeName.present) {
      map['employee_name'] = Variable<String>(employeeName.value);
    }
    if (jobTitle.present) {
      map['job_title'] = Variable<String>(jobTitle.value);
    }
    if (totalRegularLeaves.present) {
      map['total_regular_leaves'] = Variable<int>(totalRegularLeaves.value);
    }
    if (totalCasualLeaves.present) {
      map['total_casual_leaves'] = Variable<int>(totalCasualLeaves.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('employeeName: $employeeName, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('totalRegularLeaves: $totalRegularLeaves, ')
          ..write('totalCasualLeaves: $totalCasualLeaves')
          ..write(')'))
        .toString();
  }
}

class $LeaveRecordsTableTable extends LeaveRecordsTable
    with TableInfo<$LeaveRecordsTableTable, LeaveRecordModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveRecordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _leaveTypeMeta = const VerificationMeta(
    'leaveType',
  );
  @override
  late final GeneratedColumn<int> leaveType = GeneratedColumn<int>(
    'leave_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysCountMeta = const VerificationMeta(
    'daysCount',
  );
  @override
  late final GeneratedColumn<int> daysCount = GeneratedColumn<int>(
    'days_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    leaveType,
    startDate,
    endDate,
    daysCount,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_records_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveRecordModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('leave_type')) {
      context.handle(
        _leaveTypeMeta,
        leaveType.isAcceptableOrUnknown(data['leave_type']!, _leaveTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_leaveTypeMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('days_count')) {
      context.handle(
        _daysCountMeta,
        daysCount.isAcceptableOrUnknown(data['days_count']!, _daysCountMeta),
      );
    } else if (isInserting) {
      context.missing(_daysCountMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaveRecordModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveRecordModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      leaveType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}leave_type'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      daysCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_count'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $LeaveRecordsTableTable createAlias(String alias) {
    return $LeaveRecordsTableTable(attachedDatabase, alias);
  }
}

class LeaveRecordModel extends DataClass
    implements Insertable<LeaveRecordModel> {
  final int id;
  final int leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final int daysCount;
  final String? notes;
  const LeaveRecordModel({
    required this.id,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['leave_type'] = Variable<int>(leaveType);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['days_count'] = Variable<int>(daysCount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  LeaveRecordsTableCompanion toCompanion(bool nullToAbsent) {
    return LeaveRecordsTableCompanion(
      id: Value(id),
      leaveType: Value(leaveType),
      startDate: Value(startDate),
      endDate: Value(endDate),
      daysCount: Value(daysCount),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory LeaveRecordModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveRecordModel(
      id: serializer.fromJson<int>(json['id']),
      leaveType: serializer.fromJson<int>(json['leaveType']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      daysCount: serializer.fromJson<int>(json['daysCount']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'leaveType': serializer.toJson<int>(leaveType),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'daysCount': serializer.toJson<int>(daysCount),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  LeaveRecordModel copyWith({
    int? id,
    int? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    int? daysCount,
    Value<String?> notes = const Value.absent(),
  }) => LeaveRecordModel(
    id: id ?? this.id,
    leaveType: leaveType ?? this.leaveType,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    daysCount: daysCount ?? this.daysCount,
    notes: notes.present ? notes.value : this.notes,
  );
  LeaveRecordModel copyWithCompanion(LeaveRecordsTableCompanion data) {
    return LeaveRecordModel(
      id: data.id.present ? data.id.value : this.id,
      leaveType: data.leaveType.present ? data.leaveType.value : this.leaveType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      daysCount: data.daysCount.present ? data.daysCount.value : this.daysCount,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRecordModel(')
          ..write('id: $id, ')
          ..write('leaveType: $leaveType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('daysCount: $daysCount, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, leaveType, startDate, endDate, daysCount, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveRecordModel &&
          other.id == this.id &&
          other.leaveType == this.leaveType &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.daysCount == this.daysCount &&
          other.notes == this.notes);
}

class LeaveRecordsTableCompanion extends UpdateCompanion<LeaveRecordModel> {
  final Value<int> id;
  final Value<int> leaveType;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> daysCount;
  final Value<String?> notes;
  const LeaveRecordsTableCompanion({
    this.id = const Value.absent(),
    this.leaveType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.daysCount = const Value.absent(),
    this.notes = const Value.absent(),
  });
  LeaveRecordsTableCompanion.insert({
    this.id = const Value.absent(),
    required int leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required int daysCount,
    this.notes = const Value.absent(),
  }) : leaveType = Value(leaveType),
       startDate = Value(startDate),
       endDate = Value(endDate),
       daysCount = Value(daysCount);
  static Insertable<LeaveRecordModel> custom({
    Expression<int>? id,
    Expression<int>? leaveType,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? daysCount,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (leaveType != null) 'leave_type': leaveType,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (daysCount != null) 'days_count': daysCount,
      if (notes != null) 'notes': notes,
    });
  }

  LeaveRecordsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? leaveType,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? daysCount,
    Value<String?>? notes,
  }) {
    return LeaveRecordsTableCompanion(
      id: id ?? this.id,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      daysCount: daysCount ?? this.daysCount,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (leaveType.present) {
      map['leave_type'] = Variable<int>(leaveType.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (daysCount.present) {
      map['days_count'] = Variable<int>(daysCount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRecordsTableCompanion(')
          ..write('id: $id, ')
          ..write('leaveType: $leaveType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('daysCount: $daysCount, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $HolidaysTableTable extends HolidaysTable
    with TableInfo<$HolidaysTableTable, HolidayModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HolidaysTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, startDate, endDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'holidays_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HolidayModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HolidayModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HolidayModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
    );
  }

  @override
  $HolidaysTableTable createAlias(String alias) {
    return $HolidaysTableTable(attachedDatabase, alias);
  }
}

class HolidayModel extends DataClass implements Insertable<HolidayModel> {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  const HolidayModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    return map;
  }

  HolidaysTableCompanion toCompanion(bool nullToAbsent) {
    return HolidaysTableCompanion(
      id: Value(id),
      name: Value(name),
      startDate: Value(startDate),
      endDate: Value(endDate),
    );
  }

  factory HolidayModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HolidayModel(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
    };
  }

  HolidayModel copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  }) => HolidayModel(
    id: id ?? this.id,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
  );
  HolidayModel copyWithCompanion(HolidaysTableCompanion data) {
    return HolidayModel(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HolidayModel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, startDate, endDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HolidayModel &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class HolidaysTableCompanion extends UpdateCompanion<HolidayModel> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  const HolidaysTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  HolidaysTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime startDate,
    required DateTime endDate,
  }) : name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<HolidayModel> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });
  }

  HolidaysTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
  }) {
    return HolidaysTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HolidaysTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }
}

class $ExtraWorkDaysTableTable extends ExtraWorkDaysTable
    with TableInfo<$ExtraWorkDaysTableTable, ExtraWorkDayModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExtraWorkDaysTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'extra_work_days_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExtraWorkDayModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExtraWorkDayModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExtraWorkDayModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ExtraWorkDaysTableTable createAlias(String alias) {
    return $ExtraWorkDaysTableTable(attachedDatabase, alias);
  }
}

class ExtraWorkDayModel extends DataClass
    implements Insertable<ExtraWorkDayModel> {
  final int id;
  final DateTime date;
  final String? notes;
  const ExtraWorkDayModel({required this.id, required this.date, this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ExtraWorkDaysTableCompanion toCompanion(bool nullToAbsent) {
    return ExtraWorkDaysTableCompanion(
      id: Value(id),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ExtraWorkDayModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExtraWorkDayModel(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ExtraWorkDayModel copyWith({
    int? id,
    DateTime? date,
    Value<String?> notes = const Value.absent(),
  }) => ExtraWorkDayModel(
    id: id ?? this.id,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
  );
  ExtraWorkDayModel copyWithCompanion(ExtraWorkDaysTableCompanion data) {
    return ExtraWorkDayModel(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtraWorkDayModel(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtraWorkDayModel &&
          other.id == this.id &&
          other.date == this.date &&
          other.notes == this.notes);
}

class ExtraWorkDaysTableCompanion extends UpdateCompanion<ExtraWorkDayModel> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String?> notes;
  const ExtraWorkDaysTableCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ExtraWorkDaysTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.notes = const Value.absent(),
  }) : date = Value(date);
  static Insertable<ExtraWorkDayModel> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
    });
  }

  ExtraWorkDaysTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String?>? notes,
  }) {
    return ExtraWorkDaysTableCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExtraWorkDaysTableCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $LeaveRecordsTableTable leaveRecordsTable =
      $LeaveRecordsTableTable(this);
  late final $HolidaysTableTable holidaysTable = $HolidaysTableTable(this);
  late final $ExtraWorkDaysTableTable extraWorkDaysTable =
      $ExtraWorkDaysTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settingsTable,
    leaveRecordsTable,
    holidaysTable,
    extraWorkDaysTable,
  ];
}

typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      required String employeeName,
      required String jobTitle,
      required int totalRegularLeaves,
      required int totalCasualLeaves,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      Value<String> employeeName,
      Value<String> jobTitle,
      Value<int> totalRegularLeaves,
      Value<int> totalCasualLeaves,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeName => $composableBuilder(
    column: $table.employeeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalRegularLeaves => $composableBuilder(
    column: $table.totalRegularLeaves,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCasualLeaves => $composableBuilder(
    column: $table.totalCasualLeaves,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeName => $composableBuilder(
    column: $table.employeeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalRegularLeaves => $composableBuilder(
    column: $table.totalRegularLeaves,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCasualLeaves => $composableBuilder(
    column: $table.totalCasualLeaves,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeName => $composableBuilder(
    column: $table.employeeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jobTitle =>
      $composableBuilder(column: $table.jobTitle, builder: (column) => column);

  GeneratedColumn<int> get totalRegularLeaves => $composableBuilder(
    column: $table.totalRegularLeaves,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCasualLeaves => $composableBuilder(
    column: $table.totalCasualLeaves,
    builder: (column) => column,
  );
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          SettingModel,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            SettingModel,
            BaseReferences<_$AppDatabase, $SettingsTableTable, SettingModel>,
          ),
          SettingModel,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> employeeName = const Value.absent(),
                Value<String> jobTitle = const Value.absent(),
                Value<int> totalRegularLeaves = const Value.absent(),
                Value<int> totalCasualLeaves = const Value.absent(),
              }) => SettingsTableCompanion(
                id: id,
                employeeName: employeeName,
                jobTitle: jobTitle,
                totalRegularLeaves: totalRegularLeaves,
                totalCasualLeaves: totalCasualLeaves,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String employeeName,
                required String jobTitle,
                required int totalRegularLeaves,
                required int totalCasualLeaves,
              }) => SettingsTableCompanion.insert(
                id: id,
                employeeName: employeeName,
                jobTitle: jobTitle,
                totalRegularLeaves: totalRegularLeaves,
                totalCasualLeaves: totalCasualLeaves,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      SettingModel,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (
        SettingModel,
        BaseReferences<_$AppDatabase, $SettingsTableTable, SettingModel>,
      ),
      SettingModel,
      PrefetchHooks Function()
    >;
typedef $$LeaveRecordsTableTableCreateCompanionBuilder =
    LeaveRecordsTableCompanion Function({
      Value<int> id,
      required int leaveType,
      required DateTime startDate,
      required DateTime endDate,
      required int daysCount,
      Value<String?> notes,
    });
typedef $$LeaveRecordsTableTableUpdateCompanionBuilder =
    LeaveRecordsTableCompanion Function({
      Value<int> id,
      Value<int> leaveType,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> daysCount,
      Value<String?> notes,
    });

class $$LeaveRecordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LeaveRecordsTableTable> {
  $$LeaveRecordsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leaveType => $composableBuilder(
    column: $table.leaveType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysCount => $composableBuilder(
    column: $table.daysCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeaveRecordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaveRecordsTableTable> {
  $$LeaveRecordsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leaveType => $composableBuilder(
    column: $table.leaveType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysCount => $composableBuilder(
    column: $table.daysCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeaveRecordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaveRecordsTableTable> {
  $$LeaveRecordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get leaveType =>
      $composableBuilder(column: $table.leaveType, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get daysCount =>
      $composableBuilder(column: $table.daysCount, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$LeaveRecordsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaveRecordsTableTable,
          LeaveRecordModel,
          $$LeaveRecordsTableTableFilterComposer,
          $$LeaveRecordsTableTableOrderingComposer,
          $$LeaveRecordsTableTableAnnotationComposer,
          $$LeaveRecordsTableTableCreateCompanionBuilder,
          $$LeaveRecordsTableTableUpdateCompanionBuilder,
          (
            LeaveRecordModel,
            BaseReferences<
              _$AppDatabase,
              $LeaveRecordsTableTable,
              LeaveRecordModel
            >,
          ),
          LeaveRecordModel,
          PrefetchHooks Function()
        > {
  $$LeaveRecordsTableTableTableManager(
    _$AppDatabase db,
    $LeaveRecordsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveRecordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveRecordsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveRecordsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> leaveType = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> daysCount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => LeaveRecordsTableCompanion(
                id: id,
                leaveType: leaveType,
                startDate: startDate,
                endDate: endDate,
                daysCount: daysCount,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int leaveType,
                required DateTime startDate,
                required DateTime endDate,
                required int daysCount,
                Value<String?> notes = const Value.absent(),
              }) => LeaveRecordsTableCompanion.insert(
                id: id,
                leaveType: leaveType,
                startDate: startDate,
                endDate: endDate,
                daysCount: daysCount,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeaveRecordsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaveRecordsTableTable,
      LeaveRecordModel,
      $$LeaveRecordsTableTableFilterComposer,
      $$LeaveRecordsTableTableOrderingComposer,
      $$LeaveRecordsTableTableAnnotationComposer,
      $$LeaveRecordsTableTableCreateCompanionBuilder,
      $$LeaveRecordsTableTableUpdateCompanionBuilder,
      (
        LeaveRecordModel,
        BaseReferences<
          _$AppDatabase,
          $LeaveRecordsTableTable,
          LeaveRecordModel
        >,
      ),
      LeaveRecordModel,
      PrefetchHooks Function()
    >;
typedef $$HolidaysTableTableCreateCompanionBuilder =
    HolidaysTableCompanion Function({
      Value<int> id,
      required String name,
      required DateTime startDate,
      required DateTime endDate,
    });
typedef $$HolidaysTableTableUpdateCompanionBuilder =
    HolidaysTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
    });

class $$HolidaysTableTableFilterComposer
    extends Composer<_$AppDatabase, $HolidaysTableTable> {
  $$HolidaysTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HolidaysTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HolidaysTableTable> {
  $$HolidaysTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HolidaysTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HolidaysTableTable> {
  $$HolidaysTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);
}

class $$HolidaysTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HolidaysTableTable,
          HolidayModel,
          $$HolidaysTableTableFilterComposer,
          $$HolidaysTableTableOrderingComposer,
          $$HolidaysTableTableAnnotationComposer,
          $$HolidaysTableTableCreateCompanionBuilder,
          $$HolidaysTableTableUpdateCompanionBuilder,
          (
            HolidayModel,
            BaseReferences<_$AppDatabase, $HolidaysTableTable, HolidayModel>,
          ),
          HolidayModel,
          PrefetchHooks Function()
        > {
  $$HolidaysTableTableTableManager(_$AppDatabase db, $HolidaysTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HolidaysTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HolidaysTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HolidaysTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
              }) => HolidaysTableCompanion(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime startDate,
                required DateTime endDate,
              }) => HolidaysTableCompanion.insert(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HolidaysTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HolidaysTableTable,
      HolidayModel,
      $$HolidaysTableTableFilterComposer,
      $$HolidaysTableTableOrderingComposer,
      $$HolidaysTableTableAnnotationComposer,
      $$HolidaysTableTableCreateCompanionBuilder,
      $$HolidaysTableTableUpdateCompanionBuilder,
      (
        HolidayModel,
        BaseReferences<_$AppDatabase, $HolidaysTableTable, HolidayModel>,
      ),
      HolidayModel,
      PrefetchHooks Function()
    >;
typedef $$ExtraWorkDaysTableTableCreateCompanionBuilder =
    ExtraWorkDaysTableCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<String?> notes,
    });
typedef $$ExtraWorkDaysTableTableUpdateCompanionBuilder =
    ExtraWorkDaysTableCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String?> notes,
    });

class $$ExtraWorkDaysTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExtraWorkDaysTableTable> {
  $$ExtraWorkDaysTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExtraWorkDaysTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExtraWorkDaysTableTable> {
  $$ExtraWorkDaysTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExtraWorkDaysTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExtraWorkDaysTableTable> {
  $$ExtraWorkDaysTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$ExtraWorkDaysTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExtraWorkDaysTableTable,
          ExtraWorkDayModel,
          $$ExtraWorkDaysTableTableFilterComposer,
          $$ExtraWorkDaysTableTableOrderingComposer,
          $$ExtraWorkDaysTableTableAnnotationComposer,
          $$ExtraWorkDaysTableTableCreateCompanionBuilder,
          $$ExtraWorkDaysTableTableUpdateCompanionBuilder,
          (
            ExtraWorkDayModel,
            BaseReferences<
              _$AppDatabase,
              $ExtraWorkDaysTableTable,
              ExtraWorkDayModel
            >,
          ),
          ExtraWorkDayModel,
          PrefetchHooks Function()
        > {
  $$ExtraWorkDaysTableTableTableManager(
    _$AppDatabase db,
    $ExtraWorkDaysTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExtraWorkDaysTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExtraWorkDaysTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExtraWorkDaysTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) =>
                  ExtraWorkDaysTableCompanion(id: id, date: date, notes: notes),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<String?> notes = const Value.absent(),
              }) => ExtraWorkDaysTableCompanion.insert(
                id: id,
                date: date,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExtraWorkDaysTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExtraWorkDaysTableTable,
      ExtraWorkDayModel,
      $$ExtraWorkDaysTableTableFilterComposer,
      $$ExtraWorkDaysTableTableOrderingComposer,
      $$ExtraWorkDaysTableTableAnnotationComposer,
      $$ExtraWorkDaysTableTableCreateCompanionBuilder,
      $$ExtraWorkDaysTableTableUpdateCompanionBuilder,
      (
        ExtraWorkDayModel,
        BaseReferences<
          _$AppDatabase,
          $ExtraWorkDaysTableTable,
          ExtraWorkDayModel
        >,
      ),
      ExtraWorkDayModel,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$LeaveRecordsTableTableTableManager get leaveRecordsTable =>
      $$LeaveRecordsTableTableTableManager(_db, _db.leaveRecordsTable);
  $$HolidaysTableTableTableManager get holidaysTable =>
      $$HolidaysTableTableTableManager(_db, _db.holidaysTable);
  $$ExtraWorkDaysTableTableTableManager get extraWorkDaysTable =>
      $$ExtraWorkDaysTableTableTableManager(_db, _db.extraWorkDaysTable);
}
