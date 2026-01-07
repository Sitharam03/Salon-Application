import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/reviews/controllers/reviews_controller.dart';
import 'package:salon/app/modules/reviews/models/review_model.dart';
import 'package:salon/app/modules/reviews/views/respond_to_review_view.dart';

class ShopReviewsView extends GetView<ReviewsController> {
  const ShopReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Shop Reviews',
          style: TextStyle(
            color: Color(0xFF1E232C),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E232C)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Rating Summary Card
              _buildRatingSummary(),
              
              const SizedBox(height: 24),
              
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() => Row(
                  children: [
                    _buildFilterChip('Most Recent'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Highest Rated'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Lowest Rated'),
                    const SizedBox(width: 8),
                    _buildFilterChip('With Photos'),
                  ],
                )),
              ),

              const SizedBox(height: 24),

              // Reviews List
              Obx(() => ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.filteredReviews.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildReviewCard(controller.filteredReviews[index]);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = controller.currentFilter.value == label;
    return GestureDetector(
      onTap: () => controller.setFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE22424) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '4.5',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, height: 1),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildStarRow(4.5),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Based on 128 reviews',
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 20),
           _buildProgressBar(5, 0.60),
           _buildProgressBar(4, 0.20),
           _buildProgressBar(3, 0.10),
           _buildProgressBar(2, 0.05),
           _buildProgressBar(1, 0.05),
        ],
      ),
    );
  }

  Widget _buildStarRow(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Color(0xFFE22424), size: 20);
        } else if (index < rating && (rating - index) >= 0.5) {
          return const Icon(Icons.star_half, color: Color(0xFFE22424), size: 20);
        } else {
          return Icon(Icons.star_border, color: Colors.grey.shade300, size: 20);
        }
      }),
    );
  }

  Widget _buildProgressBar(int star, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text('$star', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE22424)),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text('${(percentage * 100).toInt()}%', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: const AssetImage('assets/profile_avatar.png'), // Fallback
                // Foreground logic if using the review.userImage
                // foregroundImage: AssetImage(review.userImage),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Container(
                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                           decoration: BoxDecoration(
                             color: Colors.grey.shade100,
                             borderRadius: BorderRadius.circular(8),
                           ),
                           child: Row(
                             children: [
                               Text('${review.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                               const SizedBox(width: 4),
                               const Icon(Icons.star, color: Color(0xFFE22424), size: 14),
                             ],
                           ),
                        ),
                      ],
                    ),
                    Text(
                      review.date,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Comment
          Text(
            review.comment,
            style: TextStyle(color: Colors.grey.shade800, height: 1.5),
          ),
          
          const SizedBox(height: 16),
          
          // Action / Reply
          if (review.reply != null)
             Container(
               padding: const EdgeInsets.all(12),
               decoration: BoxDecoration(
                 color: const Color(0xFFF8F9FA),
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(color: Colors.grey.shade200),
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text(
                     'Your Response:',
                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E232C)),
                   ),
                   const SizedBox(height: 4),
                   Text(
                     review.reply!,
                     style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                   ),
                 ],
               ),
             )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to Respond View
                    Get.to(() => RespondToReviewView(review: review));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.reply, size: 18, color: Color(0xFFE22424)),
                      SizedBox(width: 4),
                      Text(
                        'Reply',
                        style: TextStyle(
                          color: Color(0xFFE22424),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
