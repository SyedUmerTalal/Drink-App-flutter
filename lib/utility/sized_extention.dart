import 'package:flutter/material.dart';

extension sizing on num {
  num getContextHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * (this / 820.5714285714286);
  }
}
