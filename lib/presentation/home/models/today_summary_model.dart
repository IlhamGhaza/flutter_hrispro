class TodaySummaryModel {
  final String checkIn;
  final String checkInStatus;
  final String checkOut;
  final String checkOutStatus;
  final String workHours;
  final String workHoursTotal;
  final String overtime;
  final String overtimeStatus;

  TodaySummaryModel({
    required this.checkIn,
    required this.checkInStatus,
    required this.checkOut,
    required this.checkOutStatus,
    required this.workHours,
    required this.workHoursTotal,
    required this.overtime,
    required this.overtimeStatus,
  });
}
