class ImageYolu {
  static ImageYolu? _instance;
  static ImageYolu get instance {
    _instance ??= _instance = ImageYolu._init();
    return _instance!;
  }

  ImageYolu._init();
  String get google => toPng('google');
  String get user => toPng('user');

  String toPng(value) => 'assets/image/$value.png';
}

class AnimasyonLolu {
  static AnimasyonLolu? _instance;
  static AnimasyonLolu get instance {
    _instance ??= _instance = AnimasyonLolu._init();
    return _instance!;
  }

  AnimasyonLolu._init();
  String get girisAnimasyonu => toJson('uzay');
  String get hediye => toJson('odul');
  String get yildizlar => toJson('yildizlar');

  String toJson(value) => 'assets/json/$value.json';
}
