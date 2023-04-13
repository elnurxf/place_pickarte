import 'package:place_pickarte/src/models/places_autocomplete_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_pickarte/src/widgets/place_pickarte_pin.dart';

const _initialDefaultLocationLatLng = LatLng(
  23.1311098,
  -82.3975397,
);
const _initialCameraZoom = 16.5;

class PlacePickarteConfig {
  final String? androidApiKey;
  final String? iosApiKey;
  final PlacesAutocompleteConfig? placesAutocompleteConfig;
  final PinBuilder? pinBuilder;
  final String? googleMapStyle;
  final MapType googleMapType;
  final bool myLocationAsInitial;

  PlacePickarteConfig({
    LatLng initialLocation = _initialDefaultLocationLatLng,
    double initialZoom = _initialCameraZoom,
    this.googleMapType = MapType.normal,
    this.pinBuilder,
    this.googleMapStyle,
    this.androidApiKey,
    this.iosApiKey,
    this.myLocationAsInitial = true,
    this.placesAutocompleteConfig,
  }) {
    _initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: initialZoom,
    );
  }

  late final CameraPosition _initialCameraPosition;
  CameraPosition get initialCameraPosition => _initialCameraPosition;
}
