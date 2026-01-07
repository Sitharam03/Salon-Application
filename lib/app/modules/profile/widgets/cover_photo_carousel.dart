import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/app/modules/shop_details/controllers/shop_details_controller.dart';

class CoverPhotoCarousel extends StatefulWidget {
  final List<XFile> images;
  final VoidCallback onAddTap;

  const CoverPhotoCarousel({
    Key? key,
    required this.images,
    required this.onAddTap,
  }) : super(key: key);

  @override
  State<CoverPhotoCarousel> createState() => _CoverPhotoCarouselState();
}

class _CoverPhotoCarouselState extends State<CoverPhotoCarousel> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Initialize with large initial page for infinite scroll effect
    _pageController = PageController(initialPage: widget.images.isNotEmpty ? 10000 : 0);
    _currentPage = 10000;
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (widget.images.isEmpty) return;
      
      _currentPage++;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _navigateToPage(int delta) {
    if (widget.images.isEmpty) return;
    _currentPage += delta;
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showImagePreview(XFile image, int index) {
    Get.to(() => ImagePreviewScreen(
      image: image,
      imageIndex: index,
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 200,
        width: Get.width,
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.store, size: 50, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text('Add Cover Photo', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      width: Get.width,
      child: Stack(
        children: [
          // PageView with infinite scroll
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final actualIndex = index % widget.images.length;
              final image = widget.images[actualIndex];
              return GestureDetector(
                onTap: () => _showImagePreview(image, actualIndex),
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: kIsWeb 
                          ? NetworkImage(image.path) 
                          : FileImage(File(image.path)) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          // Left Arrow
          if (widget.images.length > 1)
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.black.withOpacity(0.5),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _navigateToPage(-1),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          // Right Arrow
          if (widget.images.length > 1)
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.black.withOpacity(0.5),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _navigateToPage(1),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          // Page indicator dots
          if (widget.images.length > 1)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) {
                    final isActive = (_currentPage % widget.images.length) == index;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 8 : 6,
                      height: isActive ? 8 : 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Fullscreen Image Preview Screen
class ImagePreviewScreen extends StatelessWidget {
  final XFile image;
  final int imageIndex;

  const ImagePreviewScreen({
    Key? key,
    required this.image,
    required this.imageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShopDetailsController>();
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),
            // Image
            Expanded(
              child: Center(
                child: InteractiveViewer(
                  child: kIsWeb
                      ? Image.network(image.path, fit: BoxFit.contain)
                      : Image.file(File(image.path), fit: BoxFit.contain),
                ),
              ),
            ),
            // Action buttons
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Delete Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        controller.coverImages.removeAt(imageIndex);
                        Get.back();
                        Get.snackbar('Deleted', 'Cover photo removed');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Save/Keep Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text('Keep'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
