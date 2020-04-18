library hashtagable;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:heben/utils/annotator/annotator.dart';

class SocialKeyboard extends EditableText {
  SocialKeyboard({
    Key key,
    FocusNode focusNode,
    TextEditingController controller,
    TextStyle basicStyle,
    ValueChanged<String> onChanged,
    ValueChanged<String> onSubmitted,
    Color cursorColor,
    int maxLines,
    this.decoratedStyle,
  }) : super(
          key: key,
          focusNode: focusNode,
          controller: controller,
          cursorColor: cursorColor,
          style: basicStyle,
          keyboardType: TextInputType.text,
          autocorrect: false,
          autofocus: true,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          backgroundCursorColor: Colors.white,
          maxLines: maxLines,
        );

  final TextStyle decoratedStyle;

  @override
  HashTagEditableTextState createState() => HashTagEditableTextState();
}

class HashTagEditableTextState extends EditableTextState {
  @override
  SocialKeyboard get widget => super.widget;

  Annotator annotator;

  @override
  void initState() {
    annotator = Annotator(
        textStyle: widget.style, decoratedStyle: widget.decoratedStyle);
    super.initState();
  }

  @override
  TextSpan buildTextSpan() {
    final String sourceText = textEditingValue.text;
    final annotations = annotator.getAnnotations(sourceText);
    if (annotations.isEmpty) {
      return TextSpan(text: sourceText, style: widget.style);
    } else {
      annotations.sort();
      final span = annotations.map((item) {
        return TextSpan(
            style: item.style, text: item.range.textInside(sourceText));
      }).toList();

      return TextSpan(children: span);
    }
  }
}
