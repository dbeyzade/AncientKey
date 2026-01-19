import 'package:flutter/material.dart';

class CustomMapEditorScreen extends StatefulWidget {
  const CustomMapEditorScreen({super.key});

  @override
  State<CustomMapEditorScreen> createState() => _CustomMapEditorScreenState();
}

class _CustomMapEditorScreenState extends State<CustomMapEditorScreen> {
  String selectedTool = 'pointer';
  List<MapMarker> markers = [];
  List<MapPath> paths = [];
  Color selectedColor = Colors.red;
  String markerName = '';
  bool showGrid = true;
  List<Offset> currentPath = [];
  bool isDrawing = false;

  final List<Color> markerColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  void _addMarker(Offset position) {
    if (selectedTool == 'marker') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Konum İsmi'),
          content: TextField(
            onChanged: (value) => markerName = value,
            decoration: const InputDecoration(
              hintText: 'Konum ismi girin...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (markerName.isNotEmpty) {
                  setState(() {
                    markers.add(MapMarker(
                      name: markerName,
                      position: position,
                      color: selectedColor,
                    ));
                    markerName = '';
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        ),
      );
    }
  }

  void _saveMap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✅ Harita Kaydedildi'),
        content: Text(
          'Harita başarıyla kaydedildi!\n'
          'Konum sayısı: ${markers.length}\n'
          'Yol sayısı: ${paths.length}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _exportMap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📤 Haritayı Dışa Aktar'),
        content: const Text('Harita GeoJSON veya PNG formatında dışa aktarılabilir'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Harita dışa aktarıldı!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Dışa Aktar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🗺️ Özel Harita Editörü'),
        backgroundColor: Colors.teal[700],
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[700]!, Colors.green[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveMap,
            tooltip: 'Kaydet',
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportMap,
            tooltip: 'Dışa Aktar',
          ),
        ],
      ),
      body: Column(
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Tooltip(
                    message: 'İşaretçi',
                    child: FilterChip(
                      selected: selectedTool == 'pointer',
                      onSelected: (_) => setState(() => selectedTool = 'pointer'),
                      label: const Text('👆'),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Tooltip(
                    message: 'İşaretleyici Ekle',
                    child: FilterChip(
                      selected: selectedTool == 'marker',
                      onSelected: (_) => setState(() => selectedTool = 'marker'),
                      label: const Text('📍'),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Tooltip(
                    message: 'Çizgi Çiz',
                    child: FilterChip(
                      selected: selectedTool == 'line',
                      onSelected: (_) => setState(() => selectedTool = 'line'),
                      label: const Text('✏️'),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Tooltip(
                    message: 'Sil',
                    child: FilterChip(
                      selected: selectedTool == 'delete',
                      onSelected: (_) => setState(() => selectedTool = 'delete'),
                      label: const Text('🗑️'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Tooltip(
                    message: 'Harita Sıfırla',
                    child: ElevatedButton(
                      onPressed: () => setState(() {
                        markers.clear();
                        paths.clear();
                      }),
                      child: const Text('↺ Sıfırla'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Color selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('Renk:'),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: markerColors.map((color) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => selectedColor = color),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selectedColor == color
                                      ? Colors.black
                                      : Colors.grey,
                                  width: selectedColor == color ? 3 : 1,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Canvas
          Expanded(
            child: GestureDetector(
              onTapDown: (details) {
                if (selectedTool == 'marker') {
                  _addMarker(details.localPosition);
                } else if (selectedTool == 'delete') {
                  setState(() {
                    markers.removeWhere((m) => 
                      (m.position - details.localPosition).distance < 20);
                  });
                }
              },
              onPanStart: (details) {
                if (selectedTool == 'line') {
                  setState(() {
                    isDrawing = true;
                    currentPath = [details.localPosition];
                  });
                }
              },
              onPanUpdate: (details) {
                if (selectedTool == 'line' && isDrawing) {
                  setState(() {
                    currentPath.add(details.localPosition);
                  });
                }
              },
              onPanEnd: (details) {
                if (selectedTool == 'line' && isDrawing && currentPath.length > 1) {
                  setState(() {
                    paths.add(MapPath(
                      points: List.from(currentPath),
                      color: selectedColor,
                    ));
                    currentPath = [];
                    isDrawing = false;
                  });
                }
              },
              child: Container(
                color: Colors.grey[100],
                child: CustomPaint(
                  painter: MapCanvasPainter(
                    markers: markers,
                    paths: paths,
                    showGrid: showGrid,
                    currentPath: currentPath,
                    isDrawing: isDrawing,
                    currentColor: selectedColor,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          // Info Panel
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Konumlar: ${markers.length}'),
                Text('Yollar: ${paths.length}'),
                IconButton(
                  icon: Icon(
                    showGrid ? Icons.grid_on : Icons.grid_off,
                  ),
                  onPressed: () => setState(() => showGrid = !showGrid),
                  tooltip: showGrid ? 'Kılavuzu Gizle' : 'Kılavuzu Göster',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MapMarker {
  final String name;
  final Offset position;
  final Color color;

  MapMarker({
    required this.name,
    required this.position,
    required this.color,
  });
}

class MapPath {
  final List<Offset> points;
  final Color color;

  MapPath({
    required this.points,
    required this.color,
  });
}

class MapCanvasPainter extends CustomPainter {
  final List<MapMarker> markers;
  final List<MapPath> paths;
  final bool showGrid;
  final List<Offset> currentPath;
  final bool isDrawing;
  final Color currentColor;

  MapCanvasPainter({
    required this.markers,
    required this.paths,
    required this.showGrid,
    required this.currentPath,
    required this.isDrawing,
    required this.currentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    // Draw paths
    for (var path in paths) {
      final paint = Paint()
        ..color = path.color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      if (path.points.length > 1) {
        for (int i = 0; i < path.points.length - 1; i++) {
          canvas.drawLine(path.points[i], path.points[i + 1], paint);
        }
      }
    }

    // Draw current path being drawn
    if (isDrawing && currentPath.length > 1) {
      final paint = Paint()
        ..color = currentColor.withOpacity(0.7)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      for (int i = 0; i < currentPath.length - 1; i++) {
        canvas.drawLine(currentPath[i], currentPath[i + 1], paint);
      }
    }

    // Draw markers
    for (var marker in markers) {
      canvas.drawCircle(
        marker.position,
        8,
        Paint()..color = marker.color,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: marker.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        marker.position.translate(12, -textPainter.height / 2),
      );
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    const gridSize = 30.0;
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(MapCanvasPainter oldDelegate) => true;
}
