import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/services/audio_guide_service.dart';

class AudioGuidePlayerScreen extends ConsumerStatefulWidget {
  final String mapId;
  final String mapName;

  const AudioGuidePlayerScreen({
    super.key,
    required this.mapId,
    required this.mapName,
  });

  @override
  ConsumerState<AudioGuidePlayerScreen> createState() =>
      _AudioGuidePlayerScreenState();
}

class _AudioGuidePlayerScreenState
    extends ConsumerState<AudioGuidePlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioGuide? _currentGuide;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final Map<String, double> _downloadProgress = {};
  final Set<String> _downloading = {};

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sesli Rehber - ${widget.mapName}'),
        backgroundColor: Colors.black87,
      ),
      body: FutureBuilder<List<AudioGuide>>(
        future: ref
            .read(audioGuideServiceProvider)
            .getAudioGuidesByMapId(widget.mapId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final guides = snapshot.data ?? [];

          if (guides.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.headphones_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Bu harita için sesli rehber bulunmamaktadır',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (_currentGuide != null) _buildPlayer(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: guides.length,
                  itemBuilder: (context, index) {
                    final guide = guides[index];
                    final isCurrentlyPlaying =
                        _currentGuide?.id == guide.id && _isPlaying;
                    return _buildGuideCard(guide, isCurrentlyPlaying);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlayer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.purple],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _currentGuide!.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Slider(
            value: _position.inSeconds.toDouble(),
            max: _duration.inSeconds.toDouble(),
            activeColor: Colors.white,
            inactiveColor: Colors.white30,
            onChanged: (value) {
              _audioPlayer.seek(Duration(seconds: value.toInt()));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  _formatDuration(_duration),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _rewind,
                icon: const Icon(Icons.replay_10, color: Colors.white),
                iconSize: 40,
              ),
              const SizedBox(width: 20),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.deepPurple,
                  ),
                  iconSize: 48,
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: _forward,
                icon: const Icon(Icons.forward_10, color: Colors.white),
                iconSize: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(AudioGuide guide, bool isCurrentlyPlaying) {
    final isDownloading = _downloading.contains(guide.id);
    final progress = _downloadProgress[guide.id] ?? 0.0;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isCurrentlyPlaying ? Colors.purple.shade50 : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isCurrentlyPlaying ? Colors.deepPurple : Colors.grey.shade300,
          child: Icon(
            isCurrentlyPlaying ? Icons.volume_up : Icons.headphones,
            color: isCurrentlyPlaying ? Colors.white : Colors.grey.shade600,
          ),
        ),
        title: Text(
          guide.title,
          style: TextStyle(
            fontWeight: isCurrentlyPlaying ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Süre: ${_formatDuration(Duration(seconds: guide.duration))}'),
            if (!guide.downloaded && !isDownloading)
              TextButton.icon(
                onPressed: () => _showDownloadDialog(guide),
                icon: const Icon(Icons.download, size: 16),
                label: const Text('İndir', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            if (isDownloading) ...[
              Text(
                'İndiriliyor... %${(progress * 100).toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.orange, fontSize: 12),
              ),
              LinearProgressIndicator(value: progress),
            ],
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isCurrentlyPlaying ? Icons.stop : Icons.play_arrow,
            color: Colors.deepPurple,
          ),
          onPressed: isDownloading ? null : () => _playGuide(guide),
        ),
      ),
    );
  }

  Future<void> _playGuide(AudioGuide guide) async {
    if (_currentGuide?.id == guide.id) {
      _togglePlayPause();
      return;
    }

    await _audioPlayer.stop();
    setState(() => _currentGuide = guide);

    if (guide.downloaded) {
      await _audioPlayer.play(DeviceFileSource(guide.filePath));
    } else {
      if (_isRemoteUrl(guide.filePath)) {
        await _audioPlayer.play(UrlSource(guide.filePath));
      } else {
        _showDownloadDialog(guide);
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  Future<void> _rewind() async {
    final newPosition = _position - const Duration(seconds: 10);
    await _audioPlayer.seek(
        newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  Future<void> _forward() async {
    final newPosition = _position + const Duration(seconds: 10);
    await _audioPlayer
        .seek(newPosition > _duration ? _duration : newPosition);
  }

  void _showDownloadDialog(AudioGuide guide) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sesli Rehber İndir'),
        content: Text(
            '${guide.title} sesli rehberini offline dinlemek için indirmek ister misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadGuide(guide);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text('İndir'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadGuide(AudioGuide guide) async {
    if (_downloading.contains(guide.id)) return;

    if (!_isRemoteUrl(guide.filePath)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('İndirilebilir bir kaynak bulunamadı.')),
        );
      }
      return;
    }

    setState(() {
      _downloading.add(guide.id);
      _downloadProgress[guide.id] = 0.0;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${dir.path}/audio_guides');
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }

      final extension = _inferExtension(guide.filePath);
      final localPath = '${audioDir.path}/${guide.id}$extension';

      await Dio().download(
        guide.filePath,
        localPath,
        onReceiveProgress: (received, total) {
          if (total <= 0) return;
          final value = received / total;
          if (mounted) {
            setState(() {
              _downloadProgress[guide.id] = value.clamp(0.0, 1.0);
            });
          }
        },
      );

      await ref
          .read(audioGuideServiceProvider)
          .markAsDownloaded(guide.id, localPath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('İndirme tamamlandı ✅')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İndirme hatası: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _downloading.remove(guide.id);
          _downloadProgress.remove(guide.id);
        });
      }
    }
  }

  bool _isRemoteUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  String _inferExtension(String url) {
    final uri = Uri.tryParse(url);
    final path = uri?.path ?? '';
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < path.length - 1) {
      return path.substring(dotIndex);
    }
    return '.mp3';
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
