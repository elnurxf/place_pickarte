import 'dart:async';

import 'package:place_pickarte/src/helpers/extensions.dart';
import 'package:place_pickarte/src/services/google/core.dart';
import 'package:place_pickarte/src/services/google/geocoding.dart';
import 'package:place_pickarte/src/services/google/places.dart';
import 'package:rxdart/rxdart.dart';
import 'package:place_pickarte/place_pickarte.dart';

class PlacePickarteManager {
  late final PlacePickarteConfig config;
  late final GoogleMapsGeocoding _googleMapsGeocoding;
  late final GoogleMapsPlaces _googleMapsPlaces;
  late final StreamSubscription _pinStateSubscription;
  late final StreamSubscription _searchQuerySubscription;

  PlacePickarteManager({
    required this.config,
  }) {
    _googleMapsGeocoding = GoogleMapsGeocoding(
      apiKey: config.iosApiKey,
    );
    _googleMapsPlaces = GoogleMapsPlaces(
      apiKey: config.iosApiKey,
    );
    _pinStateSubscription = _pinState.stream.listen((PinState event) {
      /// null check before using value (CameraPosition subject is nullable).
      if (cameraPosition == null) return;

      /// Search only when the user released the control of the map.
      if (_pinState.value == PinState.idle) {
        _searchByLocation(
          Location(
            lat: cameraPosition!.target.latitude,
            lng: cameraPosition!.target.longitude,
          ),
        );
      }
    });

    _searchQuerySubscription = _searchQuery
        .distinct()
        .debounceTime(
          const Duration(milliseconds: 500),
        )
        .listen((String event) {
      _searchAutocomplete(event);
    });
  }

  final _pinState = BehaviorSubject<PinState>.seeded(PinState.idle);
  final _cameraPosition = BehaviorSubject<CameraPosition?>();
  final _searchQuery = BehaviorSubject<String>.seeded('');
  final _currentLocation = BehaviorSubject<GeocodingResult?>();
  final _autocompleteResults = BehaviorSubject<List<Prediction>?>();
  final _googleMapType = BehaviorSubject<MapType>.seeded(MapType.normal);

  Stream<PinState> get pinStateStream => _pinState.stream;
  Stream<CameraPosition?> get cameraPositionStream => _cameraPosition.stream;
  Stream<String> get searchQueryStream => _searchQuery.stream;
  Stream<GeocodingResult?> get currentLocationStream => _currentLocation.stream;
  Stream<List<Prediction>?> get autocompleteResultsStream => _autocompleteResults.stream;
  Stream<MapType> get googleMapTypeStream => _googleMapType.stream;

  CameraPosition? get cameraPosition => _cameraPosition.valueOrNull;
  List<Prediction>? get autocompleteResults => _autocompleteResults.valueOrNull;
  MapType get googleMapType => _googleMapType.value;
  GeocodingResult? get currentLocation => _currentLocation.valueOrNull;

  void updatePinState(PinState event) => _pinState.add(event);
  void updateCameraPosition(CameraPosition event) => _cameraPosition.add(event);
  void searchAutocomplete(String event) => _searchQuery.add(event);
  void _updateCurrentLocation(GeocodingResult? event) => _currentLocation.add(event);
  void _updateAutocompleteResults(List<Prediction>? event) => _autocompleteResults.add(event);
  void _updateGoogleMapType(MapType event) => _googleMapType.add(event);

  void close() {
    _googleMapType.close();
    _autocompleteResults.close();
    _currentLocation.close();
    _searchQuery.close();
    _pinState.close();
    _cameraPosition.close();
    _pinStateSubscription.cancel();
    _searchQuerySubscription.cancel();
  }

  Future<void> _searchAutocomplete(String query) async {
    _updateAutocompleteResults(null);
    final result = await _googleMapsPlaces.autocomplete(
      query,
      sessionToken: config.placesAutocompleteConfig?.sessionToken,
      offset: config.placesAutocompleteConfig?.offset,
      origin: config.placesAutocompleteConfig?.origin,
      location: config.placesAutocompleteConfig?.location,
      radius: config.placesAutocompleteConfig?.radius,
      language: config.placesAutocompleteConfig?.language,
      types: config.placesAutocompleteConfig?.types ?? [],
      components: config.placesAutocompleteConfig?.components ?? [],
      strictbounds: config.placesAutocompleteConfig?.strictbounds ?? false,
      region: config.placesAutocompleteConfig?.region,
    );

    if (result.errorMessage != null && result.errorMessage!.isNotEmpty) {
      '📛 ${result.errorMessage!}'.logiosa();
    } else {
      _updateAutocompleteResults(result.predictions);
    }
  }

  Future<void> _searchByLocation(Location location) async {
    _updateCurrentLocation(null);
    final result = await _googleMapsGeocoding.searchByLocation(location);

    if (result.errorMessage != null && result.errorMessage!.isNotEmpty) {
      '📛 ${result.errorMessage!}'.logiosa();
    } else {
      _updateCurrentLocation(result.results.first);
    }
  }

  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    // use PlacesDetailsResponse with its error handling
    final detailsResponse = await _googleMapsPlaces.getDetailsByPlaceId(placeId);
    return detailsResponse.result;
  }

  void changeGoogleMapType(MapType mapType) {
    // Do not rebuild if same [MapType] is being set.
    if (mapType == googleMapType) {
      'ignoring changing GoogleMap type: already "$mapType"'.logiosa();

      return;
    }

    'changing GoogleMap type to "$mapType"'.logiosa();

    _updateGoogleMapType(mapType);
  }

  void clearAutocompleteResults() {
    _updateAutocompleteResults(null);
  }
}
