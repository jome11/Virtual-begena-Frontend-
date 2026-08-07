import 'package:flutter/material.dart';

enum Language { en, am }

final ValueNotifier<Language> languageNotifier = ValueNotifier(Language.am);

class AppStrings {
  static String get(String key) {
    final lang = languageNotifier.value;
    return _strings[lang]?[key] ?? key;
  }

  static const Map<Language, Map<String, String>> _strings = {
    Language.en: {
      'app_title': 'VIRTUAL BEGENA',
      'home': 'Home',
      'about': 'About',
      'lessons': 'Lessons',
      'contact': 'Contact',
      'enter': 'Enter',
      'get_started': 'Get Started',
      'hero_title': 'VIRTUAL BEGENA',
      'hero_subtitle': 'Master the Harp of David.\nExperience the spiritual depth of Ethiopian heritage through immersive digital lessons.',
      'start_learning': 'START LEARNING',
      'feature_title': 'Why Choose Virtual Begena?',
      'feature_1_title': 'Structured Lessons',
      'feature_1_desc': 'Step-by-step guidance from beginners to advanced techniques.',
      'feature_2_title': 'Interactive Practice',
      'feature_2_desc': 'Real-time feedback and virtual strings to master the melody.',
      'feature_3_title': 'Cultural Heritage',
      'feature_3_desc': 'Learn the history and spiritual significance of the Begena.',
      'footer_subtitle': 'Bringing the ancient sounds\nto the modern world.',
      'footer_copyright': '© 2026 Virtual Begena. All rights reserved.',
      // Auth
      'sign_in': 'Sign In',
      'username': 'Username',
      'password': 'Password',
      'sign_in_cta': 'Sign In',
      'sign_out': 'Sign out',
      'welcome': 'Welcome,',
      // Dashboard
      'dashboard_title': 'Virtual Begena Trainer',
      'dashboard_subtitle': 'AI-powered traditional Ethiopian instrument practice',
      'choose_mode': 'Choose a mode to begin:',
      'mode_exercise': 'Exercise Mode',
      'mode_free_play': 'Free Play Mode',
      'mode_tuning': 'Tuning Mode',
      'mode_mezmur_tenat': 'Mezmur Tenat',
      'mode_progress': 'My Progress',
      'mode_training_plan': 'My Training Plan',
      'mode_real_play': 'Real Play Mode',
    },
    Language.am: {
      'app_title': 'ቪርቹዋል በገና',
      'home': 'መነሻ',
      'about': 'ስለ እኛ',
      'lessons': 'ትምህርቶች',
      'contact': 'እውቂያ',
      'enter': 'ይግቡ',
      'get_started': 'ይጀምሩ',
      'hero_title': 'ቪርቹዋል በገና',
      'hero_subtitle': 'የዳዊትን በገና ይልመዱ።\nየኢትዮጵያን መንፈሳዊ ቅርስ በጥልቀት በሚያስተምሩ ዲጂታል ትምህርቶች ይለማመዱ።',
      'start_learning': 'መማር ይጀምሩ',
      'feature_title': 'ለምን ቪርቹዋል በገናን ይመርጣሉ?',
      'feature_1_title': 'የተዋቀሩ ትምህርቶች',
      'feature_1_desc': 'ከጀማሪ እስከ ከፍተኛ ደረጃ ያሉ ደረጃ በደረጃ መመሪያዎች።',
      'feature_2_title': 'በይነተገናኝ ልምምድ',
      'feature_2_desc': 'ዜማውን ለመለማመድ የቀጥታ ግብረመልስ እና ምናባዊ አውታሮች።',
      'feature_3_title': 'ባህላዊ ቅርስ',
      'feature_3_desc': 'የበገናን ታሪክ እና መንፈሳዊ ጠቀሜታ ይወቁ።',
      'footer_subtitle': 'ጥንታዊ ድምጾችን ወደ ዘመናዊው ዓለም ማምጣት።',
      'footer_copyright': '© 2026 ቪርቹዋል በገና። መብቱ በሕግ የተጠበቀ ነው።',
      // Auth
      'sign_in': 'ይግቡ',
      'username': 'የተጠቃሚ ስም',
      'password': 'የይለፍ ቃል',
      'sign_in_cta': 'ይግቡ',
      'sign_out': 'ውጣ',
      'welcome': 'እንኳን ደህና መጡ,',
      // Dashboard
      'dashboard_title': 'ቪርቹዋል በገና ስልጠና',
      'dashboard_subtitle': 'በሰው ሰራሽ ልህቀት የተደገፈ የበገና ልምምድ',
      'choose_mode': 'ለመጀመር ሁነታ ይምረጡ:',
      'mode_exercise': 'የልምምድ ሁነታ',
      'mode_free_play': 'ነጻ ጨዋታ ሁነታ',
      'mode_tuning': 'ማስተካከያ ሁነታ',
      'mode_mezmur_tenat': 'መዝሙር ጥናት',
      'mode_progress': 'የእኔ እድገት',
      'mode_training_plan': 'የስልጠና እቅዴ',
      'mode_real_play': 'እውነተኛ ጨዋታ ሁነታ',
    },
  };
}
