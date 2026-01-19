import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../../core/services/models_3d_service.dart';

final models3DProvider = FutureProvider<List<Model3D>>((ref) async {
  final service = Models3DService();
  return service.getAllModels();
});

class Models3DScreen extends ConsumerWidget {
  const Models3DScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelsAsync = ref.watch(models3DProvider);

    return Scaffold(
      appBar: AppBar(title: Text('3D Modeller'), elevation: 2),
      body: modelsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
        data: (models) {
          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: models.length,
            itemBuilder: (context, index) {
              final model = models[index];
              return _Model3DCard(model: model);
            },
          );
        },
      ),
    );
  }
}

class _Model3DCard extends StatelessWidget {
  final Model3D model;

  const _Model3DCard({required this.model});

  String _getCivilization(String name) {
    if (name.contains('Yunan') ||
        name.contains('Parthenon') ||
        name.contains('Akropolis') ||
        name.contains('Truva')) {
      return 'Yunan';
    }
    if (name.contains('Roma') ||
        name.contains('Koloseum') ||
        name.contains('Efes') ||
        name.contains('Pantheon') ||
        name.contains('Forum')) {
      return 'Roma';
    }
    if (name.contains('Mısır') ||
        name.contains('Giza') ||
        name.contains('Karnak') ||
        name.contains('Abu Simbel')) {
      return 'Mısır';
    }
    if (name.contains('Bizans') || name.contains('Ayasofya')) return 'Bizans';
    if (name.contains('İnka') || name.contains('Machu')) return 'İnka';
    if (name.contains('Petra')) return 'Nabati';
    if (name.contains('Stonehenge')) return 'Neolitik';
    if (name.contains('Angkor')) return 'Khmer';
    if (name.contains('Babil')) return 'Babil';
    if (name.contains('Moai')) return 'Polinezya';
    if (name.contains('Knossos')) return 'Minos';
    if (name.contains('Ziggurat') || name.contains('Ur')) return 'Sümer';
    if (name.contains('Teotihuacan')) return 'Aztek';
    if (name.contains('Borobudur')) return 'Java';
    if (name.contains('Persepolis')) return 'Pers';
    if (name.contains('Osmanlı') ||
        name.contains('Topkapı') ||
        name.contains('Süleymaniye')) {
      return 'Osmanlı';
    }
    if (name.contains('Versailles') || name.contains('Notre Dame')) {
      return 'Fransa';
    }
    if (name.contains('Taj Mahal')) return 'Babür';
    if (name.contains('Çin') || name.contains('Terrakotta')) return 'Çin';
    if (name.contains('Chichen Itza')) return 'Maya';
    return 'Diğer';
  }

  Color _getCivilizationColor(String civilization) {
    final colors = {
      'Yunan': Colors.blue,
      'Roma': Colors.red,
      'Mısır': Colors.amber,
      'Bizans': Colors.purple,
      'İnka': Colors.green,
      'Nabati': Colors.pink,
      'Neolitik': Colors.blueGrey,
      'Khmer': Colors.teal,
      'Babil': Colors.deepPurple,
      'Polinezya': Colors.cyan,
      'Minos': Colors.indigo,
      'Sümer': Colors.orange,
      'Aztek': Colors.lime[800],
      'Java': Colors.brown,
      'Pers': Colors.deepOrange,
      'Osmanlı': Colors.red[900],
      'Fransa': Colors.blue[800],
      'Babür': Colors.lightGreen,
      'Çin': Colors.red[700],
      'Maya': Colors.green[700],
    };
    return colors[civilization] ?? Colors.grey;
  }

  IconData _getIcon(String civilization) {
    final icons = {
      'Yunan': Icons.account_balance,
      'Roma': Icons.stadium,
      'Mısır': Icons.change_history,
      'Bizans': Icons.church,
      'İnka': Icons.landscape,
      'Nabati': Icons.architecture,
      'Neolitik': Icons.circle,
      'Khmer': Icons.temple_hindu,
      'Babil': Icons.apartment,
      'Polinezya': Icons.analytics,
      'Minos': Icons.castle,
      'Sümer': Icons.home_work,
      'Osmanlı': Icons.mosque,
      'Çin': Icons.castle,
    };
    return icons[civilization] ?? Icons.view_in_ar;
  }

