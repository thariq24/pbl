
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book_model.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mengambil seluruh buku yang sudah dipublikasikan.
  Stream<List<BookModel>> getPublishedBooks() {
    return _firestore
        .collection('books')
        .where('isPublished', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((document) => BookModel.fromFirestore(document))
          .toList();
    });
  }

  // Mengambil detail satu buku berdasarkan ID dokumen.
  Future<BookModel?> getBookById(String bookId) async {
    final document = await _firestore
        .collection('books')
        .doc(bookId)
        .get();

    if (!document.exists) {
      return null;
    }

    return BookModel.fromFirestore(document);
  }
}
