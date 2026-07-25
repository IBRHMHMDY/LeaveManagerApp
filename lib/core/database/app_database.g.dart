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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    startDate,
    endDate,
    daysCount,
  ];
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
    if (data.containsKey('days_count')) {
      context.handle(
        _daysCountMeta,
        daysCount.isAcceptableOrUnknown(data['days_count']!, _daysCountMeta),
      );
    } else if (isInserting) {
      context.missing(_daysCountMeta);
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
      daysCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_count'],
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
  final int daysCount;
  const HolidayModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['days_count'] = Variable<int>(daysCount);
    return map;
  }

  HolidaysTableCompanion toCompanion(bool nullToAbsent) {
    return HolidaysTableCompanion(
      id: Value(id),
      name: Value(name),
      startDate: Value(startDate),
      endDate: Value(endDate),
      daysCount: Value(daysCount),
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
      daysCount: serializer.fromJson<int>(json['daysCount']),
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
      'daysCount': serializer.toJson<int>(daysCount),
    };
  }

  HolidayModel copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    int? daysCount,
  }) => HolidayModel(
    id: id ?? this.id,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    daysCount: daysCount ?? this.daysCount,
  );
  HolidayModel copyWithCompanion(HolidaysTableCompanion data) {
    return HolidayModel(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      daysCount: data.daysCount.present ? data.daysCount.value : this.daysCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HolidayModel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('daysCount: $daysCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, startDate, endDate, daysCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HolidayModel &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.daysCount == this.daysCount);
}

class HolidaysTableCompanion extends UpdateCompanion<HolidayModel> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> daysCount;
  const HolidaysTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.daysCount = const Value.absent(),
  });
  HolidaysTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required int daysCount,
  }) : name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate),
       daysCount = Value(daysCount);
  static Insertable<HolidayModel> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? daysCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (daysCount != null) 'days_count': daysCount,
    });
  }

  HolidaysTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? daysCount,
  }) {
    return HolidaysTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      daysCount: daysCount ?? this.daysCount,
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
    if (daysCount.present) {
      map['days_count'] = Variable<int>(daysCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HolidaysTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('daysCount: $daysCount')
          ..write(')'))
        .toString();
  }
}

class $RestAllowancesTableTable extends RestAllowancesTable
    with TableInfo<$RestAllowancesTableTable, RestAllowanceModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestAllowancesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _earnedDateMeta = const VerificationMeta(
    'earnedDate',
  );
  @override
  late final GeneratedColumn<DateTime> earnedDate = GeneratedColumn<DateTime>(
    'earned_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consumedDateMeta = const VerificationMeta(
    'consumedDate',
  );
  @override
  late final GeneratedColumn<DateTime> consumedDate = GeneratedColumn<DateTime>(
    'consumed_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  List<GeneratedColumn> get $columns => [id, earnedDate, consumedDate, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rest_allowances_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RestAllowanceModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('earned_date')) {
      context.handle(
        _earnedDateMeta,
        earnedDate.isAcceptableOrUnknown(data['earned_date']!, _earnedDateMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedDateMeta);
    }
    if (data.containsKey('consumed_date')) {
      context.handle(
        _consumedDateMeta,
        consumedDate.isAcceptableOrUnknown(
          data['consumed_date']!,
          _consumedDateMeta,
        ),
      );
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
  RestAllowanceModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestAllowanceModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      earnedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}earned_date'],
      )!,
      consumedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}consumed_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $RestAllowancesTableTable createAlias(String alias) {
    return $RestAllowancesTableTable(attachedDatabase, alias);
  }
}

