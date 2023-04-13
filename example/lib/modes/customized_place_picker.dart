import 'package:example/modes/place_search_delegate.dart';
import 'package:flutter_artkit/flutter_artkit.dart';
import 'package:place_pickarte/place_pickarte.dart';
import 'package:example/api_key.dart';
import 'package:flutter/material.dart';

class CustomizedPlacePicker extends StatefulWidget {
  const CustomizedPlacePicker({super.key});

  @override
  State<CustomizedPlacePicker> createState() => _CustomizedPlacePickerState();
}

class _CustomizedPlacePickerState extends State<CustomizedPlacePicker> {
  late final PlacePickarteController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PlacePickarteController(
      config: PlacePickarteConfig(
        iosApiKey: iosApiKey,
        androidApiKey: androidApiKey,
        placesAutocompleteConfig: PlacesAutocompleteConfig(
          region: 'az',
          components: [
            Component(Component.country, 'tr'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: PlacePickarteMap(_controller),
      bottomNavigationBar: _buildLocationDetails(),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.goToMyLocation,
        child: const Icon(Icons.location_searching_outlined),
      ),
    );
  }

  Widget _buildLocationDetails() {
    return ElevatedBottomBar(
      elevation: 8.0,
      child: Column(
        children: [
          StreamBuilder<GeocodingResult?>(
            stream: _controller.currentLocationStream,
            builder: (context, snapshot) {
              return ListTile(
                leading: const Icon(Icons.maps_home_work_rounded),
                title: !snapshot.hasData
                    ? const LinearProgressIndicator()
                    : Text(
                        '${snapshot.data?.formattedAddress.toString()}',
                      ),
              );
            },
          ),
          Hoxy.h8(),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.maxFinite, 56),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.of(context).pop(
              _controller.currentLocation,
            ),
            icon: const Icon(
              Icons.check_rounded,
              color: Colors.white,
            ),
            label: const Text(
              'Choose address',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ).padHorizontal(24.0),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Customized Example'),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: PlaceSearchDelegate(_controller),
            );
          },
          icon: const Icon(Icons.search, size: 28.0),
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }
}
