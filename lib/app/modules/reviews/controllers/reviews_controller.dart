import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:salon/app/modules/reviews/models/review_model.dart';
import 'package:salon/app/modules/reviews/views/response_submitted_view.dart';

class ReviewsController extends GetxController {
  
  // Filter State
  final currentFilter = 'Most Recent'.obs;

  // Mock Data
  final reviews = <Review>[
    Review(
      id: '1',
      userName: 'Sarah Jenkins',
      userImage: 'assets/user1.png', 
      date: '2 days ago',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      rating: 5.0,
      comment: 'Absolutely loved the service! The new coloring technique is amazing. Will definitely be coming back for my next appointment. The ambiance is so relaxing.',
      likes: 12,
      reply: null,
      hasPhotos: true,
    ),
    Review(
      id: '2',
      userName: 'Mike T.',
      userImage: 'assets/user2.png',
      date: '1 week ago',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      rating: 4.0,
      comment: 'Great haircut but had to wait 15 mins past my booking time. Otherwise very professional staff.',
      likes: 4,
      reply: 'We apologize for the wait, Mike! We try our best to stay on schedule. Glad you liked the haircut!',
      hasPhotos: false,
    ),
    Review(
      id: '3',
      userName: 'Emily Chen',
      userImage: 'assets/user3.png',
      date: '2 weeks ago',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      rating: 5.0,
      comment: 'Best salon in town. The stylist really listened to what I wanted.',
      likes: 8,
      reply: null,
      hasPhotos: true,
    ),
    Review(
      id: '4',
      userName: 'David Wilson',
      userImage: 'assets/user4.png',
      date: '3 weeks ago',
      createdAt: DateTime.now().subtract(const Duration(days: 21)),
      rating: 2.0,
      comment: 'Not satisfied with the service. The haircut was uneven.',
      likes: 1,
      reply: null,
      hasPhotos: false,
    ),
  ].obs;

  List<Review> get filteredReviews {
    List<Review> temp = List.from(reviews);
    
    switch (currentFilter.value) {
      case 'Most Recent':
        temp.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Highest Rated':
        temp.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Lowest Rated':
        temp.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case 'With Photos':
        temp = temp.where((r) => r.hasPhotos).toList();
        break;
    }
    return temp;
  }

  void setFilter(String filter) {
    currentFilter.value = filter;
  }

  final responseController = TextEditingController();

  @override
  void onClose() {
    responseController.dispose();
    super.onClose();
  }

  void submitResponse(Review review) {
    if (responseController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a response');
      return;
    }

    // Mock API call / Update local state
    review.reply = responseController.text;
    reviews.refresh(); // Build UI updates

    // Clear input
    responseController.clear();

    // Navigate to Success
    Get.to(() => const ResponseSubmittedView());
  }

  Review? getReviewById(String id) {
    return reviews.firstWhereOrNull((r) => r.id == id);
  }
}
