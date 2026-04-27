import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/colors.dart';
import 'chat_screen.dart';

class TreatmentPlansScreen extends StatefulWidget {
  const TreatmentPlansScreen({super.key});

  @override
  State<TreatmentPlansScreen> createState() => _TreatmentPlansScreenState();
}

class _TreatmentPlansScreenState extends State<TreatmentPlansScreen> {
  String _filter = "All";
  bool _drawerOpen = false;

  final List<_PlanModel> _plans = [
    _PlanModel(
      patientName: "Sara Ibrahim",
      patientImage: "assets/images/patient_avatar.jpeg",
      specialty: "Dermatology",
      title: "AI Chickenpox Screening Plan",
      details: "Diagnosis: Chickenpox (Positive)\n\n"
          "Suggested Plan:\n"
          "• Isolation & hydration\n"
          "• Paracetamol if fever\n"
          "• Itch relief + skin care\n"
          "• Doctor review required",
      status: "Pending",
      nextAction: "Awaiting doctor approval",
      lastUpdated: "Today",
      source: "AI Suggested",
      hasSkinImage: true,
      diagnosis: "Chickenpox: Positive",
    ),
    _PlanModel(
      patientName: "Olivia Turner",
      patientImage: "assets/images/patient_avatar.jpeg",
      specialty: "Endocrinology",
      title: "Diabetes Control Plan",
      details:
      "Metformin 500mg — 2x daily after meals.\nHydration reminders.\nFollow-up in 7 days.",
      status: "Active",
      nextAction: "Next dose: Today 6:00 PM",
      lastUpdated: "Today",
      source: "Doctor Plan",
      hasSkinImage: false,
      diagnosis: null,
    ),
    _PlanModel(
      patientName: "Mohamed Adel",
      patientImage: "assets/images/patient_avatar.jpeg",
      specialty: "Cardiology",
      title: "Blood Pressure Plan",
      details:
      "Amlodipine 5mg — once daily.\nReduce salt.\nFollow-up in 10 days.",
      status: "Pending",
      nextAction: "Pending approval",
      lastUpdated: "Yesterday",
      source: "Doctor Plan",
      hasSkinImage: false,
      diagnosis: null,
    ),
    _PlanModel(
      patientName: "Youssef Hassan",
      patientImage: "assets/images/patient_avatar.jpeg",
      specialty: "Pulmonology",
      title: "Asthma Management Plan",
      details:
      "Inhaler — 2 puffs when needed.\nPeak flow monitoring.\nFollow-up in 9 days.",
      status: "Active",
      nextAction: "Next check: Tomorrow 9:00 AM",
      lastUpdated: "2 days ago",
      source: "Doctor Plan",
      hasSkinImage: false,
      diagnosis: null,
    ),
    _PlanModel(
      patientName: "Mariam Hassan",
      patientImage: "assets/images/patient_avatar.jpeg",
      specialty: "Dermatology",
      title: "Skin Care Plan",
      details:
      "Topical cream — apply nightly.\nAvoid sun exposure.\nFollow-up in 14 days.",
      status: "Completed",
      nextAction: "Completed",
      lastUpdated: "3 days ago",
      source: "Doctor Plan",
      hasSkinImage: false,
      diagnosis: null,
    ),
  ];

  List<_PlanModel> get _filteredPlans {
    if (_filter == "All") return _plans;
    return _plans.where((p) => p.status == _filter).toList();
  }

