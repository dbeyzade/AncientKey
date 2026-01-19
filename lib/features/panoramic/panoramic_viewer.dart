import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PanoramicViewer extends ConsumerStatefulWidget {
  final String imageUrl;
  final String title;

  const PanoramicViewer({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  ConsumerState<PanoramicViewer> createState() => _PanoramicViewerState();
}

class _PanoramicViewerState extends ConsumerState<PanoramicViewer> {
  late PhotoViewController _controller;
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = PhotoViewController();
    _controller.outputStateStream.listen((state) {
      setState(() => _currentScale = state.scale ?? 1.0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfo,
          ),
        ],
      ),
      body: Stack(
        children: [
          PhotoView(
            imageProvider: AssetImage(widget.imageUrl),
            controller: _controller,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
            enableRotation: true,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Görüntü yüklenemedi',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(
                  icon: Icons.zoom_out,
                  onPressed: _zoomOut,
                ),
                const SizedBox(width: 12),
                _buildControlButton(
                  icon: Icons.refresh,
                  onPressed: _resetView,
                ),
                const SizedBox(width: 12),
                _buildControlButton(
                  icon: Icons.zoom_in,
                  onPressed: _zoomIn,
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.zoom_in, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${(_currentScale * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        iconSize: 28,
      ),
    );
  }

  void _zoomIn() {
    final newScale = (_currentScale * 1.2).clamp(1.0, 3.0);
    _controller.scale = newScale;
  }

  void _zoomOut() {
    final newScale = (_currentScale / 1.2).clamp(1.0, 3.0);
    _controller.scale = newScale;
  }

  void _resetView() {
    _controller.reset();
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nasıl Kullanılır?'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.pan_tool, color: Colors.deepPurple),
              title: Text('Kaydırma'),
              subtitle: Text('Parmağınızı sürükleyerek panoramayı keşfedin'),
            ),
            ListTile(
              leading: Icon(Icons.zoom_in, color: Colors.deepPurple),
              title: Text('Zoom'),
              subtitle: Text('İki parmakla yakınlaştırın/uzaklaştırın'),
            ),
            ListTile(
              leading: Icon(Icons.rotate_right, color: Colors.deepPurple),
              title: Text('Döndürme'),
              subtitle: Text('İki parmakla döndürün'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anladım'),
          ),
        ],
      ),
    );
  }
}

// Gallery view for multiple panoramic images
class PanoramicGalleryScreen extends ConsumerWidget {
  final String mapId;
  final String mapName;
  final List<String> imageUrls;

  const PanoramicGalleryScreen({
    super.key,
    required this.mapId,
    required this.mapName,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('360° Görünümler - $mapName'),
        backgroundColor: Colors.black87,
      ),
      body: imageUrls.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.panorama_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '360° görünüm bulunmamaktadır',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                final imageUrl = imageUrls[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PanoramicViewer(
                          imageUrl: imageUrl,
                          title: '$mapName - Görünüm ${index + 1}',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.error_outline,
                              color: Colors.grey,
                              size: 48,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Görünüm ${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.panorama,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
