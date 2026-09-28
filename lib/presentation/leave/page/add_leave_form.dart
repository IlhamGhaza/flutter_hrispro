import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';
import '../bloc/leave_cubit.dart';
import '../bloc/get_all_leaves/get_all_leaves_bloc.dart';
import '../bloc/create_leave/create_leave_bloc.dart';
import '../bloc/leave_type/leave_type_bloc.dart';

class AddLeaveForm extends StatefulWidget {
  const AddLeaveForm({super.key});

  @override
  State<AddLeaveForm> createState() => _AddLeaveFormState();
}

class _AddLeaveFormState extends State<AddLeaveForm> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  int? _selectedLeaveTypeId;
  File? _selectedFile;
  String? _selectedFileName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LeaveTypeBloc>().add(const LeaveTypeEvent.getLeaveTypes());
      }
    });
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (file != null && file.path != null) {
      setState(() {
        _selectedFile = File(file.path!);
        _selectedFileName = file.name;
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatDisplayDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        controller.text = _formatDisplayDate(picked);
      });
    }
  }

  void _submitLeaveRequest() {
    if (_selectedLeaveTypeId == null ||
        _startDateController.text.isEmpty ||
        _endDateController.text.isEmpty ||
        _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final startDate = DateFormat(
      'dd MMM yyyy',
    ).parse(_startDateController.text);
    final endDate = DateFormat('dd MMM yyyy').parse(_endDateController.text);

    context.read<CreateLeaveBloc>().add(
      CreateLeaveEvent.createLeave(
        leaveTypeId: _selectedLeaveTypeId!,
        startDate: _formatDate(startDate),
        endDate: _formatDate(endDate),
        reason: _reasonController.text,
        attachment: _selectedFile,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateLeaveBloc, CreateLeaveState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          success: (response) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response),
                backgroundColor: AppColors.success,
              ),
            );
            context.read<GetAllLeavesBloc>().add(
              const GetAllLeavesEvent.getAllLeaves(),
            );
            context.read<LeaveCubit>().toggleForm(false);
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red),
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: TopBar(
          title: 'New Leave Request',
          onBack: () => context.read<LeaveCubit>().toggleForm(false),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Leave Type',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: BlocBuilder<LeaveTypeBloc, LeaveTypeState>(
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () => const SizedBox(
                              height: 48,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            success: (leaveTypesData) {
                              final leaveTypes = leaveTypesData.data ?? [];
                              if (leaveTypes.isEmpty) {
                                return const SizedBox(
                                  height: 48,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('No leave types available'),
                                  ),
                                );
                              }
                              if (_selectedLeaveTypeId == null) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (mounted) {
                                    setState(
                                      () => _selectedLeaveTypeId =
                                          leaveTypes.first.id,
                                    );
                                  }
                                });
                              }
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  isExpanded: true,
                                  value: _selectedLeaveTypeId,
                                  items: leaveTypes.map((t) {
                                    return DropdownMenuItem<int>(
                                      value: t.id,
                                      child: Text(
                                        t.name ?? '',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      _selectedLeaveTypeId = v;
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: () => _selectDate(_startDateController),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Text(
                                    _startDateController.text.isEmpty
                                        ? 'Select Date'
                                        : _startDateController.text,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _startDateController.text.isEmpty
                                          ? Colors.grey
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'End Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: () => _selectDate(_endDateController),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Text(
                                    _endDateController.text.isEmpty
                                        ? 'Select Date'
                                        : _endDateController.text,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _endDateController.text.isEmpty
                                          ? Colors.grey
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Reason',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _reasonController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Briefly describe your reason for leave...',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: const TextSpan(
                        text: 'Supporting Document ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        children: [
                          TextSpan(
                            text: '(optional)',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _pickFile,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.border,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              LucideIcons.fileText,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _selectedFileName ?? 'Tap to upload document',
                              style: TextStyle(
                                color: _selectedFileName != null
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (_selectedFileName == null)
                              const Text(
                                'PDF, JPG or PNG · Max 5MB',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<CreateLeaveBloc, CreateLeaveState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.maybeWhen(
                        loading: () => null,
                        orElse: () => _submitLeaveRequest,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.maybeWhen(
                        loading: () => const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        orElse: () => const Text(
                          'Submit Leave Request',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
