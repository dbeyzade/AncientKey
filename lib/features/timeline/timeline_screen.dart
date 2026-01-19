import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../core/services/timeline_service.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  final String mapId;
  final String? mapName;

  const TimelineScreen({super.key, required this.mapId, this.mapName});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  String _filterType = 'all'; // all, civilization, era
  String? _selectedFilter;
  List<String> _availableFilters = [];

  @override
  Widget build(BuildContext context) {
    final timelineService = ref.watch(timelineServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tarihi Zaman Çizelgesi'),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (value) async {
              if (value == 'civilization' || value == 'era') {
                setState(() => _filterType = value);
                if (value == 'civilization') {
                  _availableFilters = await timelineService
                      .getAllCivilizations();
                } else {
                  _availableFilters = await timelineService.getAllEras();
                }
                if (_availableFilters.isNotEmpty) {
                  _showFilterDialog();
                }
              } else {
                setState(() {
                  _filterType = 'all';
                  _selectedFilter = null;
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text('Tümü')),
              PopupMenuItem(
                value: 'civilization',
                child: Text('Medeniyete Göre'),
              ),
              PopupMenuItem(value: 'era', child: Text('Döneme Göre')),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<TimelineEvent>>(
        future: _getFilteredEvents(timelineService),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timeline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Henüz tarih çizelgesi eklenmemiş',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final isFirst = index == 0;
              final isLast = index == events.length - 1;

              return TimelineTile(
                isFirst: isFirst,
                isLast: isLast,
                alignment: TimelineAlign.manual,
                lineXY: 0.3,
                indicatorStyle: IndicatorStyle(
                  width: 40,
                  height: 40,
                  indicator: Container(
                    decoration: BoxDecoration(
                      color: _getColorForEra(event.era),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Center(
                      child: Icon(
                        _getIconForCategory(event.category),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                beforeLineStyle: LineStyle(
                  color: _getColorForEra(event.era).withOpacity(0.5),
                  thickness: 3,
                ),
                endChild: _buildEventCard(event),
                startChild: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        event.yearStart.abs().toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        event.yearStart < 0 ? 'MÖ' : 'MS',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      if (event.yearEnd != null) ...[
                        SizedBox(height: 4),
                        Text(
                          '${event.yearEnd!.abs()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          event.yearEnd! < 0 ? 'MÖ' : 'MS',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<TimelineEvent>> _getFilteredEvents(
    TimelineService service,
  ) async {
    if (_filterType == 'civilization' && _selectedFilter != null) {
      return await service.getEventsByCivilization(_selectedFilter!);
    } else if (_filterType == 'era' && _selectedFilter != null) {
      return await service.getEventsByEra(_selectedFilter!);
    } else if (_filterType == 'all') {
      return await service.getAllEvents();
    } else {
      return await service.getEventsForMap(widget.mapId);
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _filterType == 'civilization' ? 'Medeniyet Seç' : 'Dönem Seç',
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _availableFilters.length,
            itemBuilder: (context, index) {
              final filter = _availableFilters[index];
              return ListTile(
                title: Text(filter),
                selected: _selectedFilter == filter,
                onTap: () {
                  setState(() => _selectedFilter = filter);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(TimelineEvent event) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (event.civilization != null) ...[
              SizedBox(height: 4),
              Chip(
                label: Text(
                  event.civilization!,
                  style: TextStyle(fontSize: 11),
                ),
                backgroundColor: _getColorForEra(event.era).withOpacity(0.2),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
            if (event.description != null) ...[
              SizedBox(height: 8),
              Text(
                event.description!,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
            if (event.category != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    _getIconForCategory(event.category),
                    size: 16,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text(
                    event.category!,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getColorForEra(String? era) {
    if (era == null) return Colors.blue;
    switch (era.toLowerCase()) {
      case 'antik':
      case 'ancient':
        return Colors.amber[800]!;
      case 'klasik':
      case 'classical':
        return Colors.purple;
      case 'orta çağ':
      case 'medieval':
        return Colors.brown;
      case 'rönesans':
      case 'renaissance':
        return Colors.teal;
      case 'modern':
        return Colors.indigo;
      default:
        return Colors.blue;
    }
  }

  IconData _getIconForCategory(String? category) {
    if (category == null) return Icons.event;
    switch (category.toLowerCase()) {
      case 'savaş':
      case 'battle':
      case 'war':
        return Icons.military_tech;
      case 'kuruluş':
      case 'foundation':
        return Icons.location_city;
      case 'keşif':
      case 'discovery':
        return Icons.explore;
      case 'buluş':
      case 'invention':
        return Icons.lightbulb;
      case 'sanat':
      case 'art':
        return Icons.palette;
      case 'din':
      case 'religion':
        return Icons.temple_hindu;
      case 'bilim':
      case 'science':
        return Icons.science;
      case 'ticaret':
      case 'trade':
        return Icons.store;
      default:
        return Icons.event;
    }
  }
}
