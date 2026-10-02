import 'package:flutter/material.dart';
import '../models/document_model.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/crypto_service.dart';

enum DocumentSortOption { dateNewest, nameAscending, issuerName }

class DocumentProvider extends ChangeNotifier {
  List<DocumentModel> _documents = StorageService.getDocuments();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  DocumentSortOption _sortOption = DocumentSortOption.dateNewest;
  bool _isLoading = false;

  List<DocumentModel> get documents => _filteredAndSortedDocuments;
  List<DocumentModel> get allDocuments => _documents;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  DocumentSortOption get sortOption => _sortOption;
  bool get isLoading => _isLoading;

  int get countAll => _documents.length;
  int get countVerified => _documents.where((d) => d.status == 'VERIFIED').length;
  int get countExpiring => _documents.where((d) => d.status == 'EXPIRING SOON').length;

  List<DocumentModel> get _filteredAndSortedDocuments {
    List<DocumentModel> list = List.from(_documents);

    // Category Filter
    if (_selectedCategory != 'All') {
      list = list.where((doc) => doc.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }

    // Search Query Filter
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((doc) =>
        doc.title.toLowerCase().contains(q) ||
        doc.issuerName.toLowerCase().contains(q) ||
        doc.maskedDocumentNumber.toLowerCase().contains(q) ||
        doc.category.toLowerCase().contains(q)
      ).toList();
    }

    // Sorting
    switch (_sortOption) {
      case DocumentSortOption.dateNewest:
        // Sort by ID or simulated recency
        list.sort((a, b) => b.id.compareTo(a.id));
        break;
      case DocumentSortOption.nameAscending:
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case DocumentSortOption.issuerName:
        list.sort((a, b) => a.issuerName.toLowerCase().compareTo(b.issuerName.toLowerCase()));
        break;
    }

    return list;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSortOption(DocumentSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  Future<void> toggleFavorite(String documentId) async {
    final index = _documents.indexWhere((d) => d.id == documentId);
    if (index != -1) {
      final doc = _documents[index];
      _documents[index] = doc.copyWith(isFavorite: !doc.isFavorite);
      await StorageService.saveDocuments(_documents);
      notifyListeners();
    }
  }

  Future<bool> fetchDocumentFromIssuer({
    required String issuerName,
    required String issuerLogoUrl,
    required String docTitle,
    required String category,
    required String docNumber,
    required String holderName,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200)); // Simulate DigiLocker API response

    final newId = 'DOC-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
    final masked = CryptoService.maskDocumentNumber(docNumber, category: category);
    final checksum = CryptoService.generateDocumentChecksum(newId, holderName);

    final newDoc = DocumentModel(
      id: newId,
      title: docTitle,
      category: category,
      issuerName: issuerName,
      issuerLogoUrl: issuerLogoUrl,
      rawDocumentNumber: docNumber,
      maskedDocumentNumber: masked,
      holderName: holderName,
      issueDate: 'Today',
      expiryDate: 'Permanent',
      status: 'VERIFIED',
      checksum: checksum,
      fileSizeMb: 1.5,
      fileType: 'PDF',
      qrPayload: 'DIGIVAULT:$newId|$issuerName|$holderName|$checksum',
      digitalSignatureInfo: {
        'signerName': '$issuerName Authorized Sub-CA',
        'certificateId': 'X509-${newId.substring(4)}',
        'algorithm': 'RSA 2048-bit / SHA-256 Digest',
        'sha256Fingerprint': '99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:00:11:22',
        'timestamp': DateTime.now().toIso8601String(),
        'tsaName': 'National Digital Repository TSA',
        'status': 'Valid Digital Signature',
      },
    );

    _documents.insert(0, newDoc);
    await StorageService.saveDocuments(_documents);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> uploadCustomDocument({
    required String title,
    required String category,
    required String docNumber,
    required String holderName,
    required String expiryDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    final newId = 'DOC-UPLOAD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final masked = docNumber.isNotEmpty
        ? CryptoService.maskDocumentNumber(docNumber, category: category)
        : 'USER-UPLOADED';
    final checksum = CryptoService.generateDocumentChecksum(newId, holderName);

    final newDoc = DocumentModel(
      id: newId,
      title: title,
      category: category,
      issuerName: 'User Self-Uploaded Vault Item',
      issuerLogoUrl: '',
      rawDocumentNumber: docNumber,
      maskedDocumentNumber: masked,
      holderName: holderName.isNotEmpty ? holderName : 'Grishma Thakare',
      issueDate: 'Today',
      expiryDate: expiryDate.isNotEmpty ? expiryDate : 'Not Specified',
      status: 'VERIFIED',
      checksum: checksum,
      fileSizeMb: 2.3,
      fileType: 'PDF',
      qrPayload: 'DIGIVAULT:$newId|Self-Uploaded|$holderName|$checksum',
      digitalSignatureInfo: {
        'signerName': 'DigiVault Self-Encrypted Storage Seal',
        'certificateId': 'X509-LOCAL-SEAL',
        'algorithm': 'AES-256 Local HSM Seal',
        'sha256Fingerprint': 'FF:EE:DD:CC:BB:AA:00:11:22:33:44:55:66:77:88:99:00:11:22:33',
        'timestamp': DateTime.now().toIso8601String(),
        'tsaName': 'DigiVault Internal TSA',
        'status': 'Locally Encrypted',
      },
    );

    _documents.insert(0, newDoc);
    await StorageService.saveDocuments(_documents);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> deleteDocument(String documentId) async {
    _documents.removeWhere((doc) => doc.id == documentId);
    await StorageService.saveDocuments(_documents);
    notifyListeners();
  }
}
