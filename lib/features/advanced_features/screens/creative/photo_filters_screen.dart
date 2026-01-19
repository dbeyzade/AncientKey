import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class PhotoFiltersScreen extends StatefulWidget {
  const PhotoFiltersScreen({super.key});

  @override
  State<PhotoFiltersScreen> createState() => _PhotoFiltersScreenState();
}

class _PhotoFiltersScreenState extends State<PhotoFiltersScreen> {
  String? selectedPhotoPath;
  String selectedPhotoName = 'Henüz Fotoğraf Yok';
  String selectedFilter = 'Orijinal';
  double filterIntensity = 1.0;
  double brightness = 0.0;
  double contrast = 0.0;
  double saturation = 0.0;
  double blur = 0.0;
  bool _isProcessing = false;

  final ScreenshotController _screenshotController = ScreenshotController();

  final List<String> filters = [
    'Orijinal',
    'Sepya',
    'Siyah-Beyaz',
    'Soğuk Ton',
    'Sıcak Ton',
    'Vintage',
    'Nostalji',
    'Yüksek Kontrast',
    'Düşük Kontrast',
    'Ters Renkler',
  ];

  final List<String> filterEmojis = [
    '🎨',
    '📜',
    '⬜',
    '❄️',
    '🔥',
    '🕰️',
    '📽️',
    '⚫',
    '⚪',
    '🔄',
  ];

