import 'package:place_pickarte/src/services/google/core.dart';

class PlacesAutocompleteConfig {
  final String? sessionToken;
  final num? offset;
  final Location? origin;
  final Location? location;
  final num? radius;
  final String? language;
  final List<String> types;
  final List<Component> components;
  final bool strictbounds;
  final String? region;

  const PlacesAutocompleteConfig({
    this.sessionToken,
    this.offset,
    this.origin,
    this.location,
    this.radius,
    this.language,
    this.types = const [],
    this.components = const [],
    this.strictbounds = false,
    this.region,
  });
}
