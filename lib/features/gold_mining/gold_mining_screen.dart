import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:video_player/video_player.dart';
import 'models/gold_location.dart';
import 'data/turkey_gold_locations.dart';
import 'widgets/gold_mining_techniques_screen.dart';

class GoldMiningScreen extends StatefulWidget {
  const GoldMiningScreen({super.key});

  @override
  State<GoldMiningScreen> createState() => _GoldMiningScreenState();
}

class _GoldMiningScreenState extends State<GoldMiningScreen> {
  String? _selectedCity;
  final MapController _mapController = MapController();
  VideoPlayerController? _videoController;
  bool _showVideo = true;
  bool _isVideoInitialized = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _allCities = [
    'Adana',
    'Adıyaman',
    'Afyonkarahisar',
    'Ağrı',
    'Aksaray',
    'Amasya',
    'Ankara',
    'Antalya',
    'Ardahan',
    'Artvin',
    'Aydın',
    'Balıkesir',
    'Bartın',
    'Batman',
    'Bayburt',
    'Bilecik',
    'Bingöl',
    'Bitlis',
    'Bolu',
    'Burdur',
    'Bursa',
    'Çanakkale',
    'Çankırı',
    'Çorum',
    'Denizli',
    'Diyarbakır',
    'Düzce',
    'Edirne',
    'Elazığ',
    'Erzincan',
    'Erzurum',
    'Eskişehir',
    'Gaziantep',
    'Giresun',
    'Gümüşhane',
    'Hakkari',
    'Hatay',
    'Iğdır',
    'Isparta',
    'İstanbul',
    'İzmir',
    'Kahramanmaraş',
    'Karabük',
    'Karaman',
    'Kars',
    'Kastamonu',
    'Kayseri',
    'Kilis',
    'Kırıkkale',
    'Kırklareli',
    'Kırşehir',
    'Kocaeli',
    'Konya',
    'Kütahya',
    'Malatya',
    'Manisa',
    'Mardin',
    'Mersin',
    'Muğla',
    'Muş',
    'Nevşehir',
    'Niğde',
    'Ordu',
    'Osmaniye',
    'Rize',
    'Sakarya',
    'Samsun',
    'Şanlıurfa',
    'Siirt',
    'Sinop',
    'Şırnak',
    'Sivas',
    'Tekirdağ',
    'Tokat',
    'Trabzon',
    'Tunceli',
    'Uşak',
    'Van',
    'Yalova',
    'Yozgat',
    'Zonguldak',
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(
        'assets/videos/gold_mining_intro.mov',
      );
      await _videoController!.initialize();
      await _videoController!.setLooping(false);
      await _videoController!.play();
      setState(() => _isVideoInitialized = true);

      _videoController!.addListener(() {
        if (_videoController!.value.position >=
            _videoController!.value.duration) {
          setState(() => _showVideo = false);
        }
      });
    } catch (e) {
      setState(() => _showVideo = false);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showVideo) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (_isVideoInitialized && _videoController != null)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController!.value.size.width,
                    height: _videoController!.value.size.height,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            Positioned(
              top: 50,
              right: 16,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => _showVideo = false);
                  _videoController?.pause();
                },
                icon: const Icon(Icons.skip_next),
                label: const Text('Geç'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final filteredLocations = _selectedCity == null
        ? turkeyGoldLocations
        : turkeyGoldLocations
              .where((loc) => loc.city == _selectedCity)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('⛏️ Altın Arama Rehberi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.school),
            tooltip: 'Altın Çıkarma Teknikleri',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GoldMiningTechniquesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Şehir Filtresi
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black87,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Şehre Göre Filtrele:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _showCitySearchDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.amber),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedCity ?? '🇹🇷 Tüm Türkiye',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (_selectedCity != null)
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.amber,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _selectedCity = null);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          )
                        else
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.amber,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Harita
          Expanded(
            flex: 2,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(39.0, 35.0),
                initialZoom: 6.0,
                backgroundColor: Colors.black,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'ancientkey.app',
                ),
                MarkerLayer(
                  markers: filteredLocations.map((location) {
                    return Marker(
                      point: location.coordinates,
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _showLocationDetails(location),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber.withOpacity(0.9),
                            border: Border.all(color: Colors.orange, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Lokasyon Listesi
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black87,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: filteredLocations.length,
                itemBuilder: (context, index) {
                  final location = filteredLocations[index];
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Text(
                          location.potentialLevel.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        location.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      subtitle: Text(
                        '${location.city} - ${location.type}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Icon(
                        _getPotentialIcon(location.potentialLevel),
                        color: _getPotentialColor(location.potentialLevel),
                      ),
                      onTap: () => _showLocationDetails(location),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPotentialIcon(int level) {
    if (level >= 8) return Icons.stars;
    if (level >= 5) return Icons.star_half;
    return Icons.star_border;
  }

  Color _getPotentialColor(int level) {
    if (level >= 8) return Colors.amber;
    if (level >= 5) return Colors.orange;
    return Colors.grey;
  }

  void _showLocationDetails(GoldLocation location) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: Colors.amber, width: 2),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        Text(
                          '${location.city} - ${location.type}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoCard(
                'Potansiyel Seviyesi',
                '${location.potentialLevel}/10',
                Icons.trending_up,
                _getPotentialColor(location.potentialLevel),
              ),
              _buildInfoCard(
                'Açıklama',
                location.description,
                Icons.info_outline,
                Colors.blue,
              ),
              _buildInfoCard(
                'Önerilen Yöntem',
                location.recommendedMethod,
                Icons.construction,
                Colors.orange,
              ),
              _buildInfoCard(
                'En İyi Sezon',
                location.bestSeason,
                Icons.calendar_month,
                Colors.green,
              ),
              if (location.tips.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  '💡 İpuçları:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 8),
                ...location.tips.map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: Colors.amber)),
                        Expanded(
                          child: Text(
                            tip,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCitySearchDialog() {
    _searchController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final searchQuery = _searchController.text.toLowerCase();
          final filteredCities = searchQuery.isEmpty
              ? _allCities
              : _allCities
                    .where((city) => city.toLowerCase().contains(searchQuery))
                    .toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.search, color: Colors.amber),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Şehir Ara',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.amber),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Search TextField
                      TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(color: Colors.amber),
                        decoration: InputDecoration(
                          hintText: 'Şehir adı yazın...',
                          hintStyle: TextStyle(
                            color: Colors.amber.withOpacity(0.5),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.amber,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.amber,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setModalState(() {});
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.amber),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.amber.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.amber,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) => setModalState(() {}),
                      ),
                    ],
                  ),
                ),
                // Tüm Türkiye Option
                ListTile(
                  leading: const Icon(Icons.map, color: Colors.amber),
                  title: const Text(
                    '🇹🇷 Tüm Türkiye',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  tileColor: _selectedCity == null
                      ? Colors.amber.withOpacity(0.1)
                      : null,
                  onTap: () {
                    setState(() => _selectedCity = null);
                    Navigator.pop(context);
                  },
                ),
                const Divider(color: Colors.amber, height: 1),
                // Cities List
                Expanded(
                  child: filteredCities.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.amber.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Şehir bulunamadı',
                                style: TextStyle(
                                  color: Colors.amber.withOpacity(0.5),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredCities.length,
                          itemBuilder: (context, index) {
                            final city = filteredCities[index];
                            final isSelected = _selectedCity == city;

                            return ListTile(
                              leading: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.location_city,
                                color: isSelected
                                    ? Colors.amber
                                    : Colors.amber.withOpacity(0.7),
                              ),
                              title: Text(
                                city,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.amber
                                      : Colors.white,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              tileColor: isSelected
                                  ? Colors.amber.withOpacity(0.1)
                                  : null,
                              onTap: () {
                                setState(() => _selectedCity = city);
                                Navigator.pop(context);

                                // Haritayı seçilen şehre taşı
                                final cityLocations = turkeyGoldLocations
                                    .where((loc) => loc.city == city)
                                    .toList();
                                if (cityLocations.isNotEmpty) {
                                  _mapController.move(
                                    cityLocations.first.coordinates,
                                    7,
                                  );
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
