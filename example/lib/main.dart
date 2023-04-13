import 'package:example/modes/customized_place_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_artkit/flutter_artkit.dart';
import 'package:place_pickarte/place_pickarte.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Place Pickarte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GeocodingResult? _pickedPlace;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artistic Place Picker'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              '${_pickedPlace?.formattedAddress.asValidString}',
            ),
            subtitle: const Text('Formatted address'),
          ),
          ListTile(
            title: Text(
              '${_pickedPlace?.details.city.asValidString}',
            ),
            subtitle: const Text('City'),
          ),
          ListTile(
            title: Text(
              '${_pickedPlace?.details.streetName.asValidString}',
            ),
            subtitle: const Text('Street name'),
          ),
          ListTile(
            title: Text(
              '${_pickedPlace?.details.streetNumber.asValidString}',
            ),
            subtitle: const Text('Street number'),
          ),
          ListTile(
            title: Text(
              '${_pickedPlace?.details.countryName.asValidString}',
            ),
            subtitle: const Text('Country'),
          ),
          ListTile(
            title: Text(
              '${_pickedPlace?.details.addressLine.asValidString}',
            ),
            subtitle: const Text('Address line'),
          ),
          ListTile(
            title: Text(
              '${_pickedPlace?.partialMatch.toString().asValidString}',
            ),
            subtitle: const Text('Partial match?'),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('What is partial match?'),
                    content: const Text(
                      'Partial_match indicates that the geocoder did not return an exact match for the original request, though it was able to match part of the requested address. You may wish to examine the original request for misspellings and/or an incomplete address',
                    ),
                    actions: [
                      TextButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Text('Owkey!'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.info_outline_rounded,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ButtonBar(
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CustomizedPlacePicker(),
                ),
              );

              setState(() => _pickedPlace = result);
            },
            icon: const Icon(Icons.format_paint_rounded),
            label: const Text('Customized sample'),
          ),
          ElevatedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.map),
            label: const Text('Prestyled sample'),
          ),
        ],
      ),
    );
  }
}