class RestAllowanceModel extends DataClass
    implements Insertable<RestAllowanceModel> {
  final int id;
  final DateTime earnedDate;
  final DateTime? consumedDate;
  final String? notes;
  const RestAllowanceModel({
    required this.id,
    required this.earnedDate,
    this.consumedDate,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['earned_date'] = Variable<DateTime>(earnedDate);
    if (!nullToAbsent || consumedDate != null) {
      map['consumed_date'] = Variable<DateTime>(consumedDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  RestAllowancesTableCompanion toCompanion(bool nullToAbsent) {
    return RestAllowancesTableCompanion(
      id: Value(id),
      earnedDate: Value(earnedDate),
      consumedDate: consumedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(consumedDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory RestAllowanceModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestAllowanceModel(
      id: serializer.fromJson<int>(json['id']),
      earnedDate: serializer.fromJson<DateTime>(json['earnedDate']),
      consumedDate: serializer.fromJson<DateTime?>(json['consumedDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'earnedDate': serializer.toJson<DateTime>(earnedDate),
      'consumedDate': serializer.toJson<DateTime?>(consumedDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  RestAllowanceModel copyWith({
    int? id,
    DateTime? earnedDate,
    Value<DateTime?> consumedDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => RestAllowanceModel(
    id: id ?? this.id,
    earnedDate: earnedDate ?? this.earnedDate,
    consumedDate: consumedDate.present ? consumedDate.value : this.consumedDate,
    notes: notes.present ? notes.value : this.notes,
  );
  RestAllowanceModel copyWithCompanion(RestAllowancesTableCompanion data) {
    return RestAllowanceModel(
      id: data.id.present ? data.id.value : this.id,
      earnedDate: data.earnedDate.present
          ? data.earnedDate.value
          : this.earnedDate,
      consumedDate: data.consumedDate.present
          ? data.consumedDate.value
          : this.consumedDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestAllowanceModel(')
          ..write('id: $id, ')
          ..write('earnedDate: $earnedDate, ')
          ..write('consumedDate: $consumedDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, earnedDate, consumedDate, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestAllowanceModel &&
          other.id == this.id &&
          other.earnedDate == this.earnedDate &&
          other.consumedDate == this.consumedDate &&
          other.notes == this.notes);
}

class RestAllowancesTableCompanion extends UpdateCompanion<RestAllowanceModel> {
  final Value<int> id;
  final Value<DateTime> earnedDate;
  final Value<DateTime?> consumedDate;
  final Value<String?> notes;
  const RestAllowancesTableCompanion({
    this.id = const Value.absent(),
    this.earnedDate = const Value.absent(),
    this.consumedDate = const Value.absent(),
    this.notes = const Value.absent(),
  });
  RestAllowancesTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime earnedDate,
    this.consumedDate = const Value.absent(),
    this.notes = const Value.absent(),
  }) : earnedDate = Value(earnedDate);
  static Insertable<RestAllowanceModel> custom({
    Expression<int>? id,
    Expression<DateTime>? earnedDate,
    Expression<DateTime>? consumedDate,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (earnedDate != null) 'earned_date': earnedDate,
      if (consumedDate != null) 'consumed_date': consumedDate,
      if (notes != null) 'notes': notes,
    });
  }

  RestAllowancesTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? earnedDate,
    Value<DateTime?>? consumedDate,
    Value<String?>? notes,
  }) {
    return RestAllowancesTableCompanion(
      id: id ?? this.id,
      earnedDate: earnedDate ?? this.earnedDate,
      consumedDate: consumedDate ?? this.consumedDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (earnedDate.present) {
      map['earned_date'] = Variable<DateTime>(earnedDate.value);
    }
    if (consumedDate.present) {
      map['consumed_date'] = Variable<DateTime>(consumedDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestAllowancesTableCompanion(')
          ..write('id: $id, ')
          ..write('earnedDate: $earnedDate, ')
          ..write('consumedDate: $consumedDate, ')
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
  late final $RestAllowancesTableTable restAllowancesTable =
      $RestAllowancesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settingsTable,
    leaveRecordsTable,
    holidaysTable,
    restAllowancesTable,
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
      required int daysCount,
    });
typedef $$HolidaysTableTableUpdateCompanionBuilder =
    HolidaysTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> daysCount,
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

  ColumnFilters<int> get daysCount => $composableBuilder(
    column: $table.daysCount,
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

  ColumnOrderings<int> get daysCount => $composableBuilder(
    column: $table.daysCount,
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

  GeneratedColumn<int> get daysCount =>
      $composableBuilder(column: $table.daysCount, builder: (column) => column);
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
                Value<int> daysCount = const Value.absent(),
              }) => HolidaysTableCompanion(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                daysCount: daysCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime startDate,
                required DateTime endDate,
                required int daysCount,
              }) => HolidaysTableCompanion.insert(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                daysCount: daysCount,
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
typedef $$RestAllowancesTableTableCreateCompanionBuilder =
    RestAllowancesTableCompanion Function({
      Value<int> id,
      required DateTime earnedDate,
      Value<DateTime?> consumedDate,
      Value<String?> notes,
    });
typedef $$RestAllowancesTableTableUpdateCompanionBuilder =
    RestAllowancesTableCompanion Function({
      Value<int> id,
      Value<DateTime> earnedDate,
      Value<DateTime?> consumedDate,
      Value<String?> notes,
    });

class $$RestAllowancesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RestAllowancesTableTable> {
  $$RestAllowancesTableTableFilterComposer({
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

  ColumnFilters<DateTime> get earnedDate => $composableBuilder(
    column: $table.earnedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get consumedDate => $composableBuilder(
    column: $table.consumedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RestAllowancesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RestAllowancesTableTable> {
  $$RestAllowancesTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get earnedDate => $composableBuilder(
    column: $table.earnedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get consumedDate => $composableBuilder(
    column: $table.consumedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RestAllowancesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestAllowancesTableTable> {
  $$RestAllowancesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get earnedDate => $composableBuilder(
    column: $table.earnedDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get consumedDate => $composableBuilder(
    column: $table.consumedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$RestAllowancesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RestAllowancesTableTable,
          RestAllowanceModel,
          $$RestAllowancesTableTableFilterComposer,
          $$RestAllowancesTableTableOrderingComposer,
          $$RestAllowancesTableTableAnnotationComposer,
          $$RestAllowancesTableTableCreateCompanionBuilder,
          $$RestAllowancesTableTableUpdateCompanionBuilder,
          (
            RestAllowanceModel,
            BaseReferences<
              _$AppDatabase,
              $RestAllowancesTableTable,
              RestAllowanceModel
            >,
          ),
          RestAllowanceModel,
          PrefetchHooks Function()
        > {
  $$RestAllowancesTableTableTableManager(
    _$AppDatabase db,
    $RestAllowancesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestAllowancesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestAllowancesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RestAllowancesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> earnedDate = const Value.absent(),
                Value<DateTime?> consumedDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => RestAllowancesTableCompanion(
                id: id,
                earnedDate: earnedDate,
                consumedDate: consumedDate,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime earnedDate,
                Value<DateTime?> consumedDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => RestAllowancesTableCompanion.insert(
                id: id,
                earnedDate: earnedDate,
                consumedDate: consumedDate,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RestAllowancesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RestAllowancesTableTable,
      RestAllowanceModel,
      $$RestAllowancesTableTableFilterComposer,
      $$RestAllowancesTableTableOrderingComposer,
      $$RestAllowancesTableTableAnnotationComposer,
      $$RestAllowancesTableTableCreateCompanionBuilder,
      $$RestAllowancesTableTableUpdateCompanionBuilder,
      (
        RestAllowanceModel,
        BaseReferences<
          _$AppDatabase,
          $RestAllowancesTableTable,
          RestAllowanceModel
        >,
      ),
      RestAllowanceModel,
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
  $$RestAllowancesTableTableTableManager get restAllowancesTable =>
      $$RestAllowancesTableTableTableManager(_db, _db.restAllowancesTable);
}
