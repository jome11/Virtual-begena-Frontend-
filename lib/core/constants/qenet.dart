import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum Qenet { selamta, tezeta, anchihoye }

extension QenetX on Qenet {
  String get label => switch (this) {
    Qenet.selamta => 'SELAMTA',
    Qenet.tezeta => 'TEZETA',
    Qenet.anchihoye => 'ANCHIHOYE',
  };
  Color get color => switch (this) {
    Qenet.selamta => AppColors.qenetSelamta,
    Qenet.tezeta => AppColors.qenetTezeta,
    Qenet.anchihoye => AppColors.qenetAnchihoye,
  };
}
