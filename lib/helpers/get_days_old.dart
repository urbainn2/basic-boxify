int getDaysOld(DateTime fromDate) {
  final today = DateTime.now();
  // logger.i(today);
  // logger.i(fromDate);
  final daysOld = fromDate.difference(today).inDays.abs();
  // logger.i("This date is $daysOld days old.");

  return daysOld;
}
