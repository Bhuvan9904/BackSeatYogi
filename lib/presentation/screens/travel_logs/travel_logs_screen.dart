import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../widgets/common/custom_card.dart';

import '../../widgets/common/main_layout.dart';
import '../../../core/services/hive_storage_service.dart';
import '../../../data/models/travel_log.dart';
import '../../widgets/common/main_layout.dart' show ResponsiveAppBar;

class TravelLogsScreen extends StatefulWidget {
  const TravelLogsScreen({super.key});

  @override
  State<TravelLogsScreen> createState() => _TravelLogsScreenState();
}

class _TravelLogsScreenState extends State<TravelLogsScreen> {
  String? selectedFilter;
  String? selectedFilterCategory;
  
  // Filter categories and options
  final Map<String, List<String>> filterCategories = {
    'Mood': ['All', ...AppConstants.moodTags],
  };

  List<TravelLog> travelLogs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTravelLogs();
  }

  Future<void> _loadTravelLogs() async {
    try {
      print('Loading travel logs...');
      final logs = await HiveStorageService.getTravelLogs();
      print('Loaded ${logs.length} travel logs');
      setState(() {
        travelLogs = logs;
        isLoading = false;
      });
      print('Travel logs state updated. Count: ${travelLogs.length}');
    } catch (e) {
      print('Error loading travel logs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 3, // Logs is index 3
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ResponsiveAppBar(
          title: 'Travel Logs',
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh,
                size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
              ),
              onPressed: _loadTravelLogs,
            ),
            IconButton(
              icon: Icon(
                Icons.filter_list,
                size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
              ),
              onPressed: _showFilterDialog,
            ),
          ],
        ),
        body: Padding(
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSimpleHeader(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
              _buildFilterChip(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
              Expanded(
                child: _buildTravelLogsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleHeader() {
    return CustomCard(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryCTA.withValues(alpha: 0.08),
              AppColors.secondaryCTA.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryCTA.withValues(alpha: 0.15),
                          AppColors.primaryCTA.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryCTA.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.history,
                      color: AppColors.primaryCTA,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 28.0),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Travel Journey',
                          style: AppTypography.headlineSmall(context).copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                        Text(
                          'Track your mindful moments and reflections',
                          style: AppTypography.bodyMedium(context).copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              
              // Stats Row - Responsive Layout
              ResponsiveUtils.getScreenSize(context) == ScreenSize.mobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickStat(
                                'Total',
                                '${travelLogs.length}',
                                Icons.article,
                                AppColors.primaryCTA,
                              ),
                            ),
                            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                            Expanded(
                              child: _buildQuickStat(
                                'This Month',
                                '${travelLogs.where((log) => log.date.month == DateTime.now().month).length}',
                                Icons.calendar_today,
                                AppColors.secondaryCTA,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                              vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.25,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryCTA.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context) * 0.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  color: AppColors.primaryCTA.withValues(alpha: 0.7),
                                  size: ResponsiveUtils.getResponsiveIconSize(context, 14.0),
                                ),
                                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                                Text(
                                  'Active',
                                  style: AppTypography.labelSmall(context).copyWith(
                                    color: AppColors.primaryCTA.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        _buildQuickStat(
                          'Total',
                          '${travelLogs.length}',
                          Icons.article,
                          AppColors.primaryCTA,
                        ),
                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                        _buildQuickStat(
                          'This Month',
                          '${travelLogs.where((log) => log.date.month == DateTime.now().month).length}',
                          Icons.calendar_today,
                          AppColors.secondaryCTA,
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                            vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.25,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryCTA.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context) * 0.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: AppColors.primaryCTA.withValues(alpha: 0.7),
                                size: ResponsiveUtils.getResponsiveIconSize(context, 14.0),
                              ),
                              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                              Text(
                                'Active',
                                style: AppTypography.labelSmall(context).copyWith(
                                  color: AppColors.primaryCTA.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return CustomCard(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCTA.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  ),
                  child: Icon(
                    Icons.history,
                    color: AppColors.primaryCTA,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 32.0),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Travel Journey',
                        style: AppTypography.headlineMedium(context).copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                      Text(
                        'Track your mindful moments and reflections',
                        style: AppTypography.bodyLarge(context).copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 2),
              
              // Stats Section
              Text(
                'Quick Overview',
                style: AppTypography.titleMedium(context).copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              ResponsiveUtils.getScreenSize(context) == ScreenSize.mobile
                  ? Column(
                      children: [
                        _buildEnhancedStatCard(
                          'Total Logs',
                          '${travelLogs.length}',
                          Icons.article,
                          AppColors.primaryCTA,
                          'All time entries',
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
                        _buildEnhancedStatCard(
                          'This Month',
                          '${travelLogs.where((log) => log.date.month == DateTime.now().month).length}',
                          Icons.calendar_today,
                          AppColors.secondaryCTA,
                          'Current month',
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        _buildEnhancedStatCard(
                          'Total Logs',
                          '${travelLogs.length}',
                          Icons.article,
                          AppColors.primaryCTA,
                          'All time entries',
                        ),
                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
                        _buildEnhancedStatCard(
                          'This Month',
                          '${travelLogs.where((log) => log.date.month == DateTime.now().month).length}',
                          Icons.calendar_today,
                          AppColors.secondaryCTA,
                          'Current month',
                        ),
                      ],
                    ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
            
            // Stats Section
            Text(
              'Quick Overview',
              style: AppTypography.titleMedium(context).copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            ResponsiveUtils.getScreenSize(context) == ScreenSize.mobile
                ? Column(
                    children: [
                      _buildStatCard(
                        'Total Logs',
                        '${travelLogs.length}',
                        Icons.article,
                        AppColors.primaryCTA,
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
                      _buildStatCard(
                        'This Month',
                        '${travelLogs.where((log) => log.date.month == DateTime.now().month).length}',
                        Icons.calendar_today,
                        AppColors.secondaryCTA,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _buildStatCard(
                        'Total Logs',
                        '${travelLogs.length}',
                        Icons.article,
                        AppColors.primaryCTA,
                      ),
                      SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
                      _buildStatCard(
                        'This Month',
                        '${travelLogs.where((log) => log.date.month == DateTime.now().month).length}',
                        Icons.calendar_today,
                        AppColors.secondaryCTA,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
        vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.25,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context) * 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color.withValues(alpha: 0.7),
            size: ResponsiveUtils.getResponsiveIconSize(context, 14.0),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTypography.titleSmall(context).copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: AppTypography.labelSmall(context).copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.75),
            Text(
              value,
              style: AppTypography.headlineSmall(context).copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
            Text(
              title,
              style: AppTypography.labelSmall(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.08),
              color.withValues(alpha: 0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                    vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.25,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  ),
                  child: Text(
                    subtitle,
                    style: AppTypography.labelSmall(context).copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1),
            Text(
              value,
              style: AppTypography.headlineMedium(context).copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
            Text(
              title,
              style: AppTypography.titleSmall(context).copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip() {
    if (selectedFilter == null || selectedFilterCategory == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveSpacing(context),
        vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 1.25,
              vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryCTA,
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryCTA.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_list,
                  color: AppColors.textLight,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 18.0),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.75),
                Text(
                  '$selectedFilterCategory: $selectedFilter',
                  style: AppTypography.labelMedium(context).copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.75),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = null;
                      selectedFilterCategory = null;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                    decoration: BoxDecoration(
                      color: AppColors.textLight.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.textLight,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelLogsList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryCTA),
      );
    }

    if (travelLogs.isEmpty) {
      return _buildEmptyState();
    }

    // Apply filter if selected
    List<TravelLog> filteredLogs = travelLogs;
    if (selectedFilter != null && selectedFilter != 'All') {
      filteredLogs = travelLogs.where((log) {
        if (selectedFilterCategory == 'Mood') {
          return log.mood?.toLowerCase() == selectedFilter!.toLowerCase();
        }
        return false;
      }).toList();
    }

    // Show empty state for filtered results
    if (selectedFilter != null && selectedFilter != 'All' && filteredLogs.isEmpty) {
      return _buildEmptyFilteredState();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Show filter results count
          if (selectedFilter != null && selectedFilter != 'All') ...[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsiveSpacing(context),
                vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.textSecondary,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 18.0),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.75),
                  Text(
                    'Showing ${filteredLogs.length} of ${travelLogs.length} logs',
                    style: AppTypography.bodySmall(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1),
          ],
          // Log cards
          ...filteredLogs.map((log) => _buildLogCard(log)).toList(),
        ],
      ),
    );
  }

  Widget _buildLogCard(TravelLog log) {
    return CustomCard(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
      onTap: () => _showLogDetails(log),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCTA.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  ),
                  child: Icon(
                    _getTravelIcon(log.travelType),
                    color: AppColors.primaryCTA,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.destination,
                        style: AppTypography.titleMedium(context).copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppColors.textSecondary,
                            size: ResponsiveUtils.getResponsiveIconSize(context, 16.0),
                          ),
                          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                          Expanded(
                            child: Text(
                              '${log.formattedDate} • ${log.formattedTime}',
                              style: AppTypography.bodySmall(context).copyWith(
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (log.mood != null)
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
                        vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                      ),
                      decoration: BoxDecoration(
                        color: _getMoodColor(log.mood!),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                        boxShadow: [
                          BoxShadow(
                            color: _getMoodColor(log.mood!).withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getMoodEmoji(log.mood!),
                            style: const TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                          Flexible(
                            child: Text(
                              log.mood![0].toUpperCase() + log.mood!.substring(1),
                              style: AppTypography.labelSmall(context).copyWith(
                                color: AppColors.textLight,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            if (log.practiceName != null) ...[
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                decoration: BoxDecoration(
                  color: AppColors.secondaryCTA.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  border: Border.all(
                    color: AppColors.secondaryCTA.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.self_improvement,
                      color: AppColors.secondaryCTA,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 18.0),
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.75),
                    Expanded(
                      child: Text(
                        '${log.practiceName}${log.practiceDuration != null ? ' • ${log.practiceDuration} min' : ''}',
                        style: AppTypography.bodySmall(context).copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Compact icon container
              Container(
                width: ResponsiveUtils.getResponsiveIconSize(context, 70.0),
                height: ResponsiveUtils.getResponsiveIconSize(context, 70.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.textSecondary.withValues(alpha: 0.15),
                      AppColors.textSecondary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  border: Border.all(
                    color: AppColors.textSecondary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.history,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 40.0),
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              
              // Compact title
              Text(
                'No Travel Logs Yet',
                style: AppTypography.titleLarge(context).copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
              
              // Compact description
              Text(
                'Your mindful journeys will appear here once you start logging.',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFilteredState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Compact icon container
              Container(
                width: ResponsiveUtils.getResponsiveIconSize(context, 70.0),
                height: ResponsiveUtils.getResponsiveIconSize(context, 70.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.secondaryCTA.withValues(alpha: 0.15),
                      AppColors.secondaryCTA.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  border: Border.all(
                    color: AppColors.secondaryCTA.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.filter_list_off,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 40.0),
                    color: AppColors.secondaryCTA.withValues(alpha: 0.8),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              
              // Compact title
              Text(
                'No Logs Found',
                style: AppTypography.titleLarge(context).copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
              
              // Compact description
              Text(
                'No logs match: $selectedFilterCategory - $selectedFilter',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              
              // Compact clear filter button
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsiveSpacing(context),
                  vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryCTA.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  border: Border.all(
                    color: AppColors.secondaryCTA.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = null;
                      selectedFilterCategory = null;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.clear_all,
                        color: AppColors.secondaryCTA,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 18.0),
                      ),
                      SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                      Text(
                        'Clear Filter',
                        style: AppTypography.labelMedium(context).copyWith(
                          color: AppColors.secondaryCTA,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    // Store current filter state for dialog
    String? tempFilterCategory = selectedFilterCategory;
    String? tempFilter = selectedFilter;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Filter Logs',
            style: AppTypography.titleLarge(context).copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category selection
                Text(
                  'Filter by Category',
                  style: AppTypography.titleSmall(context).copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                Wrap(
                  spacing: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                  children: filterCategories.keys.map((category) {
                    final isSelected = tempFilterCategory == category;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          tempFilterCategory = isSelected ? null : category;
                          tempFilter = null;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getResponsiveSpacing(context),
                          vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryCTA : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryCTA : AppColors.surfaceVariant,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          category,
                          style: AppTypography.labelMedium(context).copyWith(
                            color: isSelected ? AppColors.textLight : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
                
                // Filter options for selected category
                if (tempFilterCategory != null) ...[
                  Text(
                    'Select $tempFilterCategory',
                    style: AppTypography.titleSmall(context).copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                  ...filterCategories[tempFilterCategory]!.map<Widget>((filter) {
                    final isSelected = tempFilter == filter;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        _getFilterIcon(filter),
                        color: isSelected ? AppColors.primaryCTA : AppColors.textSecondary,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                      ),
                      title: Text(
                        filter,
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.textLight,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: Radio<String>(
                        value: filter,
                        groupValue: tempFilter,
                        onChanged: (value) {
                          setDialogState(() {
                            tempFilter = value;
                          });
                        },
                        activeColor: AppColors.primaryCTA,
                      ),
                    );
                  }).toList(),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedFilter = null;
                  selectedFilterCategory = null;
                });
                Navigator.pop(context);
              },
              child: Text(
                'Clear All',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.primaryCTA,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedFilterCategory = tempFilterCategory;
                  selectedFilter = tempFilter;
                });
                Navigator.pop(context);
              },
              child: Text(
                'Apply',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.primaryCTA,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogDetails(TravelLog log) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getTravelIcon(log.travelType),
                  color: AppColors.primaryCTA,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 32.0),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.destination,
                        style: AppTypography.headlineSmall(context).copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${log.formattedDate} • ${log.formattedTime}',
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
            _buildDetailRow('Travel Type', log.travelType),
            if (log.practiceName != null)
              _buildDetailRow('Practice', log.practiceName!),
            if (log.practiceDuration != null)
              _buildDetailRow('Duration', '${log.practiceDuration} min'),
            if (log.mood != null) _buildDetailRow('Mood', log.mood![0].toUpperCase() + log.mood!.substring(1)),
            if (log.reflection != null) ...[
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              Text(
                'Reflection:',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
              Text(
                log.reflection!,
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ],
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCTA,
                  foregroundColor: AppColors.textLight,
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTravelIcon(String travelType) {
    switch (travelType.toLowerCase()) {
      case 'car':
        return Icons.directions_car;
      case 'train':
        return Icons.train;
      case 'flight':
        return Icons.flight;
      default:
        return Icons.directions_car;
    }
  }

  String _getMoodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'calm':
        return '😌';
      case 'focused':
        return '🎯';
      case 'grateful':
        return '🙏';
      case 'anxious':
        return '😰';
      case 'distracted':
        return '🤔';
      case 'tired':
        return '😴';
      default:
        return '😊';
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'calm':
        return Colors.blue;
      case 'focused':
        return Colors.green;
      case 'grateful':
        return Colors.orange;
      case 'anxious':
        return Colors.red;
      case 'distracted':
        return Colors.grey;
      case 'tired':
        return Colors.purple;
      default:
        return AppColors.primaryCTA;
    }
  }

  IconData _getFilterIcon(String filter) {
    switch (filter.toLowerCase()) {
      case 'all':
        return Icons.list;
      case 'calm':
        return Icons.self_improvement;
      case 'focused':
        return Icons.center_focus_strong;
      case 'grateful':
        return Icons.favorite;
      case 'anxious':
        return Icons.psychology;
      case 'distracted':
        return Icons.visibility_off;
      case 'tired':
        return Icons.bedtime;
      default:
        return Icons.filter_list;
    }
  }
}
