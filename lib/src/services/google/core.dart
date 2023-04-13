import 'package:json_annotation/json_annotation.dart';

part 'core.g.dart';

@JsonSerializable()
class Location {
  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  String toString() => '$lat,$lng';
}

@JsonSerializable()
class Geometry {
  final Location location;

  /// JSON location_type
  final String? locationType;

  final Bounds? viewport;

  final Bounds? bounds;

  Geometry({
    required this.location,
    this.locationType,
    this.viewport,
    this.bounds,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);
  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable()
class Bounds {
  final Location northeast;
  final Location southwest;

  Bounds({
    required this.northeast,
    required this.southwest,
  });

  @override
  String toString() => '${northeast.lat},${northeast.lng}|${southwest.lat},${southwest.lng}';

  factory Bounds.fromJson(Map<String, dynamic> json) => _$BoundsFromJson(json);
  Map<String, dynamic> toJson() => _$BoundsToJson(this);
}

abstract class GoogleResponseStatus {
  static const okay = 'OK';
  static const zeroResults = 'ZERO_RESULTS';
  static const overQueryLimit = 'OVER_QUERY_LIMIT';
  static const requestDenied = 'REQUEST_DENIED';
  static const invalidRequest = 'INVALID_REQUEST';
  static const unknownErrorStatus = 'UNKNOWN_ERROR';
  static const notFound = 'NOT_FOUND';
  static const maxWaypointsExceeded = 'MAX_WAYPOINTS_EXCEEDED';
  static const maxRouteLengthExceeded = 'MAX_ROUTE_LENGTH_EXCEEDED';

  // TODO use enum for Response status
  final String status;

  /// JSON error_message
  final String? errorMessage;

  bool get isOkay => status == okay;
  bool get hasNoResults => status == zeroResults;
  bool get isOverQueryLimit => status == overQueryLimit;
  bool get isDenied => status == requestDenied;
  bool get isInvalid => status == invalidRequest;
  bool get unknownError => status == unknownErrorStatus;
  bool get isNotFound => status == notFound;

  GoogleResponseStatus({required this.status, this.errorMessage});
}

abstract class GoogleResponseList<T> extends GoogleResponseStatus {
  @JsonKey(defaultValue: [])
  final List<T> results;

  GoogleResponseList(String status, String? errorMessage, this.results)
      : super(
          status: status,
          errorMessage: errorMessage,
        );
}

abstract class GoogleResponse<T> extends GoogleResponseStatus {
  final T result;

  GoogleResponse(String status, String? errorMessage, this.result)
      : super(
          status: status,
          errorMessage: errorMessage,
        );
}

@JsonSerializable()
class AddressComponent {
  @JsonKey(defaultValue: <String>[])
  final List<String> types;
  final String longName;
  final String shortName;

  AddressComponent({
    required this.types,
    required this.longName,
    required this.shortName,
  });

  static const locality = 'locality';
  static const country = 'country';
  static const streetNumber = 'street_number';

  factory AddressComponent.fromJson(Map<String, dynamic> json) => _$AddressComponentFromJson(json);
  Map<String, dynamic> toJson() => _$AddressComponentToJson(this);
}

class Component {
  static const route = 'route';
  static const locality = 'locality';
  static const administrativeArea = 'administrative_area';
  static const postalCode = 'postal_code';
  static const country = 'country';

  final String component;
  final String value;

  Component(this.component, this.value);

  @override
  String toString() => '$component:$value';
}
