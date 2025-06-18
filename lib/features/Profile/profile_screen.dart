import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import necessary files based on your project structure
import '../../common_widgets.dart/change_password.dart';
import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../theme/app_theme.dart';
import '../../util/check_login.dart';
import '../../util/format_function.dart';
import '../signin/signin_screen.dart';
import 'profile_bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileBloc _profileBloc = ProfileBloc();
  Map _profile = {};

  @override
  void initState() {
    getProfile();
    checkLogin(context);
    super.initState();
  }

  void getProfile() {
    _profileBloc.add(GetAllProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getProfile();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is ProfileGetSuccessState) {
            _profile = state.profile;
            setState(() {});
          } else if (state is ProfileSuccessState) {
            getProfile();
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.only(
                top: 20, left: 20, right: 20, bottom: 120),
            children: [
              const SizedBox(height: 16),
              Center(
                child: ProfileImage(
                  image: _profile['photo'],
                ),
              ), // No edit option
              const SizedBox(height: 25),

              CustomInfoTile(
                  icon: Icons.person,
                  label: "Name",
                  value: formatValue(_profile['name'])),
              CustomInfoTile(
                  icon: Icons.email,
                  label: "Email",
                  value: formatValue(_profile['email'])),
              CustomInfoTile(
                icon: Icons.phone,
                label: "Phone",
                value: '+91 ${formatValue(_profile['phone'])}',
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: outlineColor, width: 2),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trip image with overlay
                    if (_profile['license_url'] != null)
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          _profile['license_url'],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.tag,
                            color: Colors.black,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            formatValue(_profile['license_no']),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomInfoTile(
                icon: Icons.lock,
                label: "Change Password",
                value: "",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ChangePasswordDialog(),
                  );
                }, // Add navigation or logic here
              ),
              CustomInfoTile(
                icon: Icons.exit_to_app,
                label: "Sign Out",
                value: "",
                isDestructive: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                      title: "SIGN OUT",
                      content: const Text(
                        "Are you sure you want to Sign Out? Clicking 'Sign Out' will end your current session and require you to sign in again to access your account.",
                      ),
                      primaryButton: "SIGN OUT",
                      onPrimaryPressed: () {
                        Supabase.instance.client.auth.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SigninScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  );
                }, // Add logout functionality
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String? image;
  const ProfileImage({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(
        side: BorderSide(width: 2, color: outlineColor),
      ),
      elevation: 4,
      shadowColor: Colors.black26,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: image != null
            ? Image.network(image!, width: 150, height: 150, fit: BoxFit.cover)
            : const SizedBox(
                width: 150,
                height: 150,
                child: Icon(Icons.person, size: 50, color: iconColor),
              ),
      ),
    );
  }
}

// Custom Info Tile (Reused for Both Info & Buttons)
class CustomInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDestructive;

  const CustomInfoTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: outlineColor),
            color: isDestructive
                ? Colors.redAccent.withAlpha(200)
                : Colors.white.withAlpha(200),
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: isDestructive ? Colors.white : Colors.black54,
                  size: 22),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isDestructive ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (value.isNotEmpty)
                Text(
                  value,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