  Future<File> _generatePdf(_PlanModel plan) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "HealMate Treatment Plan",
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 16),
            pw.Text("Patient: ${plan.patientName}"),
            pw.Text("Specialty: ${plan.specialty}"),
            pw.Text("Status: ${plan.status}"),
            pw.Text("Source: ${plan.source}"),
            if (plan.diagnosis != null) pw.Text("Diagnosis: ${plan.diagnosis}"),
            pw.SizedBox(height: 16),
            pw.Text(
              plan.title,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Text(plan.details),
            pw.SizedBox(height: 16),
            pw.Text("Next Action: ${plan.nextAction}"),
            pw.Text("Last Updated: ${plan.lastUpdated}"),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final safeName = plan.patientName.replaceAll(" ", "_").toLowerCase();
    final file = File("${dir.path}/${safeName}_treatment_plan.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _exportPdf(_PlanModel plan) async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 200));
    final file = await _generatePdf(plan);
    await Printing.layoutPdf(onLayout: (_) async => file.readAsBytes());
  }

  Future<void> _sharePlan(_PlanModel plan) async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 200));
    final file = await _generatePdf(plan);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: "HealMate Treatment Plan for ${plan.patientName}",
    );
  }

  void _messagePatient(_PlanModel plan) {
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatId: "plan_${plan.patientName}",
            chatName: plan.patientName,
            avatarPath: plan.patientImage,
            subtitle: "${plan.specialty} • Patient",
          ),
        ),
      );
    });
  }

  void _editPlan(_PlanModel plan) {
    Navigator.pop(context);

    Future.delayed(const Duration(milliseconds: 200), () {
      final titleCtrl = TextEditingController(text: plan.title);
      final detailsCtrl = TextEditingController(text: plan.details);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        builder: (_) {
          return Padding(
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: 14,
              bottom: MediaQuery.of(context).viewInsets.bottom + 18,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Edit Treatment Plan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _EditField(controller: titleCtrl, hint: "Plan title"),
                const SizedBox(height: 10),
                _EditField(
                  controller: detailsCtrl,
                  hint: "Plan details",
                  maxLines: 7,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final newTitle = titleCtrl.text.trim();
                      final newDetails = detailsCtrl.text.trim();

                      if (newTitle.isEmpty || newDetails.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all fields"),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        plan.title = newTitle;
                        plan.details = newDetails;
                        plan.lastUpdated = "Just now";
                      });

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Plan updated successfully"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _approvePlan(_PlanModel plan) {
    Navigator.pop(context);

    setState(() {
      plan.status = "Active";
      plan.nextAction = "Approved • Medicine drawer opened";
      plan.lastUpdated = "Just now";
      _drawerOpen = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Approved ✅ • Opening medicine drawer...")),
    );

    Timer(const Duration(seconds: 30), () {
      if (!mounted) return;
      setState(() => _drawerOpen = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Drawer closed ✅")),
      );
    });
  }

  void _declinePlan(_PlanModel plan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Decline Plan?"),
        content: const Text("Are you sure you want to decline this plan?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);

              setState(() {
                plan.status = "Completed";
                plan.nextAction = "Declined by doctor";
                plan.lastUpdated = "Just now";
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Plan declined")),
              );
            },
            child: const Text(
              "Decline",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _addPlanSheet() {
    final nameCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final detailsCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 14,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Add New Plan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              _EditField(controller: nameCtrl, hint: "Patient name"),
              const SizedBox(height: 10),
              _EditField(controller: titleCtrl, hint: "Plan title"),
              const SizedBox(height: 10),
              _EditField(
                controller: detailsCtrl,
                hint: "Plan details",
                maxLines: 5,
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final title = titleCtrl.text.trim();
                    final details = detailsCtrl.text.trim();

                    if (name.isEmpty || title.isEmpty || details.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    setState(() {
                      _plans.insert(
                        0,
                        _PlanModel(
                          patientName: name,
                          patientImage: "assets/images/patient_avatar.jpeg",
                          specialty: "General",
                          title: title,
                          details: details,
                          status: "Pending",
                          nextAction: "Pending approval",
                          lastUpdated: "Just now",
                          source: "Doctor Plan",
                          hasSkinImage: false,
                          diagnosis: null,
                        ),
                      );
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Plan added successfully")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Save Plan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openPlanSheet(_PlanModel plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.66,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(plan.patientImage),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.patientName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              plan.specialty,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _StatusBadge(status: plan.status),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _SourceChip(text: plan.source),
                      const SizedBox(width: 10),
                      if (plan.diagnosis != null)
                        Expanded(
                          child: Text(
                            plan.diagnosis!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    plan.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded,
                          size: 18, color: AppColors.textLight),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          plan.nextAction,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (plan.hasSkinImage) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.image_outlined,
                              color: AppColors.primary, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Skin image attached from robot camera",
                              style: TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      plan.details,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Last updated: ${plan.lastUpdated}",
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textLight.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _SheetActionButton(
                          icon: Icons.picture_as_pdf_outlined,
                          label: "Export PDF",
                          onTap: () => _exportPdf(plan),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SheetActionButton(
                          icon: Icons.share_outlined,
                          label: "Share",
                          onTap: () => _sharePlan(plan),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _SheetActionButton(
                          icon: Icons.edit_outlined,
                          label: "Edit Plan",
                          onTap: () => _editPlan(plan),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SheetActionButton(
                          icon: Icons.message_outlined,
                          label: "Message",
                          onTap: () => _messagePatient(plan),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (plan.status == "Pending") ...[
                    const Text(
                      "Doctor Review",
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _approvePlan(plan),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.check_rounded,
                                color: Colors.white, size: 18),
                            label: const Text(
                              "Approve",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _editPlan(plan),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.edit_outlined,
                                size: 18, color: AppColors.primary),
                            label: const Text(
                              "Modify",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _declinePlan(plan),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFE53935)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.close_rounded,
                            size: 18, color: Color(0xFFE53935)),
                        label: const Text(
                          "Decline",
                          style: TextStyle(
                            color: Color(0xFFE53935),
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final plans = _filteredPlans;

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
          "Treatment Plans",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          if (_drawerOpen)
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Center(
                child: Icon(Icons.inventory_2_outlined, color: Colors.green),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _addPlanSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: "All",
                    isActive: _filter == "All",
                    onTap: () => setState(() => _filter = "All"),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: "Active",
                    isActive: _filter == "Active",
                    onTap: () => setState(() => _filter = "Active"),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: "Pending",
                    isActive: _filter == "Pending",
                    onTap: () => setState(() => _filter = "Pending"),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: "Completed",
                    isActive: _filter == "Completed",
                    onTap: () => setState(() => _filter = "Completed"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return _PlanCard(
                  plan: plan,
                  onTap: () => _openPlanSheet(plan),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _EditField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.inputBackground,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: isActive ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final _PlanModel plan;
  final VoidCallback onTap;

  const _PlanCard({required this.plan, required this.onTap});

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
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(plan.patientImage),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.patientName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    plan.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    plan.nextAction,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _SourceChip(text: plan.source),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusBadge(status: plan.status),
                const SizedBox(height: 8),
                const Icon(Icons.chevron_right_rounded,
                    size: 26, color: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color c = status == "Active"
        ? Colors.green
        : status == "Pending"
        ? Colors.orange
        : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: c,
        ),
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  final String text;
  const _SourceChip({required this.text});

  @override
  Widget build(BuildContext context) {
    final isAI = text.toLowerCase().contains("ai");
    final c = isAI ? Colors.deepPurple : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: c,
        ),
      ),
    );
  }
}

class _SheetActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanModel {
  final String patientName;
  final String patientImage;
  final String specialty;

  String title;
  String details;
  String status;
  String nextAction;
  String lastUpdated;

  final String source;
  final bool hasSkinImage;
  final String? diagnosis;

  _PlanModel({
    required this.patientName,
    required this.patientImage,
    required this.specialty,
    required this.title,
    required this.details,
    required this.status,
    required this.nextAction,
    required this.lastUpdated,
    required this.source,
    required this.hasSkinImage,
    required this.diagnosis,
  });
}