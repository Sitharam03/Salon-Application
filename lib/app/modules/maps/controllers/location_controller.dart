import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:salon/app/routes/app_routes.dart';

class LocationController extends GetxController {
  GoogleMapController? mapController;
  
  final _currentPosition = const LatLng(11.2588, 75.7804).obs; // Default Fort Kochi
  final _selectedAddress = ''.obs;
  final _selectedCity = ''.obs;
  final _isLoading = false.obs;
  final _showBottomSheet = false.obs;
  final _isSearching = false.obs;
  final _markers = <Marker>{}.obs;
  
  final searchController = TextEditingController();

  // Getters
  LatLng get currentPosition => _currentPosition.value;
  String get selectedAddress => _selectedAddress.value;
  String get selectedCity => _selectedCity.value;
  bool get isLoading => _isLoading.value;
  bool get showBottomSheet => _showBottomSheet.value;
  bool get isSearching => _isSearching.value;
  Set<Marker> get markers => _markers;

  @override
  void onInit() {
    super.onInit();
    // Auto-detect location on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocation();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    mapController?.dispose();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void addMarker(LatLng position) {
    _markers.value = {
      Marker(
        markerId: const MarkerId('selected_location'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ),
    };
  }

  Future<void> getCurrentLocation() async {
    _isLoading.value = true;
    _showBottomSheet.value = false;

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Location permission denied');
          _isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied');
        _isLoading.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng newPosition = LatLng(position.latitude, position.longitude);

      await getAddressFromLatLng(newPosition);

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newPosition, zoom: 15),
        ),
      );

      _currentPosition.value = newPosition;
      addMarker(newPosition);
      _showBottomSheet.value = true;
    } catch (e) {
      _showSnackBar('Error getting location: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _selectedAddress.value = place.street ?? place.subLocality ?? place.name ?? 'Unknown Location';
        _selectedCity.value = '${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}'.trim();
        if (_selectedCity.value.startsWith(',')) {
          _selectedCity.value = _selectedCity.value.substring(1).trim();
        }
      }
    } catch (e) {
      _selectedAddress.value = 'Selected Location';
      _selectedCity.value = 'Tap to confirm';
    }
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) return;

    _isLoading.value = true;
    _isSearching.value = true;
    _showBottomSheet.value = false;

    try {
      List<Location> locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        Location location = locations[0];
        LatLng newPosition = LatLng(location.latitude, location.longitude);

        await getAddressFromLatLng(newPosition);

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newPosition, zoom: 15),
          ),
        );

        _currentPosition.value = newPosition;
        addMarker(newPosition);
        _isSearching.value = false;
        _showBottomSheet.value = true;

        FocusScope.of(Get.context!).unfocus();
      } else {
        _showSnackBar('Location not found');
        _isSearching.value = false;
      }
    } catch (e) {
      _showSnackBar('Error searching location: $e');
      _isSearching.value = false;
    } finally {
      _isLoading.value = false;
    }
  }

  void onMapTapped(LatLng position) {
    _currentPosition.value = position;
    addMarker(position);
    _showBottomSheet.value = false;
    _isSearching.value = true;
    
    getAddressFromLatLng(position).then((_) {
      _isSearching.value = false;
      _showBottomSheet.value = true;
    });
  }

  void onCameraMove(CameraPosition position) {
    if (_showBottomSheet.value && !_isLoading.value) {
      _showBottomSheet.value = false;
      _isSearching.value = true;
    }
  }

  void onCameraIdle() {
    if (_isSearching.value && !_isLoading.value) {
      mapController?.getVisibleRegion().then((bounds) {
        final lat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
        final lng = (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
        final centerPosition = LatLng(lat, lng);
        
        _currentPosition.value = centerPosition;
        addMarker(centerPosition);
        
        getAddressFromLatLng(centerPosition).then((_) {
          _isSearching.value = false;
          _showBottomSheet.value = true;
        });
      });
    }
  }

  void changeLocation() {
    _showBottomSheet.value = false;
    _isSearching.value = true;
    _showSnackBar('Tap on map, search, or zoom to change location');
  }

  void confirmLocation() {
    // Get destination from arguments or default to SHOP_DETAILS
    final args = Get.arguments as Map<String, dynamic>?;
    final destination = args?['destination'] ?? AppRoutes.SHOP_DETAILS;

    // Remove destination from args if present to avoid looping or pollution if needed, 
    // but here we just need to pass back the location data.
    
    // If destination is HOME, we might want to clear stack or just navigate
    if (destination == AppRoutes.HOME) {
      Get.offAllNamed(destination, arguments: {
        'address': _selectedAddress.value,
        'city': _selectedCity.value,
        'latitude': _currentPosition.value.latitude,
        'longitude': _currentPosition.value.longitude,
      });
    } else {
       Get.toNamed(destination, arguments: {
        'address': _selectedAddress.value,
        'city': _selectedCity.value,
        'latitude': _currentPosition.value.latitude,
        'longitude': _currentPosition.value.longitude,
      });
    }
  }

  void _showSnackBar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
