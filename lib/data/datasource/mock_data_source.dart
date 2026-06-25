import '../model/response/models.dart';

class MockDataSource {
  static const Employee emp = Employee(
    name: "Ilham Prasetyo",
    id: "EMP-2024-0087",
    dept: "Information Technology",
    position: "Senior Software Engineer",
    email: "ilham.prasetyo@company.com",
    phone: "+62 812-3456-7890",
    role: "Manager",
    joinDate: "March 15, 2021",
    leaveBalance: 12,
  );

  static const List<Attendance> attendance = [
    Attendance(id: 1, date: "Mon, Jun 22", inn: "08:02", out: "17:15", loc: "Main Office", status: "Present", hrs: "9h 13m"),
    Attendance(id: 2, date: "Fri, Jun 19", inn: "08:15", out: "17:00", loc: "Main Office", status: "Present", hrs: "8h 45m"),
    Attendance(id: 3, date: "Thu, Jun 18", inn: "09:35", out: "17:00", loc: "Main Office", status: "Late", hrs: "7h 25m"),
    Attendance(id: 4, date: "Wed, Jun 17", inn: "08:00", out: "18:30", loc: "Client Office", status: "Present", hrs: "10h 30m"),
    Attendance(id: 5, date: "Tue, Jun 16", inn: "08:05", out: "17:00", loc: "WFH", status: "Present", hrs: "8h 55m"),
    Attendance(id: 6, date: "Mon, Jun 15", inn: "—", out: "—", loc: "—", status: "Absent", hrs: "—"),
  ];

  static const List<Leave> leaves = [
    Leave(id: 1, type: "Annual Leave", start: "Jun 10", end: "Jun 12", days: 3, status: "Approved", reason: "Family vacation"),
    Leave(id: 2, type: "Sick Leave", start: "May 28", end: "May 28", days: 1, status: "Approved", reason: "Fever and fatigue"),
    Leave(id: 3, type: "Annual Leave", start: "May 5", end: "May 7", days: 3, status: "Rejected", reason: "Personal matters"),
    Leave(id: 4, type: "Special Leave", start: "Apr 15", end: "Apr 16", days: 2, status: "Approved", reason: "Family bereavement"),
  ];

  static const List<Overtime> overtime = [
    Overtime(id: 1, date: "Jun 19", start: "17:00", end: "20:00", hrs: "3h", project: "Mobile App v2.0", status: "Approved"),
    Overtime(id: 2, date: "Jun 15", start: "17:00", end: "19:30", hrs: "2.5h", project: "System Migration", status: "Pending"),
    Overtime(id: 3, date: "Jun 8", start: "17:00", end: "21:00", hrs: "4h", project: "Q2 Deployment", status: "Approved"),
  ];

  static const List<AppNotification> notifs = [
    AppNotification(id: 1, cat: "Leave", title: "Leave Request Approved", msg: "Your Annual Leave for Jun 10-12 has been approved by Budi Santoso.", time: "2h ago", read: false),
    AppNotification(id: 2, cat: "Attendance", title: "Attendance Reminder", msg: "You have not checked out today. Submit a correction if needed.", time: "5h ago", read: false),
    AppNotification(id: 3, cat: "HR", title: "Policy Update", msg: "Updated WFH policy effective July 1, 2026. Please review.", time: "1d ago", read: true),
    AppNotification(id: 4, cat: "Overtime", title: "Overtime Request Approved", msg: "Your overtime for Jun 19 (3 hours) has been approved.", time: "2d ago", read: true),
    AppNotification(id: 5, cat: "System", title: "Scheduled Maintenance", msg: "System maintenance on Jun 27, 22:00–02:00 WIB.", time: "3d ago", read: true),
    AppNotification(id: 6, cat: "HR", title: "Mid-Year Review Reminder", msg: "Self-assessment period starts July 1. Please complete by July 15.", time: "4d ago", read: true),
  ];

  static const List<Approval> approvals = [
    Approval(id: 1, name: "Reza Firmansyah", empId: "EMP-0092", dept: "IT", ini: "RF", type: "Leave", sub: "Annual Leave", detail: "Jun 25–27 · 3 days", reason: "Family event in Surabaya", time: "Jun 22, 09:15"),
    Approval(id: 2, name: "Sari Dewi", empId: "EMP-0078", dept: "IT", ini: "SD", type: "Overtime", sub: "Project Overtime", detail: "Jun 22 · 3h (17:00–20:00)", reason: "Feature deployment deadline", time: "Jun 21, 16:30"),
    Approval(id: 3, name: "Andi Kurniawan", empId: "EMP-0103", dept: "IT", ini: "AK", type: "Correction", sub: "Forgot Check In", detail: "Jun 19", reason: "Badge reader malfunction at gate", time: "Jun 19, 14:00"),
    Approval(id: 4, name: "Maya Sari", empId: "EMP-0065", dept: "IT", ini: "MS", type: "Leave", sub: "Sick Leave", detail: "Jun 23 · 1 day", reason: "Doctor appointment", time: "Jun 22, 07:45"),
  ];

  static const List<Announcement> announcements = [
    Announcement(id: 1, title: "Independence Day Holiday", body: "July 17 is a national holiday. Offices will be closed.", tag: "Holiday"),
    Announcement(id: 2, title: "New WFH Policy July 1", body: "Employees may work from home up to 2 days/week with manager approval.", tag: "Policy"),
    Announcement(id: 3, title: "Annual Health Check", body: "Medical check-ups scheduled July 7–11. Register via HR portal.", tag: "Event"),
  ];
}
