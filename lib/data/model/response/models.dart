import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String name;
  final String id;
  final String dept;
  final String position;
  final String email;
  final String phone;
  final String role;
  final String joinDate;
  final int leaveBalance;

  const Employee({
    required this.name,
    required this.id,
    required this.dept,
    required this.position,
    required this.email,
    required this.phone,
    required this.role,
    required this.joinDate,
    required this.leaveBalance,
  });

  @override
  List<Object?> get props => [id, name];
}

class Attendance extends Equatable {
  final int id;
  final String date;
  final String inn;
  final String out;
  final String loc;
  final String status;
  final String hrs;

  const Attendance({
    required this.id,
    required this.date,
    required this.inn,
    required this.out,
    required this.loc,
    required this.status,
    required this.hrs,
  });

  @override
  List<Object?> get props => [id];
}

class Leave extends Equatable {
  final int id;
  final String type;
  final String start;
  final String end;
  final int days;
  final String status;
  final String reason;

  const Leave({
    required this.id,
    required this.type,
    required this.start,
    required this.end,
    required this.days,
    required this.status,
    required this.reason,
  });

  @override
  List<Object?> get props => [id];
}

class Overtime extends Equatable {
  final int id;
  final String date;
  final String start;
  final String end;
  final String hrs;
  final String project;
  final String status;

  const Overtime({
    required this.id,
    required this.date,
    required this.start,
    required this.end,
    required this.hrs,
    required this.project,
    required this.status,
  });

  @override
  List<Object?> get props => [id];
}

class AppNotification extends Equatable {
  final int id;
  final String cat;
  final String title;
  final String msg;
  final String time;
  final bool read;

  const AppNotification({
    required this.id,
    required this.cat,
    required this.title,
    required this.msg,
    required this.time,
    required this.read,
  });

  @override
  List<Object?> get props => [id];
}

class Approval extends Equatable {
  final int id;
  final String name;
  final String empId;
  final String dept;
  final String ini;
  final String type;
  final String sub;
  final String detail;
  final String reason;
  final String time;

  const Approval({
    required this.id,
    required this.name,
    required this.empId,
    required this.dept,
    required this.ini,
    required this.type,
    required this.sub,
    required this.detail,
    required this.reason,
    required this.time,
  });

  @override
  List<Object?> get props => [id];
}

class Announcement extends Equatable {
  final int id;
  final String title;
  final String body;
  final String tag;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.tag,
  });

  @override
  List<Object?> get props => [id];
}
