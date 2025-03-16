
class Utils {
  static List<T> listFromJson<T>(dynamic json, T Function(Map<String, dynamic>) fromJson) {
    if (json is List) {
      return json.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "N/A";

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = _getMonthName(dateTime.month);
    final year = dateTime.year.toString();
    final hour = dateTime.hour > 12
        ? (dateTime.hour - 12).toString().padLeft(2, '0')
        : dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';

    return "$day-$month-$year, $hour:$minute $amPm";
  }

  static String formatShortDate(DateTime? dateTime) {
    if (dateTime == null) return "N/A";

    final day = dateTime.day.toString();
    final month = _getMonthName(dateTime.month);

    return "$day $month";
  }

  static String calculateEstimatedDelivery(DateTime? orderDate) {
    if (orderDate == null) return "N/A";

    // Add 10 days for estimated delivery
    final estimatedDate = orderDate.add(const Duration(days: 10));
    return formatShortDate(estimatedDate);
  }

  static String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  static String getMonthAbbreviation(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

}

extension WDateTimeExtension on DateTime {
  static DateTime dateDefault = DateTime(2019, 1, 1);

  int totalSeconds() => difference(dateDefault).inSeconds;
}
