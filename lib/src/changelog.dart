import 'package:change/src/release.dart';
import 'package:change/src/section.dart';
import 'package:markdown/markdown.dart';
import 'package:pub_semver/pub_semver.dart';

class Changelog {
  /// Releases mapped by version
  final _releases = <String, Release>{};

  /// Changelog header which comes on top of the file before the Unreleased
  /// and version sections.
  final header = <Node>[];

  /// The unreleased changes.
  final unreleased = Section();

  /// All releases in chronological order (oldest first)
  Iterable<Release> history() {
    final releases = _releases.values.toList();
    releases.sort();
    return releases;
  }

  /// Returns the release by version or throws [StateError]
  Release get(String version) =>
      _releases[_normalize(version)] ??
      (throw StateError('Version $version not found'));

  /// Returns `true` if the [version] exists in the changelog
  bool has(String version) => _releases.containsKey(_normalize(version));

  /// Adds a new release
  void add(Release release) {
    final version = _normalize(release.version.toString());
    if (has(version)) throw StateError('Release $version already exists');
    _releases[version] = release;
  }

  /// Returns the release which immediately precedes the [version]
  Release? preceding(Version version) {
    final older = history().where((r) => r.version < version).toList();
    if (older.isNotEmpty) return older.last;
    return null;
  }

  String _normalize(String version) => version.trim().toLowerCase();
}
