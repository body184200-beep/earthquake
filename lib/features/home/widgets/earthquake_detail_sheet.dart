import 'package:earthquake/core/theme/app_colors.dart';
import 'package:earthquake/features/data/models/earth_quake_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EarthquakeDetailSheet extends StatelessWidget {
  final EarthquakeModel earthquake;

  const EarthquakeDetailSheet({
    super.key,
    required this.earthquake,
  });

  static void show(BuildContext context, EarthquakeModel earthquake) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EarthquakeDetailSheet(earthquake: earthquake),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final magColor = AppColors.getMagnitudeColor(earthquake.magnitude);
    final magProgress = (earthquake.magnitude / 10.0).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 4.5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            // Magnitude Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    magColor.withAlpha(45),
                    magColor.withAlpha(15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: magColor.withAlpha(80),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: magColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: magColor.withAlpha(80),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          earthquake.magnitude.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${earthquake.severityLabel} Earthquake',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: magColor,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              earthquake.formattedDate,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.grey[300] : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Richter Meter Progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RICHTER SCALE: ${earthquake.magnitude.toStringAsFixed(1)} / 10.0',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      Text(
                        earthquake.severityLabel.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: magColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: magProgress,
                      minHeight: 8,
                      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(magColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Location & Epicenter Details
            const Text(
              'Epicenter Details',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    icon: Icons.place_rounded,
                    label: 'Location',
                    value: earthquake.place,
                  ),
                  if (earthquake.latitude != null && earthquake.longitude != null) ...[
                    const Divider(height: 18),
                    _buildDetailRow(
                      context,
                      icon: Icons.explore_rounded,
                      label: 'Coordinates',
                      value: earthquake.coordinatesDisplay,
                    ),
                  ],
                  if (earthquake.depth != null) ...[
                    const Divider(height: 18),
                    _buildDetailRow(
                      context,
                      icon: Icons.layers_rounded,
                      label: 'Hypocenter Depth',
                      value: '${earthquake.depth!.toStringAsFixed(1)} km',
                    ),
                    const Divider(height: 18),
                    _buildDetailRow(
                      context,
                      icon: Icons.nature_rounded,
                      label: 'Focus Category',
                      value: earthquake.depthCategory,
                    ),
                  ],
                  if (earthquake.tsunami) ...[
                    const Divider(height: 18),
                    _buildDetailRow(
                      context,
                      icon: Icons.waves_rounded,
                      label: 'Tsunami Hazard',
                      value: 'Warning Issued',
                      valueColor: Colors.blue,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Safety Reminder
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withAlpha(80)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.shield_rounded,
                    color: Colors.amber,
                    size: 26,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preparedness Advice',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: Colors.amber,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Drop, Cover, and Hold On! Stay away from glass and heavy fixtures during tremors.',
                          style: TextStyle(fontSize: 12, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Actions (Copy / Share)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text('Copy Details'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      final summary = 'Earthquake M${earthquake.magnitude.toStringAsFixed(1)} '
                          '- ${earthquake.place} at ${earthquake.formattedDate}. '
                          'Coordinates: ${earthquake.coordinatesDisplay}, Depth: ${earthquake.depth?.toStringAsFixed(1)} km.';
                      Clipboard.setData(ClipboardData(text: summary));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Earthquake summary copied to clipboard!'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
