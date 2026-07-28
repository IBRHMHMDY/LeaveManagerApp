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

class $OvertimeRecordsTableTable extends OvertimeRecordsTable
    with TableInfo<$OvertimeRecordsTableTable, OvertimeRecordModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OvertimeRecordsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _workReasonMeta = const VerificationMeta(
    'workReason',
  );
  @override
  late final GeneratedColumn<int> workReason = GeneratedColumn<int>(
    'work_reason',
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
  static const VerificationMeta _holidayIdMeta = const VerificationMeta(
    'holidayId',
  );
  @override
  late final GeneratedColumn<int> holidayId = GeneratedColumn<int>(
    'holiday_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES holidays_table (id)',
    ),
  );
  static const VerificationMeta _isConsumedMeta = const VerificationMeta(
    'isConsumed',
  );
  @override
  late final GeneratedColumn<bool> isConsumed = GeneratedColumn<bool>(
    'is_consumed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_consumed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    workReason,
    startDate,
    endDate,
    daysCount,
    holidayId,
    isConsumed,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'overtime_records_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OvertimeRecordModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('work_reason')) {
      context.handle(
        _workReasonMeta,
        workReason.isAcceptableOrUnknown(data['work_reason']!, _workReasonMeta),
      );
    } else if (isInserting) {
      context.missing(_workReasonMeta);
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
    if (data.containsKey('holiday_id')) {
      context.handle(
        _holidayIdMeta,
        holidayId.isAcceptableOrUnknown(data['holiday_id']!, _holidayIdMeta),
      );
    }
    if (data.containsKey('is_consumed')) {
      context.handle(
        _isConsumedMeta,
        isConsumed.isAcceptableOrUnknown(data['is_consumed']!, _isConsumedMeta),
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
  OvertimeRecordModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OvertimeRecordModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workReason: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_reason'],
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
      holidayId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}holiday_id'],
      ),
      isConsumed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_consumed'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $OvertimeRecordsTableTable createAlias(String alias) {
    return $OvertimeRecordsTableTable(attachedDatabase, alias);
  }
}

