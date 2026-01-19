import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/historical_documents_service.dart';

final documentsProvider = FutureProvider<List<HistoricalDocument>>((ref) async {
  final service = HistoricalDocumentsService();
  await service.insertSampleDocuments();
  return service.getAllDocuments();
});

class HistoricalDocumentsScreen extends ConsumerWidget {
  const HistoricalDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(documentsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Tarihi Belgeler Arşivi'),
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: documentsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Hata: $error'),
        ),
        data: (documents) {
          if (documents.isEmpty) {
            return Center(
              child: Text('Henüz belge yok'),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              return _DocumentCard(document: doc);
            },
          );
        },
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final HistoricalDocument document;

  const _DocumentCard({required this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getDocumentColor(document.documentType).withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DocumentDetailScreen(document: document),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getDocumentIcon(document.documentType),
                    color: _getDocumentColor(document.documentType),
                    size: 32,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (document.author != null) ...[
                          SizedBox(height: 4),
                          Text(
                            document.author!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (document.dateWritten != null) ...[
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      document.dateWritten!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
              if (document.language != null) ...[
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.language, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        document.language!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (document.documentType != null) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDocumentColor(document.documentType).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    document.documentType!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getDocumentColor(document.documentType),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
    );
  }

  IconData _getDocumentIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'ferman':
      case 'yasal belge':
      case 'hukuk':
      case 'hukuk metni':
        return Icons.gavel;
      case 'dini metin':
      case 'din':
        return Icons.auto_stories;
      case 'tıbbi metin':
      case 'tıbbi':
        return Icons.medical_services;
      case 'edebi eser':
      case 'destan':
      case 'edebi':
      case 'roman':
      case 'felsefi roman':
        return Icons.menu_book;
      case 'mit':
      case 'mitoloji':
      case 'yaratılış destanı':
        return Icons.auto_awesome;
      case 'tarih':
      case 'tarih yazımı':
      case 'tarihsel kayıt':
      case 'tarih/askeri rapor':
      case 'biyografi':
        return Icons.history_edu;
      case 'felsefi metin':
      case 'felsefi/dini':
      case 'felsefi/dini şiir':
      case 'felsefi şiir':
      case 'tarih felsefesi':
      case 'siyasi/felsefi':
        return Icons.psychology;
      case 'bilimsel':
      case 'matematik':
      case 'astronomi':
      case 'astronomi/din':
        return Icons.science;
      case 'askeri strateji':
        return Icons.shield;
      case 'gezi yazısı':
        return Icons.explore;
      case 'siyaset bilimi':
      case 'siyasi traktat':
        return Icons.account_balance;
      default:
        return Icons.description;
    }
  }

  Color _getDocumentColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'ferman':
      case 'yasal belge':
      case 'hukuk':
      case 'hukuk metni':
        return Colors.deepOrange;
      case 'dini metin':
      case 'din':
        return Colors.purple;
      case 'tıbbi metin':
      case 'tıbbi':
        return Colors.red;
      case 'edebi eser':
      case 'destan':
      case 'edebi':
      case 'roman':
      case 'felsefi roman':
        return Colors.indigo;
      case 'mit':
      case 'mitoloji':
      case 'yaratılış destanı':
        return Colors.amber;
      case 'tarih':
      case 'tarih yazımı':
      case 'tarihsel kayıt':
      case 'tarih/askeri rapor':
      case 'biyografi':
        return Colors.brown;
      case 'felsefi metin':
      case 'felsefi/dini':
      case 'felsefi/dini şiir':
      case 'felsefi şiir':
      case 'tarih felsefesi':
      case 'siyasi/felsefi':
        return Colors.deepPurple;
      case 'bilimsel':
      case 'matematik':
      case 'astronomi':
      case 'astronomi/din':
        return Colors.teal;
      case 'askeri strateji':
        return Colors.red[900]!;
      case 'gezi yazısı':
        return Colors.green;
      case 'siyaset bilimi':
      case 'siyasi traktat':
        return Colors.blue[900]!;
      default:
        return Colors.blueGrey;
    }
  }
}

class DocumentDetailScreen extends StatelessWidget {
  final HistoricalDocument document;

  const DocumentDetailScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Belge Detayı'),
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                document.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (document.author != null)
                    _buildInfoRow('Yazar', document.author!, Icons.person),
                  if (document.dateWritten != null)
                    _buildInfoRow('Tarih', document.dateWritten!, Icons.calendar_today),
                  if (document.language != null)
                    _buildInfoRow('Dil', document.language!, Icons.language),
                  if (document.documentType != null)
                    _buildInfoRow('Tür', document.documentType!, Icons.category),
                ],
              ),
            ),
            SizedBox(height: 24),
            if (document.content != null) ...[
              _buildSectionTitle('İçerik'),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  document.content!,
                  style: TextStyle(fontSize: 16, height: 1.8, color: Colors.black87),
                ),
              ),
              SizedBox(height: 24),
            ],
            if (document.translation != null) ...[
              _buildSectionTitle('Çeviri/Özet'),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  document.translation!,
                  style: TextStyle(fontSize: 16, height: 1.8, fontStyle: FontStyle.italic, color: Colors.black87),
                ),
              ),
              SizedBox(height: 24),
            ],
            if (document.significance != null) ...[
              _buildSectionTitle('Tarihi Önemi'),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE1BEE7),
                      Color(0xFFCE93D8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.star, color: Colors.purple[700], size: 28),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        document.significance!,
                        style: TextStyle(fontSize: 16, height: 1.8, color: Colors.black87, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.purple[700]),
          SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.only(bottom: 4, left: 4),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.purple[700]!,
            width: 4,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
