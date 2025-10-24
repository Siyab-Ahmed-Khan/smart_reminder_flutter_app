class TimeHelper {
  static String remainingTime(DateTime targetTime) {
    final diff = targetTime.difference(DateTime.now());
    if (diff.isNegative) return "Expired";

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    if (hours > 0) {
      return "$hours hr ${minutes} min";
    } else if (minutes > 0) {
      return "$minutes min ${seconds}s";
    } else {
      return "$seconds s";
    }
  }
}
