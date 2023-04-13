import 'package:flutter/material.dart';
import 'package:place_pickarte/place_pickarte.dart';

class PlacePickarteAutocompleteItem extends StatelessWidget {
  final Prediction prediction;
  final Function(Prediction item) onTap;

  const PlacePickarteAutocompleteItem({
    required this.prediction,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        onTap: () {
          FocusScope.of(context).unfocus();
          onTap.call(prediction);
        },
        title: RichText(
          text: TextSpan(children: getStyledTexts(context)),
        ),
      ),
    );
  }

  List<TextSpan> getStyledTexts(BuildContext context) {
    final List<TextSpan> result = [];
    const style = TextStyle(color: Colors.grey, fontSize: 15);

    final startText = prediction.description!.substring(0, prediction.matchedSubstrings.first.offset.toInt());
    if (startText.isNotEmpty) {
      result.add(TextSpan(text: startText, style: style));
    }

    final boldText = prediction.description!.substring(
      prediction.matchedSubstrings.first.offset.toInt(),
      prediction.matchedSubstrings.first.offset.toInt() + prediction.matchedSubstrings.first.length.toInt(),
    );
    result.add(
      TextSpan(
        text: boldText,
        style: style.copyWith(
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );

    final remainingText = prediction.description!.substring(
      prediction.matchedSubstrings.first.offset.toInt() + prediction.matchedSubstrings.first.length.toInt(),
    );
    result.add(
      TextSpan(
        text: remainingText,
        style: style,
      ),
    );

    return result;
  }
}
