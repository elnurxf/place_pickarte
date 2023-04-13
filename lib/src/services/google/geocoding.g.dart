// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geocoding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeocodingResponse _$GeocodingResponseFromJson(Map<String, dynamic> json) => GeocodingResponse(
      status: json['status'] as String,
      errorMessage: json['error_message'] as String?,
      results: (json['results'] as List<dynamic>?)?.map((e) => GeocodingResult.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );

Map<String, dynamic> _$GeocodingResponseToJson(GeocodingResponse instance) => <String, dynamic>{
      'status': instance.status,
      'error_message': instance.errorMessage,
      'results': instance.results,
    };

GeocodingResult _$GeocodingResultFromJson(Map<String, dynamic> json) => GeocodingResult(
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      placeId: json['place_id'] as String,
      types: (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      addressComponents: (json['address_components'] as List<dynamic>?)?.map((e) => AddressComponent.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      postcodeLocalities: (json['postcode_localities'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      partialMatch: json['partial_match'] as bool? ?? false,
      formattedAddress: json['formatted_address'] as String?,
    );

Map<String, dynamic> _$GeocodingResultToJson(GeocodingResult instance) => <String, dynamic>{
      'types': instance.types,
      'formatted_address': instance.formattedAddress,
      'address_components': instance.addressComponents,
      'postcode_localities': instance.postcodeLocalities,
      'geometry': instance.geometry,
      'partial_match': instance.partialMatch,
      'place_id': instance.placeId,
    };
