// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'catalog.dart';

class CatalogMapper extends ClassMapperBase<Catalog> {
  CatalogMapper._();

  static CatalogMapper? _instance;
  static CatalogMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CatalogMapper._());
      PoetMapper.ensureInitialized();
      PoemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Catalog';

  static List<Poet> _$poets(Catalog v) => v.poets;
  static const Field<Catalog, List<Poet>> _f$poets = Field('poets', _$poets);
  static List<Poem> _$poems(Catalog v) => v.poems;
  static const Field<Catalog, List<Poem>> _f$poems = Field('poems', _$poems);

  @override
  final MappableFields<Catalog> fields = const {
    #poets: _f$poets,
    #poems: _f$poems,
  };

  static Catalog _instantiate(DecodingData data) {
    return Catalog(poets: data.dec(_f$poets), poems: data.dec(_f$poems));
  }

  @override
  final Function instantiate = _instantiate;

  static Catalog fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Catalog>(map);
  }

  static Catalog fromJson(String json) {
    return ensureInitialized().decodeJson<Catalog>(json);
  }
}

mixin CatalogMappable {
  String toJson() {
    return CatalogMapper.ensureInitialized().encodeJson<Catalog>(
      this as Catalog,
    );
  }

  Map<String, dynamic> toMap() {
    return CatalogMapper.ensureInitialized().encodeMap<Catalog>(
      this as Catalog,
    );
  }

  CatalogCopyWith<Catalog, Catalog, Catalog> get copyWith =>
      _CatalogCopyWithImpl<Catalog, Catalog>(
        this as Catalog,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CatalogMapper.ensureInitialized().stringifyValue(this as Catalog);
  }

  @override
  bool operator ==(Object other) {
    return CatalogMapper.ensureInitialized().equalsValue(
      this as Catalog,
      other,
    );
  }

  @override
  int get hashCode {
    return CatalogMapper.ensureInitialized().hashValue(this as Catalog);
  }
}

