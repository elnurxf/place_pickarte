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
    return Stack(
      children: [
        StreamBuilder<MapType>(
          initialData: controller.config.googleMapType,
          stream: controller.googleMapTypeStream,
          builder: (context, snapshot) {
            final googleMapType = snapshot.requireData;

            return GoogleMap(
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              mapType: googleMapType,
              onMapCreated: controller.onGoogleMapCreated,
              initialCameraPosition: controller.config.initialCameraPosition,
              onCameraIdle: () {
                'camera is now idle'.logiosa();

                controller.manager.updatePinState(PinState.idle);
              },
              onCameraMove: (CameraPosition position) {
                'camera is moving: $position'.logiosa();

                controller.manager.updateCameraPosition(position);
              },
              onCameraMoveStarted: () {
                'camera started moving'.logiosa();

                controller.manager.updatePinState(PinState.dragging);
              },
            );
          },
        ),
        PlacePickartePin(
          pinBuilder: controller.config.pinBuilder,
          pinStateStream: controller.pinStateStream,
          // pinKey: controller.config.pinKey,
        ),
      ],
    );
  }
}
