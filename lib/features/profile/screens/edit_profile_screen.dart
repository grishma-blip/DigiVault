import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../auth/providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _dobController;
  late String _selectedGender;
  late String _avatarUrl;
  bool _isSaving = false;

  final List<Map<String, String>> _avatarOptions = [
    {'name': 'Default Citizen', 'url': 'avatar_default'},
    {'name': 'Engineer / Student', 'url': 'avatar_engineer'},
    {'name': 'Government Officer', 'url': 'avatar_officer'},
    {'name': 'Professional Female', 'url': 'avatar_female'},
    {'name': 'Professional Male', 'url': 'avatar_male'},
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController = TextEditingController(text: user.fullName);
    _emailController = TextEditingController(text: user.email);
    _mobileController = TextEditingController(text: user.mobileNumber);
    _dobController = TextEditingController(text: user.dob);
    _selectedGender = user.gender;
    _avatarUrl = user.avatarUrl.isEmpty ? 'avatar_default' : user.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _showAvatarPickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Profile Photo Avatar',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose a verified profile avatar for your DigiLocker e-credential enclave.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _avatarOptions.map((opt) {
                  final isSelected = _avatarUrl == opt['url'];
                  return GestureDetector(
                    onTap: () {
                      setState(() => _avatarUrl = opt['url']!);
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: AppColors.primary.withOpacity(0.12),
                            child: Icon(
                              _getAvatarIcon(opt['url']!),
                              color: AppColors.primary,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          opt['name']!.split(' ').first,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  IconData _getAvatarIcon(String urlKey) {
    switch (urlKey) {
      case 'avatar_engineer':
        return Icons.engineering_rounded;
      case 'avatar_officer':
        return Icons.badge_rounded;
      case 'avatar_female':
        return Icons.face_3_rounded;
      case 'avatar_male':
        return Icons.face_6_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  void _onSaveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full Name cannot be empty.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final auth = context.read<AuthProvider>();
    await auth.updateUserProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      dob: _dobController.text.trim(),
      gender: _selectedGender,
      avatarUrl: _avatarUrl,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile details updated successfully!'),
          backgroundColor: AppColors.tertiary,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Change Card Header
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.primary.withOpacity(0.12),
                          child: Icon(_getAvatarIcon(_avatarUrl), color: AppColors.primary, size: 52),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showAvatarPickerModal,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: _showAvatarPickerModal,
                      icon: const Icon(Icons.photo_camera_outlined, size: 16),
                      label: const Text(
                        'Change Profile Photo',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              // Full Name Field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Citizen Name',
                  prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primary),
                  hintText: 'Grishma Thakare',
                ),
              ),
              const SizedBox(height: 16),

              // Email Address Field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
                  hintText: 'grishma.thakare@example.com',
                ),
              ),
              const SizedBox(height: 16),

              // Mobile Number Field
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Registered Mobile (+91)',
                  prefixIcon: Icon(Icons.phone_android_rounded, color: AppColors.primary),
                  hintText: '+91 98765 43210',
                ),
              ),
              const SizedBox(height: 16),

              // Row for Date of Birth & Gender Selection
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _dobController,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                        hintText: '21/11/2005',
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: Icon(Icons.wc_rounded, color: AppColors.primary),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedGender = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Save Profile Changes',
                isLoading: _isSaving,
                onPressed: _onSaveProfile,
                icon: Icons.check_circle_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
