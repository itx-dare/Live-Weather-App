String formatHourlyTime(String timeString) {
  try {
    int timeValue = int.parse(timeString);

    if (timeValue < 100) {
      timeValue *= 100;
    }

    int hours = timeValue ~/ 100;
    int minutes = timeValue % 100;

    String period = hours < 12 ? 'AM' : 'PM';
    if (hours > 12) hours -= 12;
    if (hours == 0) hours = 12;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
  } catch (e) {
    return timeString;
  }
}