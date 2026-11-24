import 'package:earthquake/features/home/controllers/earthquake_provider.dart';
import 'package:earthquake/features/home/widgets/earthquake_card.dart';
import 'package:earthquake/features/home/widgets/earthquake_detail_sheet.dart';
import 'package:earthquake/features/home/widgets/earthquake_state_views.dart';
import 'package:earthquake/features/home/widgets/filter_sort_bar.dart';
import 'package:earthquake/features/home/widgets/peak_activity_card.dart';
import 'package:earthquake/features/home/widgets/stats_overview_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EarthquakeProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filtered = provider.filteredEarthquakes;
    final peakQuake = provider.peakEarthquake;
    final showPeakCard = peakQuake != null && !provider.hasActiveFilters;

    return Scaffold(
      appBar: _buildAppBar(context, provider, theme, isDark),
      body: provider.isLoading
          ? const EarthquakeLoadingView()
          : provider.errorMessage != null
              ? EarthquakeErrorView(
                  errorMessage: provider.errorMessage,
                  onRetry: provider.fetchEarthquakes,
                )
              : RefreshIndicator(
                  onRefresh: provider.fetchEarthquakes,
                  child: CustomScrollView(
                    slivers: [
                      // Overview Statistics with Feed Timeframe Selector
                      SliverToBoxAdapter(
                        child: StatsOverviewBar(
                          totalCount: provider.totalCount,
                          peakMagnitude: provider.peakMagnitude,
                          significantCount: provider.significantCount,
                          feedPeriod: provider.feedPeriod,
                          onPeriodChanged: provider.setFeedPeriod,
                        ),
                      ),

                      // Peak Activity Hero Banner
                      if (showPeakCard)
                        SliverToBoxAdapter(
                          child: PeakActivityCard(
                            earthquake: peakQuake,
                            onTap: () => EarthquakeDetailSheet.show(context, peakQuake),
                          ),
                        ),

                      // Filter chips and Sort toggle
                      SliverToBoxAdapter(
                        child: FilterSortBar(
                          selectedMagnitude: provider.minMagnitude,
                          sortByMagnitude: provider.sortByMagnitude,
                          onMagnitudeSelected: provider.setMinMagnitude,
                          onToggleSort: provider.toggleSortOrder,
                        ),
                      ),

                      // Event Counter and Reset Filters
                      SliverToBoxAdapter(
                        child: _buildCountBar(context, provider, isDark, filtered.length),
                      ),

                      // Earthquake List or Empty State
                      if (filtered.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: EarthquakeEmptyView(
                            onResetFilters: provider.resetFilters,
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final quake = filtered[index];
                                return EarthquakeCard(
                                  earthquake: quake,
                                  onTap: () => EarthquakeDetailSheet.show(context, quake),
                                );
                              },
                              childCount: filtered.length,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    EarthquakeProvider provider,
    ThemeData theme,
    bool isDark,
  ) {
    return AppBar(
      titleSpacing: 16,
      title: provider.isSearchOpen
          ? TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search city, state, or region...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 15,
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16),
              onChanged: provider.setSearchQuery,
            )
          : Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.waves_rounded,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Earthquake Tracker',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Live Seismic Activity Monitor',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
      actions: [
        IconButton(
          tooltip: provider.isSearchOpen ? 'Close search' : 'Search',
          icon: Icon(provider.isSearchOpen ? Icons.close_rounded : Icons.search_rounded),
          onPressed: provider.toggleSearchOpen,
        ),
        IconButton(
          tooltip: 'Refresh data',
          icon: const Icon(Icons.refresh_rounded),
          onPressed: provider.fetchEarthquakes,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildCountBar(
    BuildContext context,
    EarthquakeProvider provider,
    bool isDark,
    int count,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $count seismic events',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          if (provider.hasActiveFilters)
            GestureDetector(
              onTap: provider.resetFilters,
              child: Text(
                'Reset Filters',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
