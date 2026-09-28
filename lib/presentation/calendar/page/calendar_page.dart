import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';
import '../bloc/calendar_cubit.dart';
import '../bloc/calendar_event_cubit.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CalendarCubit()),
        BlocProvider(create: (_) => CalendarEventCubit()..fetchEvents(DateTime.now().month, DateTime.now().year)),
      ],
      child: const _CalendarView(),
    );
  }
}

class _CalendarView extends StatefulWidget {
  const _CalendarView();

  @override
  State<_CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView> {
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime? _selectedDate;
  
  void _changeMonth(int offset) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + offset, 1);
    });
    context.read<CalendarEventCubit>().fetchEvents(_currentMonth.month, _currentMonth.year);
  }

  @override
  Widget build(BuildContext context) {
    final dayHeaders = ['S', 'M', 'T', 'W', 'T', 'F', 'S']; // Sunday first

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TopBar(
        title: 'Calendar',
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(_currentMonth),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          _buildNavBtn(LucideIcons.chevronLeft, () => _changeMonth(-1)),
                          const SizedBox(width: 8),
                          _buildNavBtn(LucideIcons.chevronRight, () => _changeMonth(1)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      7,
                      (i) => Expanded(
                        child: Text(
                          dayHeaders[i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: (i == 0 || i == 6)
                                ? Colors.red.shade400
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<CalendarEventCubit, CalendarEventState>(
                    builder: (context, state) {
                      List<CalendarEvent> events = [];
                      if (state is CalendarEventLoaded) {
                        events = state.events;
                      }

                      // Calculate days
                      final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
                      final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
                      final daysInMonth = lastDayOfMonth.day;
                      
                      final firstWeekday = firstDayOfMonth.weekday; // 1 (Mon) - 7 (Sun)
                      final offset = firstWeekday == 7 ? 0 : firstWeekday;
                      
                      final totalCells = daysInMonth + offset;
                      final rowCount = (totalCells / 7).ceil();
                      
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          childAspectRatio: 1,
                        ),
                        itemCount: rowCount * 7,
                        itemBuilder: (context, idx) {
                          if (idx < offset || idx >= offset + daysInMonth) {
                            return const SizedBox(); // empty cell
                          }
                          
                          final day = idx - offset + 1;
                          final date = DateTime(_currentMonth.year, _currentMonth.month, day);
                          
                          final isToday = date.year == DateTime.now().year && 
                                          date.month == DateTime.now().month && 
                                          date.day == DateTime.now().day;
                                          
                          final isSelected = _selectedDate?.year == date.year &&
                                             _selectedDate?.month == date.month &&
                                             _selectedDate?.day == date.day;
                                             
                          final isWeekend = date.weekday == 6 || date.weekday == 7;
                          
                          // Find events for this day
                          final dayEvents = events.where((e) => e.date.day == date.day).toList();
                          final dotColor = dayEvents.isNotEmpty ? _getColorForType(dayEvents.first.type) : null;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppColors.primary
                                    : (isToday ? AppColors.primaryLight : Colors.transparent),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$day',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : (isToday
                                              ? AppColors.primary
                                              : (isWeekend ? Colors.red.shade400 : AppColors.textPrimary)),
                                    ),
                                  ),
                                  if (dotColor != null)
                                    Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.white : dotColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  ),
                ],
              ),
            ),
            
            // Legend
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LEGEND',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildLegendItem('Attendance', AppColors.success),
                      const SizedBox(width: 16),
                      _buildLegendItem('National Holiday', Colors.red.shade400),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildLegendItem('Company Event', AppColors.info),
                      const SizedBox(width: 16),
                      _buildLegendItem('Company Holiday', AppColors.purple),
                    ],
                  ),
                ],
              ),
            ),
            
            // Selected Date Events
            if (_selectedDate != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: BlocBuilder<CalendarEventCubit, CalendarEventState>(
                  builder: (context, state) {
                    if (state is CalendarEventLoaded) {
                      final dayEvents = state.events.where((e) => e.date.day == _selectedDate!.day).toList();
                      if (dayEvents.isEmpty) {
                        return const Text('No events for this date.', style: TextStyle(color: AppColors.textSecondary));
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: dayEvents.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _getColorForType(e.type),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )).toList(),
                      );
                    }
                    return const SizedBox();
                  }
                ),
              ),
              
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'national_holiday': return Colors.red.shade400;
      case 'company_event': return AppColors.info;
      case 'company_holiday': return AppColors.purple;
      case 'attendance': return AppColors.success;
      default: return AppColors.textSecondary;
    }
  }

  Widget _buildLegendItem(String label, Color color) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 16,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