class OvertimeRecordModel extends DataClass
    implements Insertable<OvertimeRecordModel> {
  final int id;
  final int workReason;
  final DateTime startDate;
  final DateTime endDate;
  final int daysCount;
  final int? holidayId;
  final bool isConsumed;
  final String? notes;
  const OvertimeRecordModel({
    required this.id,
    required this.workReason,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    this.holidayId,
    required this.isConsumed,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['work_reason'] = Variable<int>(workReason);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['days_count'] = Variable<int>(daysCount);
    if (!nullToAbsent || holidayId != null) {
      map['holiday_id'] = Variable<int>(holidayId);
    }
    map['is_consumed'] = Variable<bool>(isConsumed);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  OvertimeRecordsTableCompanion toCompanion(bool nullToAbsent) {
    return OvertimeRecordsTableCompanion(
      id: Value(id),
      workReason: Value(workReason),
      startDate: Value(startDate),
      endDate: Value(endDate),
      daysCount: Value(daysCount),
      holidayId: holidayId == null && nullToAbsent
          ? const Value.absent()
          : Value(holidayId),
      isConsumed: Value(isConsumed),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory OvertimeRecordModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OvertimeRecordModel(
      id: serializer.fromJson<int>(json['id']),
      workReason: serializer.fromJson<int>(json['workReason']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      daysCount: serializer.fromJson<int>(json['daysCount']),
      holidayId: serializer.fromJson<int?>(json['holidayId']),
      isConsumed: serializer.fromJson<bool>(json['isConsumed']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workReason': serializer.toJson<int>(workReason),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'daysCount': serializer.toJson<int>(daysCount),
      'holidayId': serializer.toJson<int?>(holidayId),
      'isConsumed': serializer.toJson<bool>(isConsumed),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  OvertimeRecordModel copyWith({
    int? id,
    int? workReason,
    DateTime? startDate,
    DateTime? endDate,
    int? daysCount,
    Value<int?> holidayId = const Value.absent(),
    bool? isConsumed,
    Value<String?> notes = const Value.absent(),
  }) => OvertimeRecordModel(
    id: id ?? this.id,
    workReason: workReason ?? this.workReason,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    daysCount: daysCount ?? this.daysCount,
    holidayId: holidayId.present ? holidayId.value : this.holidayId,
    isConsumed: isConsumed ?? this.isConsumed,
    notes: notes.present ? notes.value : this.notes,
  );
  OvertimeRecordModel copyWithCompanion(OvertimeRecordsTableCompanion data) {
    return OvertimeRecordModel(
      id: data.id.present ? data.id.value : this.id,
      workReason: data.workReason.present
          ? data.workReason.value
          : this.workReason,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      daysCount: data.daysCount.present ? data.daysCount.value : this.daysCount,
      holidayId: data.holidayId.present ? data.holidayId.value : this.holidayId,
      isConsumed: data.isConsumed.present
          ? data.isConsumed.value
          : this.isConsumed,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OvertimeRecordModel(')
          ..write('id: $id, ')
          ..write('workReason: $workReason, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('daysCount: $daysCount, ')
          ..write('holidayId: $holidayId, ')
          ..write('isConsumed: $isConsumed, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workReason,
    startDate,
    endDate,
    daysCount,
    holidayId,
    isConsumed,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OvertimeRecordModel &&
          other.id == this.id &&
          other.workReason == this.workReason &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.daysCount == this.daysCount &&
          other.holidayId == this.holidayId &&
          other.isConsumed == this.isConsumed &&
          other.notes == this.notes);
}

class OvertimeRecordsTableCompanion
    extends UpdateCompanion<OvertimeRecordModel> {
  final Value<int> id;
  final Value<int> workReason;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> daysCount;
  final Value<int?> holidayId;
  final Value<bool> isConsumed;
  final Value<String?> notes;
  const OvertimeRecordsTableCompanion({
    this.id = const Value.absent(),
    this.workReason = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.daysCount = const Value.absent(),
    this.holidayId = const Value.absent(),
    this.isConsumed = const Value.absent(),
    this.notes = const Value.absent(),
  });
  OvertimeRecordsTableCompanion.insert({
    this.id = const Value.absent(),
    required int workReason,
    required DateTime startDate,
    required DateTime endDate,
    required int daysCount,
    this.holidayId = const Value.absent(),
    this.isConsumed = const Value.absent(),
    this.notes = const Value.absent(),
  }) : workReason = Value(workReason),
       startDate = Value(startDate),
       endDate = Value(endDate),
       daysCount = Value(daysCount);
  static Insertable<OvertimeRecordModel> custom({
    Expression<int>? id,
    Expression<int>? workReason,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? daysCount,
    Expression<int>? holidayId,
    Expression<bool>? isConsumed,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workReason != null) 'work_reason': workReason,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (daysCount != null) 'days_count': daysCount,
      if (holidayId != null) 'holiday_id': holidayId,
      if (isConsumed != null) 'is_consumed': isConsumed,
      if (notes != null) 'notes': notes,
    });
  }

  OvertimeRecordsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? workReason,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? daysCount,
    Value<int?>? holidayId,
    Value<bool>? isConsumed,
    Value<String?>? notes,
  }) {
    return OvertimeRecordsTableCompanion(
      id: id ?? this.id,
      workReason: workReason ?? this.workReason,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      daysCount: daysCount ?? this.daysCount,
      holidayId: holidayId ?? this.holidayId,
      isConsumed: isConsumed ?? this.isConsumed,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workReason.present) {
      map['work_reason'] = Variable<int>(workReason.value);
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
    if (holidayId.present) {
      map['holiday_id'] = Variable<int>(holidayId.value);
    }
    if (isConsumed.present) {
      map['is_consumed'] = Variable<bool>(isConsumed.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OvertimeRecordsTableCompanion(')
          ..write('id: $id, ')
          ..write('workReason: $workReason, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('daysCount: $daysCount, ')
          ..write('holidayId: $holidayId, ')
          ..write('isConsumed: $isConsumed, ')
          ..write('notes: $notes')
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
  static const VerificationMeta _workReasonMeta = const VerificationMeta(
    'workReason',
  );
  @override
  late final GeneratedColumn<int> workReason = GeneratedColumn<int>(
    'work_reason',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overtimeIdMeta = const VerificationMeta(
    'overtimeId',
  );
  @override
  late final GeneratedColumn<int> overtimeId = GeneratedColumn<int>(
    'overtime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES overtime_records_table (id)',
    ),
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
    workReason,
    overtimeId,
    startDate,
    endDate,
    daysCount,
    notes,
  ];
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
    if (data.containsKey('work_reason')) {
      context.handle(
        _workReasonMeta,
        workReason.isAcceptableOrUnknown(data['work_reason']!, _workReasonMeta),
      );
    } else if (isInserting) {
      context.missing(_workReasonMeta);
    }
    if (data.containsKey('overtime_id')) {
      context.handle(
        _overtimeIdMeta,
        overtimeId.isAcceptableOrUnknown(data['overtime_id']!, _overtimeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_overtimeIdMeta);
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
  RestAllowanceModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestAllowanceModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workReason: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_reason'],
      )!,
      overtimeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overtime_id'],
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
  $RestAllowancesTableTable createAlias(String alias) {
    return $RestAllowancesTableTable(attachedDatabase, alias);
  }
}

class RestAllowanceModel extends DataClass
    implements Insertable<RestAllowanceModel> {
  final int id;
  final int workReason;
  final int overtimeId;
  final DateTime startDate;
  final DateTime endDate;
  final int daysCount;
  final String? notes;
  const RestAllowanceModel({
    required this.id,
    required this.workReason,
    required this.overtimeId,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['work_reason'] = Variable<int>(workReason);
    map['overtime_id'] = Variable<int>(overtimeId);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['days_count'] = Variable<int>(daysCount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  RestAllowancesTableCompanion toCompanion(bool nullToAbsent) {
    return RestAllowancesTableCompanion(
      id: Value(id),
      workReason: Value(workReason),
      overtimeId: Value(overtimeId),
      startDate: Value(startDate),
      endDate: Value(endDate),
      daysCount: Value(daysCount),
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
      workReason: serializer.fromJson<int>(json['workReason']),
      overtimeId: serializer.fromJson<int>(json['overtimeId']),
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
      'workReason': serializer.toJson<int>(workReason),
      'overtimeId': serializer.toJson<int>(overtimeId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'daysCount': serializer.toJson<int>(daysCount),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  RestAllowanceModel copyWith({
    int? id,
    int? workReason,
    int? overtimeId,
    DateTime? startDate,
    DateTime? endDate,
    int? daysCount,
    Value<String?> notes = const Value.absent(),
  }) => RestAllowanceModel(
    id: id ?? this.id,
    workReason: workReason ?? this.workReason,
    overtimeId: overtimeId ?? this.overtimeId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    daysCount: daysCount ?? this.daysCount,
    notes: notes.present ? notes.value : this.notes,
  );
  RestAllowanceModel copyWithCompanion(RestAllowancesTableCompanion data) {
    return RestAllowanceModel(
      id: data.id.present ? data.id.value : this.id,
      workReason: data.workReason.present
          ? data.workReason.value
          : this.workReason,
      overtimeId: data.overtimeId.present
          ? data.overtimeId.value
          : this.overtimeId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      daysCount: data.daysCount.present ? data.daysCount.value : this.daysCount,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestAllowanceModel(')
          ..write('id: $id, ')
          ..write('workReason: $workReason, ')
          ..write('overtimeId: $overtimeId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('daysCount: $daysCount, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workReason,
    overtimeId,
    startDate,
    endDate,
    daysCount,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestAllowanceModel &&
          other.id == this.id &&
          other.workReason == this.workReason &&
          other.overtimeId == this.overtimeId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.daysCount == this.daysCount &&
          other.notes == this.notes);
}

class RestAllowancesTableCompanion extends UpdateCompanion<RestAllowanceModel> {
  final Value<int> id;
  final Value<int> workReason;
  final Value<int> overtimeId;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> daysCount;
  final Value<String?> notes;
  const RestAllowancesTableCompanion({
    this.id = const Value.absent(),
    this.workReason = const Value.absent(),
    this.overtimeId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.daysCount = const Value.absent(),
    this.notes = const Value.absent(),
  });
  RestAllowancesTableCompanion.insert({
    this.id = const Value.absent(),
    required int workReason,
    required int overtimeId,
    required DateTime startDate,
    required DateTime endDate,
    required int daysCount,
    this.notes = const Value.absent(),
  }) : workReason = Value(workReason),
       overtimeId = Value(overtimeId),
       startDate = Value(startDate),
       endDate = Value(endDate),
       daysCount = Value(daysCount);
  static Insertable<RestAllowanceModel> custom({
    Expression<int>? id,
    Expression<int>? workReason,
    Expression<int>? overtimeId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? daysCount,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workReason != null) 'work_reason': workReason,
      if (overtimeId != null) 'overtime_id': overtimeId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (daysCount != null) 'days_count': daysCount,
      if (notes != null) 'notes': notes,
    });
  }

  RestAllowancesTableCompanion copyWith({
    Value<int>? id,
    Value<int>? workReason,
    Value<int>? overtimeId,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? daysCount,
    Value<String?>? notes,
  }) {
    return RestAllowancesTableCompanion(
      id: id ?? this.id,
      workReason: workReason ?? this.workReason,
      overtimeId: overtimeId ?? this.overtimeId,
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
    if (workReason.present) {
      map['work_reason'] = Variable<int>(workReason.value);
    }
    if (overtimeId.present) {
      map['overtime_id'] = Variable<int>(overtimeId.value);
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
    return (StringBuffer('RestAllowancesTableCompanion(')
          ..write('id: $id, ')
          ..write('workReason: $workReason, ')
          ..write('overtimeId: $overtimeId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('daysCount: $daysCount, ')
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
  late final $OvertimeRecordsTableTable overtimeRecordsTable =
      $OvertimeRecordsTableTable(this);
  late final $RestAllowancesTableTable restAllowancesTable =
      $RestAllowancesTableTable(this);
  late final Index idxLeaveDates = Index(
    'idx_leave_dates',
    'CREATE INDEX idx_leave_dates ON leave_records_table (start_date, end_date)',
  );
  late final Index idxHolidayDates = Index(
    'idx_holiday_dates',
    'CREATE INDEX idx_holiday_dates ON holidays_table (start_date, end_date)',
  );
  late final Index idxRestDates = Index(
    'idx_rest_dates',
    'CREATE INDEX idx_rest_dates ON rest_allowances_table (start_date, end_date)',
  );
  late final Index idxOvertimeDates = Index(
    'idx_overtime_dates',
    'CREATE INDEX idx_overtime_dates ON overtime_records_table (start_date, end_date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settingsTable,
    leaveRecordsTable,
    holidaysTable,
    overtimeRecordsTable,
    restAllowancesTable,
    idxLeaveDates,
    idxHolidayDates,
    idxRestDates,
    idxOvertimeDates,
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

final class $$HolidaysTableTableReferences
    extends BaseReferences<_$AppDatabase, $HolidaysTableTable, HolidayModel> {
  $$HolidaysTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $OvertimeRecordsTableTable,
    List<OvertimeRecordModel>
  >
  _overtimeRecordsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.overtimeRecordsTable,
        aliasName: $_aliasNameGenerator(
          db.holidaysTable.id,
          db.overtimeRecordsTable.holidayId,
        ),
      );

  $$OvertimeRecordsTableTableProcessedTableManager
  get overtimeRecordsTableRefs {
    final manager = $$OvertimeRecordsTableTableTableManager(
      $_db,
      $_db.overtimeRecordsTable,
    ).filter((f) => f.holidayId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _overtimeRecordsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> overtimeRecordsTableRefs(
    Expression<bool> Function($$OvertimeRecordsTableTableFilterComposer f) f,
  ) {
    final $$OvertimeRecordsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overtimeRecordsTable,
      getReferencedColumn: (t) => t.holidayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OvertimeRecordsTableTableFilterComposer(
            $db: $db,
            $table: $db.overtimeRecordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> overtimeRecordsTableRefs<T extends Object>(
    Expression<T> Function($$OvertimeRecordsTableTableAnnotationComposer a) f,
  ) {
    final $$OvertimeRecordsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.overtimeRecordsTable,
          getReferencedColumn: (t) => t.holidayId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OvertimeRecordsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.overtimeRecordsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
          (HolidayModel, $$HolidaysTableTableReferences),
          HolidayModel,
          PrefetchHooks Function({bool overtimeRecordsTableRefs})
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$HolidaysTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({overtimeRecordsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (overtimeRecordsTableRefs) db.overtimeRecordsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (overtimeRecordsTableRefs)
                    await $_getPrefetchedData<
                      HolidayModel,
                      $HolidaysTableTable,
                      OvertimeRecordModel
                    >(
                      currentTable: table,
                      referencedTable: $$HolidaysTableTableReferences
                          ._overtimeRecordsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$HolidaysTableTableReferences(
                            db,
                            table,
                            p0,
                          ).overtimeRecordsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.holidayId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (HolidayModel, $$HolidaysTableTableReferences),
      HolidayModel,
      PrefetchHooks Function({bool overtimeRecordsTableRefs})
    >;
typedef $$OvertimeRecordsTableTableCreateCompanionBuilder =
    OvertimeRecordsTableCompanion Function({
      Value<int> id,
      required int workReason,
      required DateTime startDate,
      required DateTime endDate,
      required int daysCount,
      Value<int?> holidayId,
      Value<bool> isConsumed,
      Value<String?> notes,
    });
typedef $$OvertimeRecordsTableTableUpdateCompanionBuilder =
    OvertimeRecordsTableCompanion Function({
      Value<int> id,
      Value<int> workReason,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> daysCount,
      Value<int?> holidayId,
      Value<bool> isConsumed,
      Value<String?> notes,
    });

final class $$OvertimeRecordsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OvertimeRecordsTableTable,
          OvertimeRecordModel
        > {
  $$OvertimeRecordsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HolidaysTableTable _holidayIdTable(_$AppDatabase db) =>
      db.holidaysTable.createAlias(
        $_aliasNameGenerator(
          db.overtimeRecordsTable.holidayId,
          db.holidaysTable.id,
        ),
      );

  $$HolidaysTableTableProcessedTableManager? get holidayId {
    final $_column = $_itemColumn<int>('holiday_id');
    if ($_column == null) return null;
    final manager = $$HolidaysTableTableTableManager(
      $_db,
      $_db.holidaysTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_holidayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $RestAllowancesTableTable,
    List<RestAllowanceModel>
  >
  _restAllowancesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.restAllowancesTable,
        aliasName: $_aliasNameGenerator(
          db.overtimeRecordsTable.id,
          db.restAllowancesTable.overtimeId,
        ),
      );

  $$RestAllowancesTableTableProcessedTableManager get restAllowancesTableRefs {
    final manager = $$RestAllowancesTableTableTableManager(
      $_db,
      $_db.restAllowancesTable,
    ).filter((f) => f.overtimeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _restAllowancesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OvertimeRecordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $OvertimeRecordsTableTable> {
  $$OvertimeRecordsTableTableFilterComposer({
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

  ColumnFilters<int> get workReason => $composableBuilder(
    column: $table.workReason,
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

  ColumnFilters<bool> get isConsumed => $composableBuilder(
    column: $table.isConsumed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$HolidaysTableTableFilterComposer get holidayId {
    final $$HolidaysTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.holidayId,
      referencedTable: $db.holidaysTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HolidaysTableTableFilterComposer(
            $db: $db,
            $table: $db.holidaysTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> restAllowancesTableRefs(
    Expression<bool> Function($$RestAllowancesTableTableFilterComposer f) f,
  ) {
    final $$RestAllowancesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.restAllowancesTable,
      getReferencedColumn: (t) => t.overtimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RestAllowancesTableTableFilterComposer(
            $db: $db,
            $table: $db.restAllowancesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OvertimeRecordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OvertimeRecordsTableTable> {
  $$OvertimeRecordsTableTableOrderingComposer({
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

  ColumnOrderings<int> get workReason => $composableBuilder(
    column: $table.workReason,
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

  ColumnOrderings<bool> get isConsumed => $composableBuilder(
    column: $table.isConsumed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$HolidaysTableTableOrderingComposer get holidayId {
    final $$HolidaysTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.holidayId,
      referencedTable: $db.holidaysTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HolidaysTableTableOrderingComposer(
            $db: $db,
            $table: $db.holidaysTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OvertimeRecordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OvertimeRecordsTableTable> {
  $$OvertimeRecordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get workReason => $composableBuilder(
    column: $table.workReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get daysCount =>
      $composableBuilder(column: $table.daysCount, builder: (column) => column);

  GeneratedColumn<bool> get isConsumed => $composableBuilder(
    column: $table.isConsumed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$HolidaysTableTableAnnotationComposer get holidayId {
    final $$HolidaysTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.holidayId,
      referencedTable: $db.holidaysTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HolidaysTableTableAnnotationComposer(
            $db: $db,
            $table: $db.holidaysTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> restAllowancesTableRefs<T extends Object>(
    Expression<T> Function($$RestAllowancesTableTableAnnotationComposer a) f,
  ) {
    final $$RestAllowancesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.restAllowancesTable,
          getReferencedColumn: (t) => t.overtimeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RestAllowancesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.restAllowancesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OvertimeRecordsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OvertimeRecordsTableTable,
          OvertimeRecordModel,
          $$OvertimeRecordsTableTableFilterComposer,
          $$OvertimeRecordsTableTableOrderingComposer,
          $$OvertimeRecordsTableTableAnnotationComposer,
          $$OvertimeRecordsTableTableCreateCompanionBuilder,
          $$OvertimeRecordsTableTableUpdateCompanionBuilder,
          (OvertimeRecordModel, $$OvertimeRecordsTableTableReferences),
          OvertimeRecordModel,
          PrefetchHooks Function({bool holidayId, bool restAllowancesTableRefs})
        > {
  $$OvertimeRecordsTableTableTableManager(
    _$AppDatabase db,
    $OvertimeRecordsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OvertimeRecordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OvertimeRecordsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OvertimeRecordsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workReason = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> daysCount = const Value.absent(),
                Value<int?> holidayId = const Value.absent(),
                Value<bool> isConsumed = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => OvertimeRecordsTableCompanion(
                id: id,
                workReason: workReason,
                startDate: startDate,
                endDate: endDate,
                daysCount: daysCount,
                holidayId: holidayId,
                isConsumed: isConsumed,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workReason,
                required DateTime startDate,
                required DateTime endDate,
                required int daysCount,
                Value<int?> holidayId = const Value.absent(),
                Value<bool> isConsumed = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => OvertimeRecordsTableCompanion.insert(
                id: id,
                workReason: workReason,
                startDate: startDate,
                endDate: endDate,
                daysCount: daysCount,
                holidayId: holidayId,
                isConsumed: isConsumed,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OvertimeRecordsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({holidayId = false, restAllowancesTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (restAllowancesTableRefs) db.restAllowancesTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (holidayId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.holidayId,
                                    referencedTable:
                                        $$OvertimeRecordsTableTableReferences
                                            ._holidayIdTable(db),
                                    referencedColumn:
                                        $$OvertimeRecordsTableTableReferences
                                            ._holidayIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (restAllowancesTableRefs)
                        await $_getPrefetchedData<
                          OvertimeRecordModel,
                          $OvertimeRecordsTableTable,
                          RestAllowanceModel
                        >(
                          currentTable: table,
                          referencedTable: $$OvertimeRecordsTableTableReferences
                              ._restAllowancesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OvertimeRecordsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).restAllowancesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.overtimeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OvertimeRecordsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OvertimeRecordsTableTable,
      OvertimeRecordModel,
      $$OvertimeRecordsTableTableFilterComposer,
      $$OvertimeRecordsTableTableOrderingComposer,
      $$OvertimeRecordsTableTableAnnotationComposer,
      $$OvertimeRecordsTableTableCreateCompanionBuilder,
      $$OvertimeRecordsTableTableUpdateCompanionBuilder,
      (OvertimeRecordModel, $$OvertimeRecordsTableTableReferences),
      OvertimeRecordModel,
      PrefetchHooks Function({bool holidayId, bool restAllowancesTableRefs})
    >;
typedef $$RestAllowancesTableTableCreateCompanionBuilder =
    RestAllowancesTableCompanion Function({
      Value<int> id,
      required int workReason,
      required int overtimeId,
      required DateTime startDate,
      required DateTime endDate,
      required int daysCount,
      Value<String?> notes,
    });
typedef $$RestAllowancesTableTableUpdateCompanionBuilder =
    RestAllowancesTableCompanion Function({
      Value<int> id,
      Value<int> workReason,
      Value<int> overtimeId,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> daysCount,
      Value<String?> notes,
    });

final class $$RestAllowancesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RestAllowancesTableTable,
          RestAllowanceModel
        > {
  $$RestAllowancesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OvertimeRecordsTableTable _overtimeIdTable(_$AppDatabase db) =>
      db.overtimeRecordsTable.createAlias(
        $_aliasNameGenerator(
          db.restAllowancesTable.overtimeId,
          db.overtimeRecordsTable.id,
        ),
      );

  $$OvertimeRecordsTableTableProcessedTableManager get overtimeId {
    final $_column = $_itemColumn<int>('overtime_id')!;

    final manager = $$OvertimeRecordsTableTableTableManager(
      $_db,
      $_db.overtimeRecordsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_overtimeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

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

  ColumnFilters<int> get workReason => $composableBuilder(
    column: $table.workReason,
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

  $$OvertimeRecordsTableTableFilterComposer get overtimeId {
    final $$OvertimeRecordsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.overtimeId,
      referencedTable: $db.overtimeRecordsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OvertimeRecordsTableTableFilterComposer(
            $db: $db,
            $table: $db.overtimeRecordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  ColumnOrderings<int> get workReason => $composableBuilder(
    column: $table.workReason,
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

  $$OvertimeRecordsTableTableOrderingComposer get overtimeId {
    final $$OvertimeRecordsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.overtimeId,
          referencedTable: $db.overtimeRecordsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OvertimeRecordsTableTableOrderingComposer(
                $db: $db,
                $table: $db.overtimeRecordsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
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

  GeneratedColumn<int> get workReason => $composableBuilder(
    column: $table.workReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get daysCount =>
      $composableBuilder(column: $table.daysCount, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$OvertimeRecordsTableTableAnnotationComposer get overtimeId {
    final $$OvertimeRecordsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.overtimeId,
          referencedTable: $db.overtimeRecordsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OvertimeRecordsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.overtimeRecordsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
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
          (RestAllowanceModel, $$RestAllowancesTableTableReferences),
          RestAllowanceModel,
          PrefetchHooks Function({bool overtimeId})
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
                Value<int> workReason = const Value.absent(),
                Value<int> overtimeId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> daysCount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => RestAllowancesTableCompanion(
                id: id,
                workReason: workReason,
                overtimeId: overtimeId,
                startDate: startDate,
                endDate: endDate,
                daysCount: daysCount,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workReason,
                required int overtimeId,
                required DateTime startDate,
                required DateTime endDate,
                required int daysCount,
                Value<String?> notes = const Value.absent(),
              }) => RestAllowancesTableCompanion.insert(
                id: id,
                workReason: workReason,
                overtimeId: overtimeId,
                startDate: startDate,
                endDate: endDate,
                daysCount: daysCount,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RestAllowancesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({overtimeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (overtimeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.overtimeId,
                                referencedTable:
                                    $$RestAllowancesTableTableReferences
                                        ._overtimeIdTable(db),
                                referencedColumn:
                                    $$RestAllowancesTableTableReferences
                                        ._overtimeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
      (RestAllowanceModel, $$RestAllowancesTableTableReferences),
      RestAllowanceModel,
      PrefetchHooks Function({bool overtimeId})
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
  $$OvertimeRecordsTableTableTableManager get overtimeRecordsTable =>
      $$OvertimeRecordsTableTableTableManager(_db, _db.overtimeRecordsTable);
  $$RestAllowancesTableTableTableManager get restAllowancesTable =>
      $$RestAllowancesTableTableTableManager(_db, _db.restAllowancesTable);
}
