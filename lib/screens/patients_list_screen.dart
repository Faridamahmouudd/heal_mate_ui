import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/gradient_button.dart';
import 'patient_profile_screen.dart';
import 'chat_screen.dart';

class PatientsListScreen extends StatelessWidget {
  const PatientsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const _PatientsListHeader(),
            const SizedBox(height: 10),
            const _PatientsFilterRow(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return _PatientListCard(
                    name: "Alexander Bennett, Ph.D.",
                    specialty: "Cardiology",
                    visits: "${index + 1} visits",
                    avatarPath: "assets/images/patient_avatar.jpeg",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PatientsListHeader extends StatelessWidget {
  const _PatientsListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 20, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          ),
          const Expanded(
            child: Text(
              "Patients",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _PatientsFilterRow extends StatelessWidget {
  const _PatientsFilterRow();

  @override
  Widget build(BuildContext context) {
    final filters = ["A-Z", "⭐", "Critical", "New", "Robot"];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) {
          final isActive = index == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              filters[index],
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textDark,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: filters.length,
      ),
    );
  }
}

class _PatientListCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String visits;
  final String avatarPath;

  const _PatientListCard({
    required this.name,
    required this.specialty,
    required this.visits,
    required this.avatarPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(avatarPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PatientProfileScreen(),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      visits,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 4),

          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PatientProfileScreen()),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              backgroundColor: AppColors.inputBackground,
              minimumSize: const Size(0, 0),
            ),
            icon: const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
            label: const Text(
              "Info",
              style: TextStyle(fontSize: 11, color: AppColors.primary),
            ),
          ),

          const SizedBox(width: 4),

          // ✅ التعديل هنا: يدخل شات المريض مباشرة
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    chatName: name,
                    avatarPath: avatarPath,
                    subtitle: "$specialty • Patient",
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              backgroundColor: AppColors.primary,
              minimumSize: const Size(0, 0),
            ),
            icon: const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.white),
            label: const Text(
              "Chat",
              style: TextStyle(fontSize: 11, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
