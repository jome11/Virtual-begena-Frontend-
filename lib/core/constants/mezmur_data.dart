import 'qenet.dart';

class MezmurSong {
  final String title;
  final String amharic;
  const MezmurSong(this.title, this.amharic);
}

const Map<Qenet, List<MezmurSong>> mezmurLibrary = {
  Qenet.selamta: [
    MezmurSong('Begete Semani', 'በጌቴ ሰማኒ'),
    MezmurSong('Hodo Lemed', 'ሆዶ ለመድ'),
    MezmurSong('Abatachin Hoy', 'አባታችን ሆይ'),
    MezmurSong('Selam Lemaryam', 'ሰላም ለማርያም'),
  ],
  Qenet.tezeta: [
    MezmurSong('Regibna Wane', 'ርግብና ዋኔ'),
    MezmurSong('Abetu Deg Sew Alkelna', 'አቤቱ ደግ ሰው አልቀልና'),
    MezmurSong('Ityopya Hoy Tneshi', 'ኢትዮጵያ ሆይ ትነሺ'),
    MezmurSong('Ye Abraham Amlak', 'የአብርሃም አምላክ'),
  ],
  Qenet.anchihoye: [
    MezmurSong('Sile Chernetih', 'ስለቸርነትህ'),
    MezmurSong('Behiyowet Bezemene', 'በሕይወት በዘመኔ'),
    MezmurSong('Metsemun Yitsemal', 'መጸሙን ይጸማል'),
    MezmurSong('Le Enas Liyu Nach', 'ለኤናስ ልዩ ናች'),
  ],
};
