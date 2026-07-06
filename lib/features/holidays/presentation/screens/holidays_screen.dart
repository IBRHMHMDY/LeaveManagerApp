import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
import '../../domain/entities/holiday_entity.dart';
import '../bloc/holidays_bloc.dart';
import '../bloc/holidays_event.dart';
import '../bloc/holidays_state.dart';

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب البلد المحفوظ من SettingsBloc
    final settingsState = context.read<SettingsBloc>().state;
    final String country = settingsState is SettingsLoaded ? settingsState.settings.selectedCountry : 'مصر';

    return BlocProvider(
      create: (context) => sl<HolidaysBloc>()..add(LoadHolidaysEvent(country)),
      child: _HolidaysView(country: country),
    );
  }
}

class _HolidaysView extends StatelessWidget {
  final String country;
  const _HolidaysView({required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإجازات الرسمية'),
      ),
      body: BlocConsumer<HolidaysBloc, HolidaysState>(
        listener: (context, state) {
          if (state is HolidayOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is HolidaysError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is HolidaysLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HolidaysLoaded) {
            if (state.holidays.isEmpty) {
              return const Center(child: Text('لا توجد إجازات رسمية مسجلة لهذه السنة المالية.'));
            }
            return ListView.builder(
              itemCount: state.holidays.length,
              itemBuilder: (context, index) {
                final holiday = state.holidays[index];
                return _HolidayTile(holiday: holiday);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHolidayDialog(context, country),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddHolidayDialog(BuildContext context, String currentCountry) {
    final bloc = context.read<HolidaysBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddHolidayBottomSheet(bloc: bloc, country: currentCountry),
    );
  }
}

class _HolidayTile extends StatelessWidget {
  final Holiday holiday;
  const _HolidayTile({required this.holiday});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    final startStr = dateFormat.format(holiday.startDate);
    final endStr = dateFormat.format(holiday.endDate);
    final daysCount = holiday.endDate.difference(holiday.startDate).inDays + 1;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(holiday.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('من: $startStr  إلى: $endStr\n($daysCount أيام)'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            context.read<HolidaysBloc>().add(DeleteHolidayEvent(holiday.id));
          },
        ),
      ),
    );
  }
}

class _AddHolidayBottomSheet extends StatefulWidget {
  final HolidaysBloc bloc;
  final String country;

  const _AddHolidayBottomSheet({required this.bloc, required this.country});

  @override
  State<_AddHolidayBottomSheet> createState() => _AddHolidayBottomSheetState();
}

class _AddHolidayBottomSheetState extends State<_AddHolidayBottomSheet> {
  final _nameController = TextEditingController();
  DateTimeRange? _selectedDateRange;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty || _selectedDateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال اسم الإجازة وتحديد التواريخ.')),
      );
      return;
    }

    final newHoliday = Holiday(
      id: 0, 
      name: _nameController.text.trim(),
      startDate: _selectedDateRange!.start,
      endDate: _selectedDateRange!.end,
      country: widget.country, // تمرير البلد المختار للكيان الجديد
    );

    widget.bloc.add(AddHolidayEvent(newHoliday));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('إضافة إجازة رسمية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'اسم الإجازة (مثل: عيد الفطر)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.date_range),
            label: Text(_selectedDateRange == null 
              ? 'تحديد فترة الإجازة' 
              : '${DateFormat('MM/dd').format(_selectedDateRange!.start)} - ${DateFormat('MM/dd').format(_selectedDateRange!.end)}'),
            onPressed: _pickDateRange,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            onPressed: _submit,
            child: const Text('حفظ الإجازة'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}