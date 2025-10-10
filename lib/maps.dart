import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(11.2588, 75.7804); // Default Fort Kochi coordinates
  String _selectedAddress = "";
  String _selectedCity = "";
  bool _isLoading = false;
  bool _showBottomSheet = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Auto-detect location on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        ),
      };
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _showBottomSheet = false;
    });

    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Location permission denied');
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied');
        setState(() => _isLoading = false);
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng newPosition = LatLng(position.latitude, position.longitude);

      // Get address from coordinates
      await _getAddressFromLatLng(newPosition);

      // Update map
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newPosition, zoom: 15),
        ),
      );

      setState(() {
        _currentPosition = newPosition;
        _addMarker(newPosition);
        _showBottomSheet = true;
      });
    } catch (e) {
      _showSnackBar('Error getting location: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _selectedAddress = place.street ?? place.subLocality ?? place.name ?? 'Unknown Location';
          _selectedCity = '${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}'.trim();
          if (_selectedCity.startsWith(',')) {
            _selectedCity = _selectedCity.substring(1).trim();
          }
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error getting address: $e');
      setState(() {
        _selectedAddress = 'Selected Location';
        _selectedCity = 'Tap to confirm';
      });
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _isSearching = true;
      _showBottomSheet = false;
    });

    try {
      List<Location> locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        Location location = locations[0];
        LatLng newPosition = LatLng(location.latitude, location.longitude);

        await _getAddressFromLatLng(newPosition);

        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newPosition, zoom: 15),
          ),
        );

        setState(() {
          _currentPosition = newPosition;
          _addMarker(newPosition);
          _isSearching = false;
          _showBottomSheet = true;
        });

        FocusScope.of(context).unfocus();
      } else {
        _showSnackBar('Location not found');
        setState(() => _isSearching = false);
      }
    } catch (e) {
      _showSnackBar('Error searching location: $e');
      setState(() => _isSearching = false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _currentPosition = position;
      _addMarker(position);
      _showBottomSheet = false;
      _isSearching = true;
    });
    _getAddressFromLatLng(position).then((_) {
      setState(() {
        _isSearching = false;
        _showBottomSheet = true;
      });
    });
  }

  void _onCameraMove(CameraPosition position) {
    // Hide bottom sheet when user zooms or pans
    if (_showBottomSheet && !_isLoading) {
      setState(() {
        _showBottomSheet = false;
        _isSearching = true;
      });
    }
  }

  void _onCameraIdle() {
    // When camera stops moving, get the center position
    if (_isSearching && !_isLoading) {
      _mapController?.getVisibleRegion().then((bounds) {
        // Get center of the visible region
        final lat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
        final lng = (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
        final centerPosition = LatLng(lat, lng);
        
        setState(() {
          _currentPosition = centerPosition;
          _addMarker(centerPosition);
        });
        
        _getAddressFromLatLng(centerPosition).then((_) {
          setState(() {
            _isSearching = false;
            _showBottomSheet = true;
          });
        });
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _confirmLocation() {
    // Return the selected location
    Navigator.pop(context, {
      'address': _selectedAddress,
      'city': _selectedCity,
      'latitude': _currentPosition.latitude,
      'longitude': _currentPosition.longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 15,
            ),
            markers: _markers,
            onTap: _onMapTapped,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search location',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSubmitted: _searchLocation,
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),

          // Current Location Button - Always above the bottom sheet
          Positioned(
            right: 16,
            bottom: _showBottomSheet ? 260 : 100,
            child: FloatingActionButton(
              onPressed: _isLoading ? null : _getCurrentLocation,
              backgroundColor: Colors.white,
              elevation: 4,
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFE91E63),
                      ),
                    )
                  : const Icon(Icons.my_location, color: Color(0xFFE91E63)),
            ),
          ),

          // Bottom Sheet - Only show when location is selected
          if (_showBottomSheet && _selectedAddress.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Location',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE91E63).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Color(0xFFE91E63),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedAddress,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedCity,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showBottomSheet = false;
                                _isSearching = true;
                              });
                              _showSnackBar('Tap on map, search, or zoom to change location');
                            },
                            child: const Text(
                              'Change',
                              style: TextStyle(
                                color: Color(0xFFE91E63),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _confirmLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Confirm Location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Loading indicator when searching/selecting
          if (_isSearching && _isLoading)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Getting location...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}