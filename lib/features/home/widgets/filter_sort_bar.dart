import 'package:flutter/material.dart';

class FilterSortBar extends StatelessWidget {
  final double selectedMagnitude;
  final bool sortByMagnitude;
  final ValueChanged<double> onMagnitudeSelected;
  final VoidCallback onToggleSort;

  const FilterSortBar({
    super.key,
    required this.selectedMagnitude,
    required this.sortByMagnitude,
    required this.onMagnitudeSelected,
    required this.onToggleSort,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip(context, label: 'All', value: 0.0),
          const SizedBox(width: 8),
          _buildFilterChip(context, label: 'M 2.5+', value: 2.5),
          const SizedBox(width: 8),
          _buildFilterChip(context, label: 'M 4.5+', value: 4.5),
          const SizedBox(width: 8),
          _buildFilterChip(context, label: 'M 6.0+ Major', value: 6.0),
          const SizedBox(width: 12),
          Container(
            height: 24,
            width: 1,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),
          const SizedBox(width: 12),
          ActionChip(
            avatar: Icon(
              sortByMagnitude
                  ? Icons.trending_up_rounded
                  : Icons.access_time_filled_rounded,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            label: Text(
              sortByMagnitude ? 'Sorted by Mag' : 'Sorted by Time',
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: theme.colorScheme.primary.withAlpha(20),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: onToggleSort,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, {required String label, required double value}) {
    final isSelected = selectedMagnitude == value;
    final theme = Theme.of(context);

    return FilterChip(
      selected: isSelected,
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        color: isSelected ? Colors.white : null,
      ),
      selectedColor: theme.colorScheme.primary,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onSelected: (_) => onMagnitudeSelected(value),
    );
  }
}