  void _importPhoto() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null) {
        final path = image.path;
        final file = File(path);
        
        // Dosyanın var olduğunu kontrol et
        if (await file.exists()) {
          setState(() {
            selectedPhotoPath = path;
            selectedPhotoName = image.name;
            selectedFilter = 'Orijinal';
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ ${image.name} yüklendi!'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('❌ Dosya bulunamadı!'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Hata: $e'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      filterIntensity = 1.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$filter filtresi uygulandı ✨'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _savePhoto() async {
    if (selectedPhotoPath == null || _isProcessing) {
      if (selectedPhotoPath == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Önce bir fotoğraf seçmelisin.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final bytes = await _capturePreview();
      if (bytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Görsel oluşturulamadı.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      final name = 'ancientkey_${DateTime.now().millisecondsSinceEpoch}';
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 95,
        name: name,
      );

      if (mounted) {
        final isSuccess = (result['isSuccess'] == true) || (result['success'] == true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isSuccess
                  ? '✅ Fotoğraf galeriye kaydedildi!'
                  : '❌ Kaydetme başarısız oldu.',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Kaydetme hatası: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _sharePhoto() async {
    if (selectedPhotoPath == null || _isProcessing) {
      if (selectedPhotoPath == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Önce bir fotoğraf seçmelisin.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final bytes = await _capturePreview();
      if (bytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Görsel oluşturulamadı.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/ancientkey_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes, flush: true);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'AncientKey ile oluşturuldu.',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Paylaşım hatası: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<Uint8List?> _capturePreview() async {
    try {
      return await _screenshotController.capture(pixelRatio: 2.0);
    } catch (_) {
      return null;
    }
  }

  Color _applyColorFilter(Color baseColor) {
    switch (selectedFilter) {
      case 'Sepya':
        return Color.lerp(baseColor, const Color(0xFF704214), 0.4)!;
      case 'Siyah-Beyaz':
        final gray = (baseColor.red + baseColor.green + baseColor.blue) ~/ 3;
        return Color.fromARGB(
          baseColor.alpha,
          gray,
          gray,
          gray,
        );
      case 'Soğuk Ton':
        return Color.lerp(baseColor, Colors.cyan, 0.2)!;
      case 'Sıcak Ton':
        return Color.lerp(baseColor, Colors.orange, 0.2)!;
      case 'Vintage':
        return Color.lerp(baseColor, Colors.brown, 0.15)!;
      case 'Nostalji':
        return Color.lerp(baseColor, Colors.pink, 0.1)!;
      case 'Yüksek Kontrast':
        return baseColor.withOpacity(1.0);
      case 'Düşük Kontrast':
        return Color.lerp(baseColor, Colors.grey, 0.3)!;
      case 'Ters Renkler':
        return Color.fromARGB(
          baseColor.alpha,
          255 - baseColor.red,
          255 - baseColor.green,
          255 - baseColor.blue,
        );
      default:
        return baseColor;
    }
  }

  Widget _buildPreviewContent() {
    if (selectedPhotoPath == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple[300]!,
                border: Border.all(
                  color: Colors.purple[500]!,
                  width: 3,
                ),
              ),
              child: const Center(
                child: Text('📸', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fotoğraf seçmek için\naşağıdaki butona tıklayın',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Filtre: $selectedFilter',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    final image = Image.file(
      File(selectedPhotoPath!),
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(error),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: _applyAllFilters(image),
    );
  }

  Widget _applyAllFilters(Widget child) {
    Widget current = child;

    if (selectedFilter != 'Orijinal') {
      current = ColorFiltered(
        colorFilter: ColorFilter.mode(
          _getFilterColor().withOpacity(filterIntensity),
          _getFilterBlendMode(),
        ),
        child: current,
      );
    }

    if (saturation != 0.0) {
      current = ColorFiltered(
        colorFilter: ColorFilter.matrix(_saturationMatrix(saturation)),
        child: current,
      );
    }

    if (brightness != 0.0 || contrast != 0.0) {
      current = ColorFiltered(
        colorFilter:
            ColorFilter.matrix(_contrastBrightnessMatrix(contrast, brightness)),
        child: current,
      );
    }

    if (blur > 0.0) {
      current = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: current,
      );
    }

    return current;
  }

  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 48, color: Colors.red),
          const SizedBox(height: 8),
          Text('Resim yüklenemedi: $error'),
        ],
      ),
    );
  }

  List<double> _saturationMatrix(double value) {
    final s = value + 1.0;
    final inv = 1.0 - s;
    const r = 0.213;
    const g = 0.715;
    const b = 0.072;

    final rComp = r * inv;
    final gComp = g * inv;
    final bComp = b * inv;

    return [
      rComp + s, gComp, bComp, 0, 0,
      rComp, gComp + s, bComp, 0, 0,
      rComp, gComp, bComp + s, 0, 0,
      0, 0, 0, 1, 0,
    ];
  }

  List<double> _contrastBrightnessMatrix(double contrastValue, double brightnessValue) {
    final c = contrastValue + 1.0;
    final t = brightnessValue * 255.0;
    final offset = (1.0 - c) * 128.0 + t;

    return [
      c, 0, 0, 0, offset,
      0, c, 0, 0, offset,
      0, 0, c, 0, offset,
      0, 0, 0, 1, 0,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📸 Fotoğraf Filtreleri'),
        backgroundColor: Colors.purple[500],
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple[500]!, Colors.pink[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          if (selectedPhotoPath != null)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _isProcessing ? null : _sharePhoto,
              tooltip: 'Paylaş',
            ),
          if (selectedPhotoPath != null)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isProcessing ? null : _savePhoto,
              tooltip: 'Kaydet',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Preview
              Screenshot(
                controller: _screenshotController,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple[500]!, width: 2),
                    color: Colors.grey[200],
                  ),
                  child: _buildPreviewContent(),
                ),
              ),
              const SizedBox(height: 16),
              // Import Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _importPhoto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[500],
                  ),
                  child: const Text('📁 Fotoğraf İçe Aktar'),
                ),
              ),
              const SizedBox(height: 24),
              // Filters Grid
              Text(
                'Filtreler',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = selectedFilter == filter;
                  return GestureDetector(
                    onTap: () => _applyFilter(filter),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _applyColorFilter(Colors.purple[100]!),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.purple[500]!
                              : Colors.grey[300]!,
                          width: isSelected ? 3 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.purple[500]!
                                      .withValues(alpha: 0.4),
                                  blurRadius: 8,
                                )
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            filterEmojis[index],
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            filter,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Adjustments
              if (selectedPhotoPath != null) ...[
                Text(
                  'Ayarlamalar',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                // Filter Intensity
                Text(
                  'Filtre Yoğunluğu: ${(filterIntensity * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12),
                ),
                Slider(
                  value: filterIntensity,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (value) =>
                      setState(() => filterIntensity = value),
                ),
                const SizedBox(height: 12),
                // Brightness
                Text(
                  'Parlaklık: ${brightness.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 12),
                ),
                Slider(
                  value: brightness,
                  min: -0.5,
                  max: 0.5,
                  onChanged: (value) =>
                      setState(() => brightness = value),
                ),
                const SizedBox(height: 12),
                // Contrast
                Text(
                  'Kontrast: ${contrast.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 12),
                ),
                Slider(
                  value: contrast,
                  min: -0.5,
                  max: 0.5,
                  onChanged: (value) =>
                      setState(() => contrast = value),
                ),
                const SizedBox(height: 12),
                // Saturation
                Text(
                  'Doygunluk: ${saturation.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 12),
                ),
                Slider(
                  value: saturation,
                  min: -0.5,
                  max: 0.5,
                  onChanged: (value) =>
                      setState(() => saturation = value),
                ),
                const SizedBox(height: 12),
                // Blur
                Text(
                  'Bulanıklık: ${blur.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 12),
                ),
                Slider(
                  value: blur,
                  min: 0.0,
                  max: 10.0,
                  onChanged: (value) =>
                      setState(() => blur = value),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = 'Orijinal';
                            filterIntensity = 1.0;
                            brightness = 0.0;
                            contrast = 0.0;
                            saturation = 0.0;
                            blur = 0.0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                        ),
                        child: const Text('↺ Sıfırla'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _savePhoto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[500],
                        ),
                        child: const Text('💾 Kaydet'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getFilterColor() {
    switch (selectedFilter) {
      case 'Sepya':
        return const Color(0xFF704214);
      case 'Siyah-Beyaz':
        return Colors.grey;
      case 'Soğuk Ton':
        return Colors.cyan;
      case 'Sıcak Ton':
        return Colors.orange;
      case 'Vintage':
        return Colors.brown;
      case 'Nostalji':
        return Colors.pink;
      case 'Ters Renkler':
        return Colors.white;
      default:
        return Colors.transparent;
    }
  }

  BlendMode _getFilterBlendMode() {
    switch (selectedFilter) {
      case 'Siyah-Beyaz':
        return BlendMode.saturation;
      case 'Ters Renkler':
        return BlendMode.difference;
      case 'Yüksek Kontrast':
        return BlendMode.hardLight;
      case 'Düşük Kontrast':
        return BlendMode.lighten;
      default:
        return BlendMode.modulate;
    }
  }
}
