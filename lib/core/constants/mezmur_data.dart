import 'qenet.dart';

class MezmurSection {
  final List<List<int>> groups;
  final int repeat;
  const MezmurSection({required this.groups, this.repeat = 1});
}

class MezmurSong {
  final String title;
  final String amharic;
  final List<MezmurSection> sections;
  const MezmurSong(this.title, this.amharic, {this.sections = const []});
}

class FlatNote {
  final int note;
  final int group;
  final int section;
  final int repeat;
  const FlatNote({
    required this.note,
    required this.group,
    required this.section,
    required this.repeat,
  });
}

List<FlatNote> flattenMezmur(MezmurSong song) {
  final flat = <FlatNote>[];
  for (int secIdx = 0; secIdx < song.sections.length; secIdx++) {
    final section = song.sections[secIdx];
    for (int rep = 0; rep < section.repeat; rep++) {
      for (int grpIdx = 0; grpIdx < section.groups.length; grpIdx++) {
        for (final note in section.groups[grpIdx]) {
          flat.add(FlatNote(note: note, group: grpIdx, section: secIdx, repeat: rep));
        }
      }
    }
  }
  return flat;
}

const Map<Qenet, List<MezmurSong>> mezmurLibrary = {
  Qenet.selamta: [
    MezmurSong('Begete Semani', 'በጌቴ ሰማኒ', sections: [
      MezmurSection(groups: [[4,2,3],[2,2,4],[5,4,2],[2,2,2]], repeat: 2),
      MezmurSection(groups: [[4,2,3],[1,1,5],[1,1,3],[2,2,4]], repeat: 1),
      MezmurSection(groups: [[5,4,2],[2,2,2]], repeat: 1),
    ]),
    MezmurSong('Hodo Lemed', 'ሆዶ ለመድ', sections: [
      MezmurSection(groups: [[4,5],[1,3,1]], repeat: 2),
      MezmurSection(groups: [[3,1,5,1,3],[2,4,2]], repeat: 1),
    ]),
    MezmurSong('Abatachin Hoy', 'አባታችን ሆይ', sections: [
      MezmurSection(groups: [[4,2,4,5],[3,1,3],[1,5,4,2,3],[3,1,2],[4,5]], repeat: 1),
      MezmurSection(groups: [[4,2,4,5],[3,1,3],[1,5,4,4,2],[2,2,2]], repeat: 1),
    ]),
    MezmurSong('Selam Lemaryam', 'ሰላም ለማርያም', sections: [
      MezmurSection(groups: [[2,3],[1,5,5,5],[1,5,5,5],[1,1],[3,1,1,3,2]], repeat: 1),
      MezmurSection(groups: [[2,3],[1,5,3,1],[1,1,3],[2,4,2],[4,5]], repeat: 1),
      MezmurSection(groups: [[4,2,3,1],[1,1,3,1],[1,1,3],[2,4,2]], repeat: 1),
    ]),
  ],
  Qenet.tezeta: [
    MezmurSong('Regibna Wane', 'ርግብና ዋኔ', sections: [
      MezmurSection(groups: [[4,4,4,4,5,5],[3],[1,1,5],[4,2]], repeat: 1),
      MezmurSection(groups: [[4,4,4,5,2],[5,3],[1,1,5],[4,2]], repeat: 1),
      MezmurSection(groups: [[3,3,1,1,3,3],[4,2],[3,1],[4,2]], repeat: 1),
      MezmurSection(groups: [[3,3,1,1,3,3],[4,2],[2],[4,2]], repeat: 1),
    ]),
    MezmurSong('Abetu Deg Sew Alkelna', 'አቤቱ ደግ ሰው አልቀልና', sections: [
      MezmurSection(groups: [[5,2,1],[1,1,5],[1,1,1,3],[4,2,2,2],[4,2]], repeat: 1),
      MezmurSection(groups: [[5,2,1],[1,1,5],[1,1,1,3],[4,2,2,3],[2,3]], repeat: 1),
      MezmurSection(groups: [[3,5,2],[4,4,5,3,1,1,1,3],[4,2,2,2],[4,2]], repeat: 2),
    ]),
    MezmurSong('Ityopya Hoy Tneshi', 'ኢትዮጵያ ሆይ ትነሺ', sections: [
      MezmurSection(groups: [[2,1,3],[2,4,5,5,2],[4,2,4,2,1],[1,1,5,5,3],[2,3]], repeat: 2),
      MezmurSection(groups: [[2,1,3],[2,4,5,5,2],[4,2,3,4,2],[2,2],[2],[4,2]], repeat: 1),
      MezmurSection(groups: [[1,5],[1,1,3],[4,2],[4,2,4,2,1],[1,1,5,5,3],[2,3]], repeat: 2),
      MezmurSection(groups: [[1,5],[1,1,3],[4,2],[4,2,4,5,2],[2,2],[2],[4,2]], repeat: 1),
    ]),
    MezmurSong('Ye Abraham Amlak', 'የአብርሃም አምላክ', sections: [
      MezmurSection(groups: [[5,2,2],[2,3,4],[2,5,1],[5,3,5,4,5]], repeat: 1),
      MezmurSection(groups: [[5]], repeat: 2),
      MezmurSection(groups: [[2,5,2,3,1],[5,1,3],[1]], repeat: 1),
      MezmurSection(groups: [[2,4],[2,5,2,3,2,2],[2]], repeat: 1),
    ]),
  ],
  Qenet.anchihoye: [
    MezmurSong('Sile Chernetih', 'ስለቸርነትህ', sections: [
      MezmurSection(groups: [[2,3,1,5,4,2],[3],[4,5,1,3],[4,2],[2]], repeat: 2),
      MezmurSection(groups: [[2,3,1,5,4,2],[3],[2,3,1,5],[1,5],[5]], repeat: 1),
    ]),
    MezmurSong('Behiyowet Bezemene', 'በሕይወት በዘመኔ', sections: [
      MezmurSection(groups: [[2,3],[4,2],[2],[1,4],[1,5],[5]], repeat: 1),
      MezmurSection(groups: [[1,5],[1,1,2,3,1],[1],[2,2,2,3],[4,2],[2]], repeat: 1),
      MezmurSection(groups: [[2,2,2,3],[4,2],[2],[1,4],[1,5],[4,2],[2]], repeat: 2),
      MezmurSection(groups: [[2,2,2,3],[4,2],[2],[2,3,1,5],[1,1],[2,3,1],[1]], repeat: 2),
    ]),
    MezmurSong('Metsemun Yitsemal', 'መጸሙን ይጸማል', sections: [
      MezmurSection(groups: [[1,5,1,5,1,5],[1,5,1,5,1,5],[1,5,1,5,5,1],[4,2]], repeat: 1),
      MezmurSection(groups: [[5,2,4,5,1,1],[4,2]], repeat: 1),
      MezmurSection(groups: [[2,3],[1,5,5,1],[1,1,2,3],[4,2],[4]], repeat: 1),
      MezmurSection(groups: [[2,3],[2,3,2,5,4],[1,3],[5,4,4,4,4,4,2]], repeat: 1),
      MezmurSection(groups: [[4,5],[1,3,1,5,4,2]], repeat: 1),
    ]),
    MezmurSong('Le Enas Liyu Nach', 'ለኤናስ ልዩ ናች', sections: [
      MezmurSection(groups: [[2,3,3],[4,2],[2],[4,2,4,2,3],[1,5],[1,3],[3,1,3,1]], repeat: 2),
      MezmurSection(groups: [[3],[4,2],[2],[4,2,4,2,3],[1,5],[1,3],[3,1,3,1]], repeat: 1),
      MezmurSection(groups: [[2,3,3],[4,2],[2],[4,2,4,2,3],[1,5],[1,3],[3,1,3,1]], repeat: 1),
      MezmurSection(groups: [[2,3,3],[4,2,2,3,3],[4,2],[2],[4,2]], repeat: 1),
      MezmurSection(groups: [[2,3,3],[4,2],[2],[4,2,4,2,3],[1,5],[1,3],[3,1,3,1]], repeat: 3),
      MezmurSection(groups: [[2,3,3],[4,2,2,3,3],[4,2],[2],[4,2]], repeat: 1),
    ]),
  ],
};
