
import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final String? coverUrl;
  final String category;
  final double? rating;
  final bool hasAudio;
  final String? audioUrl;
  final int? duration;
  final double? price;
  final bool isPublished;
  final DateTime? createdAt;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    this.description = '',
    this.coverUrl,
    required this.category,
    this.rating,
    this.hasAudio = false,
    this.audioUrl,
    this.duration,
    this.price,
    this.isPublished = false,
    this.createdAt,
  });

  // Mengubah dokumen Firestore menjadi BookModel.
  factory BookModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return BookModel(
      id: document.id,
      title: data['title'] as String? ?? '',
      author: data['author'] as String? ?? '',
      description: data['description'] as String? ?? '',
      coverUrl: data['coverUrl'] as String?,
      category: data['category'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble(),
      hasAudio: data['hasAudio'] as bool? ?? false,
      audioUrl: data['audioUrl'] as String?,
      duration: (data['duration'] as num?)?.toInt(),
      price: (data['price'] as num?)?.toDouble(),
      isPublished: data['isPublished'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Mengubah BookModel menjadi Map untuk disimpan ke Firestore.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'category': category,
      'rating': rating,
      'hasAudio': hasAudio,
      'audioUrl': audioUrl,
      'duration': duration,
      'price': price,
      'isPublished': isPublished,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : null,
    };
  }
}
