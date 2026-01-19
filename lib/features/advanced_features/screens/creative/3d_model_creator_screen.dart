import 'package:flutter/material.dart';

class ThreeDModelCreatorScreen extends StatefulWidget {
  const ThreeDModelCreatorScreen({super.key});

  @override
  State<ThreeDModelCreatorScreen> createState() =>
      _ThreeDModelCreatorScreenState();
}

class _ThreeDModelCreatorScreenState extends State<ThreeDModelCreatorScreen> {
  String selectedShape = 'Küp';
  Color selectedColor = Colors.blue;
  double scale = 1.0;
  double rotationX = 0.0;
  double rotationY = 0.0;

  final List<String> shapes = ['Küp', 'Küre', 'Piramit', 'Silindir', 'Prizma'];
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  void _saveModel() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✅ Model Kaydedildi'),
        content: Text('$selectedShape modeli başarıyla kaydedildi!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _exportModel() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📤 Modeli Dışa Aktar'),
        content: const Text('Model .obj, .gltf veya .stl formatında dışa aktarılabilir'),
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
                  content: Text('✅ Model dışa aktarıldı!'),
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
        title: const Text('🎨 3D Model Oluşturucu'),
        backgroundColor: Colors.cyan[600],
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan[600]!, Colors.teal[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveModel,
            tooltip: 'Kaydet',
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportModel,
            tooltip: 'Dışa Aktar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3D Model Preview (Simplified)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[900],
                ),
                child: Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(rotationX)
                      ..rotateY(rotationY),
                    child: Container(
                      width: 100 * scale,
                      height: 100 * scale,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: selectedShape == 'Küre'
                            ? BoxShape.circle
                            : BoxShape.rectangle,
                        border: Border.all(
                          color: selectedColor.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          selectedShape,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Shape Selection
              Text(
                'Şekil Seçin',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: shapes.map((shape) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: selectedShape == shape,
                        onSelected: (selected) {
                          setState(() => selectedShape = shape);
                        },
                        label: Text(shape),
                        selectedColor: Colors.cyan,
                        labelStyle: TextStyle(
                          color: selectedShape == shape
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              // Color Selection
              Text(
                'Renk Seçin',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: colors.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = color),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == color ? Colors.white : Colors.grey,
                          width: selectedColor == color ? 3 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              // Scale Control
              Text(
                'Boyut: ${(scale).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: scale,
                min: 0.5,
                max: 3.0,
                onChanged: (value) => setState(() => scale = value),
              ),
              const SizedBox(height: 24),
              // Rotation Controls
              Text(
                'Dönüş Kontrolü',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text('X Ekseni: ${(rotationX * 180 / 3.14159).toStringAsFixed(0)}°'),
              Slider(
                value: rotationX,
                min: -3.14159,
                max: 3.14159,
                onChanged: (value) => setState(() => rotationX = value),
              ),
              const SizedBox(height: 16),
              Text('Y Ekseni: ${(rotationY * 180 / 3.14159).toStringAsFixed(0)}°'),
              Slider(
                value: rotationY,
                min: -3.14159,
                max: 3.14159,
                onChanged: (value) => setState(() => rotationY = value),
              ),
              const SizedBox(height: 24),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedShape = 'Küp';
                          selectedColor = Colors.blue;
                          scale = 1.0;
                          rotationX = 0.0;
                          rotationY = 0.0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                      ),
                      child: const Text('🔄 Sıfırla'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveModel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan[600],
                      ),
                      child: const Text('💾 Kaydet'),
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
}
