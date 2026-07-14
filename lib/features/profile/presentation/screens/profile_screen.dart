import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/session/auth_session.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // "User opened this screen" - this is where we either do the first
    // fetch, or (if we previously failed due to no internet) silently
    // retry now that the screen is being opened again.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().onScreenOpened(widget.userId);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Bonus: also re-check when the user backgrounds the app (e.g. to
    // turn on Wi-Fi) and comes back to this same still-open screen.
    if (state == AppLifecycleState.resumed) {
      context.read<ProfileProvider>().onScreenOpened(widget.userId);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _logout(BuildContext context) {
    AuthSession.instance.clear();
    context.read<ProfileProvider>().reset();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _buildBody(profileProvider),
    );
  }

  Widget _buildBody(ProfileProvider provider) {
    switch (provider.status) {
      case ProfileStatus.idle:
      case ProfileStatus.loading:
        return const LoadingWidget();

      case ProfileStatus.error:
        return ErrorView(
          message: provider.errorMessage ?? 'Something went wrong.',
          onRetry: () => provider.fetchProfile(widget.userId),
        );

      case ProfileStatus.success:
        final profile = provider.profile!;
        return RefreshIndicator(
          onRefresh: () => provider.fetchProfile(widget.userId),
          child: ListView(
            padding: EdgeInsets.all(24.w),
            children: [
              SizedBox(height: 24.h),
              CircleAvatar(
                radius: 56.r,
                backgroundImage: NetworkImage(profile.avatarUrl),
              ),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  profile.fullName,
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  profile.email,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 24.h),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('User ID'),
                  subtitle: Text('${profile.id}'),
                ),
              ),
            ],
          ),
        );
    }
  }
}
