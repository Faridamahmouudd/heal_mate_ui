import 'package:flutter/material.dart';
import '../constants/colors.dart';

class MonitoringDashboardScreen extends StatelessWidget {
  const MonitoringDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // mock values
    const tempValue = 38.2; // TODO: from robot
    final isFever = tempValue >= 38.0;

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
          "Monitoring",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: ListView(
          children: [
            _TemperatureCard(
              value: "${tempValue.toStringAsFixed(1)} °C",
              status: isFever ? "Fever" : "Normal",
              statusColor: isFever ? Colors.redAccent : Colors.green,
            ),
            const SizedBox(height: 12),
            const _TempHistoryCard(),
            const SizedBox(height: 14),
            const _AlertSummaryTempOnly(),
          ],
        ),
      ),
    );
  }
}

class _TemperatureCard extends StatelessWidget {
  final String value;
  final String status;
  final Color statusColor;

  const _TemperatureCard({
    required this.value,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.thermostat_rounded,
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Temperature",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: statusColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TempHistoryCard extends StatelessWidget {
  const _TempHistoryCard();

  @override
  Widget build(BuildContext context) {
    // mock history
    const history = [
      {"time": "09:10", "temp": "37.6 °C"},
      {"time": "10:05", "temp": "38.0 °C"},
      {"time": "10:40", "temp": "38.2 °C"},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Readings",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          for (final item in history) ...[
            Row(
              children: [
                Container(
                  width: 58,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      item["time"]!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item["temp"]!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _AlertSummaryTempOnly extends StatelessWidget {
  const _AlertSummaryTempOnly();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        "AI Summary (Temperature Only):\n\n"
            "• Monitoring is focused on body temperature.\n"
            "• If temperature ≥ 38.0°C, it will be flagged as Fever.\n"
            "• No other vitals are tracked in this version.",
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textDark,
          height: 1.4,
        ),
      ),
    );
  }
}
