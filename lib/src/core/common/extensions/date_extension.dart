extension DaysExtension on int {
  String get daysToPeriod {
    if (this >= 30 && this < 32) {
      return '1 месяц';
    } else if (this >= 32 && this < 62) {
      return '2 мес';
    } else if (this >= 62 && this < 92) {
      return '3 мес';
    } else if (this >= 92 && this < 122) {
      return '4 мес';
    } else if (this >= 122 && this < 152) {
      return '5 мес';
    } else if (this >= 152 && this < 182) {
      return '6 мес';
    } else if (this >= 182 && this < 212) {
      return '7 мес';
    } else if (this >= 212 && this < 242) {
      return '8 мес';
    } else if (this >= 242 && this < 272) {
      return '9 мес';
    } else if (this >= 272 && this < 302) {
      return '10 мес';
    } else if (this >= 302 && this < 332) {
      return '11 мес';
    } else if (this >= 332 && this < 362) {
      return '12 мес';
    } else if (this >= 362 && this < 367) {
      return '1 год';
    } else {
      final int years = this ~/ 365;
      final int remainingDays = this % 365;
      if (remainingDays == 0) {
        return '$years ${_getYearsString(years)}';
      } else {
        return '$remainingDays ${_getDaysString(remainingDays)}';
      }
    }
  }

  String _getYearsString(int years) {
    if (years % 10 == 1 && years % 100 != 11) {
      return 'год';
    } else if (years % 10 >= 2 && years % 10 <= 4 && (years % 100 < 10 || years % 100 >= 20)) {
      return 'года';
    } else {
      return 'лет';
    }
  }

  String _getDaysString(int days) {
    if (days % 10 == 1 && days % 100 != 11) {
      return 'день';
    } else if (days % 10 >= 2 && days % 10 <= 4 && (days % 100 < 10 || days % 100 >= 20)) {
      return 'дня';
    } else {
      return 'дней';
    }
  }
}
