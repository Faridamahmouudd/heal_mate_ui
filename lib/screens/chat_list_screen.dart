import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'chat_screen.dart';

enum ChatListType { patients, nurses }

class ChatListScreen extends StatelessWidget {
  final ChatListType type;
  const ChatListScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isPatients = type == ChatListType.patients;

    final items = isPatients
        ? [
      _ChatItem(
        name: "Olivia Turner",
        subtitle: "Room 203 • Patient",
        avatar: "assets/images/patient_avatar.jpeg",
      ),
      _ChatItem(
        name: "Sara Ibrahim",
        subtitle: "Room 105 • Patient",
        avatar: "assets/images/patient_avatar.jpeg",
      ),
    ]
        : [
      _ChatItem(
        name: "Nurse Mariam",
        subtitle: "ICU • Nurse",
        avatar: "assets/images/nurse.png",
      ),
      _ChatItem(
        name: "Nurse Ahmed",
        subtitle: "ER • Nurse",
        avatar: "assets/images/nurse.png",
      ),
    ];

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
        title: Text(
          isPatients ? "Patients Chats" : "Nurses Chats",
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final c = items[index];
          return _ChatCard(
            item: c,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    chatName: c.name,
                    avatarPath: c.avatar,
                    subtitle: c.subtitle,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ChatItem {
  final String name;
  final String subtitle;
  final String avatar;
  _ChatItem({
    required this.name,
    required this.subtitle,
    required this.avatar,
  });
}

class _ChatCard extends StatelessWidget {
  final _ChatItem item;
  final VoidCallback onTap;
  const _ChatCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 24, backgroundImage: AssetImage(item.avatar)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}
