import 'package:place_pickarte/place_pickarte.dart';
import 'package:place_pickarte/src/helpers/extensions.dart';
import 'package:place_pickarte/src/widgets/place_pickarte_pin.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacePickarteMap extends StatelessWidget {
  final PlacePickarteController controller;

  const PlacePickarteMap(
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(40.409264, 49.867092)));
  }
}
