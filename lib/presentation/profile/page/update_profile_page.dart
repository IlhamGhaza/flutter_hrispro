import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hrispro/core/components/spaces.dart';
import 'package:flutter_hrispro/core/components/top_bar.dart';
import 'package:flutter_hrispro/core/constant/colors.dart';
import '../../../core/components/image_picker_widget.dart';
import '../../../data/model/response/auth_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/datasource/auth_local_datasource.dart';
import '../../../data/model/request/user_request_model.dart';
import '../bloc/get_user/get_user_bloc.dart';
import '../bloc/update_user/update_user_bloc.dart';

class UpdateProfilePage extends StatefulWidget {
  final User user;
  const UpdateProfilePage({super.key, required this.user});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? phoneController;
  XFile? imageFile;
  AuthResponseModel? authData;

  @override
  void initState() {
    super.initState();
    loadData();
    nameController = TextEditingController(text: widget.user.name ?? '');
    emailController = TextEditingController(text: widget.user.email ?? '');
    phoneController = TextEditingController(text: widget.user.phone ?? '');
  }

  loadData() async {
    authData = await AuthLocalDatasource().getAuthData();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    nameController?.dispose();
    emailController?.dispose();
    phoneController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TopBar(
        title: 'Edit Profile',
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Image Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: ImagePickerWidget(
                label: 'Profile Picture',
                onChanged: (file) {
                  if (file != null) {
                    setState(() {
                      imageFile = file;
                    });
                  }
                },
                imageUrl: widget.user.imageUrl,
              ),
            ),
            const SpaceHeight(20),
            
            // Form Fields Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'Update your personal information',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SpaceHeight(24),
                  
                  _buildTextField(
                    controller: nameController!,
                    label: 'Full Name',
                    icon: LucideIcons.user,
                  ),
                  const SpaceHeight(16),
                  
                  _buildTextField(
                    controller: emailController!,
                    label: 'Email Address',
                    icon: LucideIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SpaceHeight(16),
                  
                  _buildTextField(
                    controller: phoneController!,
                    label: 'Phone Number',
                    icon: LucideIcons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            const SpaceHeight(32),
            
            // Update Button
            SizedBox(
              width: double.infinity,
              child: _buildUpdateButton(),
            ),
            const SpaceHeight(32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
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
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                size: 18,
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return BlocConsumer<UpdateUserBloc, UpdateUserState>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () {},
          success: (user) async {
            context.read<GetUserBloc>().add(const GetUserEvent.getUser());
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!', style: TextStyle(color: Colors.white)),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop(true);
          },
          error: (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to update profile. Please try again.', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () {
            return ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          loading: () {
            return ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _updateProfile() {
    if (nameController!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (emailController!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (phoneController!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your phone number', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final String name = nameController!.text.trim();
    final String email = emailController!.text.trim();
    final String phone = phoneController!.text.trim();

    final UserRequestModel user = UserRequestModel(
      id: widget.user.id!,
      name: name,
      email: email,
      phone: phone,
      image: imageFile,
    );

    context.read<UpdateUserBloc>().add(
      UpdateUserEvent.updateUser(user, widget.user.id!),
    );
  }
}
