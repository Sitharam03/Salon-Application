class Review {
  final String id;
  final String userName;
  final String userImage; // For mock, use asset path or url
  final String date;
  final DateTime createdAt; // For sorting
  final double rating;
  final String comment;
  final bool hasPhotos;
  String? reply; // Mutable for mock updates
  final int likes;

  Review({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.date,
    required this.createdAt,
    required this.rating,
    required this.comment,
    this.hasPhotos = false,
    this.reply,
    this.likes = 0,
  });
}
