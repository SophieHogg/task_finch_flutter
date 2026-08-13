import 'package:flutter/material.dart';
import 'package:task_finch/helpers/text_helpers.dart';

class SplitSelector<T> extends StatelessWidget {
  const SplitSelector({
    super.key,
    required this.optionList,
    required this.optionGradients,
    required this.selected,
    required this.onTap,
    required this.tConverter,
  });

  final List<T> optionList;
  final List<Gradient> optionGradients;

  final List<T> selected;
  final Function (T) onTap;
  final String Function (T) tConverter;

  BorderRadius? getBorderRadius(int optionIndex, int listLength) {
    return optionIndex == 0
        ? BorderRadius.horizontal(left: Radius.circular(20))
        : optionIndex < (listLength - 1)
        ? null
        : BorderRadius.horizontal(right: Radius.circular(20));
  }

  bool getIsSelected(T option, List<T> selected) {
    return selected.contains(option);
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (index, option) in optionList.indexed)
          Expanded(
            child: InkWell(
              borderRadius: getBorderRadius(index, optionList.length),
              onTap: () => onTap(option),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: getIsSelected(option, selected) ? optionGradients[index] : null,
                  color: getIsSelected(option, selected)  ? null : Colors.grey,
                  borderRadius: getBorderRadius(index, optionList.length),
                ),
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    tConverter(option).toSentenceCase(),
                    style: TextStyle(
                      color: getIsSelected(option, selected)  ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
