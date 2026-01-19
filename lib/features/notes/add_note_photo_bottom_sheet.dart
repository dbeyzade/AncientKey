import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/services/photo_service.dart';
import '../../core/services/note_service.dart';
import '../../core/services/achievement_service.dart';

class AddNotePhotoBottomSheet extends ConsumerStatefulWidget {
  final String mapId;
  final LatLng location;

  const AddNotePhotoBottomSheet({
    super.key,
    required this.mapId,
    required this.location,
  });

  @override
  ConsumerState<AddNotePhotoBottomSheet> createState() =>
      _AddNotePhotoBottomSheetState();
}

class _AddNotePhotoBottomSheetState
    extends ConsumerState<AddNotePhotoBottomSheet> {
  final _noteController = TextEditingController();
  final _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Not ve Fotoğraf Ekle',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // Note TextField
          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notunuz',
              hintText: 'Bu yer hakkında notlarınızı yazın...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Selected Image Preview
          if (_selectedImage != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () => setState(() => _selectedImage = null),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Kamera'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeri'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: _isLoading ? null : _saveNoteAndPhoto,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      _showError('Fotoğraf seçilirken hata oluştu: $e');
    }
  }

  Future<void> _saveNoteAndPhoto() async {
    if (_noteController.text.isEmpty && _selectedImage == null) {
      _showError('Lütfen bir not yazın veya fotoğraf seçin');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final photoService = ref.read(photoServiceProvider);
      final noteService = ref.read(noteServiceProvider);
      final achievementService = ref.read(achievementServiceProvider);

      // Save photo
      if (_selectedImage != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = await _selectedImage!.copy('${appDir.path}/$fileName');
        
        await photoService.savePhoto(
          widget.mapId,
          savedImage.path,
          widget.location,
        );
      }

      // Save note
      if (_noteController.text.isNotEmpty) {
        await noteService.addNote(
          widget.mapId,
          _noteController.text,
          widget.location,
        );
      }

      // Check and unlock all achievements (including photographer and writer)
      await achievementService.checkAndUnlockAchievements();

      // Award experience points
      await achievementService.addExperiencePoints(20);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Başarıyla kaydedildi!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError('Kaydedilirken hata oluştu: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
