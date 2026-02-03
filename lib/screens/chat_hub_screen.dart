import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'chat_list_screen.dart';

class ChatHubScreen extends StatelessWidget {
  const ChatHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        ),
        title: const Text(
          "Messages",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Who do you want to chat with?",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 14),

            // ✅ Full screen cards
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _BigChoiceCard(
                      title: "Patients",
                      subtitle: "Chat with your patients",
                      icon: Icons.people_alt_outlined,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.inputBackground.withOpacity(0.9),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChatListScreen(type: ChatListType.patients),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: _BigChoiceCard(
                      title: "Nurses",
                      subtitle: "Chat with nursing staff",
                      icon: Icons.medical_services_outlined,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.inputBackground.withOpacity(0.9),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChatListScreen(type: ChatListType.nurses),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BigChoiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _BigChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: AppColors.inputBackground.withOpacity(0.7),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}
