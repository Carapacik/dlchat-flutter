/// Compares two version strings.
///
/// This function compares two version strings in the format "x.y.z" and returns
/// an integer indicating which version is greater.
///
/// - If `v1` is greater than `v2`, the function returns `1`.
/// - If `v1` is less than `v2`, the function returns `-1`.
/// - If `v1` is equal to `v2`, the function returns `0`.
///
/// The comparison is done by splitting the version strings by the dot (.)
/// separator and comparing each part numerically.
///
/// Example:
/// ```dart
/// int result = compareVersions('1.2.3', '1.2.11');
/// print(result); // Output: -1
/// ```
///
/// @param v1 The first version string.
/// @param v2 The second version string.
/// @return An integer indicating the result of the comparison.
int compareVersions(String v1, String v2) {
  final List<int> parts1 = v1.split('.').map(int.parse).toList();
  final List<int> parts2 = v2.split('.').map(int.parse).toList();

  final int maxLength = parts1.length > parts2.length ? parts1.length : parts2.length;

  for (var i = 0; i < maxLength; i++) {
    final int part1 = i < parts1.length ? parts1[i] : 0;
    final int part2 = i < parts2.length ? parts2[i] : 0;

    if (part1 > part2) {
      return 1;
    }
    if (part1 < part2) {
      return -1;
    }
  }

  return 0;
}