  @override
  Widget build(BuildContext context) {
    final civilization = _getCivilization(model.name);
    final color = _getCivilizationColor(civilization);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => _Model3DDetailDialog(model: model),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withOpacity(0.7), color.withOpacity(0.4)],
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getIcon(civilization),
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      civilization,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Model3DDetailDialog extends StatelessWidget {
  final Model3D model;

  const _Model3DDetailDialog({required this.model});

  String _getCivilization(String name) {
    if (name.contains('Yunan') ||
        name.contains('Parthenon') ||
        name.contains('Akropolis') ||
        name.contains('Truva')) {
      return 'Yunan';
    }
    if (name.contains('Roma') ||
        name.contains('Koloseum') ||
        name.contains('Efes') ||
        name.contains('Pantheon') ||
        name.contains('Forum')) {
      return 'Roma';
    }
    if (name.contains('Mısır') ||
        name.contains('Giza') ||
        name.contains('Karnak') ||
        name.contains('Abu Simbel')) {
      return 'Mısır';
    }
    if (name.contains('Bizans') || name.contains('Ayasofya')) return 'Bizans';
    if (name.contains('İnka') || name.contains('Machu')) return 'İnka';
    if (name.contains('Petra')) return 'Nabati';
    if (name.contains('Stonehenge')) return 'Neolitik';
    if (name.contains('Angkor')) return 'Khmer';
    if (name.contains('Babil')) return 'Babil';
    if (name.contains('Moai')) return 'Polinezya';
    if (name.contains('Knossos')) return 'Minos';
    if (name.contains('Ziggurat') || name.contains('Ur')) return 'Sümer';
    if (name.contains('Teotihuacan')) return 'Aztek';
    if (name.contains('Borobudur')) return 'Java';
    if (name.contains('Persepolis')) return 'Pers';
    if (name.contains('Osmanlı') ||
        name.contains('Topkapı') ||
        name.contains('Süleymaniye')) {
      return 'Osmanlı';
    }
    if (name.contains('Versailles') || name.contains('Notre Dame')) {
      return 'Fransa';
    }
    if (name.contains('Taj Mahal')) return 'Babür';
    if (name.contains('Çin') || name.contains('Terrakotta')) return 'Çin';
    if (name.contains('Chichen Itza')) return 'Maya';
    return 'Diğer';
  }

  Color _getCivilizationColor(String civilization) {
    final colors = {
      'Yunan': Colors.blue,
      'Roma': Colors.red,
      'Mısır': Colors.amber,
      'Bizans': Colors.purple,
      'İnka': Colors.green,
      'Nabati': Colors.pink,
      'Neolitik': Colors.blueGrey,
      'Khmer': Colors.teal,
      'Babil': Colors.deepPurple,
      'Polinezya': Colors.cyan,
      'Minos': Colors.indigo,
      'Sümer': Colors.orange,
      'Aztek': Colors.lime[800],
      'Java': Colors.brown,
      'Pers': Colors.deepOrange,
      'Osmanlı': Colors.red[900],
      'Fransa': Colors.blue[800],
      'Babür': Colors.lightGreen,
      'Çin': Colors.red[700],
      'Maya': Colors.green[700],
    };
    return colors[civilization] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final civilization = _getCivilization(model.name);
    final color = _getCivilizationColor(civilization);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.8), color.withOpacity(0.5)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.view_in_ar, size: 80, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      '3D Model',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      civilization,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                  if (model.description != null) ...[
                    SizedBox(height: 16),
                    Text(
                      model.description!,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                  SizedBox(height: 20),
                  _Simple3DViewer(color: color),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close),
                          label: Text('KAPAT'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FullScreen3DViewer(
                                  model: model,
                                  color: color,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.view_in_ar),
                          label: Text('TAM EKRAN'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Simple3DViewer extends StatefulWidget {
  final Color color;

  const _Simple3DViewer({required this.color});

  @override
  State<_Simple3DViewer> createState() => _Simple3DViewerState();
}

class _Simple3DViewerState extends State<_Simple3DViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _rotationX = 0.3;
  double _rotationY = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _rotationY += details.delta.dx * 0.01;
          _rotationX += details.delta.dy * 0.01;
          _rotationX = _rotationX.clamp(-math.pi / 2, math.pi / 2);
        });
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.color.withOpacity(0.1),
              widget.color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.color.withOpacity(0.3), width: 2),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _Cube3DPainter(
                rotationX: _rotationX,
                rotationY: _rotationY + _controller.value * 2 * math.pi,
                color: widget.color,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

class FullScreen3DViewer extends StatelessWidget {
  final Model3D model;
  final Color color;

  const FullScreen3DViewer({
    super.key,
    required this.model,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Use a valid sample model if the URL is a placeholder
    final displayUrl = model.modelUrl.contains('example.com')
        ? 'https://modelviewer.dev/shared-assets/models/Astronaut.glb'
        : model.modelUrl;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(model.name),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ModelViewer(
        backgroundColor: Colors.black,
        src: displayUrl,
        alt: "A 3D model of ${model.name}",
        ar: true,
        autoRotate: true,
        cameraControls: true,
        disableZoom: false,
      ),
    );
  }
}

class _Simple3DViewer extends StatelessWidget {
  final Model3D model;
  final Color color;

  const _Simple3DViewer({required this.model, required this.color});

  @override
  Widget build(BuildContext context) {
    // Use a valid sample model if the URL is a placeholder
    final displayUrl = model.modelUrl.contains('example.com')
        ? 'https://modelviewer.dev/shared-assets/models/Astronaut.glb'
        : model.modelUrl;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ModelViewer(
          backgroundColor: Colors.transparent,
          src: displayUrl,
          alt: "A 3D model of ${model.name}",
          ar: false,
          autoRotate: true,
          cameraControls: true,
          disableZoom: true,
        ),
      ),
    );
  }
}
