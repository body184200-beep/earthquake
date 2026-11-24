import 'package:earthquake/core/services/earthquake_api_service.dart';
import 'package:earthquake/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StatsOverviewBar extends StatelessWidget {
  final int totalCount;
  final double peakMagnitude;
  final int significantCount;
  final EarthquakeFeedPeriod feedPeriod;
  final ValueChanged<EarthquakeFeedPeriod> onPeriodChanged;

  const StatsOverviewBar({
    super.key,
    required this.totalCount,
    required this.peakMagnitude,
    required this.significantCount,
    required this.feedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          // Period Selector Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACTIVITY OVERVIEW',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              PopupMenuButton<EarthquakeFeedPeriod>(
                initialValue: feedPeriod,
                tooltip: 'Select Timeframe',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onSelected: onPeriodChanged,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 13,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        feedPeriod.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context) {
                  return EarthquakeFeedPeriod.values.map((period) {
                    return PopupMenuItem(
                      value: period,
                      child: Text(
                        period.label,
                        style: TextStyle(
                          fontWeight: period == feedPeriod ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Stat Cards Row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  isDark: isDark,
                  title: 'Recorded',
                  value: '$totalCount',
                  icon: Icons.public_rounded,
                  color: const Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatItem(
                  isDark: isDark,
                  title: 'Peak Mag',
                  value: peakMagnitude.toStringAsFixed(1),
                  icon: Icons.bolt_rounded,
                  color: AppColors.getMagnitudeColor(peakMagnitude),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatItem(
                  isDark: isDark,
                  title: 'Mag 4.5+',
                  value: '$significantCount',
                  icon: Icons.warning_amber_rounded,
                  color: const Color(0xFFF97316),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required bool isDark,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 15 : 4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
