
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/book_model.dart';
import 'book_service.dart';

class LibraryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final BookService _bookService = BookService();

  // Mendapatkan UID pengguna yang sedang login.
  String get _userId {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('Pengguna belum login.');
    }

    return user.uid;
  }

  // Referensi koleksi Library milik pengguna.
  CollectionReference<Map<String, dynamic>> get _libraryCollection {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('library');
  }

  // Mengambil semua buku yang tersimpan.
  Stream<List<BookModel>> getSavedBooks() {
    if (_auth.currentUser == null) {
      return Stream.value([]);
    }

    return _libraryCollection.snapshots().asyncMap((snapshot) async {
      final books = await Future.wait(
        snapshot.docs.map((document) async {
          final bookId = document.data()['bookId'] as String?;

          if (bookId == null || bookId.isEmpty) {
            return null;
          }

          return _bookService.getBookById(bookId);
        }),
      );

      return books.whereType<BookModel>().toList();
    });
  }

  // Memeriksa apakah buku sudah tersimpan.
  Future<bool> isBookSaved(String bookId) async {
    final document = await _libraryCollection.doc(bookId).get();

    return document.exists;
  }

  // Menyimpan buku ke Library.
  Future<void> saveBook(String bookId) async {
    final document = _libraryCollection.doc(bookId);

    // Mencegah penyimpanan buku yang sama berulang kali.
    final existingBook = await document.get();

    if (existingBook.exists) {
      return;
    }

    await document.set({
      'bookId': bookId,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  // Menghapus buku dari Library.
  Future<void> removeBook(String bookId) async {
    await _libraryCollection.doc(bookId).delete();
  }
}
