import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/loginflow/multiloginpage.dart';
import 'package:outc/widgets/components/toast.dart';
import 'package:outc/widgets/sharedprefservices.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = SharedPrefServices.getislogged().toString() == "true";
    if (!isLoggedIn) {
      return const _GuestAccountView();
    }

    final firstName = SharedPrefServices.getfirstname() ?? "";
    final lastName = SharedPrefServices.getlastname() ?? "";
    final email = SharedPrefServices.getemail() ?? "";
    final mobile = SharedPrefServices.getphonenumber() ?? "";
    final profileImage = SharedPrefServices.getprofileimage() ?? "";
    final fullName = [firstName, lastName].where((s) => s.isNotEmpty).join(" ");

    return Scaffold(
      backgroundColor: AppColors.subtleBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AccountHero(
              displayName: fullName.isEmpty ? "Guest" : fullName,
              initialsSource: firstName.isEmpty ? "Guest" : firstName,
              email: email,
              profileImageUrl: profileImage,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel("Personal"),
                  const SizedBox(height: AppSpacing.sm),
                  _SectionCard(children: [
                    _InfoRow(
                      icon: Icons.person_outline,
                      label: "First name",
                      value: firstName,
                    ),
                    _InfoRow(
                      icon: Icons.person_outline,
                      label: "Last name",
                      value: lastName,
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.lg),
                  const _SectionLabel("Contact"),
                  const SizedBox(height: AppSpacing.sm),
                  _SectionCard(children: [
                    _InfoRow(
                      icon: Icons.mail_outline,
                      label: "Email",
                      value: email,
                    ),
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: "Mobile number",
                      value: mobile,
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.lg),
                  const _SectionLabel("Address"),
                  const SizedBox(height: AppSpacing.sm),
                  const _AddressEmptyState(),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Colored header: avatar + name/email side by side, replacing the old
/// centered-avatar-then-separate-list layout so identity reads as one
/// glance instead of a scroll.
class _AccountHero extends StatelessWidget {
  const _AccountHero({
    required this.displayName,
    required this.initialsSource,
    required this.email,
    required this.profileImageUrl,
  });

  final String displayName;
  final String initialsSource;
  final String email;
  final String profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.xl, AppSpacing.md, AppSpacing.lg),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
      ),
      child: Row(
        children: [
          profileImageUrl.isEmpty
              ? SizedBox(
                  width: 62,
                  height: 62,
                  child: Avatar(
                    backgroundColor: Colors.white,
                    placeholderColors: const [Colors.white],
                    useCache: true,
                    onTap: () {},
                    name: initialsSource.toUpperCase(),
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 31.0,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 12.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () => showToast("Coming soon"),
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit_outlined, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: AppColors.surfaceGrey,
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.border),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final hasValue = value.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: AppColors.surfaceGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasValue ? value : "Not added",
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: hasValue ? AppColors.textPrimary : AppColors.surfaceGrey,
                    fontStyle: hasValue ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// No address API/field exists yet (spec gap, not a bug) — this replaces
/// four separately-hardcoded "TODO" rows with one honest empty state.
class _AddressEmptyState extends StatelessWidget {
  const _AddressEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.25)),
      ),
      child: const Row(
        children: [
          Icon(Icons.location_on_outlined, color: AppColors.secondary, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No address on file",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Add one for faster checkout",
                  style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestAccountView extends StatelessWidget {
  const _GuestAccountView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 100.0,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 15.0),
            const Text(
              "You're not logged in",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MultiLoginScreen()),
                ),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
