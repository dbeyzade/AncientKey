import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/maps/domain/ancient_map.dart';

class RouteNavigationScreen extends ConsumerStatefulWidget {
  final AncientMap destination;

  const RouteNavigationScreen({
    super.key,
    required this.destination,
  });

  @override
  ConsumerState<RouteNavigationScreen> createState() =>
      _RouteNavigationScreenState();
}

class _RouteNavigationScreenState extends ConsumerState<RouteNavigationScreen> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  bool _isLoading = true;
  List<LatLng> _routePoints = [];
  double? _distanceInMeters;
  String? _estimatedTime;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      _calculateRoute();
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Konum alınamadı: $e');
    }
  }

  void _calculateRoute() {
    if (_currentPosition == null) return;

    final start = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    final end = widget.destination.center;

    // Simple straight line route (in production, use a routing API)
    _routePoints = [start, end];

    // Calculate distance
    const distance = Distance();
    _distanceInMeters = distance.as(LengthUnit.Meter, start, end);

    // Estimate time (assuming 60 km/h average speed)
    final hours = (_distanceInMeters! / 1000) / 60;
    final minutes = (hours * 60).round();
    _estimatedTime = minutes < 60
        ? '$minutes dakika'
        : '${(minutes / 60).toStringAsFixed(1)} saat';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigasyon - ${widget.destination.name}'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.navigation),
            onPressed: _openInMaps,
            tooltip: 'Haritalarda Aç',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildRouteInfo(),
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentPosition != null
                          ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                          : widget.destination.center,
                      initialZoom: 10,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.ancientkey',
                      ),
                      if (_routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _routePoints,
                              color: Colors.blue,
                              strokeWidth: 4,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          if (_currentPosition != null)
                            Marker(
                              point: LatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              ),
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.blue,
                                size: 40,
                              ),
                            ),
                          Marker(
                            point: widget.destination.center,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildActionButtons(),
              ],
            ),
    );
  }

  Widget _buildRouteInfo() {
    if (_distanceInMeters == null || _estimatedTime == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.deepPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            icon: Icons.straighten,
            label: 'Mesafe',
            value: _distanceInMeters! < 1000
                ? '${_distanceInMeters!.toStringAsFixed(0)} m'
                : '${(_distanceInMeters! / 1000).toStringAsFixed(1)} km',
          ),
          _buildInfoItem(
            icon: Icons.access_time,
            label: 'Tahmini Süre',
            value: _estimatedTime!,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _startNavigation,
              icon: const Icon(Icons.navigation),
              label: const Text('Navigasyonu Başlat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _openInMaps,
              icon: const Icon(Icons.map),
              label: const Text('Haritalarda Aç'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startNavigation() {
    // Start tracking user's location
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
        _calculateRoute();
      });

      // Check if reached destination
      const distance = Distance();
      final meters = distance.as(
        LengthUnit.Meter,
        LatLng(position.latitude, position.longitude),
        widget.destination.center,
      );

      if (meters < 100) {
        _showArrivalDialog();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigasyon başlatıldı'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _openInMaps() async {
    final lat = widget.destination.center.latitude;
    final lng = widget.destination.center.longitude;
    
    // Try Apple Maps first on iOS, then Google Maps
    final appleMapsUrl = Uri.parse('http://maps.apple.com/?daddr=$lat,$lng');
    final googleMapsUrl = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');

    try {
      if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl);
      } else if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        _showError('Harita uygulaması bulunamadı');
      }
    } catch (e) {
      _showError('Harita açılamadı: $e');
    }
  }

  void _showArrivalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Tebrikler!'),
        content: Text('${widget.destination.name} konumuna ulaştınız!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
