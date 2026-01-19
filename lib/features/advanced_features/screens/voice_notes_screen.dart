import 'package:flutter/material.dart';
import 'dart:async';

class VoiceNotesScreen extends StatefulWidget {
  const VoiceNotesScreen({super.key});

  @override
  State<VoiceNotesScreen> createState() => _VoiceNotesScreenState();
}

class _VoiceNotesScreenState extends State<VoiceNotesScreen> with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  bool _isTranscribing = false;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  String? _transcribedText;
  late AnimationController _animationController;

  final List<VoiceNote> _savedNotes = [
    VoiceNote(
      id: '1',
      title: 'Efes Müzesi Notları',
      duration: '2:34',
      transcription: 'Efes Antik Kenti\'nde bugün Celsus Kütüphanesi\'ni gezdim. Roma döneminden kalma muhteşem mimari detaylar var. Özellikle sütunlardaki kabartmalar...',
      date: DateTime.now().subtract(Duration(hours: 2)),
      category: 'Müze Gezisi',
      color: Colors.blue,
    ),
    VoiceNote(
      id: '2',
      title: 'Truva Kazı Alanı',
      duration: '4:12',
      transcription: 'Truva\'da arkeolojik kazı alanındayım. Schliemann\'ın bulduğu katmanlar hala görülebiliyor. Dokuz farklı yerleşim katmanı tespit edilmiş...',
      date: DateTime.now().subtract(Duration(days: 1)),
      category: 'Arkeoloji',
      color: Colors.orange,
    ),
    VoiceNote(
      id: '3',
      title: 'Hitit Güneş Kursu',
      duration: '1:45',
      transcription: 'Anadolu Medeniyetleri Müzesi\'nde Hitit Güneş Kursu karşısındayım. MÖ 2000\'lerden kalma bu eser dinsel törenlerde kullanılmış...',
      date: DateTime.now().subtract(Duration(days: 3)),
      category: 'Sanat Eseri',
      color: Colors.purple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1565C0),
              Color(0xFF1976D2),
              Color(0xFF1E88E5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isRecording || _isTranscribing
                    ? _buildRecordingView()
                    : _buildNotesListView(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: !_isRecording && !_isTranscribing
          ? FloatingActionButton.extended(
              onPressed: _startRecording,
              backgroundColor: Colors.red,
              icon: Icon(Icons.mic),
              label: Text('Kayıt Başlat'),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sesli Not Transkripsiyon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'AI ile konuşmayı metne çevir',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.mic, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildRecordingView() {
    if (_isTranscribing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'AI ile Transkribe Ediliyor...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ses kaydınız metne dönüştürülüyor',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5 * _animationController.value),
                      blurRadius: 40,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.mic,
                  size: 80,
                  color: Colors.white,
                ),
              );
            },
          ),
          SizedBox(height: 40),
          Text(
            _formatDuration(_recordingSeconds),
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Kayıt Devam Ediyor',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: 'cancel',
                onPressed: _cancelRecording,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(Icons.close, color: Colors.white),
              ),
              SizedBox(width: 40),
              FloatingActionButton.extended(
                heroTag: 'stop',
                onPressed: _stopRecording,
                backgroundColor: Colors.red,
                icon: Icon(Icons.stop),
                label: Text('Durdur ve Transkribe Et'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesListView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kayıtlı Notlar (${_savedNotes.length})',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.filter_list, color: Colors.white),
              ),
            ],
          ),
        ),
        Expanded(
          child: _savedNotes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic_off, size: 80, color: Colors.white30),
                      SizedBox(height: 16),
                      Text(
                        'Henüz sesli notunuz yok',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Başlamak için kayıt butonuna basın',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _savedNotes.length,
                  itemBuilder: (context, index) {
                    return _buildNoteCard(_savedNotes[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(VoiceNote note) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showNoteDetails(note),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: note.color.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.mic, color: note.color, size: 24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.white70, size: 14),
                            SizedBox(width: 4),
                            Text(
                              note.duration,
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: note.color.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                note.category,
                                style: TextStyle(
                                  color: note.color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.white70),
                    onPressed: () => _showNoteOptions(note),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                note.transcription,
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(
                _formatDate(note.date),
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
      _transcribedText = null;
    });

    _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
      });
    });
  }

  void _stopRecording() {
    _recordingTimer?.cancel();
    setState(() {
      _isRecording = false;
      _isTranscribing = true;
    });

    // Simulate AI transcription
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isTranscribing = false;
        _transcribedText = 'Bu yeni bir sesli not kaydıdır. AI ile otomatik olarak metne dönüştürülmüştür.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Sesli not başarıyla transkribe edildi! +100 XP'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _cancelRecording() {
    _recordingTimer?.cancel();
    setState(() {
      _isRecording = false;
      _recordingSeconds = 0;
    });
  }

  void _showNoteDetails(VoiceNote note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Color(0xFF1565C0),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: note.color.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.mic, color: note.color, size: 32),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${note.duration} • ${_formatDate(note.date)}',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transkripsiyon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      note.transcription,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.play_arrow),
                      label: Text('Dinle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: note.color,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.share),
                      label: Text('Paylaş'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white, width: 2),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

  void _showNoteOptions(VoiceNote note) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Color(0xFF1565C0),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Colors.white),
              title: Text('Düzenle', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.white),
              title: Text('Paylaş', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Sil', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} saat önce';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class VoiceNote {
  final String id;
  final String title;
  final String duration;
  final String transcription;
  final DateTime date;
  final String category;
  final Color color;

  VoiceNote({
    required this.id,
    required this.title,
    required this.duration,
    required this.transcription,
    required this.date,
    required this.category,
    required this.color,
  });
}
