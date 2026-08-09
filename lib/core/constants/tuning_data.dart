import 'qenet.dart';

const List<int> activeStrings = [1, 4, 6, 8, 10];

const Map<int, List<String>> stringNotes = {
  1: ['E', 'F', 'F#'],
  4: ['C', 'C#'],
  6: ['C#', 'D', 'D#'],
  8: ['A', 'A#'],
  10: ['F#', 'G', 'G#'],
};

const Map<int, Map<String, String>> stringSoundFiles = {
  1: {'E': 'string1E.wav', 'F': 'string1F.wav', 'F#': 'string1Fs.wav'},
  4: {'C': 'string2C.wav', 'C#': 'string2Cs.wav'},
  6: {'C#': 'string3Cs.wav', 'D': 'string3D.wav', 'D#': 'string3Ds.wav'},
  8: {'A': 'string4A.wav', 'A#': 'string4As.wav'},
  10: {'F#': 'string5Fs.wav', 'G': 'string5G.wav', 'G#': 'string5Gs.wav'},
};

const Map<Qenet, Map<String, Map<int, String>>> qenetTuning = {
  Qenet.selamta: {
    'C': {1: 'F', 4: 'C', 6: 'D', 8: 'A', 10: 'G'},
    'C#': {1: 'F#', 4: 'C#', 6: 'D#', 8: 'A#', 10: 'G#'},
  },
  Qenet.tezeta: {
    'C': {1: 'E', 4: 'C', 6: 'D', 8: 'A', 10: 'G'},
    'C#': {1: 'F', 4: 'C#', 6: 'D#', 8: 'A#', 10: 'G#'},
  },
  Qenet.anchihoye: {
    'C': {1: 'F', 4: 'C', 6: 'C#', 8: 'A', 10: 'F#'},
    'C#': {1: 'F#', 4: 'C#', 6: 'D', 8: 'A#', 10: 'G'},
  },
};
