import 'package:flutter/material.dart';
import 'package:place_pickarte/place_pickarte.dart';

class PlaceSearchDelegate extends SearchDelegate {
  final PlacePickarteController controller;

  PlaceSearchDelegate(this.controller);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear_outlined),
      ),
      const SizedBox(width: 8.0),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: Navigator.of(context).pop,
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    controller.searchAutocomplete(query);

    return StreamBuilder<List<Prediction>?>(
      stream: controller.autocompleteResultsStream,
      builder: (_, snapshot) {
        final ready = snapshot.hasData;

        if (!ready) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final predictions = snapshot.data!;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          itemCount: predictions.length,
          itemBuilder: (_, int index) {
            final prediction = predictions.elementAt(index);

            return ListTile(
              onTap: () {
                close(context, null);
                controller.selectAutocompleteItem(prediction);
              },
              title: Text(prediction.description ?? 'asd'),
              trailing: const Icon(Icons.chevron_right_outlined),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return const FlutterLogo();
  }
}