extension CatalogValueCopy<$R, $Out> on ObjectCopyWith<$R, Catalog, $Out> {
  CatalogCopyWith<$R, Catalog, $Out> get $asCatalog =>
      $base.as((v, t, t2) => _CatalogCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CatalogCopyWith<$R, $In extends Catalog, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Poet, PoetCopyWith<$R, Poet, Poet>> get poets;
  ListCopyWith<$R, Poem, PoemCopyWith<$R, Poem, Poem>> get poems;
  $R call({List<Poet>? poets, List<Poem>? poems});
  CatalogCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CatalogCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Catalog, $Out>
    implements CatalogCopyWith<$R, Catalog, $Out> {
  _CatalogCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Catalog> $mapper =
      CatalogMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Poet, PoetCopyWith<$R, Poet, Poet>> get poets =>
      ListCopyWith(
        $value.poets,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(poets: v),
      );
  @override
  ListCopyWith<$R, Poem, PoemCopyWith<$R, Poem, Poem>> get poems =>
      ListCopyWith(
        $value.poems,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(poems: v),
      );
  @override
  $R call({List<Poet>? poets, List<Poem>? poems}) => $apply(
    FieldCopyWithData({
      if (poets != null) #poets: poets,
      if (poems != null) #poems: poems,
    }),
  );
  @override
  Catalog $make(CopyWithData data) => Catalog(
    poets: data.get(#poets, or: $value.poets),
    poems: data.get(#poems, or: $value.poems),
  );

  @override
  CatalogCopyWith<$R2, Catalog, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CatalogCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PoetMapper extends ClassMapperBase<Poet> {
  PoetMapper._();

  static PoetMapper? _instance;
  static PoetMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PoetMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Poet';

  static String _$id(Poet v) => v.id;
  static const Field<Poet, String> _f$id = Field('id', _$id);
  static String _$name(Poet v) => v.name;
  static const Field<Poet, String> _f$name = Field('name', _$name);
  static int _$born(Poet v) => v.born;
  static const Field<Poet, int> _f$born = Field('born', _$born);
  static int _$died(Poet v) => v.died;
  static const Field<Poet, int> _f$died = Field('died', _$died);

  @override
  final MappableFields<Poet> fields = const {
    #id: _f$id,
    #name: _f$name,
    #born: _f$born,
    #died: _f$died,
  };

  static Poet _instantiate(DecodingData data) {
    return Poet(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      born: data.dec(_f$born),
      died: data.dec(_f$died),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Poet fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Poet>(map);
  }

  static Poet fromJson(String json) {
    return ensureInitialized().decodeJson<Poet>(json);
  }
}

mixin PoetMappable {
  String toJson() {
    return PoetMapper.ensureInitialized().encodeJson<Poet>(this as Poet);
  }

  Map<String, dynamic> toMap() {
    return PoetMapper.ensureInitialized().encodeMap<Poet>(this as Poet);
  }

  PoetCopyWith<Poet, Poet, Poet> get copyWith =>
      _PoetCopyWithImpl<Poet, Poet>(this as Poet, $identity, $identity);
  @override
  String toString() {
    return PoetMapper.ensureInitialized().stringifyValue(this as Poet);
  }

  @override
  bool operator ==(Object other) {
    return PoetMapper.ensureInitialized().equalsValue(this as Poet, other);
  }

  @override
  int get hashCode {
    return PoetMapper.ensureInitialized().hashValue(this as Poet);
  }
}

extension PoetValueCopy<$R, $Out> on ObjectCopyWith<$R, Poet, $Out> {
  PoetCopyWith<$R, Poet, $Out> get $asPoet =>
      $base.as((v, t, t2) => _PoetCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PoetCopyWith<$R, $In extends Poet, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name, int? born, int? died});
  PoetCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PoetCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Poet, $Out>
    implements PoetCopyWith<$R, Poet, $Out> {
  _PoetCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Poet> $mapper = PoetMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, int? born, int? died}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (born != null) #born: born,
      if (died != null) #died: died,
    }),
  );
  @override
  Poet $make(CopyWithData data) => Poet(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    born: data.get(#born, or: $value.born),
    died: data.get(#died, or: $value.died),
  );

  @override
  PoetCopyWith<$R2, Poet, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PoetCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PoemMapper extends ClassMapperBase<Poem> {
  PoemMapper._();

  static PoemMapper? _instance;
  static PoemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PoemMapper._());
      RecordingMapper.ensureInitialized();
      LibriVoxItemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Poem';

  static String _$id(Poem v) => v.id;
  static const Field<Poem, String> _f$id = Field('id', _$id);
  static String _$title(Poem v) => v.title;
  static const Field<Poem, String> _f$title = Field('title', _$title);
  static String _$poetId(Poem v) => v.poetId;
  static const Field<Poem, String> _f$poetId = Field('poetId', _$poetId);
  static int _$year(Poem v) => v.year;
  static const Field<Poem, int> _f$year = Field('year', _$year);
  static List<String> _$lines(Poem v) => v.lines;
  static const Field<Poem, List<String>> _f$lines = Field('lines', _$lines);
  static List<Recording> _$recordings(Poem v) => v.recordings;
  static const Field<Poem, List<Recording>> _f$recordings = Field(
    'recordings',
    _$recordings,
  );
  static LibriVoxItem _$librivox(Poem v) => v.librivox;
  static const Field<Poem, LibriVoxItem> _f$librivox = Field(
    'librivox',
    _$librivox,
  );

  @override
  final MappableFields<Poem> fields = const {
    #id: _f$id,
    #title: _f$title,
    #poetId: _f$poetId,
    #year: _f$year,
    #lines: _f$lines,
    #recordings: _f$recordings,
    #librivox: _f$librivox,
  };

  static Poem _instantiate(DecodingData data) {
    return Poem(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      poetId: data.dec(_f$poetId),
      year: data.dec(_f$year),
      lines: data.dec(_f$lines),
      recordings: data.dec(_f$recordings),
      librivox: data.dec(_f$librivox),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Poem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Poem>(map);
  }

  static Poem fromJson(String json) {
    return ensureInitialized().decodeJson<Poem>(json);
  }
}

mixin PoemMappable {
  String toJson() {
    return PoemMapper.ensureInitialized().encodeJson<Poem>(this as Poem);
  }

  Map<String, dynamic> toMap() {
    return PoemMapper.ensureInitialized().encodeMap<Poem>(this as Poem);
  }

  PoemCopyWith<Poem, Poem, Poem> get copyWith =>
      _PoemCopyWithImpl<Poem, Poem>(this as Poem, $identity, $identity);
  @override
  String toString() {
    return PoemMapper.ensureInitialized().stringifyValue(this as Poem);
  }

  @override
  bool operator ==(Object other) {
    return PoemMapper.ensureInitialized().equalsValue(this as Poem, other);
  }

  @override
  int get hashCode {
    return PoemMapper.ensureInitialized().hashValue(this as Poem);
  }
}

extension PoemValueCopy<$R, $Out> on ObjectCopyWith<$R, Poem, $Out> {
  PoemCopyWith<$R, Poem, $Out> get $asPoem =>
      $base.as((v, t, t2) => _PoemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PoemCopyWith<$R, $In extends Poem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get lines;
  ListCopyWith<$R, Recording, RecordingCopyWith<$R, Recording, Recording>>
  get recordings;
  LibriVoxItemCopyWith<$R, LibriVoxItem, LibriVoxItem> get librivox;
  $R call({
    String? id,
    String? title,
    String? poetId,
    int? year,
    List<String>? lines,
    List<Recording>? recordings,
    LibriVoxItem? librivox,
  });
  PoemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PoemCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Poem, $Out>
    implements PoemCopyWith<$R, Poem, $Out> {
  _PoemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Poem> $mapper = PoemMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get lines =>
      ListCopyWith(
        $value.lines,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(lines: v),
      );
  @override
  ListCopyWith<$R, Recording, RecordingCopyWith<$R, Recording, Recording>>
  get recordings => ListCopyWith(
    $value.recordings,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(recordings: v),
  );
  @override
  LibriVoxItemCopyWith<$R, LibriVoxItem, LibriVoxItem> get librivox =>
      $value.librivox.copyWith.$chain((v) => call(librivox: v));
  @override
  $R call({
    String? id,
    String? title,
    String? poetId,
    int? year,
    List<String>? lines,
    List<Recording>? recordings,
    LibriVoxItem? librivox,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (poetId != null) #poetId: poetId,
      if (year != null) #year: year,
      if (lines != null) #lines: lines,
      if (recordings != null) #recordings: recordings,
      if (librivox != null) #librivox: librivox,
    }),
  );
  @override
  Poem $make(CopyWithData data) => Poem(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    poetId: data.get(#poetId, or: $value.poetId),
    year: data.get(#year, or: $value.year),
    lines: data.get(#lines, or: $value.lines),
    recordings: data.get(#recordings, or: $value.recordings),
    librivox: data.get(#librivox, or: $value.librivox),
  );

  @override
  PoemCopyWith<$R2, Poem, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PoemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RecordingMapper extends ClassMapperBase<Recording> {
  RecordingMapper._();

  static RecordingMapper? _instance;
  static RecordingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RecordingMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Recording';

  static String? _$reader(Recording v) => v.reader;
  static const Field<Recording, String> _f$reader = Field('reader', _$reader);
  static String _$duration(Recording v) => v.duration;
  static const Field<Recording, String> _f$duration = Field(
    'duration',
    _$duration,
  );
  static String _$url(Recording v) => v.url;
  static const Field<Recording, String> _f$url = Field('url', _$url);

  @override
  final MappableFields<Recording> fields = const {
    #reader: _f$reader,
    #duration: _f$duration,
    #url: _f$url,
  };

  static Recording _instantiate(DecodingData data) {
    return Recording(
      reader: data.dec(_f$reader),
      duration: data.dec(_f$duration),
      url: data.dec(_f$url),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Recording fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Recording>(map);
  }

  static Recording fromJson(String json) {
    return ensureInitialized().decodeJson<Recording>(json);
  }
}

mixin RecordingMappable {
  String toJson() {
    return RecordingMapper.ensureInitialized().encodeJson<Recording>(
      this as Recording,
    );
  }

  Map<String, dynamic> toMap() {
    return RecordingMapper.ensureInitialized().encodeMap<Recording>(
      this as Recording,
    );
  }

  RecordingCopyWith<Recording, Recording, Recording> get copyWith =>
      _RecordingCopyWithImpl<Recording, Recording>(
        this as Recording,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RecordingMapper.ensureInitialized().stringifyValue(
      this as Recording,
    );
  }

  @override
  bool operator ==(Object other) {
    return RecordingMapper.ensureInitialized().equalsValue(
      this as Recording,
      other,
    );
  }

  @override
  int get hashCode {
    return RecordingMapper.ensureInitialized().hashValue(this as Recording);
  }
}

extension RecordingValueCopy<$R, $Out> on ObjectCopyWith<$R, Recording, $Out> {
  RecordingCopyWith<$R, Recording, $Out> get $asRecording =>
      $base.as((v, t, t2) => _RecordingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RecordingCopyWith<$R, $In extends Recording, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? reader, String? duration, String? url});
  RecordingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RecordingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Recording, $Out>
    implements RecordingCopyWith<$R, Recording, $Out> {
  _RecordingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Recording> $mapper =
      RecordingMapper.ensureInitialized();
  @override
  $R call({Object? reader = $none, String? duration, String? url}) => $apply(
    FieldCopyWithData({
      if (reader != $none) #reader: reader,
      if (duration != null) #duration: duration,
      if (url != null) #url: url,
    }),
  );
  @override
  Recording $make(CopyWithData data) => Recording(
    reader: data.get(#reader, or: $value.reader),
    duration: data.get(#duration, or: $value.duration),
    url: data.get(#url, or: $value.url),
  );

  @override
  RecordingCopyWith<$R2, Recording, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RecordingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class LibriVoxItemMapper extends ClassMapperBase<LibriVoxItem> {
  LibriVoxItemMapper._();

  static LibriVoxItemMapper? _instance;
  static LibriVoxItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LibriVoxItemMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LibriVoxItem';

  static String _$week(LibriVoxItem v) => v.week;
  static const Field<LibriVoxItem, String> _f$week = Field('week', _$week);
  static String _$page(LibriVoxItem v) => v.page;
  static const Field<LibriVoxItem, String> _f$page = Field('page', _$page);

  @override
  final MappableFields<LibriVoxItem> fields = const {
    #week: _f$week,
    #page: _f$page,
  };

  static LibriVoxItem _instantiate(DecodingData data) {
    return LibriVoxItem(week: data.dec(_f$week), page: data.dec(_f$page));
  }

  @override
  final Function instantiate = _instantiate;

  static LibriVoxItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LibriVoxItem>(map);
  }

  static LibriVoxItem fromJson(String json) {
    return ensureInitialized().decodeJson<LibriVoxItem>(json);
  }
}

mixin LibriVoxItemMappable {
  String toJson() {
    return LibriVoxItemMapper.ensureInitialized().encodeJson<LibriVoxItem>(
      this as LibriVoxItem,
    );
  }

  Map<String, dynamic> toMap() {
    return LibriVoxItemMapper.ensureInitialized().encodeMap<LibriVoxItem>(
      this as LibriVoxItem,
    );
  }

  LibriVoxItemCopyWith<LibriVoxItem, LibriVoxItem, LibriVoxItem> get copyWith =>
      _LibriVoxItemCopyWithImpl<LibriVoxItem, LibriVoxItem>(
        this as LibriVoxItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return LibriVoxItemMapper.ensureInitialized().stringifyValue(
      this as LibriVoxItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return LibriVoxItemMapper.ensureInitialized().equalsValue(
      this as LibriVoxItem,
      other,
    );
  }

  @override
  int get hashCode {
    return LibriVoxItemMapper.ensureInitialized().hashValue(
      this as LibriVoxItem,
    );
  }
}

extension LibriVoxItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LibriVoxItem, $Out> {
  LibriVoxItemCopyWith<$R, LibriVoxItem, $Out> get $asLibriVoxItem =>
      $base.as((v, t, t2) => _LibriVoxItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LibriVoxItemCopyWith<$R, $In extends LibriVoxItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? week, String? page});
  LibriVoxItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LibriVoxItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LibriVoxItem, $Out>
    implements LibriVoxItemCopyWith<$R, LibriVoxItem, $Out> {
  _LibriVoxItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LibriVoxItem> $mapper =
      LibriVoxItemMapper.ensureInitialized();
  @override
  $R call({String? week, String? page}) => $apply(
    FieldCopyWithData({
      if (week != null) #week: week,
      if (page != null) #page: page,
    }),
  );
  @override
  LibriVoxItem $make(CopyWithData data) => LibriVoxItem(
    week: data.get(#week, or: $value.week),
    page: data.get(#page, or: $value.page),
  );

  @override
  LibriVoxItemCopyWith<$R2, LibriVoxItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LibriVoxItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

